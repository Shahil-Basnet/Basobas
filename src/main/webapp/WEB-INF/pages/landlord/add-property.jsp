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

<style>
/* Additional form-specific styles */
.form-section {
	margin-bottom: 2rem;
}

.form-section-title {
	font-size: 1rem;
	font-weight: 700;
	color: var(--on-surface);
	margin-bottom: 1.25rem;
	padding-bottom: 0.5rem;
	border-bottom: 2px solid var(--outline-variant);
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

.form-section-title .material-symbols-outlined {
	color: var(--primary);
	font-size: 1.25rem;
}

.form-row {
	display: grid;
	grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
	gap: 1.25rem;
	margin-bottom: 1.25rem;
}

.form-group {
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
}

.form-label {
	font-size: 0.875rem;
	font-weight: 600;
	color: var(--on-surface-variant);
}

.form-label .required {
	color: var(--error);
	margin-left: 0.25rem;
}

.form-hint {
	font-size: 0.7rem;
	color: var(--outline);
	margin-top: 0.25rem;
}

/* Photo Preview Styles */
.photo-preview {
	display: flex;
	flex-wrap: wrap;
	gap: 1rem;
	margin-top: 1rem;
}

.photo-preview-item {
	position: relative;
	width: 120px;
	height: 120px;
	border-radius: 0.75rem;
	overflow: hidden;
	border: 1px solid var(--outline-variant);
	background: var(--surface-container-low);
	transition: all 0.2s;
}

.photo-preview-item.primary {
	border: 3px solid var(--primary);
	box-shadow: 0 0 0 4px rgba(43, 110, 60, 0.1);
}

.photo-preview-item img {
	width: 100%;
	height: 100%;
	object-fit: cover;
}

.photo-preview-item .remove-photo {
	position: absolute;
	top: 0.35rem;
	right: 0.35rem;
	background: rgba(186, 26, 26, 0.9);
	color: white;
	border-radius: 50%;
	width: 24px;
	height: 24px;
	display: flex;
	align-items: center;
	justify-content: center;
	cursor: pointer;
	font-size: 1rem;
	z-index: 10;
	transition: transform 0.2s;
}

.photo-preview-item .remove-photo:hover {
	transform: scale(1.1);
	background: var(--error);
}

.photo-preview-item .set-primary-overlay {
	position: absolute;
	bottom: 0;
	left: 0;
	right: 0;
	background: rgba(0, 0, 0, 0.5);
	color: white;
	font-size: 0.65rem;
	font-weight: 700;
	padding: 0.35rem;
	text-align: center;
	cursor: pointer;
	opacity: 0;
	transition: opacity 0.2s;
}

.photo-preview-item:hover .set-primary-overlay {
	opacity: 1;
}

.photo-preview-item.primary .set-primary-overlay {
	background: var(--primary);
	opacity: 1;
}

.photo-preview-item .primary-star {
	position: absolute;
	top: 0.35rem;
	left: 0.35rem;
	color: #f59e0b;
	background: white;
	border-radius: 50%;
	padding: 2px;
	display: none;
}

.photo-preview-item.primary .primary-star {
	display: block;
}

.file-input-wrapper {
	position: relative;
	display: inline-block;
}

.file-input-wrapper input[type="file"] {
	position: absolute;
	opacity: 0;
	width: 100%;
	height: 100%;
	cursor: pointer;
}

.btn-outline {
	background: transparent;
	border: 1px solid var(--outline-variant);
	color: var(--on-surface-variant);
	padding: 0.625rem 1.25rem;
	border-radius: 0.5rem;
	font-weight: 500;
	cursor: pointer;
	transition: all 0.2s;
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
}

.btn-outline:hover {
	background: var(--surface-container);
	border-color: var(--primary);
}

.form-actions {
	display: flex;
	justify-content: flex-end;
	gap: 1rem;
	margin-top: 2rem;
	padding-top: 1.5rem;
	border-top: 1px solid var(--outline-variant);
}

@media ( max-width : 768px) {
	.form-row {
		grid-template-columns: 1fr;
		gap: 1rem;
	}
}
</style>
</head>
<body>

	<!-- SIDEBAR -->
	<aside class="sidebar">
		<div class="sidebar-header">
			<h1>Basobas</h1>
			<p>Estate Management</p>
		</div>
		<div class="nav-links">
			<a href="${pageContext.request.contextPath}/landlord/dashboard"
				class="nav-link"> <span class="material-symbols-outlined">dashboard</span>
				<span>Dashboard</span>
			</a> <a href="${pageContext.request.contextPath}/landlord/properties"
				class="nav-link"> <span class="material-symbols-outlined">real_estate_agent</span>
				<span>My Properties</span>
			</a> <a
				href="${pageContext.request.contextPath}/landlord/properties?action=add"
				class="nav-link active"> <span class="material-symbols-outlined">add_business</span>
				<span>Add Property</span>
			</a> <a href="#" class="nav-link"> <span
				class="material-symbols-outlined">key</span> <span>Rental
					Requests</span>
			</a> <a href="#" class="nav-link"> <span
				class="material-symbols-outlined">description</span> <span>My
					Leases</span>
			</a> <a href="#" class="nav-link"> <span
				class="material-symbols-outlined">payments</span> <span>Payments</span>
			</a> <a href="#" class="nav-link"> <span
				class="material-symbols-outlined">reviews</span> <span>Reviews</span>
			</a> <a href="#" class="nav-link"> <span
				class="material-symbols-outlined">person</span> <span>Profile</span>
			</a>
		</div>
		<div class="profile-section">
			<div class="avatar">
				<c:choose>
					<c:when test="${not empty sessionScope.loggedInUser.fullName}">
                        ${fn:substring(sessionScope.loggedInUser.fullName, 0, 1)}
                    </c:when>
					<c:otherwise>L</c:otherwise>
				</c:choose>
			</div>
			<div class="profile-info">
				<p>${sessionScope.loggedInUser.fullName != null ? sessionScope.loggedInUser.fullName : 'Landlord'}</p>
				<span>Property Owner</span>
			</div>
		</div>
	</aside>

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
									value="1"
									onchange="if(this.value > 10) this.value = 10; if(this.value < 0) this.value = 0;">
								<div class="form-hint">Enter number of bathrooms (e.g., 1,
									1.5, 2)</div>
							</div>

							<!-- Monthly Rent field -->
							<div class="form-group">
								<label class="form-label">Monthly Rent (NPR) <span
									class="required">*</span></label> <input type="number"
									name="monthlyRent" class="estate-input" min="0" max="10000000"
									step="1000" required placeholder="e.g., 35000">
							</div>

							<div class="form-group">
								<label class="form-label">Security Deposit (NPR)</label> <input
									type="number" name="securityDeposit" class="estate-input"
									min="0" step="1000" placeholder="Usually 2 months rent">
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
									max="35"
									onchange="if(this.value > 35) this.value = 35; if(this.value < 1) this.value = 1;">
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
									min="0" max="24" placeholder="e.g., 8"
									onchange="if(this.value > 24) this.value = 24; if(this.value < 0) this.value = 0;">
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
								<input type="hidden" name="primaryPhotoIndex" id="primaryPhotoIndex" value="0">
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

	<script>
        // Store selected files in an array to allow appending/removing
        let selectedFiles = [];
        let primaryIndex = 0;

        function updatePhotoInput() {
            const input = document.getElementById('photoInput');
            const dt = new DataTransfer();
            selectedFiles.forEach(file => dt.items.add(file));
            input.files = dt.files;
            
            // Ensure primaryIndex is valid
            if (primaryIndex >= selectedFiles.length) {
                primaryIndex = 0;
            }
            document.getElementById('primaryPhotoIndex').value = primaryIndex;
        }

        function renderPreviews() {
            const previewContainer = document.getElementById('photoPreview');
            previewContainer.innerHTML = '';
            
            selectedFiles.forEach((file, index) => {
                const reader = new FileReader();
                reader.onload = function(e) {
                    const previewItem = document.createElement('div');
                    previewItem.className = 'photo-preview-item' + (index === primaryIndex ? ' primary' : '');
                    previewItem.innerHTML = `
                        <img src="\${e.target.result}" alt="Preview">
                        <div class="primary-star">
                            <span class="material-symbols-outlined">star</span>
                        </div>
                        <div class="remove-photo" onclick="removeSelectedPhoto(\${index})">×</div>
                        <div class="set-primary-overlay" onclick="setAsPrimary(\${index})">
                            \${index === primaryIndex ? 'PRIMARY PHOTO' : 'SET AS PRIMARY'}
                        </div>
                    `;
                    previewContainer.appendChild(previewItem);
                };
                reader.readAsDataURL(file);
            });
            
            updatePhotoInput();
        }

        function removeSelectedPhoto(index) {
            selectedFiles.splice(index, 1);
            if (index === primaryIndex) {
                primaryIndex = 0;
            } else if (index < primaryIndex) {
                primaryIndex--;
            }
            renderPreviews();
        }

        function setAsPrimary(index) {
            primaryIndex = index;
            renderPreviews();
        }

        // Initialize photo input listener
        document.addEventListener('DOMContentLoaded', function() {
            const photoInput = document.getElementById('photoInput');
            if (photoInput) {
                photoInput.addEventListener('change', function() {
                    if (this.files) {
                        for (let i = 0; i < this.files.length; i++) {
                            selectedFiles.push(this.files[i]);
                        }
                        renderPreviews();
                    }
                });
            }
        });

        // Form validation
        document.getElementById('addPropertyForm').addEventListener('submit', function(e) {
            const title = document.querySelector('input[name="title"]').value.trim();
            const city = document.querySelector('input[name="city"]').value.trim();
            const monthlyRent = document.querySelector('input[name="monthlyRent"]').value;
            
            if (!title) {
                e.preventDefault();
                alert('Please enter property title');
                return false;
            }
            
            if (!city) {
                e.preventDefault();
                alert('Please enter city');
                return false;
            }
            
            if (!monthlyRent || monthlyRent <= 0) {
                e.preventDefault();
                alert('Please enter valid monthly rent');
                return false;
            }
            
            return true;
        });
    </script>
	<script>
    // Real-time validation functions
    function validateTitle() {
        const input = document.getElementById('title');
        const error = document.getElementById('titleError');
        const value = input.value.trim();
        
        if (value === '') {
            error.textContent = 'Property title is required';
            input.classList.add('error');
            return false;
        }
        if (value.length < 3) {
            error.textContent = 'Title must be at least 3 characters';
            input.classList.add('error');
            return false;
        }
        if (value.length > 200) {
            error.textContent = 'Title must be less than 200 characters';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    function validateCity() {
        const input = document.getElementById('city');
        const error = document.getElementById('cityError');
        const value = input.value.trim();
        
        if (value === '') {
            error.textContent = 'City is required';
            input.classList.add('error');
            return false;
        }
        if (value.length < 2) {
            error.textContent = 'City name must be at least 2 characters';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    function validatePropertyType() {
        const select = document.getElementById('propertyType');
        const error = document.getElementById('propertyTypeError');
        
        if (select.value === '') {
            error.textContent = 'Please select a property type';
            select.classList.add('error');
            return false;
        }
        error.textContent = '';
        select.classList.remove('error');
        return true;
    }
    
    function validateBedrooms() {
        const input = document.getElementById('bedrooms');
        const error = document.getElementById('bedroomsError');
        let value = parseInt(input.value);
        
        if (isNaN(value)) {
            error.textContent = 'Please enter number of bedrooms';
            input.classList.add('error');
            return false;
        }
        if (value < 0) {
            error.textContent = 'Bedrooms cannot be negative';
            input.classList.add('error');
            return false;
        }
        if (value > 20) {
            error.textContent = 'Bedrooms cannot exceed 20';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    function validateBathrooms() {
        const input = document.getElementById('bathrooms');
        const error = document.getElementById('bathroomsError');
        let value = parseFloat(input.value);
        
        if (isNaN(value)) {
            error.textContent = 'Please enter number of bathrooms';
            input.classList.add('error');
            return false;
        }
        if (value < 0) {
            error.textContent = 'Bathrooms cannot be negative';
            input.classList.add('error');
            return false;
        }
        if (value > 10) {
            error.textContent = 'Bathrooms cannot exceed 10';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    function validateMonthlyRent() {
        const input = document.getElementById('monthlyRent');
        const error = document.getElementById('monthlyRentError');
        let value = parseFloat(input.value);
        
        if (isNaN(value) || input.value === '') {
            error.textContent = 'Monthly rent is required';
            input.classList.add('error');
            return false;
        }
        if (value <= 0) {
            error.textContent = 'Monthly rent must be greater than 0';
            input.classList.add('error');
            return false;
        }
        if (value > 10000000) {
            error.textContent = 'Monthly rent is too high';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    function validateWardNumber() {
        const input = document.getElementById('wardNumber');
        const error = document.getElementById('wardNumberError');
        
        if (input.value === '') {
            error.textContent = '';
            input.classList.remove('error');
            return true; // Optional field
        }
        
        let value = parseInt(input.value);
        if (isNaN(value)) {
            error.textContent = 'Please enter a valid ward number';
            input.classList.add('error');
            return false;
        }
        if (value < 1 || value > 35) {
            error.textContent = 'Ward number must be between 1 and 35';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    function validateFloorNumber() {
        const input = document.getElementById('floorNumber');
        const error = document.getElementById('floorNumberError');
        
        if (input.value === '') {
            error.textContent = '';
            input.classList.remove('error');
            return true; // Optional field
        }
        
        let value = parseInt(input.value);
        if (isNaN(value)) {
            error.textContent = 'Please enter a valid floor number';
            input.classList.add('error');
            return false;
        }
        if (value < 0) {
            error.textContent = 'Floor number cannot be negative';
            input.classList.add('error');
            return false;
        }
        if (value > 50) {
            error.textContent = 'Floor number cannot exceed 50';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    function validatePowerBackup() {
        const input = document.getElementById('powerBackupHours');
        if (!input) return true; // Skip if element doesn't exist
        
        const error = document.getElementById('powerBackupError');
        if (!error) return true;
        
        if (input.value === '') {
            error.textContent = '';
            input.classList.remove('error');
            return true;
        }
        
        let value = parseInt(input.value);
        if (isNaN(value)) {
            error.textContent = 'Please enter a valid number of hours';
            input.classList.add('error');
            return false;
        }
        if (value < 0) {
            error.textContent = 'Hours cannot be negative';
            input.classList.add('error');
            return false;
        }
        if (value > 24) {
            error.textContent = 'Hours cannot exceed 24';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    function validateSecurityDeposit() {
        const input = document.getElementById('securityDeposit');
        const error = document.getElementById('securityDepositError');
        
        if (input.value === '') {
            error.textContent = '';
            input.classList.remove('error');
            return true; // Optional field
        }
        
        let value = parseFloat(input.value);
        if (isNaN(value)) {
            error.textContent = 'Please enter a valid amount';
            input.classList.add('error');
            return false;
        }
        if (value < 0) {
            error.textContent = 'Deposit cannot be negative';
            input.classList.add('error');
            return false;
        }
        if (value > 10000000) {
            error.textContent = 'Deposit amount is too high';
            input.classList.add('error');
            return false;
        }
        error.textContent = '';
        input.classList.remove('error');
        return true;
    }
    
    // Validate all fields before form submission
    function validateForm() {
    const validations = [];
    
    // Only add validation for elements that exist
    if (document.getElementById('title')) validations.push(validateTitle());
    if (document.getElementById('city')) validations.push(validateCity());
    if (document.getElementById('propertyType')) validations.push(validatePropertyType());
    if (document.getElementById('bedrooms')) validations.push(validateBedrooms());
    if (document.getElementById('bathrooms')) validations.push(validateBathrooms());
    if (document.getElementById('monthlyRent')) validations.push(validateMonthlyRent());
    if (document.getElementById('wardNumber')) validations.push(validateWardNumber());
    if (document.getElementById('floorNumber')) validations.push(validateFloorNumber());
    if (document.getElementById('powerBackupHours')) validations.push(validatePowerBackup());
    if (document.getElementById('securityDeposit')) validations.push(validateSecurityDeposit());
    
    const allValid = validations.every(v => v === true);
    
    if (!allValid) {
        const firstError = document.querySelector('.error');
        if (firstError) {
            firstError.scrollIntoView({ behavior: 'smooth', block: 'center' });
        }
        return false;
    }
    
    return true;
}
    
    // Add input event listeners for real-time validation
    document.addEventListener('DOMContentLoaded', function() {
        // Add IDs to all form fields
        document.querySelector('input[name="title"]').id = 'title';
        document.querySelector('input[name="city"]').id = 'city';
        document.querySelector('select[name="propertyType"]').id = 'propertyType';
        document.querySelector('input[name="bedrooms"]').id = 'bedrooms';
        document.querySelector('input[name="bathrooms"]').id = 'bathrooms';
        document.querySelector('input[name="monthlyRent"]').id = 'monthlyRent';
        document.querySelector('input[name="wardNumber"]').id = 'wardNumber';
        document.querySelector('input[name="floorNumber"]').id = 'floorNumber';
        document.querySelector('input[name="powerBackupHours"]').id = 'powerBackupHours';
        document.querySelector('input[name="securityDeposit"]').id = 'securityDeposit';
        
        // Add error message spans after each input
        const fields = [
            { id: 'title', label: 'Property Title' },
            { id: 'city', label: 'City' },
            { id: 'propertyType', label: 'Property Type' },
            { id: 'bedrooms', label: 'Bedrooms' },
            { id: 'bathrooms', label: 'Bathrooms' },
            { id: 'monthlyRent', label: 'Monthly Rent' },
            { id: 'wardNumber', label: 'Ward Number' },
            { id: 'floorNumber', label: 'Floor Number' },
            { id: 'powerBackupHours', label: 'Power Backup' },
            { id: 'securityDeposit', label: 'Security Deposit' }
        ];
        
        fields.forEach(field => {
            const input = document.getElementById(field.id);
            if (input && !document.getElementById(field.id + 'Error')) {
                const errorSpan = document.createElement('div');
                errorSpan.id = field.id + 'Error';
                errorSpan.className = 'form-error';
                errorSpan.style.cssText = 'color: var(--error); font-size: 0.7rem; margin-top: 0.25rem;';
                input.parentNode.appendChild(errorSpan);
                
                // Add real-time validation
                input.addEventListener('input', function() {
                    switch(field.id) {
                        case 'title': validateTitle(); break;
                        case 'city': validateCity(); break;
                        case 'propertyType': validatePropertyType(); break;
                        case 'bedrooms': validateBedrooms(); break;
                        case 'bathrooms': validateBathrooms(); break;
                        case 'monthlyRent': validateMonthlyRent(); break;
                        case 'wardNumber': validateWardNumber(); break;
                        case 'floorNumber': validateFloorNumber(); break;
                        case 'powerBackupHours': validatePowerBackup(); break;
                        case 'securityDeposit': validateSecurityDeposit(); break;
                    }
                });
                
                input.addEventListener('blur', function() {
                    switch(field.id) {
                        case 'title': validateTitle(); break;
                        case 'city': validateCity(); break;
                        case 'propertyType': validatePropertyType(); break;
                        case 'bedrooms': validateBedrooms(); break;
                        case 'bathrooms': validateBathrooms(); break;
                        case 'monthlyRent': validateMonthlyRent(); break;
                        case 'wardNumber': validateWardNumber(); break;
                        case 'floorNumber': validateFloorNumber(); break;
                        case 'powerBackupHours': validatePowerBackup(); break;
                        case 'securityDeposit': validateSecurityDeposit(); break;
                    }
                });
            }
        });
        
        // Add CSS for error styling
        const style = document.createElement('style');
        style.textContent = `
            .estate-input.error {
                border-color: var(--error);
                background-color: rgba(186, 26, 26, 0.05);
            }
            .estate-input.error:focus {
                border-color: var(--error);
                box-shadow: 0 0 0 2px rgba(186, 26, 26, 0.1);
            }
        `;
        document.head.appendChild(style);
        
        // Form submission validation
        const form = document.getElementById('addPropertyForm');
        if (form) {
            form.addEventListener('submit', function(e) {
                if (!validateForm()) {
                    e.preventDefault();
                    // Show toast or alert
                    const errorMsg = document.createElement('div');
                    errorMsg.className = 'error-alert';
                    errorMsg.style.cssText = 'position: fixed; top: 20px; right: 20px; z-index: 1000;';
                    errorMsg.innerHTML = `
                        <span class="material-symbols-outlined error-icon">error</span>
                        <div class="error-text">Please fix the errors in the form before submitting.</div>
                    `;
                    document.body.appendChild(errorMsg);
                    setTimeout(() => errorMsg.remove(), 3000);
                }
            });
        }
    });
    
    // Limit input values on the fly
    function limitInput(input, min, max) {
        let value = parseFloat(input.value);
        if (!isNaN(value)) {
            if (value < min) input.value = min;
            if (value > max) input.value = max;
        }
    }
    
    // Add real-time limits to number inputs (after DOM is ready)
    document.addEventListener('DOMContentLoaded', function() {
        const bathroomsInput = document.querySelector('input[name="bathrooms"]');
        if (bathroomsInput) {
            bathroomsInput.addEventListener('change', function() {
                limitInput(this, 0, 10);
            });
        }
        
        const bedroomsInput = document.querySelector('input[name="bedrooms"]');
        if (bedroomsInput) {
            bedroomsInput.addEventListener('change', function() {
                limitInput(this, 0, 20);
            });
        }
        
        const wardInput = document.querySelector('input[name="wardNumber"]');
        if (wardInput) {
            wardInput.addEventListener('change', function() {
                if (this.value !== '') limitInput(this, 1, 35);
            });
        }
        
        const powerInput = document.querySelector('input[name="powerBackupHours"]');
        if (powerInput) {
            powerInput.addEventListener('change', function() {
                if (this.value !== '') limitInput(this, 0, 24);
            });
        }
    });
</script>
	<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
</body>
</html>