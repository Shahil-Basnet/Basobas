package com.basobas.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.Statement;
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

	//save user
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
					user.setUserId(rs.getInt(1));
				}
				return true;
			}

		} catch (Exception e) {
			e.printStackTrace();
		}
		return false;
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