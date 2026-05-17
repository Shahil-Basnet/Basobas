package com.basobas.controller.landlord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.basobas.dao.RentalRequestDAO;
import com.basobas.model.RentalRequest;
import com.basobas.model.User;

@WebServlet("/landlord/requests/*")
public class LandlordRequestController extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private RentalRequestDAO rentalRequestDAO;
    
    @Override
    public void init() throws ServletException {
        rentalRequestDAO = new RentalRequestDAO();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("loggedInUser");
        if (currentUser == null || !"landlord".equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String path = request.getPathInfo();
        
        if (path == null || path.equals("/") || path.equals("/list")) {
            showAllRequests(request, response, currentUser);
        } else if (path.equals("/pending")) {
            showPendingRequests(request, response, currentUser);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        User currentUser = (User) session.getAttribute("loggedInUser");
        if (currentUser == null || !"landlord".equals(currentUser.getRole())) {
            response.sendError(HttpServletResponse.SC_FORBIDDEN);
            return;
        }
        
        String path = request.getPathInfo();
        
        if (path.equals("/approve")) {
            approveRequest(request, response);
        } else if (path.equals("/reject")) {
            rejectRequest(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }
    
    private void showAllRequests(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        List<RentalRequest> requests = rentalRequestDAO.getRequestsByLandlord(user.getUserId());
        int pendingCount = rentalRequestDAO.countPendingRequests(user.getUserId());
        
        request.setAttribute("requests", requests);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("page", "requests");
        
        request.getRequestDispatcher("/WEB-INF/pages/landlord/rental-requests.jsp").forward(request, response);
    }
    
    private void showPendingRequests(HttpServletRequest request, HttpServletResponse response, User user)
            throws ServletException, IOException {
        
        List<RentalRequest> requests = rentalRequestDAO.getPendingRequestsByLandlord(user.getUserId());
        int pendingCount = rentalRequestDAO.countPendingRequests(user.getUserId());
        
        request.setAttribute("requests", requests);
        request.setAttribute("pendingCount", pendingCount);
        request.setAttribute("page", "pending");
        
        request.getRequestDispatcher("/WEB-INF/pages/landlord/rental-requests.jsp").forward(request, response);
    }
    
    private void approveRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String responseMessage = request.getParameter("responseMessage");
            
            boolean approved = rentalRequestDAO.approveRequest(requestId, responseMessage);
            
            if (approved) {
                response.getWriter().write("{\"success\": true, \"message\": \"Request approved successfully\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to approve request\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred\"}");
        }
    }
    
    private void rejectRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("application/json");
        
        try {
            int requestId = Integer.parseInt(request.getParameter("requestId"));
            String responseMessage = request.getParameter("responseMessage");
            
            boolean rejected = rentalRequestDAO.rejectRequest(requestId, responseMessage);
            
            if (rejected) {
                response.getWriter().write("{\"success\": true, \"message\": \"Request rejected\"}");
            } else {
                response.getWriter().write("{\"success\": false, \"message\": \"Failed to reject request\"}");
            }
            
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("{\"success\": false, \"message\": \"An error occurred\"}");
        }
    }
}