package com.basobas.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;

public class Payment {
	private int paymentId;
	private int propertyId;
	private String propertyTitle;
	private String propertyDisplayId;
	private Integer rentalRequestId;
	private String displayId;
	private int tenantId;
	private String tenantName;
	private int landlordId;
	private String landlordName;
	private BigDecimal amount;
	private LocalDate paymentMonth;
	private Timestamp paymentDate;
	private String paymentMethod; // bank_transfer, cash, card, khalti, esewa, ime_pay, connectips
	private String transactionReference;
	private String status; // pending, completed, failed, refunded
	private BigDecimal lateFee;
	private String notes;
	private String receiptUrl;

	// Constructors
	public Payment() {
		this.status = "pending";
		this.lateFee = BigDecimal.ZERO;
	}

	// Getters and Setters
	public int getPaymentId() {
		return paymentId;
	}

	public void setPaymentId(int paymentId) {
		this.paymentId = paymentId;
	}

	public int getPropertyId() {
		return propertyId;
	}

	public void setPropertyId(int propertyId) {
		this.propertyId = propertyId;
	}

	public String getPropertyTitle() {
		return propertyTitle;
	}

	public void setPropertyTitle(String propertyTitle) {
		this.propertyTitle = propertyTitle;
	}

	public String getPropertyDisplayId() {
		return propertyDisplayId;
	}

	public void setPropertyDisplayId(String propertyDisplayId) {
		this.propertyDisplayId = propertyDisplayId;
	}

	public Integer getRentalRequestId() {
		return rentalRequestId;
	}

	public void setRentalRequestId(Integer rentalRequestId) {
		this.rentalRequestId = rentalRequestId;
	}

	public String getDisplayId() {
		return displayId;
	}

	public void setDisplayId(String displayId) {
		this.displayId = displayId;
	}

	public int getTenantId() {
		return tenantId;
	}

	public void setTenantId(int tenantId) {
		this.tenantId = tenantId;
	}

	public String getTenantName() {
		return tenantName;
	}

	public void setTenantName(String tenantName) {
		this.tenantName = tenantName;
	}

	public int getLandlordId() {
		return landlordId;
	}

	public void setLandlordId(int landlordId) {
		this.landlordId = landlordId;
	}

	public String getLandlordName() {
		return landlordName;
	}

	public void setLandlordName(String landlordName) {
		this.landlordName = landlordName;
	}

	public BigDecimal getAmount() {
		return amount;
	}

	public void setAmount(BigDecimal amount) {
		this.amount = amount;
	}

	public LocalDate getPaymentMonth() {
		return paymentMonth;
	}

	public void setPaymentMonth(LocalDate paymentMonth) {
		this.paymentMonth = paymentMonth;
	}

	public Timestamp getPaymentDate() {
		return paymentDate;
	}

	public void setPaymentDate(Timestamp paymentDate) {
		this.paymentDate = paymentDate;
	}

	public String getPaymentMethod() {
		return paymentMethod;
	}

	public void setPaymentMethod(String paymentMethod) {
		this.paymentMethod = paymentMethod;
	}

	public String getTransactionReference() {
		return transactionReference;
	}

	public void setTransactionReference(String transactionReference) {
		this.transactionReference = transactionReference;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public BigDecimal getLateFee() {
		return lateFee;
	}

	public void setLateFee(BigDecimal lateFee) {
		this.lateFee = lateFee;
	}

	public String getNotes() {
		return notes;
	}

	public void setNotes(String notes) {
		this.notes = notes;
	}

	public String getReceiptUrl() {
		return receiptUrl;
	}

	public void setReceiptUrl(String receiptUrl) {
		this.receiptUrl = receiptUrl;
	}

	// Helper methods
	public String getPaymentMethodDisplay() {
		switch (paymentMethod) {
		case "bank_transfer":
			return "Bank Transfer";
		case "cash":
			return "Cash";
		case "card":
			return "Card";
		case "khalti":
			return "Khalti";
		case "esewa":
			return "eSewa";
		case "ime_pay":
			return "IME Pay";
		case "connectips":
			return "ConnectIPS";
		default:
			return paymentMethod;
		}
	}

	public String getStatusBadgeClass() {
		switch (status) {
		case "completed":
			return "status-completed";
		case "pending":
			return "status-pending";
		case "failed":
			return "status-failed";
		case "refunded":
			return "status-refunded";
		default:
			return "status-pending";
		}
	}

	public String getStatusText() {
		switch (status) {
		case "completed":
			return "Completed";
		case "pending":
			return "Pending";
		case "failed":
			return "Failed";
		case "refunded":
			return "Refunded";
		default:
			return "Pending";
		}
	}

	public static String generateDisplayId(int paymentId) {
		return "PY" + String.format("%05d", paymentId);
	}
}