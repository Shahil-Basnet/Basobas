package com.basobas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.ArrayList;
import java.util.List;

import com.basobas.model.PropertyPhoto;
import com.basobas.config.DatabaseConfig;

public class PropertyPhotoDAO {
    
    // ========== CREATE ==========
    
    /**
     * Save a single photo
     */
    public boolean save(PropertyPhoto photo) {
        String sql = "INSERT INTO property_photos (property_id, photo_url, is_primary, caption, display_order) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, photo.getPropertyId());
            ps.setString(2, photo.getPhotoUrl());
            ps.setBoolean(3, photo.isPrimary());
            ps.setString(4, photo.getCaption());
            ps.setInt(5, photo.getDisplayOrder());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    photo.setPhotoId(rs.getInt(1));
                }
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Save multiple photos at once
     */
    public boolean saveAll(List<PropertyPhoto> photos) {
        String sql = "INSERT INTO property_photos (property_id, photo_url, is_primary, caption, display_order) " +
                     "VALUES (?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false);
            
            for (PropertyPhoto photo : photos) {
                ps.setInt(1, photo.getPropertyId());
                ps.setString(2, photo.getPhotoUrl());
                ps.setBoolean(3, photo.isPrimary());
                ps.setString(4, photo.getCaption());
                ps.setInt(5, photo.getDisplayOrder());
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            conn.commit();
            
            for (int result : results) {
                if (result == Statement.EXECUTE_FAILED) {
                    conn.rollback();
                    return false;
                }
            }
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ========== READ ==========
    
    /**
     * Get all photos for a property
     */
    public List<PropertyPhoto> getPhotosByPropertyId(int propertyId) {
        List<PropertyPhoto> photos = new ArrayList<>();
        String sql = "SELECT * FROM property_photos WHERE property_id = ? ORDER BY display_order ASC, photo_id ASC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, propertyId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                photos.add(extractPhotoFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return photos;
    }
    
    /**
     * Get photos by property display ID (PR00001)
     */
    public List<PropertyPhoto> getPhotosByPropertyDisplayId(String displayId) {
        List<PropertyPhoto> photos = new ArrayList<>();
        String sql = "SELECT pp.* FROM property_photos pp " +
                     "INNER JOIN properties p ON pp.property_id = p.property_id " +
                     "WHERE p.display_id = ? ORDER BY pp.display_order ASC, pp.photo_id ASC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, displayId);
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                photos.add(extractPhotoFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return photos;
    }
    
    /**
     * Get primary photo for a property (thumbnail)
     */
    public PropertyPhoto getPrimaryPhoto(int propertyId) {
        String sql = "SELECT * FROM property_photos WHERE property_id = ? AND is_primary = 1 LIMIT 1";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, propertyId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractPhotoFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Get primary photo URL for a property (convenience method for JSP)
     * If no primary photo is set, it will return the first available photo.
     * If no photos at all, returns the default no-image path.
     */
    public String getPrimaryPhotoUrl(int propertyId) {
        PropertyPhoto photo = getPrimaryPhoto(propertyId);
        
        // If no primary photo, try to get the first photo
        if (photo == null) {
            List<PropertyPhoto> photos = getPhotosByPropertyId(propertyId);
            if (!photos.isEmpty()) {
                photo = photos.get(0);
            }
        }
        
        return photo != null ? photo.getFullPhotoUrl() : "/assets/no-image.jpg";
    }
    
    /**
     * Get photo by ID
     */
    public PropertyPhoto findById(int photoId) {
        String sql = "SELECT * FROM property_photos WHERE photo_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, photoId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractPhotoFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    /**
     * Count photos for a property
     */
    public int countPhotosByPropertyId(int propertyId) {
        String sql = "SELECT COUNT(*) FROM property_photos WHERE property_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, propertyId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ========== UPDATE ==========
    
    /**
     * Update photo details (caption, display order)
     */
    public boolean update(PropertyPhoto photo) {
        String sql = "UPDATE property_photos SET caption = ?, display_order = ? WHERE photo_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, photo.getCaption());
            ps.setInt(2, photo.getDisplayOrder());
            ps.setInt(3, photo.getPhotoId());
            
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Set a photo as primary (and unset all other primary photos for this property)
     */
    public boolean setPrimaryPhoto(int propertyId, int photoId) {
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            
            // First, unset all primary photos for this property
            String unsetSql = "UPDATE property_photos SET is_primary = 0 WHERE property_id = ?";
            try (PreparedStatement ps1 = conn.prepareStatement(unsetSql)) {
                ps1.setInt(1, propertyId);
                ps1.executeUpdate();
            }
            
            // Then, set the selected photo as primary
            String setSql = "UPDATE property_photos SET is_primary = 1 WHERE photo_id = ? AND property_id = ?";
            try (PreparedStatement ps2 = conn.prepareStatement(setSql)) {
                ps2.setInt(1, photoId);
                ps2.setInt(2, propertyId);
                ps2.executeUpdate();
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    /**
     * Update display order for all photos (batch update)
     */
    public boolean updateDisplayOrders(int propertyId, List<Integer> photoIdsInOrder) {
        try (Connection conn = DatabaseConfig.getConnection()) {
            conn.setAutoCommit(false);
            
            String sql = "UPDATE property_photos SET display_order = ? WHERE photo_id = ? AND property_id = ?";
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                for (int i = 0; i < photoIdsInOrder.size(); i++) {
                    ps.setInt(1, i);
                    ps.setInt(2, photoIdsInOrder.get(i));
                    ps.setInt(3, propertyId);
                    ps.addBatch();
                }
                ps.executeBatch();
            }
            
            conn.commit();
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ========== DELETE ==========
    
    /**
     * Delete a single photo
     */
    public boolean delete(int photoId) {
        String sql = "DELETE FROM property_photos WHERE photo_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, photoId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete all photos for a property (useful when deleting a property)
     */
    public boolean deleteByPropertyId(int propertyId) {
        String sql = "DELETE FROM property_photos WHERE property_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, propertyId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    /**
     * Delete multiple photos by IDs
     */
    public boolean deleteMultiple(List<Integer> photoIds) {
        if (photoIds == null || photoIds.isEmpty()) {
            return true;
        }
        
        String sql = "DELETE FROM property_photos WHERE photo_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            conn.setAutoCommit(false);
            
            for (int photoId : photoIds) {
                ps.setInt(1, photoId);
                ps.addBatch();
            }
            
            int[] results = ps.executeBatch();
            conn.commit();
            
            for (int result : results) {
                if (result == Statement.EXECUTE_FAILED) {
                    conn.rollback();
                    return false;
                }
            }
            return true;
            
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    
    // ========== HELPER ==========
    
    private PropertyPhoto extractPhotoFromResultSet(ResultSet rs) throws SQLException {
        PropertyPhoto photo = new PropertyPhoto();
        photo.setPhotoId(rs.getInt("photo_id"));
        photo.setPropertyId(rs.getInt("property_id"));
        photo.setPhotoUrl(rs.getString("photo_url"));
        photo.setPrimary(rs.getBoolean("is_primary"));
        photo.setCaption(rs.getString("caption"));
        photo.setDisplayOrder(rs.getInt("display_order"));
        photo.setUploadedAt(rs.getTimestamp("uploaded_at"));
        return photo;
    }
}