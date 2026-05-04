package com.basobas.model;

public class PropertyPhoto {
	private int photoId;
	private int propertyId;
	private String photoUrl;
	private boolean isPrimary;
	private String caption;
	private int displayOrder;
	private String uploadedAt;

	// Default constructor
	public PropertyPhoto() {
		this.isPrimary = false;
		this.displayOrder = 0;
	}

	// Constructor
	public PropertyPhoto(int propertyId, String photoUrl, boolean isPrimary, String caption) {
		this.propertyId = propertyId;
		this.photoUrl = photoUrl;
		this.isPrimary = isPrimary;
		this.caption = caption;
		this.displayOrder = 0;
	}

	// Getters and Setters
	public int getPhotoId() {
		return photoId;
	}

	public void setPhotoId(int photoId) {
		this.photoId = photoId;
	}

	public int getPropertyId() {
		return propertyId;
	}

	public void setPropertyId(int propertyId) {
		this.propertyId = propertyId;
	}

	public String getPhotoUrl() {
		return photoUrl;
	}

	public void setPhotoUrl(String photoUrl) {
		this.photoUrl = photoUrl;
	}

	public boolean isPrimary() {
		return isPrimary;
	}

	public void setPrimary(boolean primary) {
		isPrimary = primary;
	}

	public String getCaption() {
		return caption;
	}

	public void setCaption(String caption) {
		this.caption = caption;
	}

	public int getDisplayOrder() {
		return displayOrder;
	}

	public void setDisplayOrder(int displayOrder) {
		this.displayOrder = displayOrder;
	}

	public String getUploadedAt() {
		return uploadedAt;
	}

	public void setUploadedAt(String uploadedAt) {
		this.uploadedAt = uploadedAt;
	}
}