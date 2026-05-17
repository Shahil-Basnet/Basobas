package com.basobas.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

import com.basobas.dao.UserDAO;
import com.basobas.dao.PropertyDAO;
import com.basobas.dao.RentalRequestDAO;
import com.basobas.model.Property;
import com.basobas.model.RentalRequest;

@WebServlet("/admin/dashboard")
public class AdminDashboardController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private UserDAO userDAO;
    private PropertyDAO propertyDAO;
    private RentalRequestDAO rentalRequestDAO;
    
    @Override
    public void init() throws ServletException {
        userDAO = new UserDAO();
        propertyDAO = new PropertyDAO();
        rentalRequestDAO = new RentalRequestDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        // Get real statistics from database
        int totalUsers = userDAO.countAllUsers();
        int totalProperties = propertyDAO.countAllProperties();
        int pendingRequests = 0;
        
        // Count pending rental requests (across all properties)
        List<Property> allProperties = propertyDAO.getAllProperties();
        
        // Calculate occupied properties (rented)
        int occupiedProperties = 0;
        for (Property p : allProperties) {
            if ("rented".equals(p.getStatus())) {
                occupiedProperties++;
            }
        }
        
        // Get recent properties (last 5)
        List<Property> recentProperties = propertyDAO.getAllProperties();
        if (recentProperties.size() > 5) {
            recentProperties = recentProperties.subList(0, 5);
        }
        
        // Get recent rental requests (last 3)
        // You'll need a method in RentalRequestDAO for this
        List<RentalRequest> recentRequests = null;
        try {
            // This assumes you have a method to get all requests
            // If not, create a new method or leave empty for now
            recentRequests = java.util.Collections.emptyList();
        } catch (Exception e) {
            recentRequests = java.util.Collections.emptyList();
        }
        
        // Calculate occupancy rate
        int occupancyRate = totalProperties > 0 ? (occupiedProperties * 100 / totalProperties) : 0;
        
        // Set attributes for JSP
        request.setAttribute("totalUsers", totalUsers);
        request.setAttribute("totalProperties", totalProperties);
        request.setAttribute("occupiedProperties", occupiedProperties);
        request.setAttribute("occupancyRate", occupancyRate);
        request.setAttribute("pendingRequests", pendingRequests);
        request.setAttribute("recentProperties", recentProperties);
        request.setAttribute("recentRequests", recentRequests);
        request.setAttribute("page", "dashboard");
        
        request.getRequestDispatcher("/WEB-INF/pages/admin/dashboard.jsp")
               .forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        doGet(request, response);
    }
}