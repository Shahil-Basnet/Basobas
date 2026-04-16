package com.basobas.services;
import org.mindrot.jbcrypt.BCrypt;
import com.basobas.dao.UserDAO;
import com.basobas.model.User;

public class AuthService {
    
    private UserDAO userDAO = new UserDAO();
    
    // Login method
    public User login(String username, String plainPassword) {
        // Find user by username
        User user = userDAO.findByUsername(username);
        
        // Check if user exists
        if (user == null) {
            return null;
        }
        
        // Check password (plain password vs stored hash)
        if (BCrypt.checkpw(plainPassword, user.getPassword())) {
            // Update last login time
            userDAO.updateLastLoggedIn(user.getUserId());
            return user;
        }
        
        return null;
    }
    
    // Register method
    public boolean register(String username, String email, String plainPassword, String role, String dateOfBirth) {
        
        // Check if username already exists
        if (userDAO.findByUsername(username) != null) {
            return false;
        }
        
        // Check if email already exists
        if (userDAO.findByEmail(email) != null) {
            return false;
        }
        
        // Hash the password
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        
        // Create user object
        User user = new User(username, email, hashedPassword, role, dateOfBirth);
        
        // Save to database
        return userDAO.save(user);
    }
    
    // Register with optional fields (fullName, phone, address)
    public boolean register(String username, String email, String plainPassword, String role, 
                            String dateOfBirth, String fullName, String phone, String address) {
        
        // Check if username already exists
        if (userDAO.findByUsername(username) != null) {
            return false;
        }
        
        // Check if email already exists
        if (userDAO.findByEmail(email) != null) {
            return false;
        }
        
        // Hash the password
        String hashedPassword = BCrypt.hashpw(plainPassword, BCrypt.gensalt());
        
        // Create user object
        User user = new User(username, email, hashedPassword, role, dateOfBirth);
        user.setFullName(fullName);
        user.setPhone(phone);
        user.setAddress(address);
        
        // Save to database
        return userDAO.save(user);
    }
    
    // Change password
    public boolean changePassword(String username, String oldPassword, String newPassword) {
        User user = userDAO.findByUsername(username);
        
        if (user == null) {
            return false;
        }
        
        // Verify old password
        if (!BCrypt.checkpw(oldPassword, user.getPassword())) {
            return false;
        }
        
        // Hash new password
        String hashedNewPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
        
        // Update in database
        return userDAO.changePassword(user.getUserId(), hashedNewPassword);
    }
    
    // Check if user exists by username
    public boolean usernameExists(String username) {
        return userDAO.findByUsername(username) != null;
    }
    
    // Check if user exists by email
    public boolean emailExists(String email) {
        return userDAO.findByEmail(email) != null;
    }
}