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

		// ========== VALIDATION ==========

		// 1. Check required fields
		if (username == null || username.trim().isEmpty()) {
			request.setAttribute("error", "Username is required");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		if (email == null || email.trim().isEmpty()) {
			request.setAttribute("error", "Email is required");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		if (password == null || password.trim().isEmpty()) {
			request.setAttribute("error", "Password is required");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		if (confirmPassword == null || confirmPassword.trim().isEmpty()) {
			request.setAttribute("error", "Please confirm your password");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		if (role == null || role.trim().isEmpty()) {
			request.setAttribute("error", "Please select a role");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// 2. Username validation - letters, numbers, underscore only, cannot start with
		// number
		String usernamePattern = "^[A-Za-z][A-Za-z0-9_]{3,19}$";
		if (!username.matches(usernamePattern)) {
			request.setAttribute("error",
					"Username must start with a letter, contain only letters, numbers, and underscores, and be 4-20 characters long");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// 3. Email validation
		String emailPattern = "^[A-Za-z0-9+_.-]+@(.+)$";
		if (!email.matches(emailPattern)) {
			request.setAttribute("error", "Please enter a valid email address");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// 4. Password validation
		if (password.length() < 6) {
			request.setAttribute("error", "Password must be at least 6 characters");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// Optional: Password strength - at least one number
		if (!password.matches(".*\\d.*")) {
			request.setAttribute("error", "Password must contain at least one number");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// Optional: Password strength - at least one uppercase letter
		if (!password.matches(".*[A-Z].*")) {
			request.setAttribute("error", "Password must contain at least one uppercase letter");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// 5. Check if passwords match
		if (!password.equals(confirmPassword)) {
			request.setAttribute("error", "Passwords do not match");
			request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
			return;
		}

		// 6. Full name validation (optional but if provided, no special characters)
		if (fullName != null && !fullName.trim().isEmpty()) {
			String namePattern = "^[A-Za-z\\s]+$";
			if (!fullName.trim().matches(namePattern)) {
				request.setAttribute("error", "Full name should only contain letters and spaces");
				request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
				return;
			}
		}

		// 7. Phone validation (optional but if provided, must be valid)
		if (phone != null && !phone.trim().isEmpty()) {
			String phonePattern = "^[0-9\\-\\+]{10,15}$";
			if (!phone.trim().matches(phonePattern)) {
				request.setAttribute("error", "Please enter a valid phone number (10-15 digits, may include + or -)");
				request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
				return;
			}
		}

		// 8. Date of birth validation (must be at least 18 years ago)
		if (dateOfBirth != null && !dateOfBirth.trim().isEmpty()) {
			try {
				java.time.LocalDate dob = java.time.LocalDate.parse(dateOfBirth);
				java.time.LocalDate today = java.time.LocalDate.now();
				int age = java.time.Period.between(dob, today).getYears();
				if (age < 18) {
					request.setAttribute("error", "You must be at least 18 years old to register");
					request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
					return;
				}
			} catch (Exception e) {
				request.setAttribute("error", "Invalid date format");
				request.getRequestDispatcher("/WEB-INF/pages/register.jsp").forward(request, response);
				return;
			}
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