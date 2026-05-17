package com.basobas.controller.landlord;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import jakarta.servlet.http.Part;

import java.io.File;
import java.io.IOException;
import java.sql.Date;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.List;
import java.util.Collection;

import com.basobas.dao.PropertyDAO;
import com.basobas.dao.PropertyPhotoDAO;
import com.basobas.model.Property;
import com.basobas.model.PropertyPhoto;
import com.basobas.model.User;

@WebServlet("/landlord/properties")
@MultipartConfig(fileSizeThreshold = 1024 * 1024 * 2, maxFileSize = 1024 * 1024 * 10, maxRequestSize = 1024 * 1024 * 50) // config
																															// for
																															// image
																															// upload
																															// size
public class LandlordPropertyController extends HttpServlet {
	private static final long serialVersionUID = 1L;

	private PropertyDAO propertyDAO;
	private PropertyPhotoDAO photoDAO;
	private static final String UPLOAD_BASE_DIR = System.getProperty("user.home") + "/Basobas_uploads/";

	@Override
	public void init() throws ServletException {
		super.init();
		propertyDAO = new PropertyDAO();
		photoDAO = new PropertyPhotoDAO();
	}

	@Override
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute("loggedInUser");

		String format = request.getParameter("format");

		// Handle JSON response for AJAX
		if ("json".equals(format)) {
			handleJsonResponse(request, response, currentUser);
			return;
		}

		String action = request.getParameter("action");

