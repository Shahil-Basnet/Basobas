<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Add Property | Basobas</title>

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
	<c:set var="page" value="add-property" scope="request" />
	<jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />

	<!-- MAIN CONTENT -->
	<main class="main-content">
		<jsp:include page="/WEB-INF/includes/topbar.jsp" />

		<div class="dashboard-container">
			<!-- Header -->
			<div class="page-header">
				<div>
					<div class="section-badge">Property Management</div>
					<h2 class="page-title">Add New Property</h2>
					<p class="page-subtitle">List your property on Basobas to start
						earning rental income.</p>
				</div>
			</div>

			<!-- Form -->
			<div class="dashboard-card">
				<form
					action="${pageContext.request.contextPath}/landlord/properties?action=add"
					method="post" enctype="multipart/form-data" id="addPropertyForm">

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
								placeholder="e.g., Cozy 2BHK Apartment in Lazimpat">
						</div>

						<div class="form-group">
							<label class="form-label">Description</label>
							<textarea name="description" class="estate-input" rows="4"
								placeholder="Describe your property - location highlights, nearby amenities, special features..."></textarea>
						</div>

						<div class="form-row">
							<div class="form-group">
								<label class="form-label">Property Type <span
									class="required">*</span></label> <select name="propertyType"
									class="estate-input" required>
									<option value="">Select property type</option>
									<option value="apartment">Apartment</option>
									<option value="house">House</option>
									<option value="condo">Condo</option>
									<option value="studio">Studio</option>
									<option value="room">Room</option>
									<option value="flat">Flat</option>
									<option value="basement">Basement</option>
								</select>
							</div>

							<div class="form-group">
								<label class="form-label">Status</label> <select name="status"
									class="estate-input">
									<option value="available">Available (Ready to Rent)</option>
									<option value="rented">Rented (Already Occupied)</option>
									<option value="inactive">Inactive (Temporarily Off)</option>
								</select>
								<div class="form-hint">Set to "Available" to show in
									tenant searches</div>
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
									class="estate-input" min="0" step="1" required value="1">
							</div>

							<div class="form-group">
								<label class="form-label">Bathrooms <span
									class="required">*</span></label> <input type="number" name="bathrooms"
									class="estate-input" min="0" max="10" step="0.5" required
									value="1">
								<div class="form-hint">Enter number of bathrooms (e.g., 1,
									1.5, 2)</div>
							</div>

							<!-- Monthly Rent field -->
							<div class="form-group">
								<label class="form-label">Monthly Rent (NPR) <span
									class="required">*</span></label> <input type="number"
									name="monthlyRent" class="estate-input" min="0" max="10000000"
									step="1" required placeholder="e.g., 35000">
							</div>

							<div class="form-group">
								<label class="form-label">Security Deposit (NPR)</label> <input
									type="number" name="securityDeposit" class="estate-input"
									min="0" step="1" placeholder="Usually 2 months rent">
								<div class="form-hint">Typically 2x monthly rent</div>
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
									placeholder="e.g., Kathmandu, Pokhara, Lalitpur">
							</div>

							<div class="form-group">
								<label class="form-label">Ward Number</label> <input
									type="number" name="wardNumber" class="estate-input" min="1"
									max="35">
							</div>
						</div>

						<div class="form-group">
							<label class="form-label">Full Address</label> <input type="text"
								name="address" class="estate-input"
								placeholder="Street, landmark, area">
						</div>
					</div>

					<div class="form-section">
						<div class="form-section-title">
							<span class="material-symbols-outlined">nest_eco_leaf</span>
							Property Features (Nepal)
						</div>

						<div class="form-row">
							<div class="form-group">
								<label class="form-label">Floor Number</label> <input
									type="number" name="floorNumber" class="estate-input" min="0"
									placeholder="e.g., 3 (Ground floor = 0)">
							</div>

							<div class="form-group">
								<label class="form-label">Road Access</label> <select
									name="roadAccess" class="estate-input">
									<option value="both">Both (2-Wheeler & 4-Wheeler)</option>
									<option value="2w">2-Wheeler Only</option>
									<option value="4w">4-Wheeler Only</option>
									<option value="none">No Road Access</option>
								</select>
							</div>
						</div>

						<div class="form-row">
							<div class="form-group">
								<label class="form-label">Water Source</label> <select
									name="waterSource" class="estate-input">
									<option value="municipal">Municipal Supply</option>
									<option value="tanker">Water Tanker</option>
									<option value="well">Well / Borewell</option>
								</select>
							</div>

							<div class="form-group">
								<label class="form-label">Power Backup (Hours/Day)</label> <input
									type="number" name="powerBackupHours" class="estate-input"
									min="0" max="24" placeholder="e.g., 8">
								<div class="form-hint">How many hours of backup power
									daily?</div>
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
								type="date" name="availableFrom" class="estate-input">
						</div>
					</div>

					<!-- Photos Section -->
					<div class="form-section">
						<div class="form-section-title">
							<span class="material-symbols-outlined">photo_camera</span>
							Property Photos
						</div>

						<div class="form-group">
							<label class="form-label">Upload Photos</label>
							<div class="file-input-wrapper">
								<button type="button" class="btn-outline"
									onclick="document.getElementById('photoInput').click()">
									<span class="material-symbols-outlined">upload</span> Select
									Photos
								</button>
								<input type="file" id="photoInput" name="photos" multiple
									accept="image/jpeg,image/png,image/jpg" style="display: none;">
								<input type="hidden" name="primaryPhotoIndex"
									id="primaryPhotoIndex" value="0">
							</div>
							<div class="form-hint">You can select multiple photos.
								JPEG, PNG only. Max 10MB each. First photo will be the
								primary/thumbnail.</div>

							<!-- Photo Preview Container - MAKE SURE THIS EXISTS -->
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
							<span class="material-symbols-outlined">check_circle</span> Add
							Property
						</button>
					</div>
				</form>
			</div>
		</div>
	</main>
	 <script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/landlord/property-form.js"></script>
</body>
</html>
