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
import java.time.format.DateTimeFormatter;
import java.util.List;

import com.basobas.dao.PropertyDAO;
import com.basobas.dao.RentalRequestDAO;
import com.basobas.dao.PaymentDAO;
import com.basobas.model.Property;
import com.basobas.model.RentalRequest;
import com.basobas.model.User;

@WebServlet("/landlord/dashboard")
public class LandlordDashboardController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PropertyDAO propertyDAO;
	private RentalRequestDAO rentalRequestDAO;
	private PaymentDAO paymentDAO;

	@Override
	public void init() throws ServletException {
		propertyDAO = new PropertyDAO();
		rentalRequestDAO = new RentalRequestDAO();
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

		// Get all properties for this landlord
		List<Property> allProperties = propertyDAO.getPropertiesByLandlord(currentUser.getUserId());

		// Calculate stats
		int totalProperties = allProperties.size();
		int availableCount = 0;
		int rentedCount = 0;
		for (Property p : allProperties) {
			if ("available".equals(p.getStatus())) {
				availableCount++;
			} else if ("rented".equals(p.getStatus())) {
				rentedCount++;
			}
		}

		// Get pending requests count
		int pendingRequestsCount = rentalRequestDAO.countPendingRequests(currentUser.getUserId());

		// Get recent rental requests (last 5)
		List<RentalRequest> recentRequests = rentalRequestDAO.getPendingRequestsByLandlord(currentUser.getUserId());
		if (recentRequests.size() > 5) {
			recentRequests = recentRequests.subList(0, 5);
		}

		// Calculate monthly earnings (current month)
		LocalDate now = LocalDate.now();
		BigDecimal monthlyEarnings = paymentDAO.getTotalCollected(currentUser.getUserId(), now.getYear(),
				now.getMonthValue());

		// Get active leases count (properties with status 'rented')
		int activeLeases = rentedCount;

		// Format current date
		String currentDate = now.format(DateTimeFormatter.ofPattern("MMMM dd, yyyy"));

		// Set attributes
		request.setAttribute("landlordName", currentUser.getFullName());
		request.setAttribute("currentDate", currentDate);
		request.setAttribute("totalProperties", totalProperties);
		request.setAttribute("availableCount", availableCount);
		request.setAttribute("rentedCount", rentedCount);
		request.setAttribute("activeLeases", activeLeases);
		request.setAttribute("pendingRequestsCount", pendingRequestsCount);
		request.setAttribute("monthlyEarnings", monthlyEarnings);
		request.setAttribute("recentRequests", recentRequests);
		request.setAttribute("page", "dashboard");

		request.getRequestDispatcher("/WEB-INF/pages/landlord/dashboard.jsp").forward(request, response);
	}
}