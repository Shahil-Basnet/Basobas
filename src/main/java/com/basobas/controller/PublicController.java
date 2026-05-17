package com.basobas.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import com.basobas.dao.PropertyDAO;
import com.basobas.dao.PropertyPhotoDAO;
import com.basobas.model.Property;
import com.basobas.model.PropertyPhoto;

@WebServlet(urlPatterns = {"/index", "/properties", "/property", "/about", "/contact" })
public class PublicController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PropertyDAO propertyDAO;
	private PropertyPhotoDAO photoDAO;

	@Override
	public void init() throws ServletException {
		super.init();
		propertyDAO = new PropertyDAO();
		photoDAO = new PropertyPhotoDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String path = request.getServletPath();
		
		switch (path) {
		case "/index":
			showHomePage(request, response);
			break;
		case "/properties":
			showPropertiesList(request, response);
			break;
		case "/property":
			showPropertyDetails(request, response);
			break;
		case "/about":
			request.getRequestDispatcher("/WEB-INF/pages/about.jsp").forward(request, response);
			break;
		case "/contact":
			request.getRequestDispatcher("/WEB-INF/pages/contact.jsp").forward(request, response);
			break;
		default:
			response.sendError(HttpServletResponse.SC_NOT_FOUND);
		}
	}

	private void showHomePage(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		// Get featured properties (latest 6 available properties)
		List<Property> allProperties = propertyDAO.getAllProperties();
		List<Property> featuredProperties = new ArrayList<>();

		int count = 0;
		for (Property p : allProperties) {
			if ("available".equals(p.getStatus()) && count < 6) {
				featuredProperties.add(p);
				count++;
			}
		}

		// Load primary photo URL for each featured property
		for (Property p : featuredProperties) {
		    PropertyPhoto primaryPhoto = photoDAO.getPrimaryPhoto(p.getPropertyId());
		    if (primaryPhoto != null) {
		        p.setPrimaryPhotoUrl(primaryPhoto.getFullPhotoUrl());
		    } else {
		        List<PropertyPhoto> photos = photoDAO.getPhotosByPropertyId(p.getPropertyId());
		        if (!photos.isEmpty()) {
		            p.setPrimaryPhotoUrl(photos.get(0).getFullPhotoUrl());
		        } else {
		            p.setPrimaryPhotoUrl("/assets/no-image.jpg");
		        }
		    }
		}

		// Calculate stats
		int totalProperties = allProperties.size();
		java.util.Set<Integer> landlordIds = new java.util.HashSet<>();
		for (Property p : allProperties) {
			landlordIds.add(p.getLandlordId());
		}
		int activeLandlords = landlordIds.size();
		int happyTenants = 100; // Placeholder - calculate from actual tenant count if needed

		request.setAttribute("featuredProperties", featuredProperties);
		request.setAttribute("totalProperties", totalProperties);
		request.setAttribute("activeLandlords", activeLandlords);
		request.setAttribute("happyTenants", happyTenants);
		request.setAttribute("page", "home");

		request.getRequestDispatcher("/WEB-INF/pages/index.jsp").forward(request, response);
	}

	private void showPropertiesList(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String search = request.getParameter("search");
	    String city = request.getParameter("city");
	    String minRent = request.getParameter("minRent");
	    String maxRent = request.getParameter("maxRent");
	    String bedrooms = request.getParameter("bedrooms");
	    String hasPowerBackup = request.getParameter("hasPowerBackup");

	    // Get all available properties
	    List<Property> allProperties = propertyDAO.getAllProperties();
	    List<Property> availableProperties = new ArrayList<>();

	    // Filter only available properties
	    for (Property p : allProperties) {
	        if (!"available".equals(p.getStatus())) {
	            continue;
	        }

	        // Apply search filter
	        if (search != null && !search.isEmpty()) {
	            if (!p.getTitle().toLowerCase().contains(search.toLowerCase())
	                    && !p.getCity().toLowerCase().contains(search.toLowerCase())) {
	                continue;
	            }
	        }

	        // Apply city filter
	        if (city != null && !city.isEmpty() && !"all".equals(city)) {
	            if (!p.getCity().equals(city)) {
	                continue;
	            }
	        }

	        // Apply rent filter
	        if (minRent != null && !minRent.isEmpty()) {
	            try {
	                int min = Integer.parseInt(minRent);
	                if (p.getMonthlyRent() < min) continue;
	            } catch (NumberFormatException e) {}
	        }

	        if (maxRent != null && !maxRent.isEmpty()) {
	            try {
	                int max = Integer.parseInt(maxRent);
	                if (p.getMonthlyRent() > max) continue;
	            } catch (NumberFormatException e) {}
	        }

	        // Apply bedrooms filter
	        if (bedrooms != null && !bedrooms.isEmpty() && !"all".equals(bedrooms)) {
	            try {
	                int beds = Integer.parseInt(bedrooms);
	                if (p.getBedrooms() != beds) continue;
	            } catch (NumberFormatException e) {}
	        }

	        // Apply power backup filter
	        if (hasPowerBackup != null && hasPowerBackup.equals("1")) {
	            if (p.getPowerBackupHours() == null || p.getPowerBackupHours() == 0) {
	                continue;
	            }
	        }

	        availableProperties.add(p);
	    }

	    // Load primary photo URL for each property
	    for (Property p : availableProperties) {
	        PropertyPhoto primaryPhoto = photoDAO.getPrimaryPhoto(p.getPropertyId());
	        if (primaryPhoto != null) {
	            p.setPrimaryPhotoUrl(primaryPhoto.getFullPhotoUrl());
	        } else {
	            // Fallback to first photo if no primary
	            List<PropertyPhoto> photos = photoDAO.getPhotosByPropertyId(p.getPropertyId());
	            if (!photos.isEmpty()) {
	                p.setPrimaryPhotoUrl(photos.get(0).getFullPhotoUrl());
	            } else {
	                p.setPrimaryPhotoUrl("/assets/no-image.jpg");
	            }
	        }
	    }

	    // Get unique cities for filter dropdown
	    List<String> cities = propertyDAO.getAllCities();

	    request.setAttribute("properties", availableProperties);
	    request.setAttribute("cities", cities);
	    request.setAttribute("page", "properties");

	    request.getRequestDispatcher("/WEB-INF/pages/properties.jsp").forward(request, response);
	}

	private void showPropertyDetails(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String displayId = request.getParameter("id");
		if (displayId == null || displayId.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/properties");
			return;
		}

		Property property = propertyDAO.findByDisplayId(displayId);
		if (property == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "Property not found");
			return;
		}

		// Get property photos
		List<com.basobas.model.PropertyPhoto> photos = photoDAO.getPhotosByPropertyId(property.getPropertyId());

		request.setAttribute("property", property);
		request.setAttribute("photos", photos);
		request.setAttribute("page", "property");

		request.getRequestDispatcher("/WEB-INF/pages/property-details.jsp").forward(request, response);
	}
}