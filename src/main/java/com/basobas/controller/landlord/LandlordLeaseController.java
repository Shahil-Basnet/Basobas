package com.basobas.controller.landlord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.basobas.dao.PropertyDAO;
import com.basobas.model.Property;
import com.basobas.model.User;

@WebServlet("/landlord/leases")
public class LandlordLeaseController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PropertyDAO propertyDAO;

	@Override
	public void init() throws ServletException {
		super.init();
		propertyDAO = new PropertyDAO();
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

		// Get properties that are currently rented
		List<Property> allProperties = propertyDAO.getPropertiesByLandlord(currentUser.getUserId());
		List<Property> rentedProperties = new ArrayList<>();

		for (Property property : allProperties) {
			if ("rented".equals(property.getStatus())) {
				// Load tenant info from database if needed
				rentedProperties.add(property);
			}
		}

		request.setAttribute("leases", rentedProperties);
		request.setAttribute("page", "leases");

		request.getRequestDispatcher("/WEB-INF/pages/landlord/leases.jsp").forward(request, response);
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doGet(request, response);
	}
}