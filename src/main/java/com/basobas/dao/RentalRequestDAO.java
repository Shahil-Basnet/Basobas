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
import java.util.List;

import com.basobas.model.RentalRequest;
import com.basobas.config.DatabaseConfig;

public class RentalRequestDAO {

	// ========== CREATE ==========

	/**
	 * Create a new rental request from tenant
	 */
	public boolean save(RentalRequest request) {
		System.out.println("=== DEBUG: RentalRequestDAO.save ===");
		System.out.println("Property ID: " + request.getPropertyId());
		System.out.println("Tenant ID: " + request.getTenantId());
		System.out.println("Landlord ID: " + request.getLandlordId());
		System.out.println("Move-in Date: " + request.getRequestedMoveInDate());
		System.out.println("Lease Duration: " + request.getRequestedLeaseDurationMonths());
		System.out.println("Monthly Rent Offered: " + request.getMonthlyRentOffered());
		System.out.println("Message: " + request.getTenantMessage());

		String sql = "INSERT INTO rental_requests (property_id, tenant_id, landlord_id, "
				+ "requested_move_in_date, requested_lease_duration_months, "
				+ "monthly_rent_offered, tenant_message, status) " + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DatabaseConfig.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setInt(1, request.getPropertyId());
			ps.setInt(2, request.getTenantId());
			ps.setInt(3, request.getLandlordId());
			ps.setDate(4, java.sql.Date.valueOf(request.getRequestedMoveInDate()));
			ps.setInt(5, request.getRequestedLeaseDurationMonths());
			ps.setBigDecimal(6, request.getMonthlyRentOffered());
			ps.setString(7, request.getTenantMessage());
			ps.setString(8, "pending");

			System.out.println("SQL: " + sql);

			int affectedRows = ps.executeUpdate();
			System.out.println("Affected rows: " + affectedRows);

			if (affectedRows > 0) {
				ResultSet rs = ps.getGeneratedKeys();
				if (rs.next()) {
					int requestId = rs.getInt(1);
					request.setRequestId(requestId);

					// Generate and update display ID
					String displayId = RentalRequest.generateDisplayId(requestId);
					request.setDisplayId(displayId);
					updateDisplayId(requestId, displayId);
					System.out.println("Request saved with ID: " + requestId + ", Display ID: " + displayId);
				}
				return true;
			}

		} catch (SQLException e) {
			System.out.println("SQL Exception: " + e.getMessage());
			e.printStackTrace();
		}
		return false;
	}

	private void updateDisplayId(int requestId, String displayId) {
		String sql = "UPDATE rental_requests SET display_id = ? WHERE request_id = ?";
		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, displayId);
			ps.setInt(2, requestId);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// ========== READ ==========

	/**
	 * Get all requests for a tenant
	 */
	public List<RentalRequest> getRequestsByTenant(int tenantId) {
		List<RentalRequest> requests = new ArrayList<>();
		String sql = "SELECT rr.*, p.title as property_title, p.display_id as property_display_id "
				+ "FROM rental_requests rr " + "JOIN properties p ON rr.property_id = p.property_id "
				+ "WHERE rr.tenant_id = ? " + "ORDER BY rr.created_at DESC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, tenantId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				requests.add(extractRequestWithDetails(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return requests;
	}

	/**
	 * Get all requests for a landlord
	 */
	public List<RentalRequest> getRequestsByLandlord(int landlordId) {
		List<RentalRequest> requests = new ArrayList<>();
		String sql = "SELECT rr.*, p.title as property_title, p.display_id as property_display_id, "
				+ "u.full_name as tenant_name, u.email as tenant_email " + "FROM rental_requests rr "
				+ "JOIN properties p ON rr.property_id = p.property_id " + "JOIN users u ON rr.tenant_id = u.user_id "
				+ "WHERE rr.landlord_id = ? " + "ORDER BY rr.created_at DESC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, landlordId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				requests.add(extractRequestWithDetails(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return requests;
	}

	/**
	 * Get pending requests for a landlord
	 */
	public List<RentalRequest> getPendingRequestsByLandlord(int landlordId) {
		List<RentalRequest> requests = new ArrayList<>();
		String sql = "SELECT rr.*, p.title as property_title, p.display_id as property_display_id, "
				+ "u.full_name as tenant_name, u.email as tenant_email, u.phone as tenant_phone "
				+ "FROM rental_requests rr " + "JOIN properties p ON rr.property_id = p.property_id "
				+ "JOIN users u ON rr.tenant_id = u.user_id " + "WHERE rr.landlord_id = ? AND rr.status = 'pending' "
				+ "ORDER BY rr.created_at ASC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, landlordId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				requests.add(extractRequestWithDetails(rs));
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return requests;
	}

	/**
	 * Get single request by ID
	 */
	public RentalRequest findById(int requestId) {
		String sql = "SELECT rr.*, p.title as property_title, p.display_id as property_display_id, "
				+ "u.full_name as tenant_name, u.email as tenant_email " + "FROM rental_requests rr "
				+ "JOIN properties p ON rr.property_id = p.property_id " + "JOIN users u ON rr.tenant_id = u.user_id "
				+ "WHERE rr.request_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, requestId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return extractRequestWithDetails(rs);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}

	/**
	 * Check if tenant already has a pending request for this property
	 */
	public boolean hasPendingRequest(int tenantId, int propertyId) {
		String sql = "SELECT COUNT(*) FROM rental_requests WHERE tenant_id = ? AND property_id = ? AND status = 'pending'";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, tenantId);
			ps.setInt(2, propertyId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				return rs.getInt(1) > 0;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * Count pending requests for a landlord
	 */
	public int countPendingRequests(int landlordId) {
		String sql = "SELECT COUNT(*) FROM rental_requests WHERE landlord_id = ? AND status = 'pending'";

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

	// ========== UPDATE ==========

	/**
	 * Approve a rental request
	 */
	public boolean approveRequest(int requestId, String responseMessage) {
		String sql = "UPDATE rental_requests SET status = 'approved', responded_at = NOW(), landlord_response = ? WHERE request_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, responseMessage);
			ps.setInt(2, requestId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * Reject a rental request
	 */
	public boolean rejectRequest(int requestId, String responseMessage) {
		String sql = "UPDATE rental_requests SET status = 'rejected', responded_at = NOW(), landlord_response = ? WHERE request_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, responseMessage);
			ps.setInt(2, requestId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	/**
	 * Cancel a pending request (by tenant)
	 */
	public boolean cancelRequest(int requestId) {
		String sql = "UPDATE rental_requests SET status = 'cancelled' WHERE request_id = ? AND status = 'pending'";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, requestId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// ========== DELETE ==========

	/**
	 * Delete a request (only if pending)
	 */
	public boolean delete(int requestId) {
		String sql = "DELETE FROM rental_requests WHERE request_id = ? AND status = 'pending'";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, requestId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// ========== HELPER ==========

	private RentalRequest extractRequestWithDetails(ResultSet rs) throws SQLException {
		RentalRequest request = new RentalRequest();
		request.setRequestId(rs.getInt("request_id"));
		request.setDisplayId(rs.getString("display_id"));
		request.setPropertyId(rs.getInt("property_id"));
		request.setTenantId(rs.getInt("tenant_id"));
		request.setLandlordId(rs.getInt("landlord_id"));

		Date moveInDate = rs.getDate("requested_move_in_date");
		request.setRequestedMoveInDate(moveInDate != null ? moveInDate.toLocalDate() : null);

		request.setRequestedLeaseDurationMonths(rs.getInt("requested_lease_duration_months"));
		request.setMonthlyRentOffered(rs.getBigDecimal("monthly_rent_offered"));
		request.setTenantMessage(rs.getString("tenant_message"));
		request.setLandlordResponse(rs.getString("landlord_response"));
		request.setStatus(rs.getString("status"));
		request.setRespondedAt(rs.getTimestamp("responded_at"));
		request.setCreatedAt(rs.getTimestamp("created_at"));

		// Additional fields
		try {
			request.setPropertyTitle(rs.getString("property_title"));
			request.setPropertyDisplayId(rs.getString("property_display_id"));
			request.setTenantName(rs.getString("tenant_name"));
			request.setTenantEmail(rs.getString("tenant_email"));
		} catch (SQLException e) {
			// These columns might not be in all queries
		}

		return request;
	}
}