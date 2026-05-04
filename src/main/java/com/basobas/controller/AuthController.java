package com.basobas.controller;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import com.basobas.services.AuthService;
import com.basobas.model.User;

@WebServlet(urlPatterns = { "/login", "/register", "/logout" })
public class AuthController extends HttpServlet {

	private AuthService authService = new AuthService();

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getServletPath();

		switch (path) {
		case "/login":
			request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
			break;

		case "/register":
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			break;

		case "/logout":
			HttpSession session = request.getSession(false);
			if (session != null) {
				session.invalidate();
			}
			response.sendRedirect("login");
			break;
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getServletPath();

		switch (path) {
		case "/login":
			processLogin(request, response);
			break;

		case "/register":
			processRegister(request, response);
			break;
		}
	}

	private void processLogin(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String username = request.getParameter("username");
		String password = request.getParameter("password");

		if (username == null || username.trim().isEmpty() || password == null || password.trim().isEmpty()) {

			request.setAttribute("error", "Username and password are required");
			request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
			return;
		}

		User user = authService.login(username, password);

		if (user != null) {
			HttpSession session = request.getSession();
			session.setAttribute("loggedInUser", user);

			String role = user.getRole();
			switch (role) {
			case "admin":
				response.sendRedirect("admin/dashboard");
				break;
			case "landlord":
				response.sendRedirect("landlord/dashboard");
				break;
			default:
				response.sendRedirect("tenant/dashboard");
				break;
			}
		} else {
			request.setAttribute("error", "Invalid username or password");
			request.getRequestDispatcher("/WEB-INF/pages/login.jsp").forward(request, response);
		}
	}

	private void processRegister(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Get form parameters
		String username = request.getParameter("username");
		String email = request.getParameter("email");
		String password = request.getParameter("password");
		String confirmPassword = request.getParameter("confirmPassword");
		String role = request.getParameter("role");
		String dateOfBirth = request.getParameter("dateOfBirth");
		String fullName = request.getParameter("fullName");
		String phone = request.getParameter("phone");
		String address = request.getParameter("address");

		// Validate required fields
		if (username == null || username.trim().isEmpty() || email == null || email.trim().isEmpty() || password == null
				|| password.trim().isEmpty() || confirmPassword == null || confirmPassword.trim().isEmpty()
				|| role == null || role.trim().isEmpty()) {

			request.setAttribute("error", "All required fields must be filled");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// Check if passwords match
		if (!password.equals(confirmPassword)) {
			request.setAttribute("error", "Passwords do not match");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// Check password length (minimum 6 characters)
		if (password.length() < 6) {
			request.setAttribute("error", "Password must be at least 6 characters");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// Register user
		boolean success = authService.register(username, email, password, role, dateOfBirth, fullName, phone, address);

		if (success) {
			// Registration successful - redirect to login
			response.sendRedirect("login");
		} else {
			// Registration failed - username or email exists
			request.setAttribute("error", "Username or email already exists");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
		}
	}
}