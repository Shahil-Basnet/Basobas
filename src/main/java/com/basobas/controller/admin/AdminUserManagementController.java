package com.basobas.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

import com.basobas.dao.UserDAO;
import com.basobas.model.User;

@WebServlet("/admin/users")
public class AdminUserManagementController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private UserDAO userDAO;

	public AdminUserManagementController() {
		super();
		userDAO = new UserDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		handleList(request, response);
	}

	private void handleList(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String format = request.getParameter("format");
		String search = request.getParameter("search");
		String role = request.getParameter("role");
		String sortBy = request.getParameter("sortBy");
		if (sortBy == null)
			sortBy = "user_id";
		String sortOrder = request.getParameter("sortOrder");
		if (sortOrder == null)
			sortOrder = "DESC";

		int page = 1;
		try {
			page = Integer.parseInt(request.getParameter("page"));
		} catch (Exception e) {
		}
		int limit = 5;
		int offset = (page - 1) * limit;

		List<User> users = userDAO.getUsersFiltered(search, role, offset, limit, sortBy, sortOrder);
		int total = userDAO.countUsersFiltered(search, role);
		int totalPages = (int) Math.ceil((double) total / limit);

		// Fetch role counts
		int adminCount = userDAO.countByRole("admin");
		int landlordCount = userDAO.countByRole("landlord");
		int tenantCount = userDAO.countByRole("tenant");

		if ("json".equals(format)) {
			// Return JSON
			String json = buildUsersJson(users, total, page, totalPages, adminCount, landlordCount, tenantCount);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(json);
		} else {
			// Set attributes and forward
			request.setAttribute("userList", users);
			request.setAttribute("totalUsers", total);
			request.setAttribute("adminCount", adminCount);
			request.setAttribute("landlordCount", landlordCount);
			request.setAttribute("tenantCount", tenantCount);
			request.setAttribute("currentPage", page);
			request.setAttribute("totalPages", totalPages);
			request.setAttribute("searchKeyword", search);
			request.setAttribute("selectedRole", role);
			request.setAttribute("sortBy", sortBy);
			request.setAttribute("sortOrder", sortOrder);
			request.getRequestDispatcher("/WEB-INF/pages/admin/users.jsp").forward(request, response);
		}
	}

	private String buildUsersJson(List<User> users, int total, int page, int totalPages, int adminCount,
			int landlordCount, int tenantCount) {
		StringBuilder json = new StringBuilder("{\"users\":[");
		for (int i = 0; i < users.size(); i++) {
			User u = users.get(i);
			json.append("{");
			json.append("\"displayId\":\"").append(escapeJson(u.getDisplayId())).append("\",");
			json.append("\"fullName\":\"").append(escapeJson(u.getFullName() != null ? u.getFullName() : ""))
					.append("\",");
			json.append("\"username\":\"").append(escapeJson(u.getUsername())).append("\",");
			json.append("\"email\":\"").append(escapeJson(u.getEmail())).append("\",");
			json.append("\"role\":\"").append(escapeJson(u.getRole())).append("\",");
			json.append("\"phone\":\"").append(escapeJson(u.getPhone() != null ? u.getPhone() : "")).append("\",");
			json.append("\"registeredAt\":\"").append(escapeJson(u.getRegisteredAt())).append("\",");
			json.append("\"lastLoggedIn\":\"")
					.append(escapeJson(u.getLastLoggedIn() != null ? u.getLastLoggedIn() : "Never")).append("\"");
			json.append("}");
			if (i < users.size() - 1)
				json.append(",");
		}
		json.append("],\"total\":").append(total).append(",\"page\":").append(page).append(",\"totalPages\":")
				.append(totalPages).append(",\"adminCount\":").append(adminCount).append(",\"landlordCount\":")
				.append(landlordCount).append(",\"tenantCount\":").append(tenantCount).append("}");
		return json.toString();
	}

	private String escapeJson(String s) {
		if (s == null)
			return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t",
				"\\t");
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		System.out.println("=== doPost called ===");
		System.out.println("Action: " + action);

		if ("delete".equals(action)) {
			String displayId = request.getParameter("displayId");
			User user = userDAO.findByDisplayId(displayId);
			if (user != null && !"admin".equals(user.getRole())) {
				userDAO.delete(user.getUserId());
			}
			response.sendRedirect(request.getContextPath() + "/admin/users");

		} else if ("resetPassword".equals(action)) {
			String displayId = request.getParameter("displayId");
			User user = userDAO.findByDisplayId(displayId);
			if (user != null) {
				String defaultPassword = "Basobas@123";
				String hashedPassword = BCrypt.hashpw(defaultPassword, BCrypt.gensalt());
				userDAO.changePassword(user.getUserId(), hashedPassword);
				request.getSession().setAttribute("message",
						"Password for " + user.getUsername() + " has been reset to: " + defaultPassword);
				request.getSession().setAttribute("messageType", "success");
			}
			response.sendRedirect(request.getContextPath() + "/admin/users");

		} else if ("bulkDelete".equals(action)) {
			String[] displayIds = request.getParameterValues("displayIds");
			if (displayIds != null) {
				for (String displayId : displayIds) {
					User user = userDAO.findByDisplayId(displayId);
					if (user != null && !"admin".equals(user.getRole())) {
						userDAO.delete(user.getUserId());
					}
				}
			}
			response.sendRedirect(request.getContextPath() + "/admin/users");

		} else if ("create".equals(action)) {
			// Set response type to JSON
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");

			String fullName = request.getParameter("fullName");
			String username = request.getParameter("username");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
			String role = request.getParameter("role");
			String dateOfBirth = request.getParameter("dateOfBirth");
			String address = request.getParameter("address");
			String password = request.getParameter("password");

			System.out.println("Create user - username: " + username + ", email: " + email);

			// Validation
			if (username == null || username.trim().isEmpty()) {
				response.getWriter().write("{\"success\": false, \"message\": \"Username is required\"}");
				return;
			}

			if (email == null || email.trim().isEmpty()) {
				response.getWriter().write("{\"success\": false, \"message\": \"Email is required\"}");
				return;
			}

			if (password == null || password.trim().isEmpty()) {
				response.getWriter().write("{\"success\": false, \"message\": \"Password is required\"}");
				return;
			}

			// Check if username already exists
			if (userDAO.findByUsername(username) != null) {
				System.out.println("Username already exists: " + username);
				response.getWriter().write("{\"success\": false, \"message\": \"Username already exists\"}");
				return;
			}

			// Check if email already exists
			if (userDAO.findByEmail(email) != null) {
				System.out.println("Email already exists: " + email);
				response.getWriter().write("{\"success\": false, \"message\": \"Email already exists\"}");
				return;
			}

			// Hash password with BCrypt
			String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

			// Create new user
			User newUser = new User();
			newUser.setFullName(fullName);
			newUser.setUsername(username);
			newUser.setEmail(email);
			newUser.setPhone(phone);
			newUser.setRole(role);
			newUser.setDateOfBirth(dateOfBirth);
			newUser.setAddress(address);
			newUser.setPassword(hashedPassword);

			if (userDAO.save(newUser)) {
				System.out.println("User created successfully: " + username);
				response.getWriter().write("{\"success\": true, \"message\": \"User created successfully\"}");
			} else {
				System.out.println("Failed to create user: " + username);
				response.getWriter().write("{\"success\": false, \"message\": \"Failed to create user\"}");
			}
			return; // IMPORTANT: Don't redirect, just return

		} else {
			System.out.println("Unknown action: " + action);
			response.sendRedirect(request.getContextPath() + "/admin/users");
		}
	}
}