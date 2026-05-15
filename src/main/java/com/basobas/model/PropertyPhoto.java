package com.basobas.model;

import java.sql.Timestamp;

public class PropertyPhoto {
	private int photoId;
	private int propertyId;
	private String photoUrl;
	private boolean isPrimary;
	private String caption;
	private int displayOrder;
	private Timestamp uploadedAt;

	// Constructors
	public PropertyPhoto() {
	}

	public PropertyPhoto(int propertyId, String photoUrl, boolean isPrimary, int displayOrder) {
		this.propertyId = propertyId;
		this.photoUrl = photoUrl;
		this.isPrimary = isPrimary;
		this.displayOrder = displayOrder;
	}

	public PropertyPhoto(int propertyId, String photoUrl, boolean isPrimary, int displayOrder, String caption) {
		this(propertyId, photoUrl, isPrimary, displayOrder);
		this.caption = caption;
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

	public void setPrimary(boolean isPrimary) {
		this.isPrimary = isPrimary;
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

	public Timestamp getUploadedAt() {
		return uploadedAt;
	}

	public void setUploadedAt(Timestamp uploadedAt) {
		this.uploadedAt = uploadedAt;
	}

	// Helper method to get full URL for JSP
	public String getFullPhotoUrl() {
		if (photoUrl != null && photoUrl.startsWith("/")) {
			return photoUrl;
		}
		return "/uploads/properties/" + photoUrl;
	}

	@Override
	public String toString() {
		return "PropertyPhoto [photoId=" + photoId + ", propertyId=" + propertyId + ", isPrimary=" + isPrimary
				+ ", displayOrder=" + displayOrder + "]";
	}
}