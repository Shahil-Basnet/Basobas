package com.basobas.controller.landlord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.List;

import com.basobas.dao.PropertyDAO;
import com.basobas.dao.PropertyPhotoDAO;
import com.basobas.dao.RentalRequestDAO;
import com.basobas.dao.UserDAO;
import com.basobas.model.Property;
import com.basobas.model.PropertyPhoto;
import com.basobas.model.RentalRequest;
import com.basobas.model.User;

@WebServlet("/landlord/property-view")
public class LandlordPropertyViewController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PropertyDAO propertyDAO;
	private PropertyPhotoDAO photoDAO;
	private RentalRequestDAO rentalRequestDAO;
	private UserDAO userDAO;

	@Override
	public void init() throws ServletException {
		super.init();
		propertyDAO = new PropertyDAO();
		photoDAO = new PropertyPhotoDAO();
		rentalRequestDAO = new RentalRequestDAO();
		userDAO = new UserDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute("loggedInUser");

		if (currentUser == null || !"landlord".equals(currentUser.getRole())) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String displayId = request.getParameter("id");
		if (displayId == null || displayId.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/landlord/properties");
			return;
		}

		Property property = propertyDAO.findByDisplayId(displayId);

		// Verify ownership
		if (property == null || property.getLandlordId() != currentUser.getUserId()) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't own this property");
			return;
		}

		// Get all photos
		List<PropertyPhoto> photos = photoDAO.getPhotosByPropertyId(property.getPropertyId());

		// Get rental requests for this property
		List<RentalRequest> requests = null;
		try {
			// You'll need to add a method to get requests by property ID
			// For now, we'll get all landlord requests and filter
			List<RentalRequest> allRequests = rentalRequestDAO.getRequestsByLandlord(currentUser.getUserId());
			requests = new java.util.ArrayList<>();
			for (RentalRequest req : allRequests) {
				if (req.getPropertyId() == property.getPropertyId()) {
					requests.add(req);
				}
			}
		} catch (Exception e) {
			requests = new java.util.ArrayList<>();
		}

		// Get current tenant info if property is rented
		User currentTenant = null;
		if ("rented".equals(property.getStatus()) && property.getCurrentTenantId() != null) {
			currentTenant = userDAO.findById(property.getCurrentTenantId());
		}

		request.setAttribute("property", property);
		request.setAttribute("photos", photos);
		request.setAttribute("requests", requests);
		request.setAttribute("currentTenant", currentTenant);
		request.setAttribute("page", "property-view");

		request.getRequestDispatcher("/WEB-INF/pages/landlord/property-view.jsp").forward(request, response);
	}
}