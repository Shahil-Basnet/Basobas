package com.basobas.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.basobas.dao.UserDAO;
import com.basobas.model.User;
import org.mindrot.jbcrypt.BCrypt;

@WebServlet(urlPatterns = { "/forgot-password", "/reset-password" })
public class ForgotPasswordController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private UserDAO userDAO;

	@Override
	public void init() throws ServletException {
		userDAO = new UserDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getServletPath();

		if ("/forgot-password".equals(path)) {
			request.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(request, response);
		} else if ("/reset-password".equals(path)) {
			String token = request.getParameter("token");
			request.setAttribute("token", token);
			request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getServletPath();

		if ("/forgot-password".equals(path)) {
			String email = request.getParameter("email");

			if (email == null || email.trim().isEmpty()) {
				request.setAttribute("error", "Email is required");
				request.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(request, response);
				return;
			}

			User user = userDAO.findByEmail(email);

			if (user == null) {
				request.setAttribute("error", "Email not found in our records");
				request.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(request, response);
				return;
			}

			// Simple: Show reset form directly (without email in this simple version)
			request.setAttribute("email", email);
			request.setAttribute("message", "Reset link generated! Please set your new password below.");
			request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);

		} else if ("/reset-password".equals(path)) {
			String email = request.getParameter("email");
			String newPassword = request.getParameter("newPassword");
			String confirmPassword = request.getParameter("confirmPassword");

			if (newPassword == null || newPassword.trim().isEmpty()) {
				request.setAttribute("error", "Password is required");
				request.setAttribute("email", email);
				request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);
				return;
			}

			if (newPassword.length() < 4) {
				request.setAttribute("error", "Password must be at least 4 characters");
				request.setAttribute("email", email);
				request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);
				return;
			}

			if (!newPassword.equals(confirmPassword)) {
				request.setAttribute("error", "Passwords do not match");
				request.setAttribute("email", email);
				request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);
				return;
			}

			User user = userDAO.findByEmail(email);

			if (user == null) {
				request.setAttribute("error", "User not found");
				request.getRequestDispatcher("/WEB-INF/pages/forgot-password.jsp").forward(request, response);
				return;
			}

			// Hash new password
			String hashedPassword = BCrypt.hashpw(newPassword, BCrypt.gensalt());
			boolean updated = userDAO.changePassword(user.getUserId(), hashedPassword);

			if (updated) {
				request.setAttribute("message", "Password reset successfully! Please login with your new password.");
				request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
			} else {
				request.setAttribute("error", "Failed to reset password. Please try again.");
				request.setAttribute("email", email);
				request.getRequestDispatcher("/WEB-INF/pages/reset-password.jsp").forward(request, response);
			}
		}
	}
}