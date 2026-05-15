package com.basobas.model;

import java.sql.Timestamp;
import java.time.LocalDate;

public class Property {
	private int propertyId;
	private String displayId;
	private String title;
	private String description;
	private int landlordId;
	private String landlordName;
	private String propertyType; // apartment, house, condo, studio, room, flat, basement
	private int bedrooms;
	private double bathrooms;
	private double monthlyRent;
	private double securityDeposit;
	private String city;
	private String address;
	private Integer wardNumber;
	private Integer floorNumber;
	private String roadAccess; // 2w, 4w, both, none
	private String waterSource; // municipal, tanker, well, borewell
	private Integer powerBackupHours;

	private String status; // available, rented, maintenance, inactive
	private java.sql.Date availableFrom;
	private Timestamp createdAt;
	private Timestamp updatedAt;
	private Integer currentTenantId;
	private LocalDate currentLeaseStart;
	private LocalDate currentLeaseEnd;

	// Constructors
	public Property() {
	}

	public Property(String title, String description, int landlordId, String landlordName, String propertyType,
			int bedrooms, double bathrooms, double monthlyRent, double securityDeposit, String city, String address) {
		this.title = title;
		this.description = description;
		this.landlordId = landlordId;
		this.landlordName = landlordName;
		this.propertyType = propertyType;
		this.bedrooms = bedrooms;
		this.bathrooms = bathrooms;
		this.monthlyRent = monthlyRent;
		this.securityDeposit = securityDeposit;
		this.city = city;
		this.address = address;
		this.status = "available";
	}

	// Getters and Setters
	public int getPropertyId() {
		return propertyId;
	}

	public void setPropertyId(int propertyId) {
		this.propertyId = propertyId;
	}

	public String getDisplayId() {
		return displayId;
	}

	public void setDisplayId(String displayId) {
		this.displayId = displayId;
	}

	public String getTitle() {
		return title;
	}

	public void setTitle(String title) {
		this.title = title;
	}

	public String getDescription() {
		return description;
	}

	public void setDescription(String description) {
		this.description = description;
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

	public String getPropertyType() {
		return propertyType;
	}

	public void setPropertyType(String propertyType) {
		this.propertyType = propertyType;
	}

	public int getBedrooms() {
		return bedrooms;
	}

	public void setBedrooms(int bedrooms) {
		this.bedrooms = bedrooms;
	}

	public double getBathrooms() {
		return bathrooms;
	}

	public void setBathrooms(double bathrooms) {
		this.bathrooms = bathrooms;
	}

	public Integer getCurrentTenantId() {
		return currentTenantId;
	}

	public void setCurrentTenantId(Integer currentTenantId) {
		this.currentTenantId = currentTenantId;
	}

	public LocalDate getCurrentLeaseStart() {
		return currentLeaseStart;
	}

	public void setCurrentLeaseStart(LocalDate currentLeaseStart) {
		this.currentLeaseStart = currentLeaseStart;
	}

	public LocalDate getCurrentLeaseEnd() {
		return currentLeaseEnd;
	}

	public void setCurrentLeaseEnd(LocalDate currentLeaseEnd) {
		this.currentLeaseEnd = currentLeaseEnd;
	}

	public double getMonthlyRent() {
		return monthlyRent;
	}

	public void setMonthlyRent(double monthlyRent) {
		this.monthlyRent = monthlyRent;
	}

	public double getSecurityDeposit() {
		return securityDeposit;
	}

	public void setSecurityDeposit(double securityDeposit) {
		this.securityDeposit = securityDeposit;
	}

	public String getCity() {
		return city;
	}

	public void setCity(String city) {
		this.city = city;
	}

	public String getAddress() {
		return address;
	}

	public void setAddress(String address) {
		this.address = address;
	}

	public Integer getWardNumber() {
		return wardNumber;
	}

	public void setWardNumber(Integer wardNumber) {
		this.wardNumber = wardNumber;
	}

	public Integer getFloorNumber() {
		return floorNumber;
	}

	public void setFloorNumber(Integer floorNumber) {
		this.floorNumber = floorNumber;
	}

	public String getRoadAccess() {
		return roadAccess;
	}

	public void setRoadAccess(String roadAccess) {
		this.roadAccess = roadAccess;
	}

	public String getWaterSource() {
		return waterSource;
	}

	public void setWaterSource(String waterSource) {
		this.waterSource = waterSource;
	}

	public Integer getPowerBackupHours() {
		return powerBackupHours;
	}

	public void setPowerBackupHours(Integer powerBackupHours) {
		this.powerBackupHours = powerBackupHours;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public java.sql.Date getAvailableFrom() {
		return availableFrom;
	}

	public void setAvailableFrom(java.sql.Date availableFrom) {
		this.availableFrom = availableFrom;
	}

	public Timestamp getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(Timestamp createdAt) {
		this.createdAt = createdAt;
	}

	public Timestamp getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(Timestamp updatedAt) {
		this.updatedAt = updatedAt;
	}

	// Helper method to get formatted rent with NPR
	public String getFormattedRent() {
		return "रू " + String.format("%,.2f", monthlyRent);
	}

	// Helper method to get full address with ward
	public String getFullAddress() {
		StringBuilder sb = new StringBuilder();
		if (address != null && !address.isEmpty()) {
			sb.append(address);
		}
		if (wardNumber != null && wardNumber > 0) {
			if (sb.length() > 0)
				sb.append(", ");
			sb.append("Ward ").append(wardNumber);
		}
		if (city != null && !city.isEmpty()) {
			if (sb.length() > 0)
				sb.append(", ");
			sb.append(city);
		}
		return sb.length() > 0 ? sb.toString() : "Address not specified";
	}

	@Override
	public String toString() {
		return "Property [propertyId=" + propertyId + ", displayId=" + displayId + ", title=" + title + ", city=" + city
				+ ", monthlyRent=" + monthlyRent + ", status=" + status + "]";
	}
}