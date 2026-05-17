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

import com.basobas.dao.PaymentDAO;
import com.basobas.dao.PropertyDAO;
import com.basobas.model.Payment;
import com.basobas.model.Property;
import com.basobas.model.User;

@WebServlet("/tenant/payments/*")
public class PaymentController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PaymentDAO paymentDAO;
	private PropertyDAO propertyDAO;

	@Override
	public void init() throws ServletException {
		paymentDAO = new PaymentDAO();
		propertyDAO = new PropertyDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession(false);
		User currentUser = (User) session.getAttribute("loggedInUser");

		String path = request.getPathInfo();

		if (path == null || path.equals("/") || path.equals("/list")) {
			showPayments(request, response, currentUser);
		} else if (path.equals("/make" ) || path.equals("/submit")) {
			showMakePaymentForm(request, response, currentUser);
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
		if (currentUser == null || !"tenant".equals(currentUser.getRole())) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN);
			return;
		}

		String path = request.getPathInfo();
		System.out.println("PaymentController doPost - pathInfo: " + path);

		if (path == null || path.equals("/")) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
			return;
		}

		if (path.equals("/make") || path.equals("/submit")) {
			submitPayment(request, response, currentUser);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void showPayments(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		List<Payment> payments = paymentDAO.getPaymentsByTenant(user.getUserId());

		request.setAttribute("payments", payments);
		request.setAttribute("page", "payments");

		request.getRequestDispatcher("/WEB-INF/pages/tenant/payments.jsp").forward(request, response);
	}

	private void showMakePaymentForm(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		System.out.println("=== showMakePaymentForm called ===");
		System.out.println("User ID: " + user.getUserId());

		// Get properties the tenant is currently renting
		List<Property> rentedProperties = propertyDAO.getRentedPropertiesByTenant(user.getUserId());

		System.out.println("Found " + rentedProperties.size() + " rented properties");

		request.setAttribute("properties", rentedProperties);
		request.setAttribute("page", "make-payment");

		request.getRequestDispatcher("/WEB-INF/pages/tenant/make-payment.jsp").forward(request, response);
	}

	private void submitPayment(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");

		try {
			// Use getParameter for FormData - MUCH simpler!
			String propertyIdStr = request.getParameter("propertyId");
			String amountStr = request.getParameter("amount");
			String paymentMonthStr = request.getParameter("paymentMonth");
			String paymentMethod = request.getParameter("paymentMethod");
			String transactionReference = request.getParameter("transactionReference");
			String notes = request.getParameter("notes");

			System.out.println("=== Payment Submission Debug ===");
			System.out.println("propertyIdStr: '" + propertyIdStr + "'");
			System.out.println("amountStr: '" + amountStr + "'");
			System.out.println("paymentMonthStr: '" + paymentMonthStr + "'");
			System.out.println("paymentMethod: '" + paymentMethod + "'");

			// Validate required fields
			if (propertyIdStr == null || propertyIdStr.trim().isEmpty()) {
				response.getWriter().write("{\"success\": false, \"message\": \"Property ID is required\"}");
				return;
			}

			if (amountStr == null || amountStr.trim().isEmpty()) {
				response.getWriter().write("{\"success\": false, \"message\": \"Amount is required\"}");
				return;
			}

			if (paymentMonthStr == null || paymentMonthStr.trim().isEmpty()) {
				response.getWriter().write("{\"success\": false, \"message\": \"Payment month is required\"}");
				return;
			}

			if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
				response.getWriter().write("{\"success\": false, \"message\": \"Payment method is required\"}");
				return;
			}

			int propertyId = Integer.parseInt(propertyIdStr.trim());
			BigDecimal amount = new BigDecimal(amountStr.trim());
			LocalDate paymentMonth = LocalDate.parse(paymentMonthStr.trim() + "-01");

			// Get property details
			Property property = propertyDAO.findById(propertyId);

			if (property == null) {
				response.getWriter().write("{\"success\": false, \"message\": \"Property not found\"}");
				return;
			}

			Payment payment = new Payment();
			payment.setPropertyId(propertyId);
			payment.setTenantId(user.getUserId());
			payment.setLandlordId(property.getLandlordId());
			payment.setAmount(amount);
			payment.setPaymentMonth(paymentMonth);
			payment.setPaymentMethod(paymentMethod);
			payment.setTransactionReference(transactionReference);
			payment.setNotes(notes);
			payment.setStatus("pending");

			boolean saved = paymentDAO.save(payment);

			if (saved) {
				response.getWriter().write(
						"{\"success\": true, \"message\": \"Payment recorded successfully! It will be verified by the landlord.\"}");
			} else {
				response.getWriter()
						.write("{\"success\": false, \"message\": \"Failed to record payment. Please try again.\"}");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"success\": false, \"message\": \"Error: " + e.getMessage() + "\"}");
		}
	}

}