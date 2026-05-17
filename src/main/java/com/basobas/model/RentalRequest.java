package com.basobas.model;

import java.math.BigDecimal;
import java.sql.Timestamp;
import java.time.LocalDate;

public class RentalRequest {
    private int requestId;
    private String displayId;
    private int propertyId;
    private int tenantId;
    private int landlordId;
    private LocalDate requestedMoveInDate;
    private int requestedLeaseDurationMonths;
    private BigDecimal monthlyRentOffered;
    private String tenantMessage;
    private String landlordResponse;
    private String status; // pending, approved, rejected, cancelled
    private Timestamp respondedAt;
    private Timestamp createdAt;
    
    // Additional fields for display (from joins)
    private String propertyTitle;
    private String propertyDisplayId;
    private String tenantName;
    private String tenantEmail;
    private String landlordName;
    
    // Constructors
    public RentalRequest() {
        this.requestedLeaseDurationMonths = 12;
        this.status = "pending";
    }
    
    // Getters and Setters
    public int getRequestId() {
        return requestId;
    }
    
    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }
    
    public String getDisplayId() {
        return displayId;
    }
    
    public void setDisplayId(String displayId) {
        this.displayId = displayId;
    }
    
    public int getPropertyId() {
        return propertyId;
    }
    
    public void setPropertyId(int propertyId) {
        this.propertyId = propertyId;
    }
    
    public int getTenantId() {
        return tenantId;
    }
    
    public void setTenantId(int tenantId) {
        this.tenantId = tenantId;
    }
    
    public int getLandlordId() {
        return landlordId;
    }
    
    public void setLandlordId(int landlordId) {
        this.landlordId = landlordId;
    }
    
    public LocalDate getRequestedMoveInDate() {
        return requestedMoveInDate;
    }
    
    public void setRequestedMoveInDate(LocalDate requestedMoveInDate) {
        this.requestedMoveInDate = requestedMoveInDate;
    }
    
    public int getRequestedLeaseDurationMonths() {
        return requestedLeaseDurationMonths;
    }
    
    public void setRequestedLeaseDurationMonths(int requestedLeaseDurationMonths) {
        this.requestedLeaseDurationMonths = requestedLeaseDurationMonths;
    }
    
    public BigDecimal getMonthlyRentOffered() {
        return monthlyRentOffered;
    }
    
    public void setMonthlyRentOffered(BigDecimal monthlyRentOffered) {
        this.monthlyRentOffered = monthlyRentOffered;
    }
    
    public String getTenantMessage() {
        return tenantMessage;
    }
    
    public void setTenantMessage(String tenantMessage) {
        this.tenantMessage = tenantMessage;
    }
    
    public String getLandlordResponse() {
        return landlordResponse;
    }
    
    public void setLandlordResponse(String landlordResponse) {
        this.landlordResponse = landlordResponse;
    }
    
    public String getStatus() {
        return status;
    }
    
    public void setStatus(String status) {
        this.status = status;
    }
    
    public Timestamp getRespondedAt() {
        return respondedAt;
    }
    
    public void setRespondedAt(Timestamp respondedAt) {
        this.respondedAt = respondedAt;
    }
    
    public Timestamp getCreatedAt() {
        return createdAt;
    }
    
    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
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
    
    public String getTenantName() {
        return tenantName;
    }
    
    public void setTenantName(String tenantName) {
        this.tenantName = tenantName;
    }
    
    public String getTenantEmail() {
        return tenantEmail;
    }
    
    public void setTenantEmail(String tenantEmail) {
        this.tenantEmail = tenantEmail;
    }
    
    public String getLandlordName() {
        return landlordName;
    }
    
    public void setLandlordName(String landlordName) {
        this.landlordName = landlordName;
    }
    
    // Helper methods
    public String getStatusBadgeClass() {
        switch (status) {
            case "approved": return "status-approved";
            case "rejected": return "status-rejected";
            case "cancelled": return "status-cancelled";
            default: return "status-pending";
        }
    }
    
    public String getStatusText() {
        switch (status) {
            case "approved": return "Approved";
            case "rejected": return "Rejected";
            case "cancelled": return "Cancelled";
            default: return "Pending";
        }
    }
    
    // Generate display ID (RR00001 format)
    public static String generateDisplayId(int requestId) {
        return "RR" + String.format("%05d", requestId);
    }
    
    @Override
    public String toString() {
        return "RentalRequest [requestId=" + requestId + ", propertyId=" + propertyId + 
               ", tenantId=" + tenantId + ", status=" + status + "]";
    }
}