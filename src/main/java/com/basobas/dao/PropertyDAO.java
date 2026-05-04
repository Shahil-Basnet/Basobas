package com.basobas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import com.basobas.model.Property;
import com.basobas.config.DatabaseConfig;

public class PropertyDAO {
    
    // ========== CREATE ==========
    public boolean save(Property property) {
        String sql = "INSERT INTO properties (title, description, landlord_id, landlord_name, property_type, bedrooms, bathrooms, monthly_rent, city, address) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setString(1, property.getTitle());
            ps.setString(2, property.getDescription());
            ps.setInt(3, property.getLandlordId());
            ps.setString(4, property.getLandlordName());
            ps.setString(5, property.getPropertyType());
            ps.setInt(6, property.getBedrooms());
            ps.setDouble(7, property.getBathrooms());
            ps.setDouble(8, property.getMonthlyRent());
            ps.setString(9, property.getCity());
            ps.setString(10, property.getAddress());
            
            int affectedRows = ps.executeUpdate();
            
            if (affectedRows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    int propertyId = rs.getInt(1);
                    property.setPropertyId(propertyId);
                    
                    String displayId = generateDisplayId(propertyId);
                    property.setDisplayId(displayId);
                    updateDisplayId(propertyId, displayId);
                }
                return true;
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    private String generateDisplayId(int propertyId) {
        return "PR" + String.format("%05d", propertyId);
    }
    
    private void updateDisplayId(int propertyId, String displayId) {
        String sql = "UPDATE properties SET display_id = ? WHERE property_id = ?";
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, displayId);
            ps.setInt(2, propertyId);
            ps.executeUpdate();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
    
    // ========== READ ==========
    public Property findById(int propertyId) {
        String sql = "SELECT * FROM properties WHERE property_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, propertyId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractPropertyFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public Property findByDisplayId(String displayId) {
        String sql = "SELECT * FROM properties WHERE display_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, displayId);
            ResultSet rs = ps.executeQuery();
            
            if (rs.next()) {
                return extractPropertyFromResultSet(rs);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    
    public List<Property> getAllProperties() {
        List<Property> properties = new ArrayList<>();
        String sql = "SELECT * FROM properties ORDER BY property_id DESC";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            
            while (rs.next()) {
                properties.add(extractPropertyFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return properties;
    }
    
    public List<Property> getFilteredProperties(String search, String status, String city, 
                                                  int offset, int limit, String sortBy, String sortOrder) {
        List<Property> properties = new ArrayList<>();
        StringBuilder sql = new StringBuilder("SELECT * FROM properties WHERE 1=1");
        
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (title LIKE ? OR city LIKE ? OR landlord_name LIKE ?)");
        }
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            sql.append(" AND status = ?");
        }
        if (city != null && !city.isEmpty() && !city.equals("all")) {
            sql.append(" AND city = ?");
        }
        
        String safeSortBy = getSafeColumnName(sortBy);
        String safeSortOrder = "DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";
        sql.append(" ORDER BY ").append(safeSortBy).append(" ").append(safeSortOrder);
        sql.append(" LIMIT ? OFFSET ?");
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (search != null && !search.isEmpty()) {
                String pattern = "%" + search + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            if (status != null && !status.isEmpty() && !status.equals("all")) {
                ps.setString(paramIndex++, status);
            }
            if (city != null && !city.isEmpty() && !city.equals("all")) {
                ps.setString(paramIndex++, city);
            }
            
            ps.setInt(paramIndex++, limit);
            ps.setInt(paramIndex++, offset);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                properties.add(extractPropertyFromResultSet(rs));
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return properties;
    }
    
    public int countFilteredProperties(String search, String status, String city) {
        StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM properties WHERE 1=1");
        
        if (search != null && !search.isEmpty()) {
            sql.append(" AND (title LIKE ? OR city LIKE ? OR landlord_name LIKE ?)");
        }
        if (status != null && !status.isEmpty() && !status.equals("all")) {
            sql.append(" AND status = ?");
        }
        if (city != null && !city.isEmpty() && !city.equals("all")) {
            sql.append(" AND city = ?");
        }
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {
            
            int paramIndex = 1;
            
            if (search != null && !search.isEmpty()) {
                String pattern = "%" + search + "%";
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
                ps.setString(paramIndex++, pattern);
            }
            if (status != null && !status.isEmpty() && !status.equals("all")) {
                ps.setString(paramIndex++, status);
            }
            if (city != null && !city.isEmpty() && !city.equals("all")) {
                ps.setString(paramIndex++, city);
            }
            
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
    public boolean updateStatus(int propertyId, String status) {
        String sql = "UPDATE properties SET status = ? WHERE property_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ps.setInt(2, propertyId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // ========== DELETE ==========
    public boolean delete(int propertyId) {
        String sql = "DELETE FROM properties WHERE property_id = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, propertyId);
            return ps.executeUpdate() > 0;
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    
    // ========== COUNTS ==========
    public int countAllProperties() {
        String sql = "SELECT COUNT(*) FROM properties";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM properties WHERE status = ?";
        
        try (Connection conn = DatabaseConfig.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
            
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    
    // ========== HELPER ==========
    private String getSafeColumnName(String column) {
        switch (column) {
            case "property_id": return "property_id";
            case "display_id": return "display_id";
            case "title": return "title";
            case "city": return "city";
            case "monthly_rent": return "monthly_rent";
            case "status": return "status";
            case "created_at": return "created_at";
            default: return "property_id";
        }
    }
    
    private Property extractPropertyFromResultSet(ResultSet rs) throws SQLException {
        Property property = new Property();
        property.setPropertyId(rs.getInt("property_id"));
        property.setDisplayId(rs.getString("display_id"));
        property.setTitle(rs.getString("title"));
        property.setDescription(rs.getString("description"));
        property.setLandlordId(rs.getInt("landlord_id"));
        property.setLandlordName(rs.getString("landlord_name"));
        property.setPropertyType(rs.getString("property_type"));
        property.setBedrooms(rs.getInt("bedrooms"));
        property.setBathrooms(rs.getDouble("bathrooms"));
        property.setMonthlyRent(rs.getDouble("monthly_rent"));
        property.setCity(rs.getString("city"));
        property.setAddress(rs.getString("address"));
        property.setStatus(rs.getString("status"));
        property.setCreatedAt(rs.getString("created_at"));
        property.setUpdatedAt(rs.getString("updated_at"));
        return property;
    }
}