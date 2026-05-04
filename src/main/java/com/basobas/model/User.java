package com.basobas.model;

public class User {
    
    // Fields
    private int userId;
    private String displayId;
    private String username;
    private String email;
    private String password;
    private String role;
    private String fullName;
    private String phone;
    private String address;
    private String dateOfBirth;
    private String registeredAt;
    

	private String lastLoggedIn;
    
    // Default Constructor
    public User() {
        this.role = "tenant";
    }
    
    // Constructor for registration
    public User(String username, String email, String password, String role, String dateOfBirth) {
        this.username = username;
        this.email = email;
        this.password = password;
        this.role = role;
        this.dateOfBirth = dateOfBirth;
    }
    
    // Getters
    public int getUserId() {
        return userId;
    }
    
    public String getDisplayId() {
		return displayId;
	}
    
    public String getUsername() {
        return username;
    }
    
    public String getEmail() {
        return email;
    }
    
    public String getPassword() {
        return password;
    }
    
    public String getRole() {
        return role;
    }
    
    public String getFullName() {
        return fullName;
    }
    
    public String getPhone() {
        return phone;
    }
    
    public String getAddress() {
        return address;
    }
    
    public String getDateOfBirth() {
        return dateOfBirth;
    }
    
    public String getRegisteredAt() {
        return registeredAt;
    }
    
    public String getLastLoggedIn() {
        return lastLoggedIn;
    }

	
    // Setters
    public void setUserId(int userId) {
        this.userId = userId;
    }
    
    public void setDisplayId(String displayId) {
		this.displayId = displayId;
	}
    
    public void setUsername(String username) {
        this.username = username;
    }
    
    public void setEmail(String email) {
        this.email = email;
    }
    
    public void setPassword(String password) {
        this.password = password;
    }
    
    public void setRole(String role) {
        this.role = role;
    }
    
    public void setFullName(String fullName) {
        this.fullName = fullName;
    }
    
    public void setPhone(String phone) {
        this.phone = phone;
    }
    
    public void setAddress(String address) {
        this.address = address;
    }
    
    public void setDateOfBirth(String dateOfBirth) {
        this.dateOfBirth = dateOfBirth;
    }
    
    public void setRegisteredAt(String registeredAt) {
        this.registeredAt = registeredAt;
    }
    
    public void setLastLoggedIn(String lastLoggedIn) {
        this.lastLoggedIn = lastLoggedIn;
    }
    
    // Helper Methods
    public boolean isAdmin() {
        return "admin".equalsIgnoreCase(this.role);
    }
    
    public boolean isLandlord() {
        return "landlord".equalsIgnoreCase(this.role);
    }
    
    public boolean isTenant() {
        return "tenant".equalsIgnoreCase(this.role);
    }
}