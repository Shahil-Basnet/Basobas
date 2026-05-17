package com.basobas.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;

import com.basobas.dao.UserDAO;
import com.basobas.model.User;
import com.basobas.services.AuthService;

@WebServlet("/profile")
public class ProfileController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private UserDAO userDAO;
	private AuthService authService;

	@Override
	public void init() throws ServletException {
		userDAO = new UserDAO();
		authService = new AuthService();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User currentUser = (User) session.getAttribute("loggedInUser");
		// Get fresh user data from database
		User user = userDAO.findById(currentUser.getUserId());

		request.setAttribute("profileUser", user);
		request.setAttribute("page", "profile");

		// Role-specific sidebar will be handled in JSP
		request.getRequestDispatcher("/WEB-INF/pages/profile.jsp").forward(request, response);
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
		if (currentUser == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String action = request.getParameter("action");

		if ("updateProfile".equals(action)) {
			updateProfile(request, response, currentUser);
		} else if ("changePassword".equals(action)) {
			changePassword(request, response, currentUser);
		} else {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
		}
	}

	private void updateProfile(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws ServletException, IOException {

		String fullName = request.getParameter("fullName");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");

		currentUser.setFullName(fullName);
		currentUser.setPhone(phone);
		currentUser.setAddress(address);

		boolean updated = userDAO.update(currentUser);

		if (updated) {
			// Update session
			request.getSession().setAttribute("loggedInUser", currentUser);
			request.getSession().setAttribute("message", "Profile updated successfully!");
			request.getSession().setAttribute("messageType", "success");
		} else {
			request.getSession().setAttribute("message", "Failed to update profile.");
			request.getSession().setAttribute("messageType", "error");
		}

		response.sendRedirect(request.getContextPath() + "/profile");
	}

	private void changePassword(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws ServletException, IOException {

		String currentPassword = request.getParameter("currentPassword");
		String newPassword = request.getParameter("newPassword");
		String confirmPassword = request.getParameter("confirmPassword");

		// Check if new password matches confirmation
		if (!newPassword.equals(confirmPassword)) {
			request.getSession().setAttribute("message", "New passwords do not match.");
			request.getSession().setAttribute("messageType", "error");
			response.sendRedirect(request.getContextPath() + "/profile");
			return;
		}

		// Validate password strength
		if (newPassword.length() < 4) {
			request.getSession().setAttribute("message", "Password must be at least 4 characters.");
			request.getSession().setAttribute("messageType", "error");
			response.sendRedirect(request.getContextPath() + "/profile");
			return;
		}

		// Use AuthService to change password
		boolean updated = authService.changePassword(currentUser.getUsername(), currentPassword, newPassword);

		if (updated) {
			request.getSession().setAttribute("message", "Password changed successfully!");
			request.getSession().setAttribute("messageType", "success");
		} else {
			request.getSession().setAttribute("message", "Current password is incorrect.");
			request.getSession().setAttribute("messageType", "error");
		}

		response.sendRedirect(request.getContextPath() + "/profile");
	}
}