package com.basobas.controller.tenant;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.math.BigDecimal;
import java.time.LocalDate;
import java.util.List;

import com.basobas.dao.PropertyDAO;
import com.basobas.dao.RentalRequestDAO;
import com.basobas.dao.PropertyPhotoDAO;
import com.basobas.model.Property;
import com.basobas.model.RentalRequest;
import com.basobas.model.User;
import com.basobas.model.PropertyPhoto;

@WebServlet("/tenant/*")
public class TenantDashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private RentalRequestDAO rentalRequestDAO;
	private PropertyDAO propertyDAO;
	private PropertyPhotoDAO photoDAO;

	@Override
	public void init() throws ServletException {
		rentalRequestDAO = new RentalRequestDAO();
		propertyDAO = new PropertyDAO();
		photoDAO = new PropertyPhotoDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User currentUser = (User) session.getAttribute("loggedInUser");

		String path = request.getPathInfo();

		if (path == null || path.equals("/") || path.equals("/dashboard")) {
			showDashboard(request, response, currentUser);
		} else if (path.equals("/rentals")) {
			showRentals(request, response, currentUser);
		} else if (path.equals("/requests")) {
			showRequests(request, response, currentUser);
		} else if (path.equals("/payments")) {
			showPayments(request, response, currentUser);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getPathInfo();

		HttpSession session = request.getSession(false);
		if (session == null) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		User currentUser = (User) session.getAttribute("loggedInUser");
		if (currentUser == null || !"tenant".equals(currentUser.getRole())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		System.out.println("TenantDashboardController doPost - path: " + path);

		if (path.equals("/submit-request")) {
			submitRentalRequest(request, response, currentUser);
		} else if (path.equals("/cancel-request")) {
			cancelRentalRequest(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void submitRentalRequest(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			// Read JSON from request body
			StringBuilder sb = new StringBuilder();
			String line;
			try (java.io.BufferedReader reader = request.getReader()) {
				while ((line = reader.readLine()) != null) {
					sb.append(line);
				}
			}

			String jsonBody = sb.toString();
			System.out.println("Received JSON: " + jsonBody);

			// Parse JSON manually (since you may not have Jackson/Gson)
			int propertyId = 0;
			String moveInDateStr = null;
			int leaseDuration = 0;
			String tenantMessage = null;

			// Remove braces and split
			jsonBody = jsonBody.replace("{", "").replace("}", "");
			String[] pairs = jsonBody.split(",");
			for (String pair : pairs) {
				String[] keyValue = pair.split(":");
				if (keyValue.length == 2) {
					String key = keyValue[0].replace("\"", "").trim();
					String value = keyValue[1].replace("\"", "").trim();

					System.out.println("Key: '" + key + "', Value: '" + value + "'");

					switch (key) {
					case "propertyId":
						propertyId = Integer.parseInt(value);
						break;
					case "moveInDate":
						moveInDateStr = value;
						break;
					case "leaseDuration":
						leaseDuration = Integer.parseInt(value);
						break;
					case "message":
						tenantMessage = value;
						break;
					}
				}
			}

			System.out.println("Parsed - propertyId: " + propertyId);
			System.out.println("Parsed - moveInDateStr: " + moveInDateStr);
			System.out.println("Parsed - leaseDuration: " + leaseDuration);
			System.out.println("Parsed - tenantMessage: " + tenantMessage);

			// Validate
			if (propertyId == 0) {
				response.getWriter().write("{\"success\": false, \"message\": \"Property ID is required\"}");
				return;
			}

			if (moveInDateStr == null || moveInDateStr.isEmpty()) {
				response.getWriter().write("{\"success\": false, \"message\": \"Move-in date is required\"}");
				return;
			}

			if (leaseDuration == 0) {
				response.getWriter().write("{\"success\": false, \"message\": \"Lease duration is required\"}");
				return;
			}

			// Get property details
			PropertyDAO propertyDAO = new PropertyDAO();
			Property property = propertyDAO.findById(propertyId);

			if (property == null) {
				response.getWriter().write("{\"success\": false, \"message\": \"Property not found\"}");
				return;
			}

			// Check if already has pending request
			RentalRequestDAO rentalRequestDAO = new RentalRequestDAO();
			if (rentalRequestDAO.hasPendingRequest(user.getUserId(), propertyId)) {
				response.getWriter().write(
						"{\"success\": false, \"message\": \"You already have a pending request for this property\"}");
				return;
			}

			// Create rental request
			RentalRequest rentalRequest = new RentalRequest();
			rentalRequest.setPropertyId(propertyId);
			rentalRequest.setTenantId(user.getUserId());
			rentalRequest.setLandlordId(property.getLandlordId());
			rentalRequest.setRequestedMoveInDate(java.time.LocalDate.parse(moveInDateStr));
			rentalRequest.setRequestedLeaseDurationMonths(leaseDuration);
			rentalRequest.setTenantMessage(tenantMessage);

			boolean saved = rentalRequestDAO.save(rentalRequest);

			if (saved) {
				response.getWriter()
						.write("{\"success\": true, \"message\": \"Rental request submitted successfully!\"}");
			} else {
				response.getWriter()
						.write("{\"success\": false, \"message\": \"Failed to submit request. Please try again.\"}");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
		}
	}

	private void cancelRentalRequest(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");

		try {
			int requestId = Integer.parseInt(request.getParameter("requestId"));

			boolean cancelled = rentalRequestDAO.cancelRequest(requestId);

			if (cancelled) {
				response.getWriter().write("{\"success\": true, \"message\": \"Request cancelled successfully\"}");
			} else {
				response.getWriter().write(
						"{\"success\": false, \"message\": \"Could not cancel request. It may have already been processed.\"}");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"success\": false, \"message\": \"An error occurred\"}");
		}
	}

	private void showDashboard(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		List<Property> rentals = propertyDAO.getRentedPropertiesByTenant(user.getUserId());
		List<RentalRequest> requests = rentalRequestDAO.getRequestsByTenant(user.getUserId());

		long pendingRequests = requests.stream().filter(r -> "pending".equals(r.getStatus())).count();
		long approvedRequests = requests.stream().filter(r -> "approved".equals(r.getStatus())).count();

		request.setAttribute("rentals", rentals);
		request.setAttribute("rentalsCount", rentals.size());
		request.setAttribute("pendingRequests", pendingRequests);
		request.setAttribute("approvedRequests", approvedRequests);
		request.setAttribute("totalRequests", requests.size());
		request.setAttribute("page", "dashboard");

		request.getRequestDispatcher("/WEB-INF/pages/tenant/dashboard.jsp").forward(request, response);
	}

	private void showRentals(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		List<Property> rentals = propertyDAO.getRentedPropertiesByTenant(user.getUserId());

		for (Property property : rentals) {
			PropertyPhoto primaryPhoto = photoDAO.getPrimaryPhoto(property.getPropertyId());
			if (primaryPhoto != null && primaryPhoto.getPhotoUrl() != null) {
				property.setPrimaryPhotoUrl("/property-photo/" + primaryPhoto.getPhotoUrl());
			} else {
				property.setPrimaryPhotoUrl("/assets/no-image.jpg");
			}
		}

		request.setAttribute("rentals", rentals);
		request.setAttribute("page", "rentals");

		request.getRequestDispatcher("/WEB-INF/pages/tenant/rentals.jsp").forward(request, response);
	}

	private void showRequests(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		System.out.println("=== showRequests called for tenant ID: " + user.getUserId());

		List<RentalRequest> requests = rentalRequestDAO.getRequestsByTenant(user.getUserId());

		System.out.println("Found " + (requests != null ? requests.size() : 0) + " requests");

		if (requests != null && !requests.isEmpty()) {
			for (RentalRequest req : requests) {
				System.out.println(
						"Request: " + req.getDisplayId() + " - " + req.getPropertyTitle() + " - " + req.getStatus());
			}
		}

		request.setAttribute("requests", requests);
		request.setAttribute("page", "requests");

		request.getRequestDispatcher("/WEB-INF/pages/tenant/requests.jsp").forward(request, response);
	}

	private void showPayments(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		request.setAttribute("page", "payments");

		request.getRequestDispatcher("/WEB-INF/pages/tenant/payments.jsp").forward(request, response);
	}
}