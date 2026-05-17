package com.basobas.controller.landlord;

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
import com.basobas.model.Payment;
import com.basobas.model.User;

@WebServlet("/landlord/payments/*")
public class LandlordPaymentController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PaymentDAO paymentDAO;

	@Override
	public void init() throws ServletException {
		paymentDAO = new PaymentDAO();
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
			showPayments(request, response, currentUser);
		} else if (path.equals("/pending")) {
			showPendingPayments(request, response, currentUser);
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

		if (path.equals("/verify")) {
			verifyPayment(request, response);
		} else {
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void showPayments(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		List<Payment> payments = paymentDAO.getPaymentsByLandlord(user.getUserId());

		// Calculate total collected
		BigDecimal totalCollected = BigDecimal.ZERO;
		for (Payment p : payments) {
			if ("completed".equals(p.getStatus())) {
				totalCollected = totalCollected.add(p.getAmount());
			}
		}

		request.setAttribute("payments", payments);
		request.setAttribute("totalCollected", totalCollected);
		request.setAttribute("page", "payments");

		request.getRequestDispatcher("/WEB-INF/pages/landlord/payments.jsp").forward(request, response);
	}

	private void showPendingPayments(HttpServletRequest request, HttpServletResponse response, User user)
			throws ServletException, IOException {

		List<Payment> pendingPayments = paymentDAO.getPendingPaymentsByLandlord(user.getUserId());

		request.setAttribute("payments", pendingPayments);
		request.setAttribute("page", "payments");

		request.getRequestDispatcher("/WEB-INF/pages/landlord/payments.jsp").forward(request, response);
	}

	private void verifyPayment(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("application/json");

		try {
			int paymentId = Integer.parseInt(request.getParameter("paymentId"));
			String status = request.getParameter("status");

			boolean updated = paymentDAO.updateStatus(paymentId, status);

			if (updated) {
				response.getWriter().write("{\"success\": true, \"message\": \"Payment marked as " + status + "\"}");
			} else {
				response.getWriter().write("{\"success\": false, \"message\": \"Failed to update payment status\"}");
			}

		} catch (Exception e) {
			e.printStackTrace();
			response.getWriter().write("{\"success\": false, \"message\": \"An error occurred\"}");
		}
	}
}