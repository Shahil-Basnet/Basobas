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

		// Check if admin is logged in
		// HttpSession session = request.getSession(false);
		// if (session == null || session.getAttribute("loggedInUser") == null) {
		// response.sendRedirect(request.getContextPath() + "/login");
		// return;
		// }

		// User loggedInUser = (User) session.getAttribute("loggedInUser");
		// if (!"admin".equals(loggedInUser.getRole())) {
		// response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin
		// only.");
		// return;
		// }

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

	private void handleView(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Placeholder for view user
		response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED);
	}

	private void handleEdit(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Placeholder for edit user
		response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED);
	}

	private void handleCreate(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// Placeholder for create user
		response.sendError(HttpServletResponse.SC_NOT_IMPLEMENTED);
	}

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String action = request.getParameter("action");

		if ("delete".equals(action)) {
		    String displayId = request.getParameter("displayId");

		    // Find user by display_id first
		    User user = userDAO.findByDisplayId(displayId);
		    if (user != null && !"admin".equals(user.getRole())) {
		        // Don't allow deleting other admins
		        userDAO.delete(user.getUserId());
		    }
		} else if ("resetPassword".equals(action)) {
		    String displayId = request.getParameter("displayId");
		    User user = userDAO.findByDisplayId(displayId);
		    if (user != null) {
		        // Reset to default password
		        String defaultPassword = "Basobas@123";
		        String hashedPassword = BCrypt.hashpw(defaultPassword, BCrypt.gensalt());
		        userDAO.changePassword(user.getUserId(), hashedPassword);

		        // Add success message to session to show on redirect
		        request.getSession().setAttribute("message", "Password for " + user.getUsername() + " has been reset to: " + defaultPassword);
		        request.getSession().setAttribute("messageType", "success");
		    }
		} else if ("bulkDelete".equals(action)) {			String[] displayIds = request.getParameterValues("displayIds");
			if (displayIds != null) {
				for (String displayId : displayIds) {
					User user = userDAO.findByDisplayId(displayId);
					if (user != null && !"admin".equals(user.getRole())) {
						userDAO.delete(user.getUserId());
					}
				}
			}
		} else if ("create".equals(action)) {
			String fullName = request.getParameter("fullName");
			String username = request.getParameter("username");
			String email = request.getParameter("email");
			String phone = request.getParameter("phone");
			String role = request.getParameter("role");
			String dateOfBirth = request.getParameter("dateOfBirth");
			String address = request.getParameter("address");
			String password = request.getParameter("password");

			// Check if username or email already exists
			if (userDAO.findByUsername(username) != null) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Username already exists");
				return;
			}
			if (userDAO.findByEmail(email) != null) {
				response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Email already exists");
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
				response.setStatus(HttpServletResponse.SC_OK);
				response.getWriter().write("User created successfully");
			} else {
				response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Failed to create user");
			}
		}

		// Redirect back to the users list
		response.sendRedirect(request.getContextPath() + "/admin/users");
	}
}