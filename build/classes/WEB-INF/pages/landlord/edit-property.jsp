<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Edit Property | Basobas</title>

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">

<!-- Material Icons -->
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
	rel="stylesheet">

<!-- CSS Files -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/dashboard.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/property-form.css">
</head>
<body>

	<!-- SIDEBAR -->
	<c:set var="page" value="edit-property" scope="request" />
	<jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />

	<!-- MAIN CONTENT -->
	<main class="main-content">
		<jsp:include page="/WEB-INF/includes/topbar.jsp" />

		<div class="dashboard-container">
			<!-- Header -->
			<div class="page-header">
				<div>
					<div class="section-badge">Property Management</div>
					<h2 class="page-title">Edit Property</h2>
					<p class="page-subtitle">Update your property listing
						information.</p>
				</div>
			</div>

			<!-- Form -->
			<div class="dashboard-card">
				<form
					action="${pageContext.request.contextPath}/landlord/properties?action=edit"
					method="post" enctype="multipart/form-data" id="editPropertyForm">

					<input type="hidden" name="displayId" value="${property.displayId}">

					<!-- Basic Information Section -->
					<div class="form-section">
						<div class="form-section-title">
							<span class="material-symbols-outlined">info</span> Basic
							Information
						</div>

						<div class="form-group">
							<label class="form-label">Property Title <span
								class="required">*</span></label> <input type="text" name="title"
								class="estate-input" required
								value="${fn:escapeXml(property.title)}">
						</div>

						<div class="form-group">
							<label class="form-label">Description</label>
							<textarea name="description" class="estate-input" rows="4">${fn:escapeXml(property.description)}</textarea>
						</div>

						<div class="form-row">
							<div class="form-group">
								<label class="form-label">Property Type <span
									class="required">*</span></label> <select name="propertyType"
									class="estate-input" required>
									<option value="apartment"
										${property.propertyType == 'apartment' ? 'selected' : ''}>Apartment</option>
									<option value="house"
										${property.propertyType == 'house' ? 'selected' : ''}>House</option>
									<option value="condo"
										${property.propertyType == 'condo' ? 'selected' : ''}>Condo</option>
									<option value="studio"
										${property.propertyType == 'studio' ? 'selected' : ''}>Studio</option>
									<option value="room"
										${property.propertyType == 'room' ? 'selected' : ''}>Room</option>
									<option value="flat"
										${property.propertyType == 'flat' ? 'selected' : ''}>Flat</option>
									<option value="basement"
										${property.propertyType == 'basement' ? 'selected' : ''}>Basement</option>
								</select>
							</div>

							<div class="form-group">
								<label class="form-label">Status</label> <select name="status"
									class="estate-input">
									<option value="available"
										${property.status == 'available' ? 'selected' : ''}>Available
										(Ready to Rent)</option>
									<option value="rented"
										${property.status == 'rented' ? 'selected' : ''}>Rented
										(Already Occupied)</option>
									<option value="inactive"
										${property.status == 'inactive' ? 'selected' : ''}>Inactive
										(Temporarily Off)</option>
								</select>
							</div>
						</div>
					</div>

					<!-- Size & Pricing Section -->
					<div class="form-section">
						<div class="form-section-title">
							<span class="material-symbols-outlined">attach_money</span> Size
							& Pricing
						</div>

						<div class="form-row">
							<div class="form-group">
								<label class="form-label">Bedrooms <span
									class="required">*</span></label> <input type="number" name="bedrooms"
									class="estate-input" min="0" max="20" step="1" required
									value="${property.bedrooms}">
							</div>

							<div class="form-group">
								<label class="form-label">Bathrooms <span
									class="required">*</span></label> <input type="number" name="bathrooms"
									class="estate-input" min="0" max="10" step="0.5" required
									value="${property.bathrooms}">
							</div>

							<div class="form-group">
								<label class="form-label">Monthly Rent (NPR) <span
									class="required">*</span></label> <input type="number"
									name="monthlyRent" class="estate-input" min="0" step="1"
									required value="${property.monthlyRent}">
							</div>

							<div class="form-group">
								<label class="form-label">Security Deposit (NPR)</label> <input
									type="number" name="securityDeposit" class="estate-input"
									min="0" step="1" value="${property.securityDeposit}">
							</div>
						</div>
					</div>

					<!-- Location Section -->
					<div class="form-section">
						<div class="form-section-title">
							<span class="material-symbols-outlined">location_on</span>
							Location Details
						</div>

						<div class="form-row">
							<div class="form-group">
								<label class="form-label">City <span class="required">*</span></label>
								<input type="text" name="city" class="estate-input" required
									value="${fn:escapeXml(property.city)}">
							</div>

							<div class="form-group">
								<label class="form-label">Ward Number</label> <input
									type="number" name="wardNumber" class="estate-input" min="1"
									max="35" value="${property.wardNumber}">
							</div>
						</div>

						<div class="form-group">
							<label class="form-label">Full Address</label> <input type="text"
								name="address" class="estate-input"
								value="${fn:escapeXml(property.address)}">
						</div>
					</div>

					<!-- Nepal-Specific Section -->
					<div class="form-section">
						<div class="form-section-title">
							<span class="material-symbols-outlined">nest_eco_leaf</span>
							Property Features (Nepal)
						</div>

						<div class="form-row">
							<div class="form-group">
								<label class="form-label">Floor Number</label> <input
									type="number" name="floorNumber" class="estate-input" min="0"
									value="${property.floorNumber}">
							</div>

							<div class="form-group">
								<label class="form-label">Road Access</label> <select
									name="roadAccess" class="estate-input">
									<option value="both"
										${property.roadAccess == 'both' ? 'selected' : ''}>Both
										(2-Wheeler & 4-Wheeler)</option>
									<option value="2w"
										${property.roadAccess == '2w' ? 'selected' : ''}>2-Wheeler
										Only</option>
									<option value="4w"
										${property.roadAccess == '4w' ? 'selected' : ''}>4-Wheeler
										Only</option>
									<option value="none"
										${property.roadAccess == 'none' ? 'selected' : ''}>No
										Road Access</option>
								</select>
							</div>
						</div>

						<div class="form-row">
							<div class="form-group">
								<label class="form-label">Water Source</label> <select
									name="waterSource" class="estate-input">
									<option value="municipal"
										${property.waterSource == 'municipal' ? 'selected' : ''}>Municipal
										Supply</option>
									<option value="tanker"
										${property.waterSource == 'tanker' ? 'selected' : ''}>Water
										Tanker</option>
									<option value="well"
										${property.waterSource == 'well' ? 'selected' : ''}>Well
										/ Borewell</option>
								</select>
							</div>

							<div class="form-group">
								<label class="form-label">Power Backup (Hours/Day)</label> <input
									type="number" name="powerBackupHours" class="estate-input"
									min="0" max="24" value="${property.powerBackupHours}">
							</div>
						</div>
					</div>

					<!-- Availability Section -->
					<div class="form-section">
						<div class="form-section-title">
							<span class="material-symbols-outlined">calendar_today</span>
							Availability
						</div>

						<div class="form-group">
							<label class="form-label">Available From</label> <input
								type="date" name="availableFrom" class="estate-input"
								value="${property.availableFrom}">
						</div>
					</div>

					<!-- Existing Photos Section -->
					<div class="form-section">
						<div class="form-section-title">
							<span class="material-symbols-outlined">photo_library</span>
							Property Photos
						</div>

						<c:if test="${not empty photos}">
							<div class="photo-gallery" id="photoGallery">
								<c:forEach items="${photos}" var="photo">
									<div class="photo-card" data-photo-id="${photo.photoId}">
										<img src="${pageContext.request.contextPath}${photo.photoUrl}"
											alt="Property Photo">
										<c:if test="${photo.primary}">
											<div class="primary-badge">Primary</div>
										</c:if>
										<div class="photo-actions">
											<c:if test="${not photo.primary}">
												<button type="button" class="set-primary"
													onclick="setPrimaryPhoto(${photo.photoId})"
													title="Set as Primary">
													<span class="material-symbols-outlined">star</span>
												</button>
											</c:if>
											<button type="button" class="delete-photo"
												onclick="deletePhoto(${photo.photoId})" title="Delete Photo">
												<span class="material-symbols-outlined">delete</span>
											</button>
										</div>
									</div>
								</c:forEach>
							</div>
						</c:if>

						<div class="form-group" style="margin-top: 1rem;">
							<label class="form-label">Add New Photos</label>
							<div class="file-input-wrapper">
								<button type="button" class="btn-outline"
									onclick="document.getElementById('photoInput').click()">
									<span class="material-symbols-outlined">upload</span> Select
									Photos
								</button>
								<input type="file" id="photoInput" name="photos" multiple
									accept="image/jpeg,image/png,image/jpg" style="display: none;">
								<input type="hidden" name="primaryPhotoIndex"
									id="primaryPhotoIndex" value="-1">
							</div>
							<div class="form-hint">You can select multiple photos.
								JPEG, PNG only. First photo will be primary if no primary
								exists.</div>

							<!-- Photo Preview for new uploads -->
							<div class="photo-preview" id="photoPreview"></div>
						</div>
					</div>

					<!-- Form Actions -->
					<div class="form-actions">
						<a href="${pageContext.request.contextPath}/landlord/properties"
							class="btn-secondary"
							style="text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.75rem 1.5rem;">
							<span class="material-symbols-outlined">close</span> Cancel
						</a>
						<button type="submit" class="btn-primary"
							style="display: inline-flex; align-items: center; gap: 0.5rem;">
							<span class="material-symbols-outlined">save</span> Save Changes
						</button>
					</div>
				</form>
			</div>
		</div>
	</main>

	<script
		src="${pageContext.request.contextPath}/js/landlord/property-form.js"></script>
</body>
</html>