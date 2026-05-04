package com.basobas.model;

import java.util.List;

public class Property {

	// Primary fields
	private int propertyId;
	private String displayId;
	private String title;
	private String description;
	private int landlordId;
	private String landlordName;

	// Property details
	private String propertyType; // apartment, house, condo, studio, room, flat, basement
	private int bedrooms;
	private double bathrooms;
	private double monthlyRent;
	private double securityDeposit;

	// Location details (Nepal specific)
	private String city;
	private String address;
	private int wardNumber;
	private int floorNumber;

	// Nepal specific features
	private String roadAccess; // 2w, 4w, both, none
	private String waterSource; // municipal, tanker, well, borewell
	private int powerBackupHours;

	// Status
	private String status; // available, rented, maintenance, inactive
	private String availableFrom;

	// Timestamps
	private String createdAt;
	private String updatedAt;

	// Related data (not stored in DB, filled by queries)
	private List<PropertyPhoto> photos;
	private List<String> amenities;

	// Default constructor
	public Property() {
		this.propertyType = "apartment";
		this.bedrooms = 1;
		this.bathrooms = 1.0;
		this.status = "available";
		this.roadAccess = "both";
		this.waterSource = "municipal";
		this.powerBackupHours = 0;
		this.securityDeposit = 0.0;
	}

	// Constructor for creating new property
	public Property(String title, String description, int landlordId, String landlordName, String propertyType,
			int bedrooms, double bathrooms, double monthlyRent, double securityDeposit, String city, String address,
			int wardNumber, int floorNumber, String roadAccess, String waterSource, int powerBackupHours) {
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
		this.wardNumber = wardNumber;
		this.floorNumber = floorNumber;
		this.roadAccess = roadAccess;
		this.waterSource = waterSource;
		this.powerBackupHours = powerBackupHours;
		this.status = "available";
	}

	// ========== Getters and Setters ==========

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

	public int getWardNumber() {
		return wardNumber;
	}

	public void setWardNumber(int wardNumber) {
		this.wardNumber = wardNumber;
	}

	public int getFloorNumber() {
		return floorNumber;
	}

	public void setFloorNumber(int floorNumber) {
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

	public int getPowerBackupHours() {
		return powerBackupHours;
	}

	public void setPowerBackupHours(int powerBackupHours) {
		this.powerBackupHours = powerBackupHours;
	}

	public String getStatus() {
		return status;
	}

	public void setStatus(String status) {
		this.status = status;
	}

	public String getAvailableFrom() {
		return availableFrom;
	}

	public void setAvailableFrom(String availableFrom) {
		this.availableFrom = availableFrom;
	}

	public String getCreatedAt() {
		return createdAt;
	}

	public void setCreatedAt(String createdAt) {
		this.createdAt = createdAt;
	}

	public String getUpdatedAt() {
		return updatedAt;
	}

	public void setUpdatedAt(String updatedAt) {
		this.updatedAt = updatedAt;
	}

	public List<PropertyPhoto> getPhotos() {
		return photos;
	}

	public void setPhotos(List<PropertyPhoto> photos) {
		this.photos = photos;
	}

	public List<String> getAmenities() {
		return amenities;
	}

	public void setAmenities(List<String> amenities) {
		this.amenities = amenities;
	}

	// Helper methods
	public boolean isAvailable() {
		return "available".equalsIgnoreCase(this.status);
	}

	public String getFormattedRent() {
		return "रु " + String.format("%,.0f", monthlyRent);
	}

	@Override
	public String toString() {
		return "Property [displayId=" + displayId + ", title=" + title + ", city=" + city + ", rent=" + monthlyRent
				+ "]";
	}
}