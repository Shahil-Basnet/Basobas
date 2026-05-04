package com.basobas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;
import com.basobas.model.User;
import com.basobas.config.DatabaseConfig;

public class UserDAO {

	// Find user by username
	public User findByUsername(String username) {
		String sql = "SELECT * FROM users WHERE username = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, username);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return extractUserFromResultSet(rs);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// Find user by full name
	public User findByName(String fullName) {
		String sql = "SELECT * FROM users WHERE full_name = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, fullName);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return extractUserFromResultSet(rs);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// Find user by email
	public User findByEmail(String email) {
		String sql = "SELECT * FROM users WHERE email = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, email);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return extractUserFromResultSet(rs);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// Find user by ID
	public User findById(int userId) {
		String sql = "SELECT * FROM users WHERE user_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return extractUserFromResultSet(rs);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// Find user by display_id
	public User findByDisplayId(String displayId) {
		String sql = "SELECT * FROM users WHERE display_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, displayId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return extractUserFromResultSet(rs);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return null;
	}

	// ========== NEW METHODS ==========

	// Find all users by role (admin, landlord, tenant)
	public List<User> findByRole(String role) {
		List<User> users = new ArrayList<>();
		String sql = "SELECT * FROM users WHERE role = ? ORDER BY user_id DESC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, role);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				users.add(extractUserFromResultSet(rs));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return users;
	}

	// Partial search by username, email, or full name
	public List<User> searchUsers(String keyword) {
	    List<User> users = new ArrayList<>();
	    String sql = "SELECT * FROM users WHERE username LIKE ? OR email LIKE ? OR full_name LIKE ? ORDER BY user_id DESC";

	    try (Connection conn = DatabaseConfig.getConnection(); 
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        String searchPattern = "%" + keyword + "%";
	        ps.setString(1, searchPattern);
	        ps.setString(2, searchPattern);
	        ps.setString(3, searchPattern);
	        ResultSet rs = ps.executeQuery();

	        while (rs.next()) {
	            users.add(extractUserFromResultSet(rs));
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return users;
	}

	// Get all users (for admin overview)
	public List<User> getAllUsers() {
		List<User> users = new ArrayList<>();
		String sql = "SELECT * FROM users ORDER BY user_id DESC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				users.add(extractUserFromResultSet(rs));
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return users;
	}

	// Count users by role
	public int countByRole(String role) {
		String sql = "SELECT COUNT(*) FROM users WHERE role = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, role);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	// Count total users
	public int countAllUsers() {
		String sql = "SELECT COUNT(*) FROM users";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt(1);
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	// Count users with filters
	public int countUsersFiltered(String search, String role) {
		StringBuilder sql = new StringBuilder("SELECT COUNT(*) FROM users WHERE 1=1");
		List<Object> params = new ArrayList<>();
		if (search != null && !search.isEmpty()) {
			sql.append(" AND (username LIKE ? OR email LIKE ? OR full_name LIKE ?)");
			String pattern = "%" + search + "%";
			params.add(pattern);
			params.add(pattern);
			params.add(pattern);
		}
		if (role != null && !role.isEmpty() && !role.equals("all")) {
			sql.append(" AND role = ?");
			params.add(role);
		}
		try (Connection conn = DatabaseConfig.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			for (int i = 0; i < params.size(); i++) {
				if (params.get(i) instanceof Integer) {
					ps.setInt(i + 1, (Integer) params.get(i));
				} else {
					ps.setString(i + 1, (String) params.get(i));
				}
			}
			ResultSet rs = ps.executeQuery();
			if (rs.next()) {
				return rs.getInt(1);
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return 0;
	}

	// Get users with filters and pagination
	public List<User> getUsersFiltered(String search, String role, int offset, int limit, String sortBy,
			String sortOrder) {
		StringBuilder sql = new StringBuilder("SELECT * FROM users WHERE 1=1");
		List<Object> params = new ArrayList<>();
		if (search != null && !search.isEmpty()) {
			sql.append(" AND (username LIKE ? OR email LIKE ? OR full_name LIKE ?)");
			String pattern = "%" + search + "%";
			params.add(pattern);
			params.add(pattern);
			params.add(pattern);
		}
		if (role != null && !role.isEmpty() && !role.equals("all")) {
			sql.append(" AND role = ?");
			params.add(role);
		}
		sql.append(" ORDER BY ").append(getSafeSortColumn(sortBy)).append(" ").append(getSafeSortOrder(sortOrder))
				.append(" LIMIT ? OFFSET ?");
		params.add(limit);
		params.add(offset);
		List<User> users = new ArrayList<>();
		try (Connection conn = DatabaseConfig.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql.toString())) {
			for (int i = 0; i < params.size(); i++) {
				if (params.get(i) instanceof Integer) {
					ps.setInt(i + 1, (Integer) params.get(i));
				} else {
					ps.setString(i + 1, (String) params.get(i));
				}
			}
			ResultSet rs = ps.executeQuery();
			while (rs.next()) {
				users.add(extractUserFromResultSet(rs));
			}
		} catch (Exception e) {
			e.printStackTrace();
		}
		return users;
	}

	private String getSafeSortColumn(String sortBy) {
		switch (sortBy) {
		case "user_id":
			return "user_id";
		case "username":
			return "username";
		case "email":
			return "email";
		case "role":
			return "role";
		case "full_name":
			return "full_name";
		case "phone":
			return "phone";
		case "registered_at":
			return "registered_at";
		case "last_logged_in":
			return "last_logged_in";
		default:
			return "user_id";
		}
	}

	private String getSafeSortOrder(String sortOrder) {
		return "DESC".equalsIgnoreCase(sortOrder) ? "DESC" : "ASC";
	}

	// save user to database
	public boolean save(User user) {
		String sql = "INSERT INTO users (username, email, password, role, full_name, phone, address, date_of_birth) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DatabaseConfig.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setString(1, user.getUsername());
			ps.setString(2, user.getEmail());
			ps.setString(3, user.getPassword());
			ps.setString(4, user.getRole());
			ps.setString(5, user.getFullName());
			ps.setString(6, user.getPhone());
			ps.setString(7, user.getAddress());
			ps.setString(8, user.getDateOfBirth());

			int affectedRows = ps.executeUpdate();

			if (affectedRows > 0) {
				ResultSet rs = ps.getGeneratedKeys();
				if (rs.next()) {
					int userId = rs.getInt(1);
					user.setUserId(userId);

					String displayId = generateDisplayId(user.getRole(), userId);
					user.setDisplayId(displayId);
					updateDisplayId(userId, displayId);
				}
				return true;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	private String generateDisplayId(String role, int userId) {
		String prefix;
		switch (role.toLowerCase()) {
		case "tenant":
			prefix = "TE";
			break;
		case "landlord":
			prefix = "LD";
			break;
		default:
			prefix = "AD";
		}
		return prefix + String.format("%05d", userId);
	}

	private void updateDisplayId(int userId, String displayId) {
		String sql = "UPDATE users SET display_id = ? WHERE user_id = ?";
		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, displayId);
			ps.setInt(2, userId);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// Update last logged in time
	public void updateLastLoggedIn(int userId) {
		String sql = "UPDATE users SET last_logged_in = NOW() WHERE user_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			ps.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	// Update user profile
	public boolean update(User user) {
		String sql = "UPDATE users SET full_name = ?, phone = ?, address = ?, date_of_birth = ? WHERE user_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, user.getFullName());
			ps.setString(2, user.getPhone());
			ps.setString(3, user.getAddress());
			ps.setString(4, user.getDateOfBirth());
			ps.setInt(5, user.getUserId());

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// Change password (hash new password before calling)
	public boolean changePassword(int userId, String hashedPassword) {
		String sql = "UPDATE users SET password = ? WHERE user_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, hashedPassword);
			ps.setInt(2, userId);

			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// Delete user
	public boolean delete(int userId) {
		String sql = "DELETE FROM users WHERE user_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, userId);
			return ps.executeUpdate() > 0;

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
	}

	// Helper method to extract User from ResultSet
	private User extractUserFromResultSet(ResultSet rs) throws Exception {
		User user = new User();
		user.setUserId(rs.getInt("user_id"));
		user.setDisplayId(rs.getString("display_id"));
		user.setUsername(rs.getString("username"));
		user.setEmail(rs.getString("email"));
		user.setPassword(rs.getString("password")); // This is the hashed password
		user.setRole(rs.getString("role"));
		user.setFullName(rs.getString("full_name"));
		user.setPhone(rs.getString("phone"));
		user.setAddress(rs.getString("address"));
		user.setDateOfBirth(rs.getString("date_of_birth"));
		user.setRegisteredAt(rs.getString("registered_at"));
		user.setLastLoggedIn(rs.getString("last_logged_in"));
		return user;
	}
}