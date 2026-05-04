package com.basobas.controller.admin;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.basobas.dao.PropertyDAO;
import com.basobas.model.Property;
import com.basobas.model.User;

@WebServlet("/admin/properties")
public class AdminPropertyController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PropertyDAO propertyDAO;

	public AdminPropertyController() {
		super();
		propertyDAO = new PropertyDAO();
	}

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Check if admin is logged in
		HttpSession session = request.getSession(false);
		if (session == null || session.getAttribute("loggedInUser") == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		User loggedInUser = (User) session.getAttribute("loggedInUser");
		if (!"admin".equals(loggedInUser.getRole())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin only.");
			return;
		}

		String format = request.getParameter("format");
		String search = request.getParameter("search");
		String status = request.getParameter("status");
		String city = request.getParameter("city");
		String sortBy = request.getParameter("sortBy");
		if (sortBy == null)
			sortBy = "property_id";
		String sortOrder = request.getParameter("sortOrder");
		if (sortOrder == null)
			sortOrder = "DESC";

		int page = 1;
		try {
			page = Integer.parseInt(request.getParameter("page"));
		} catch (Exception e) {
		}
		int limit = 10;
		int offset = (page - 1) * limit;

		List<Property> properties = propertyDAO.getFilteredProperties(search, status, city, offset, limit, sortBy,
				sortOrder);
		int total = propertyDAO.countFilteredProperties(search, status, city);
		int totalPages = (int) Math.ceil((double) total / limit);

		if ("json".equals(format)) {
			String json = buildPropertiesJson(properties, total, page, totalPages);
			response.setContentType("application/json");
			response.setCharacterEncoding("UTF-8");
			response.getWriter().write(json);
		} else {
			// Set attributes and forward to JSP
			request.setAttribute("propertyList", properties);
			request.setAttribute("totalProperties", total);
			request.setAttribute("currentPage", page);
			request.setAttribute("totalPages", totalPages);
			request.setAttribute("searchKeyword", search);
			request.setAttribute("selectedStatus", status);
			request.setAttribute("selectedCity", city);
			request.setAttribute("sortBy", sortBy);
			request.setAttribute("sortOrder", sortOrder);
			request.getRequestDispatcher("/WEB-INF/pages/admin/properties.jsp").forward(request, response);
		}
	}

	private String buildPropertiesJson(List<Property> properties, int total, int page, int totalPages) {
		StringBuilder json = new StringBuilder("{\"properties\":[");
		for (int i = 0; i < properties.size(); i++) {
			Property p = properties.get(i);
			json.append("{");
			json.append("\"displayId\":\"").append(escapeJson(p.getDisplayId())).append("\",");
			json.append("\"title\":\"").append(escapeJson(p.getTitle())).append("\",");
			json.append("\"landlordName\":\"").append(escapeJson(p.getLandlordName())).append("\",");
			json.append("\"city\":\"").append(escapeJson(p.getCity())).append("\",");
			json.append("\"monthlyRent\":").append(p.getMonthlyRent()).append(",");
			json.append("\"bedrooms\":").append(p.getBedrooms()).append(",");
			json.append("\"propertyType\":\"").append(escapeJson(p.getPropertyType())).append("\",");
			json.append("\"status\":\"").append(escapeJson(p.getStatus())).append("\",");
			json.append("\"createdAt\":\"").append(escapeJson(p.getCreatedAt())).append("\"");
			json.append("}");
			if (i < properties.size() - 1)
				json.append(",");
		}
		json.append("],\"total\":").append(total).append(",\"page\":").append(page).append(",\"totalPages\":")
				.append(totalPages).append("}");
		return json.toString();
	}

	private String escapeJson(String s) {
		if (s == null)
			return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t",
				"\\t");
	}

	// AdminPropertyController.java - Simplified (Read-Only)
	protected void doPost(HttpServletRequest request, HttpServletResponse response) 
	        throws ServletException, IOException {
	    response.sendRedirect(request.getContextPath() + "/admin/properties");
	}
}