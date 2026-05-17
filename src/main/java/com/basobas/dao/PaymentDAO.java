package com.basobas.dao;

import java.math.BigDecimal;
import java.sql.Connection;
import java.sql.Date;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;

import com.basobas.model.Payment;
import com.basobas.config.DatabaseConfig;

public class PaymentDAO {

	// ========== CREATE ==========

	public boolean save(Payment payment) {
		String sql = "INSERT INTO payments (property_id, rental_request_id, tenant_id, landlord_id, "
				+ "amount, payment_month, payment_method, transaction_reference, status, notes) "
				+ "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";

		try (Connection conn = DatabaseConfig.getConnection();
				PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

			ps.setInt(1, payment.getPropertyId());
			if (payment.getRentalRequestId() != null) {
				ps.setInt(2, payment.getRentalRequestId());
			} else {
				ps.setNull(2, java.sql.Types.INTEGER);
			}
			ps.setInt(3, payment.getTenantId());
			ps.setInt(4, payment.getLandlordId());
			ps.setBigDecimal(5, payment.getAmount());
			ps.setDate(6, Date.valueOf(payment.getPaymentMonth()));
			ps.setString(7, payment.getPaymentMethod());
			ps.setString(8, payment.getTransactionReference());
			ps.setString(9, payment.getStatus() != null ? payment.getStatus() : "pending");
			ps.setString(10, payment.getNotes());

			int affectedRows = ps.executeUpdate();

			if (affectedRows > 0) {
				ResultSet rs = ps.getGeneratedKeys();
				if (rs.next()) {
					int paymentId = rs.getInt(1);
					payment.setPaymentId(paymentId);
					String displayId = Payment.generateDisplayId(paymentId);
					payment.setDisplayId(displayId);
					updateDisplayId(paymentId, displayId);
				}
				return true;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	private void updateDisplayId(int paymentId, String displayId) {
		String sql = "UPDATE payments SET display_id = ? WHERE payment_id = ?";
		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {
			ps.setString(1, displayId);
			ps.setInt(2, paymentId);
			ps.executeUpdate();
		} catch (SQLException e) {
			e.printStackTrace();
		}
	}

	// ========== READ ==========

	public List<Payment> getPaymentsByTenant(int tenantId) {
		List<Payment> payments = new ArrayList<>();
		String sql = "SELECT p.*, pr.title as property_title, pr.display_id as property_display_id "
				+ "FROM payments p " + "JOIN properties pr ON p.property_id = pr.property_id "
				+ "WHERE p.tenant_id = ? " + "ORDER BY p.payment_month DESC, p.payment_date DESC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, tenantId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Payment payment = extractPaymentFromResultSet(rs);
				payment.setPropertyTitle(rs.getString("property_title"));
				payment.setPropertyDisplayId(rs.getString("property_display_id"));
				payments.add(payment);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return payments;
	}

	public List<Payment> getPaymentsByLandlord(int landlordId) {
		List<Payment> payments = new ArrayList<>();
		String sql = "SELECT p.*, pr.title as property_title, pr.display_id as property_display_id, "
				+ "u.full_name as tenant_name " + "FROM payments p "
				+ "JOIN properties pr ON p.property_id = pr.property_id " + "JOIN users u ON p.tenant_id = u.user_id "
				+ "WHERE p.landlord_id = ? " + "ORDER BY p.payment_month DESC, p.payment_date DESC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, landlordId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Payment payment = extractPaymentFromResultSet(rs);
				payment.setPropertyTitle(rs.getString("property_title"));
				payment.setPropertyDisplayId(rs.getString("property_display_id"));
				payment.setTenantName(rs.getString("tenant_name"));
				payments.add(payment);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return payments;
	}

	public List<Payment> getPaymentsByProperty(int propertyId) {
		List<Payment> payments = new ArrayList<>();
		String sql = "SELECT p.*, u.full_name as tenant_name " + "FROM payments p "
				+ "JOIN users u ON p.tenant_id = u.user_id " + "WHERE p.property_id = ? "
				+ "ORDER BY p.payment_month DESC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, propertyId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Payment payment = extractPaymentFromResultSet(rs);
				payment.setTenantName(rs.getString("tenant_name"));
				payments.add(payment);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return payments;
	}

	public List<Payment> getPendingPaymentsByLandlord(int landlordId) {
		List<Payment> payments = new ArrayList<>();
		String sql = "SELECT p.*, pr.title as property_title, pr.display_id as property_display_id, "
				+ "u.full_name as tenant_name " + "FROM payments p "
				+ "JOIN properties pr ON p.property_id = pr.property_id " + "JOIN users u ON p.tenant_id = u.user_id "
				+ "WHERE p.landlord_id = ? AND p.status = 'pending' " + "ORDER BY p.payment_month ASC";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, landlordId);
			ResultSet rs = ps.executeQuery();

			while (rs.next()) {
				Payment payment = extractPaymentFromResultSet(rs);
				payment.setPropertyTitle(rs.getString("property_title"));
				payment.setPropertyDisplayId(rs.getString("property_display_id"));
				payment.setTenantName(rs.getString("tenant_name"));
				payments.add(payment);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return payments;
	}

	public Payment findById(int paymentId) {
		String sql = "SELECT p.*, pr.title as property_title, pr.display_id as property_display_id, "
				+ "u.full_name as tenant_name " + "FROM payments p "
				+ "JOIN properties pr ON p.property_id = pr.property_id " + "JOIN users u ON p.tenant_id = u.user_id "
				+ "WHERE p.payment_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setInt(1, paymentId);
			ResultSet rs = ps.executeQuery();

			if (rs.next()) {
				Payment payment = extractPaymentFromResultSet(rs);
				payment.setPropertyTitle(rs.getString("property_title"));
				payment.setPropertyDisplayId(rs.getString("property_display_id"));
				payment.setTenantName(rs.getString("tenant_name"));
				return payment;
			}

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return null;
	}
	
	/**
	 * Calculate total rent collected for a landlord for a specific month
	 * @param landlordId - The landlord ID
	 * @param year - The year (e.g., 2026)
	 * @param month - The month (1-12)
	 * @return Total amount collected
	 */
	public BigDecimal getTotalCollected(int landlordId, int year, int month) {
	    String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments " +
	                 "WHERE landlord_id = ? AND YEAR(payment_month) = ? AND MONTH(payment_month) = ? " +
	                 "AND status = 'completed'";
	    
	    try (Connection conn = DatabaseConfig.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        
	        ps.setInt(1, landlordId);
	        ps.setInt(2, year);
	        ps.setInt(3, month);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            return rs.getBigDecimal(1);
	        }
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return BigDecimal.ZERO;
	}

	/**
	 * Calculate total rent collected for a landlord (all time)
	 * @param landlordId - The landlord ID
	 * @return Total amount collected
	 */
	public BigDecimal getTotalCollectedAllTime(int landlordId) {
	    String sql = "SELECT COALESCE(SUM(amount), 0) FROM payments " +
	                 "WHERE landlord_id = ? AND status = 'completed'";
	    
	    try (Connection conn = DatabaseConfig.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {
	        
	        ps.setInt(1, landlordId);
	        ResultSet rs = ps.executeQuery();
	        
	        if (rs.next()) {
	            return rs.getBigDecimal(1);
	        }
	        
	    } catch (SQLException e) {
	        e.printStackTrace();
	    }
	    return BigDecimal.ZERO;
	}

	// ========== UPDATE ==========

	public boolean updateStatus(int paymentId, String status) {
		String sql = "UPDATE payments SET status = ?, payment_date = NOW() WHERE payment_id = ?";

		try (Connection conn = DatabaseConfig.getConnection(); PreparedStatement ps = conn.prepareStatement(sql)) {

			ps.setString(1, status);
			ps.setInt(2, paymentId);
			return ps.executeUpdate() > 0;

		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false;
	}

	// ========== HELPER ==========

	private Payment extractPaymentFromResultSet(ResultSet rs) throws SQLException {
		Payment payment = new Payment();
		payment.setPaymentId(rs.getInt("payment_id"));
		payment.setPropertyId(rs.getInt("property_id"));

		int requestId = rs.getInt("rental_request_id");
		if (!rs.wasNull()) {
			payment.setRentalRequestId(requestId);
		}

		payment.setDisplayId(rs.getString("display_id"));
		payment.setTenantId(rs.getInt("tenant_id"));
		payment.setLandlordId(rs.getInt("landlord_id"));
		payment.setAmount(rs.getBigDecimal("amount"));

		Date paymentMonth = rs.getDate("payment_month");
		if (paymentMonth != null) {
			payment.setPaymentMonth(paymentMonth.toLocalDate());
		}

		payment.setPaymentDate(rs.getTimestamp("payment_date"));
		payment.setPaymentMethod(rs.getString("payment_method"));
		payment.setTransactionReference(rs.getString("transaction_reference"));
		payment.setStatus(rs.getString("status"));
		payment.setLateFee(rs.getBigDecimal("late_fee"));
		payment.setNotes(rs.getString("notes"));
		payment.setReceiptUrl(rs.getString("receipt_url"));

		return payment;
	}
}