		if ("add".equals(action)) {
			request.getRequestDispatcher("/WEB-INF/pages/landlord/add-property.jsp").forward(request, response);
		} else if ("edit".equals(action)) {
			handleEditForm(request, response, currentUser);
		} else if ("delete".equals(action)) {
			handleDeleteProperty(request, response, currentUser);
		} else if ("deletePhoto".equals(action)) {
			handleDeletePhoto(request, response, currentUser);
		} else {
			// Default: show properties list
			request.getRequestDispatcher("/WEB-INF/pages/landlord/properties.jsp").forward(request, response);
		}
	}

	@Override
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HttpSession session = request.getSession();
		User currentUser = (User) session.getAttribute("loggedInUser");

		if (currentUser == null || !"landlord".equals(currentUser.getRole())) {
			response.sendRedirect(request.getContextPath() + "/login");
			return;
		}

		String action = request.getParameter("action");

		if ("add".equals(action)) {
			handleAddProperty(request, response, currentUser);
		} else if ("edit".equals(action)) {
			handleEditProperty(request, response, currentUser);
		} else if ("delete".equals(action)) {
			handleDeleteProperty(request, response, currentUser);
		} else if ("bulkDelete".equals(action)) {
			handleBulkDelete(request, response, currentUser);
		} else if ("deletePhoto".equals(action)) {
			handleDeletePhoto(request, response, currentUser);
		} else if ("setPrimary".equals(action)) {
			handleSetPrimaryPhoto(request, response, currentUser);
		} else {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Unknown action");
		}
	}

	// ========== JSON RESPONSE HANDLER ==========

	private void handleJsonResponse(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws IOException {

		String search = request.getParameter("search");
		String status = request.getParameter("status");
		String sortByParam = request.getParameter("sortBy");
		String sortOrderParam = request.getParameter("sortOrder");

		final String sortBy = (sortByParam != null) ? sortByParam : "property_id";
		final String sortOrder = (sortOrderParam != null) ? sortOrderParam : "DESC";

		int page = 1;
		try {
			page = Integer.parseInt(request.getParameter("page"));
		} catch (Exception e) {
		}
		final int limit = 10;
		final int offset = (page - 1) * limit;

		// Get properties for this landlord only
		List<Property> allProperties = propertyDAO.getPropertiesByLandlord(currentUser.getUserId());

		// Apply filters
		List<Property> filtered = new ArrayList<>();
		for (Property p : allProperties) {
			boolean matches = true;
			if (search != null && !search.isEmpty()) {
				if (!p.getTitle().toLowerCase().contains(search.toLowerCase())
						&& !p.getCity().toLowerCase().contains(search.toLowerCase())
						&& !p.getDisplayId().toLowerCase().contains(search.toLowerCase())) {
					matches = false;
				}
			}
			if (matches && status != null && !status.isEmpty() && !"all".equals(status)) {
				if (!p.getStatus().equals(status)) {
					matches = false;
				}
			}
			if (matches) {
				filtered.add(p);
			}
		}

		final int total = filtered.size();
		final int totalPages = (int) Math.ceil((double) total / limit);

		// Apply sorting using a proper Comparator
		Comparator<Property> comparator = getComparator(sortBy, sortOrder);
		Collections.sort(filtered, comparator);

		// Apply pagination
		int fromIndex = Math.min(offset, filtered.size());
		int toIndex = Math.min(offset + limit, filtered.size());
		List<Property> paged = filtered.subList(fromIndex, toIndex);

		// Calculate stats
		int totalCount = allProperties.size();
		int availableCount = 0;
		int rentedCount = 0;
		for (Property p : allProperties) {
			if ("available".equals(p.getStatus())) {
				availableCount++;
			} else if ("rented".equals(p.getStatus())) {
				rentedCount++;
			}
		}

		// Build JSON response
		StringBuilder json = new StringBuilder();
		json.append("{");
		json.append("\"properties\":[");
		for (int i = 0; i < paged.size(); i++) {
			Property p = paged.get(i);
			if (i > 0)
				json.append(",");
			json.append("{");
			json.append("\"propertyId\":").append(p.getPropertyId()).append(",");
			json.append("\"displayId\":\"").append(escapeJson(p.getDisplayId())).append("\",");
			json.append("\"title\":\"").append(escapeJson(p.getTitle())).append("\",");
			json.append("\"city\":\"").append(escapeJson(p.getCity())).append("\",");
			json.append("\"wardNumber\":").append(p.getWardNumber() != null ? p.getWardNumber() : "null").append(",");
			json.append("\"monthlyRent\":").append(p.getMonthlyRent()).append(",");
			json.append("\"bedrooms\":").append(p.getBedrooms()).append(",");
			json.append("\"bathrooms\":").append(p.getBathrooms()).append(",");
			json.append("\"propertyType\":\"").append(escapeJson(p.getPropertyType())).append("\",");
			json.append("\"status\":\"").append(escapeJson(p.getStatus())).append("\",");
			json.append("\"createdAt\":\"").append(p.getCreatedAt() != null ? p.getCreatedAt().toString() : "")
					.append("\"");
			json.append("}");
		}
		json.append("],");
		json.append("\"stats\":{");
		json.append("\"total\":").append(totalCount).append(",");
		json.append("\"available\":").append(availableCount).append(",");
		json.append("\"rented\":").append(rentedCount);
		json.append("},");
		json.append("\"page\":").append(page).append(",");
		json.append("\"totalPages\":").append(totalPages).append(",");
		json.append("\"total\":").append(total);
		json.append("}");

		response.setContentType("application/json");
		response.setCharacterEncoding("UTF-8");
		response.getWriter().write(json.toString());
	}

	private Comparator<Property> getComparator(final String sortBy, final String sortOrder) {
		return new Comparator<Property>() {
			@Override
			public int compare(Property a, Property b) {
				int result = 0;
				switch (sortBy) {
				case "display_id":
					result = a.getDisplayId().compareTo(b.getDisplayId());
					break;
				case "title":
					result = a.getTitle().compareTo(b.getTitle());
					break;
				case "city":
					result = a.getCity().compareTo(b.getCity());
					break;
				case "monthly_rent":
					result = Double.compare(a.getMonthlyRent(), b.getMonthlyRent());
					break;
				case "bedrooms":
					result = Integer.compare(a.getBedrooms(), b.getBedrooms());
					break;
				case "status":
					result = a.getStatus().compareTo(b.getStatus());
					break;
				default:
					result = a.getPropertyId() - b.getPropertyId();
				}
				return "ASC".equals(sortOrder) ? result : -result;
			}
		};
	}

	// ========== PROPERTY CRUD ==========

	private void handleAddProperty(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws ServletException, IOException {

		try {
			Property property = extractPropertyFromRequest(request, currentUser);

			// Save property
			if (propertyDAO.save(property)) {
				// Handle photo uploads
				handlePhotoUploads(request, property.getPropertyId());

				request.getSession().setAttribute("message", "Property added successfully!");
				request.getSession().setAttribute("messageType", "success");
			} else {
				request.getSession().setAttribute("message", "Failed to add property. Please try again.");
				request.getSession().setAttribute("messageType", "error");
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.getSession().setAttribute("message", "Error: " + e.getMessage());
			request.getSession().setAttribute("messageType", "error");
		}

		response.sendRedirect(request.getContextPath() + "/landlord/properties");
	}

	private void handleEditForm(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws ServletException, IOException {

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

		// Get existing photos
		List<PropertyPhoto> photos = photoDAO.getPhotosByPropertyId(property.getPropertyId());

		request.setAttribute("property", property);
		request.setAttribute("photos", photos);
		request.getRequestDispatcher("/WEB-INF/pages/landlord/edit-property.jsp").forward(request, response);
	}

	private void handleEditProperty(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws IOException {

		String displayId = request.getParameter("displayId");
		if (displayId == null || displayId.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/landlord/properties");
			return;
		}

		Property existingProperty = propertyDAO.findByDisplayId(displayId);

		// Verify ownership
		if (existingProperty == null || existingProperty.getLandlordId() != currentUser.getUserId()) {
			response.sendError(HttpServletResponse.SC_FORBIDDEN, "You don't own this property");
			return;
		}

		try {
			Property property = extractPropertyFromRequest(request, currentUser);
			property.setPropertyId(existingProperty.getPropertyId());
			property.setDisplayId(displayId);

			// Update property
			if (propertyDAO.update(property)) {
				// Handle new photo uploads
				handlePhotoUploads(request, property.getPropertyId());

				request.getSession().setAttribute("message", "Property updated successfully!");
				request.getSession().setAttribute("messageType", "success");
			} else {
				request.getSession().setAttribute("message", "Failed to update property.");
				request.getSession().setAttribute("messageType", "error");
			}
		} catch (Exception e) {
			e.printStackTrace();
			request.getSession().setAttribute("message", "Error: " + e.getMessage());
			request.getSession().setAttribute("messageType", "error");
		}

		response.sendRedirect(request.getContextPath() + "/landlord/properties");
	}

	private void handleDeleteProperty(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws IOException {

		String displayId = request.getParameter("id");
		if (displayId == null) {
			displayId = request.getParameter("displayId");
		}

		if (displayId == null || displayId.isEmpty()) {
			response.sendRedirect(request.getContextPath() + "/landlord/properties");
			return;
		}

		Property property = propertyDAO.findByDisplayId(displayId);

		if (property != null && property.getLandlordId() == currentUser.getUserId()) {
			// Delete all photos from disk first
			List<PropertyPhoto> photos = photoDAO.getPhotosByPropertyId(property.getPropertyId());
			deletePhotoFiles(photos);

			// Delete from database
			photoDAO.deleteByPropertyId(property.getPropertyId());
			propertyDAO.delete(property.getPropertyId());

			request.getSession().setAttribute("message", "Property deleted successfully!");
			request.getSession().setAttribute("messageType", "success");
		} else {
			request.getSession().setAttribute("message", "Property not found or you don't have permission.");
			request.getSession().setAttribute("messageType", "error");
		}

		response.sendRedirect(request.getContextPath() + "/landlord/properties");
	}

	private void handleBulkDelete(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws IOException {

		String[] displayIds = request.getParameterValues("displayIds");

		if (displayIds != null) {
			int deleted = 0;
			for (String displayId : displayIds) {
				Property property = propertyDAO.findByDisplayId(displayId);
				if (property != null && property.getLandlordId() == currentUser.getUserId()) {
					// Delete photos from disk
					List<PropertyPhoto> photos = photoDAO.getPhotosByPropertyId(property.getPropertyId());
					deletePhotoFiles(photos);

					photoDAO.deleteByPropertyId(property.getPropertyId());
					propertyDAO.delete(property.getPropertyId());
					deleted++;
				}
			}
			request.getSession().setAttribute("message", deleted + " property(s) deleted successfully!");
			request.getSession().setAttribute("messageType", "success");
		}

		response.sendRedirect(request.getContextPath() + "/landlord/properties");
	}

	// ========== PHOTO MANAGEMENT ==========

	private void handlePhotoUploads(HttpServletRequest request, int propertyId) throws ServletException, IOException {

		System.out.println("=== PHOTO UPLOAD DEBUG ===");
		System.out.println("Property ID: " + propertyId);

		String primaryIndexStr = request.getParameter("primaryPhotoIndex");
		int primaryIndex = -1;
		try {
			if (primaryIndexStr != null) {
				primaryIndex = Integer.parseInt(primaryIndexStr);
			}
		} catch (NumberFormatException e) {
		}

		Collection<Part> parts = request.getParts();
		System.out.println("Total parts found: " + parts.size());

		int order = photoDAO.countPhotosByPropertyId(propertyId);
		System.out.println("Existing photos count: " + order);

		int currentOrder = order;
		int photoPartIndex = 0;

		// Use PERMANENT directory outside Tomcat
		String uploadPath = UPLOAD_BASE_DIR + "properties/";
		File uploadDir = new File(uploadPath);
		if (!uploadDir.exists()) {
			uploadDir.mkdirs();
		}
		System.out.println("Upload path: " + uploadPath);

		for (Part part : parts) {
			String partName = part.getName();
			String fileName = getSubmittedFileName(part);
			long fileSize = part.getSize();

			// Check if this is a file part with name "photos"
			if ("photos".equals(partName) && fileName != null && !fileName.isEmpty() && fileSize > 0) {
				System.out.println("Processing photo: " + fileName + " at index " + photoPartIndex);

				String extension = fileName.substring(fileName.lastIndexOf("."));
				String newFileName = "PR" + String.format("%05d", propertyId) + "_" + System.currentTimeMillis()
						+ extension;

				part.write(uploadPath + newFileName);
				System.out.println("Saved to: " + uploadPath + newFileName);

				// Store only filename in DB - helper methods handle the prefixing
				String dbPath = newFileName;

				// Determine if this photo should be primary
				boolean isPrimary = false;
				if (primaryIndex != -1) {
					isPrimary = (photoPartIndex == primaryIndex);
				} else {
					isPrimary = (currentOrder == 0);
				}

				// If we are setting a new primary, unset others
				if (isPrimary) {
					photoDAO.setPrimaryPhoto(propertyId, -1);
				}

				PropertyPhoto photo = new PropertyPhoto(propertyId, dbPath, isPrimary, currentOrder);
				photoDAO.save(photo);
				System.out.println("Photo saved to DB with isPrimary: " + isPrimary);

				currentOrder++;
				photoPartIndex++;
			}
		}
		System.out.println("=== PHOTO UPLOAD DEBUG END ===");
	}

	private void handleDeletePhoto(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws IOException {

		String photoIdParam = request.getParameter("photoId");
		if (photoIdParam == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		int photoId = Integer.parseInt(photoIdParam);
		PropertyPhoto photo = photoDAO.findById(photoId);

		if (photo != null) {
			Property property = propertyDAO.findById(photo.getPropertyId());
			if (property != null && property.getLandlordId() == currentUser.getUserId()) {
				// Delete file from PERMANENT disk location
				String filename = photo.getPhotoUrl().replace("/property-photo/", "");
				String filePath = UPLOAD_BASE_DIR + "properties/" + filename;
				File file = new File(filePath);
				if (file.exists()) {
					file.delete();
					System.out.println("Deleted file: " + filePath);
				}

				// Delete from database
				photoDAO.delete(photoId);

				response.setContentType("application/json");
				response.getWriter().write("{\"success\": true}");
				return;
			}
		}

		response.setContentType("application/json");
		response.getWriter().write("{\"success\": false}");
	}

	private void deletePhotoFiles(List<PropertyPhoto> photos) {
		for (PropertyPhoto photo : photos) {
			String filename = photo.getPhotoUrl().replace("/property-photo/", "");
			String filePath = UPLOAD_BASE_DIR + "properties/" + filename;
			File file = new File(filePath);
			if (file.exists()) {
				file.delete();
				System.out.println("Deleted file during property delete: " + filePath);
			}
		}
	}

	private void handleSetPrimaryPhoto(HttpServletRequest request, HttpServletResponse response, User currentUser)
			throws IOException {

		String photoIdParam = request.getParameter("photoId");
		if (photoIdParam == null) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST);
			return;
		}

		int photoId = Integer.parseInt(photoIdParam);
		PropertyPhoto photo = photoDAO.findById(photoId);

		if (photo != null) {
			Property property = propertyDAO.findById(photo.getPropertyId());
			if (property != null && property.getLandlordId() == currentUser.getUserId()) {
				photoDAO.setPrimaryPhoto(property.getPropertyId(), photoId);
				response.setContentType("application/json");
				response.getWriter().write("{\"success\": true}");
				return;
			}
		}

		response.setContentType("application/json");
		response.getWriter().write("{\"success\": false}");
	}

	// ========== HELPER METHODS ==========

	private Property extractPropertyFromRequest(HttpServletRequest request, User currentUser) {
		Property property = new Property();

		// Basic Info - with validation
		String title = request.getParameter("title");
		if (title == null || title.trim().isEmpty()) {
			throw new IllegalArgumentException("Property title is required");
		}
		property.setTitle(title.trim());

		property.setDescription(request.getParameter("description"));
		property.setLandlordId(currentUser.getUserId());
		property.setLandlordName(currentUser.getFullName());

		// Property Type
		String propertyType = request.getParameter("propertyType");
		if (propertyType == null || propertyType.trim().isEmpty()) {
			throw new IllegalArgumentException("Property type is required");
		}
		property.setPropertyType(propertyType);

		// Bedrooms validation
		int bedrooms = 1;
		try {
			bedrooms = Integer.parseInt(request.getParameter("bedrooms"));
			if (bedrooms < 0 || bedrooms > 20) {
				throw new IllegalArgumentException("Bedrooms must be between 0 and 20");
			}
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException("Invalid bedrooms value");
		}
		property.setBedrooms(bedrooms);

		// Bathrooms validation (critical fix)
		double bathrooms = 1.0;
		try {
			String bathroomsStr = request.getParameter("bathrooms");
			if (bathroomsStr != null && !bathroomsStr.isEmpty()) {
				bathrooms = Double.parseDouble(bathroomsStr);
				if (bathrooms < 0 || bathrooms > 10) {
					throw new IllegalArgumentException("Bathrooms must be between 0 and 10");
				}
				// Check for reasonable values (not 55!)
				if (bathrooms > 10) {
					throw new IllegalArgumentException("Bathrooms value is too high. Maximum is 10.");
				}
			}
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException(
					"Invalid bathrooms value. Please enter a valid number (e.g., 1, 1.5, 2)");
		}
		property.setBathrooms(bathrooms);

		// Monthly Rent validation
		double monthlyRent = 0;
		try {
			String rentStr = request.getParameter("monthlyRent");
			if (rentStr == null || rentStr.trim().isEmpty()) {
				throw new IllegalArgumentException("Monthly rent is required");
			}
			monthlyRent = Double.parseDouble(rentStr);
			if (monthlyRent < 0 || monthlyRent > 10000000) {
				throw new IllegalArgumentException("Monthly rent must be between 0 and 10,000,000");
			}
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException("Invalid monthly rent value");
		}
		property.setMonthlyRent(monthlyRent);

		// Security Deposit validation
		double securityDeposit = 0;
		try {
			String depositStr = request.getParameter("securityDeposit");
			if (depositStr != null && !depositStr.isEmpty()) {
				securityDeposit = Double.parseDouble(depositStr);
				if (securityDeposit < 0 || securityDeposit > 10000000) {
					throw new IllegalArgumentException("Security deposit must be between 0 and 10,000,000");
				}
			}
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException("Invalid security deposit value");
		}
		property.setSecurityDeposit(securityDeposit);

		// Location
		String city = request.getParameter("city");
		if (city == null || city.trim().isEmpty()) {
			throw new IllegalArgumentException("City is required");
		}
		property.setCity(city.trim());
		property.setAddress(request.getParameter("address"));

		// Ward Number validation
		try {
			String wardNumber = request.getParameter("wardNumber");
			if (wardNumber != null && !wardNumber.isEmpty()) {
				int ward = Integer.parseInt(wardNumber);
				if (ward < 1 || ward > 35) {
					throw new IllegalArgumentException("Ward number must be between 1 and 35");
				}
				property.setWardNumber(ward);
			} else {
				property.setWardNumber(null);
			}
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException("Invalid ward number");
		}

		// Floor Number validation
		try {
			String floorNumber = request.getParameter("floorNumber");
			if (floorNumber != null && !floorNumber.isEmpty()) {
				int floor = Integer.parseInt(floorNumber);
				if (floor < 0 || floor > 50) {
					throw new IllegalArgumentException("Floor number must be between 0 and 50");
				}
				property.setFloorNumber(floor);
			} else {
				property.setFloorNumber(null);
			}
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException("Invalid floor number");
		}

		// Road Access
		String roadAccess = request.getParameter("roadAccess");
		if (roadAccess != null && !roadAccess.isEmpty()) {
			String[] validRoadAccess = { "2w", "4w", "both", "none" };
			boolean valid = false;
			for (String v : validRoadAccess) {
				if (v.equals(roadAccess)) {
					valid = true;
					break;
				}
			}
			if (!valid) {
				throw new IllegalArgumentException("Invalid road access value");
			}
			property.setRoadAccess(roadAccess);
		}

		// Water Source
		String waterSource = request.getParameter("waterSource");
		if (waterSource != null && !waterSource.isEmpty()) {
			String[] validWaterSource = { "municipal", "tanker", "well", "borewell" };
			boolean valid = false;
			for (String v : validWaterSource) {
				if (v.equals(waterSource)) {
					valid = true;
					break;
				}
			}
			if (!valid) {
				throw new IllegalArgumentException("Invalid water source value");
			}
			property.setWaterSource(waterSource);
		}

		// Power Backup Hours validation
		try {
			String powerBackup = request.getParameter("powerBackupHours");
			if (powerBackup != null && !powerBackup.isEmpty()) {
				int hours = Integer.parseInt(powerBackup);
				if (hours < 0 || hours > 24) {
					throw new IllegalArgumentException("Power backup hours must be between 0 and 24");
				}
				property.setPowerBackupHours(hours);
			} else {
				property.setPowerBackupHours(0);
			}
		} catch (NumberFormatException e) {
			throw new IllegalArgumentException("Invalid power backup hours");
		}

		// Status validation
		String status = request.getParameter("status");
		if (status != null && !status.isEmpty()) {
			String[] validStatus = { "available", "rented", "inactive" };
			boolean valid = false;
			for (String v : validStatus) {
				if (v.equals(status)) {
					valid = true;
					break;
				}
			}
			if (!valid) {
				throw new IllegalArgumentException("Invalid status value");
			}
			property.setStatus(status);
		} else {
			property.setStatus("available");
		}

		// Available From date
		String availableFrom = request.getParameter("availableFrom");
		if (availableFrom != null && !availableFrom.isEmpty()) {
			try {
				property.setAvailableFrom(Date.valueOf(availableFrom));
			} catch (IllegalArgumentException e) {
				throw new IllegalArgumentException("Invalid date format for 'Available From'");
			}
		}

		return property;
	}

	private String getSubmittedFileName(Part part) {
		String contentDisposition = part.getHeader("content-disposition");
		System.out.println("Content-Disposition: " + contentDisposition);

		for (String cd : contentDisposition.split(";")) {
			if (cd.trim().startsWith("filename")) {
				String fileName = cd.substring(cd.indexOf('=') + 1).trim().replace("\"", "");
				return fileName.substring(fileName.lastIndexOf("/") + 1).substring(fileName.lastIndexOf("\\") + 1);
			}
		}
		return null;
	}

	private String escapeJson(String s) {
		if (s == null)
			return "";
		return s.replace("\\", "\\\\").replace("\"", "\\\"").replace("\n", "\\n").replace("\r", "\\r").replace("\t",
				"\\t");
	}
}