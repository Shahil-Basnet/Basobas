package com.basobas.dao;

import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;

import com.basobas.model.Property;
import com.basobas.config.DatabaseConfig;

public class PropertyDAO {

	// ========== CREATE ==========
	public boolean save(Property property) {
		String sql = "INSERT INTO properties (title, description, landlord_id, landlord_name, property_type, "
				+ "bedrooms, bathrooms, monthly_rent, security_deposit, city, address, "
				+ "ward_number, floor_number, road_access, water_source, power_backup_hours, "
				+ "status, available_from) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

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
			ps.setDouble(9, property.getSecurityDeposit());
			ps.setString(10, property.getCity());
			ps.setString(11, property.getAddress());
			ps.setObject(12, property.getWardNumber());
			ps.setObject(13, property.getFloorNumber());
			ps.setString(14, property.getRoadAccess());
			ps.setString(15, property.getWaterSource());
			ps.setObject(16, property.getPowerBackupHours());
			ps.setString(17, property.getStatus() != null ? property.getStatus() : "available");
			ps.setDate(18, property.getAvailableFrom());

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
		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
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

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				properties.add(extractPropertyFromResultSet(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return properties;
	}

	public List<Property> getPropertiesByLandlord(int landlordId) {
		List<Property> properties = new ArrayList<>();
		String sql = "SELECT * FROM properties WHERE landlord_id = ? ORDER BY property_id DESC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, landlordId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				properties.add(extractPropertyFromResultSet(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return properties;
	}

	public List<Property> getAvailableProperties() {
		List<Property> properties = new ArrayList<>();
		String sql = "SELECT * FROM vw_active_properties";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				properties.add(extractPropertyFromResultSet(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return properties;
	}

	// Get rented properties for a tenant
	public List<Property> getRentedPropertiesByTenant(int tenantId) {
		List<Property> properties = new ArrayList<>();
		String sql = "SELECT * FROM properties WHERE current_tenant_id = ? AND status = 'rented'";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, tenantId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				properties.add(extractPropertyFromResultSet(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return properties;
	}

	// ========== UPDATE ==========
	public boolean update(Property property) {
		String sql = "UPDATE properties SET title = ?, description = ?, property_type = ?, "
				+ "bedrooms = ?, bathrooms = ?, monthly_rent = ?, security_deposit = ?, "
				+ "city = ?, address = ?, ward_number = ?, floor_number = ?, "
				+ "road_access = ?, water_source = ?, power_backup_hours = ?, "
				+ "status = ?, available_from = ?, current_tenant_id = ?, "
				+ "current_lease_start = ?, current_lease_end = ? " + "WHERE property_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, property.getTitle());
			ps.setString(2, property.getDescription());
			ps.setString(3, property.getPropertyType());
			ps.setInt(4, property.getBedrooms());
			ps.setDouble(5, property.getBathrooms());
			ps.setDouble(6, property.getMonthlyRent());
			ps.setDouble(7, property.getSecurityDeposit());
			ps.setString(8, property.getCity());
			ps.setString(9, property.getAddress());
			ps.setObject(10, property.getWardNumber());
			ps.setObject(11, property.getFloorNumber());
			ps.setString(12, property.getRoadAccess());
			ps.setString(13, property.getWaterSource());
			ps.setObject(14, property.getPowerBackupHours());
			ps.setString(15, property.getStatus());
			ps.setDate(16, property.getAvailableFrom());
			ps.setObject(17, property.getCurrentTenantId());
			ps.setObject(18,
					property.getCurrentLeaseStart() != null ? Date.valueOf(property.getCurrentLeaseStart()) : null);
			ps.setObject(19,
					property.getCurrentLeaseEnd() != null ? Date.valueOf(property.getCurrentLeaseEnd()) : null);
			ps.setInt(20, property.getPropertyId());

			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	public boolean updateStatus(int propertyId, String status) {
		String sql = "UPDATE properties SET status = ? WHERE property_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, status);
			ps.setInt(2, propertyId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// Mark property as rented with tenant info
	public boolean markAsRented(int propertyId, int tenantId, LocalDate leaseStart, LocalDate leaseEnd) {
		String sql = "UPDATE properties SET status = 'rented', current_tenant_id = ?, "
				+ "current_lease_start = ?, current_lease_end = ? WHERE property_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, tenantId);
			ps.setDate(2, Date.valueOf(leaseStart));
			ps.setDate(3, Date.valueOf(leaseEnd));
			ps.setInt(4, propertyId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// Mark property as available (tenant moved out)
	public boolean markAsAvailable(int propertyId) {
		String sql = "UPDATE properties SET status = 'available', current_tenant_id = NULL, "
				+ "current_lease_start = NULL, current_lease_end = NULL WHERE property_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, propertyId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// ========== DELETE ==========
	public boolean delete(int propertyId) {
		String sql = "DELETE FROM properties WHERE property_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

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

	public int countByLandlord(int landlordId) {
		String sql = "SELECT COUNT(*) FROM properties WHERE landlord_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, landlordId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	public int countRentedByTenant(int tenantId) {
		String sql = "SELECT COUNT(*) FROM properties WHERE current_tenant_id = ? AND status = 'rented'";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, tenantId);
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return 0;
	}

	// Get unique cities for filter dropdown
	public List<String> getAllCities() {
		List<String> cities = new ArrayList<>();
		String sql = "SELECT DISTINCT city FROM properties WHERE city IS NOT NULL AND city != '' ORDER BY city";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				cities.add(rs.getString("city"));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return cities;
	}

	// Add this method for filtering with pagination
	public List<Property> getFilteredProperties(String search, String status, String city, int offset, int limit,
			String sortBy, String sortOrder) {
		List<Property> allProperties = getAllProperties();
		List<Property> filtered = new ArrayList<>();

		for (Property p : allProperties) {
			boolean matches = true;

			// Apply search filter
			if (search != null && !search.isEmpty()) {
				if (!p.getTitle().toLowerCase().contains(search.toLowerCase())
						&& !p.getCity().toLowerCase().contains(search.toLowerCase())
						&& !p.getLandlordName().toLowerCase().contains(search.toLowerCase())) {
					matches = false;
				}
			}

			// Apply status filter
			if (matches && status != null && !status.isEmpty() && !"all".equals(status)) {
				if (!p.getStatus().equals(status)) {
					matches = false;
				}
			}

			// Apply city filter
			if (matches && city != null && !city.isEmpty() && !"all".equals(city)) {
				if (!p.getCity().equals(city)) {
					matches = false;
				}
			}

			if (matches) {
				filtered.add(p);
			}
		}

		// Apply sorting
		Comparator<Property> comparator = (a, b) -> {
			int result = 0;
			switch (sortBy) {
			case "display_id":
				result = a.getDisplayId().compareTo(b.getDisplayId());
				break;
			case "title":
				result = a.getTitle().compareTo(b.getTitle());
				break;
			case "landlord_name":
				result = a.getLandlordName().compareTo(b.getLandlordName());
				break;
			case "city":
				result = a.getCity().compareTo(b.getCity());
				break;
			case "monthly_rent":
				result = Double.compare(a.getMonthlyRent(), b.getMonthlyRent());
				break;
			case "bedrooms":
				result = Integer.compare(a.getBedrooms(), b.getBedrooms());
				break;
			case "status":
				result = a.getStatus().compareTo(b.getStatus());
				break;
			default:
				result = Integer.compare(a.getPropertyId(), b.getPropertyId());
			}
			return result;
		};

		if ("DESC".equals(sortOrder)) {
			Collections.sort(filtered, comparator.reversed());
		} else {
			Collections.sort(filtered, comparator);
		}

		// Apply pagination
		int fromIndex = Math.min(offset, filtered.size());
		int toIndex = Math.min(offset + limit, filtered.size());
		return filtered.subList(fromIndex, toIndex);
	}

	// Add this method for counting filtered properties
	public int countFilteredProperties(String search, String status, String city) {
		List<Property> allProperties = getAllProperties();
		int count = 0;

		for (Property p : allProperties) {
			boolean matches = true;

			// Apply search filter
			if (search != null && !search.isEmpty()) {
				if (!p.getTitle().toLowerCase().contains(search.toLowerCase())
						&& !p.getCity().toLowerCase().contains(search.toLowerCase())
						&& !p.getLandlordName().toLowerCase().contains(search.toLowerCase())) {
					matches = false;
				}
			}

			// Apply status filter
			if (matches && status != null && !status.isEmpty() && !"all".equals(status)) {
				if (!p.getStatus().equals(status)) {
					matches = false;
				}
			}

			// Apply city filter
			if (matches && city != null && !city.isEmpty() && !"all".equals(city)) {
				if (!p.getCity().equals(city)) {
					matches = false;
				}
			}

			if (matches) {
				count++;
			}
		}

		return count;
	}

	// ========== HELPER ==========
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
		property.setSecurityDeposit(rs.getDouble("security_deposit"));
		property.setCity(rs.getString("city"));
		property.setAddress(rs.getString("address"));

		// Nepal-specific fields
		int wardNumber = rs.getInt("ward_number");
		property.setWardNumber(rs.wasNull() ? null : wardNumber);

		int floorNumber = rs.getInt("floor_number");
		property.setFloorNumber(rs.wasNull() ? null : floorNumber);

		property.setRoadAccess(rs.getString("road_access"));
		property.setWaterSource(rs.getString("water_source"));

		int powerBackupHours = rs.getInt("power_backup_hours");
		property.setPowerBackupHours(rs.wasNull() ? null : powerBackupHours);

		property.setStatus(rs.getString("status"));
		property.setAvailableFrom(rs.getDate("available_from"));
		property.setCreatedAt(rs.getTimestamp("created_at"));
		property.setUpdatedAt(rs.getTimestamp("updated_at"));

		// New fields for tracking current tenant
		int currentTenantId = rs.getInt("current_tenant_id");
		property.setCurrentTenantId(rs.wasNull() ? null : currentTenantId);

		Date currentLeaseStart = rs.getDate("current_lease_start");
		property.setCurrentLeaseStart(currentLeaseStart != null ? currentLeaseStart.toLocalDate() : null);

		Date currentLeaseEnd = rs.getDate("current_lease_end");
		property.setCurrentLeaseEnd(currentLeaseEnd != null ? currentLeaseEnd.toLocalDate() : null);

		return property;
	}
}