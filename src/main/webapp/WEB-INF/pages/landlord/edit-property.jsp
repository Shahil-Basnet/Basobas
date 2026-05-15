<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Property | Basobas</title>

    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">

    <!-- Material Icons -->
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">

    <!-- CSS Files -->
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">

    <style>
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
        
        /* Photo Gallery */
        .photo-gallery {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .photo-card {
            position: relative;
            width: 150px;
            border-radius: 0.75rem;
            overflow: hidden;
            border: 1px solid var(--outline-variant);
            background: var(--surface-container-low);
        }
        
        .photo-card img {
            width: 100%;
            height: 120px;
            object-fit: cover;
        }
        
        .photo-card .primary-badge {
            position: absolute;
            top: 0.5rem;
            left: 0.5rem;
            background: var(--primary);
            color: white;
            font-size: 0.7rem;
            font-weight: 700;
            padding: 0.25rem 0.5rem;
            border-radius: 0.25rem;
        }
        
        .photo-card .photo-actions {
            display: flex;
            justify-content: space-between;
            padding: 0.5rem;
            border-top: 1px solid var(--outline-variant);
        }
        
        .photo-card .photo-actions button {
            background: none;
            border: none;
            cursor: pointer;
            padding: 0.25rem;
            border-radius: 0.25rem;
            display: flex;
            align-items: center;
            justify-content: center;
            transition: background 0.2s;
        }
        
        .photo-card .photo-actions .set-primary {
            color: var(--primary);
        }
        
        .photo-card .photo-actions .set-primary:hover {
            background: rgba(51, 79, 43, 0.1);
        }
        
        .photo-card .photo-actions .delete-photo {
            color: var(--error);
        }
        
        .photo-card .photo-actions .delete-photo:hover {
            background: rgba(186, 26, 26, 0.1);
        }
        
        .file-input-wrapper {
            position: relative;
            display: inline-block;
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
        
        .photo-preview {
            display: flex;
            flex-wrap: wrap;
            gap: 1rem;
            margin-top: 1rem;
        }
        
        .photo-preview-item {
            position: relative;
            width: 100px;
            height: 100px;
            border-radius: 0.5rem;
            overflow: hidden;
            border: 1px solid var(--outline-variant);
        }
        
        .photo-preview-item img {
            width: 100%;
            height: 100%;
            object-fit: cover;
        }
        
        .photo-preview-item .remove-photo {
            position: absolute;
            top: 0.25rem;
            right: 0.25rem;
            background: var(--error);
            color: white;
            border-radius: 50%;
            width: 20px;
            height: 20px;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            font-size: 0.75rem;
        }
        
        .form-actions {
            display: flex;
            justify-content: flex-end;
            gap: 1rem;
            margin-top: 2rem;
            padding-top: 1.5rem;
            border-top: 1px solid var(--outline-variant);
        }
        
        .estate-input.error {
            border-color: var(--error);
            background-color: rgba(186, 26, 26, 0.05);
        }
        
        .form-error {
            color: var(--error);
            font-size: 0.7rem;
            margin-top: 0.25rem;
        }
        
        @media (max-width: 768px) {
            .form-row {
                grid-template-columns: 1fr;
                gap: 1rem;
            }
            .photo-card {
                width: calc(50% - 0.5rem);
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
            <a href="${pageContext.request.contextPath}/landlord/dashboard" class="nav-link">
                <span class="material-symbols-outlined">dashboard</span>
                <span>Dashboard</span>
            </a>
            <a href="${pageContext.request.contextPath}/landlord/properties" class="nav-link">
                <span class="material-symbols-outlined">real_estate_agent</span>
                <span>My Properties</span>
            </a>
            <a href="${pageContext.request.contextPath}/landlord/properties?action=add" class="nav-link">
                <span class="material-symbols-outlined">add_business</span>
                <span>Add Property</span>
            </a>
            <a href="#" class="nav-link">
                <span class="material-symbols-outlined">key</span>
                <span>Rental Requests</span>
            </a>
            <a href="#" class="nav-link">
                <span class="material-symbols-outlined">description</span>
                <span>My Leases</span>
            </a>
            <a href="#" class="nav-link">
                <span class="material-symbols-outlined">payments</span>
                <span>Payments</span>
            </a>
            <a href="#" class="nav-link">
                <span class="material-symbols-outlined">reviews</span>
                <span>Reviews</span>
            </a>
            <a href="#" class="nav-link">
                <span class="material-symbols-outlined">person</span>
                <span>Profile</span>
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
                    <h2 class="page-title">Edit Property</h2>
                    <p class="page-subtitle">Update your property listing information.</p>
                </div>
            </div>

            <!-- Form -->
            <div class="dashboard-card">
                <form action="${pageContext.request.contextPath}/landlord/properties?action=edit" 
                      method="post" enctype="multipart/form-data" id="editPropertyForm">
                    
                    <input type="hidden" name="displayId" value="${property.displayId}">
                    
                    <!-- Basic Information Section -->
                    <div class="form-section">
                        <div class="form-section-title">
                            <span class="material-symbols-outlined">info</span>
                            Basic Information
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Property Title <span class="required">*</span></label>
                            <input type="text" name="title" class="estate-input" required 
                                   value="${fn:escapeXml(property.title)}">
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Description</label>
                            <textarea name="description" class="estate-input" rows="4">${fn:escapeXml(property.description)}</textarea>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Property Type <span class="required">*</span></label>
                                <select name="propertyType" class="estate-input" required>
                                    <option value="apartment" ${property.propertyType == 'apartment' ? 'selected' : ''}>Apartment</option>
                                    <option value="house" ${property.propertyType == 'house' ? 'selected' : ''}>House</option>
                                    <option value="condo" ${property.propertyType == 'condo' ? 'selected' : ''}>Condo</option>
                                    <option value="studio" ${property.propertyType == 'studio' ? 'selected' : ''}>Studio</option>
                                    <option value="room" ${property.propertyType == 'room' ? 'selected' : ''}>Room</option>
                                    <option value="flat" ${property.propertyType == 'flat' ? 'selected' : ''}>Flat</option>
                                    <option value="basement" ${property.propertyType == 'basement' ? 'selected' : ''}>Basement</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Status</label>
                                <select name="status" class="estate-input">
                                    <option value="available" ${property.status == 'available' ? 'selected' : ''}>Available (Ready to Rent)</option>
                                    <option value="rented" ${property.status == 'rented' ? 'selected' : ''}>Rented (Already Occupied)</option>
                                    <option value="inactive" ${property.status == 'inactive' ? 'selected' : ''}>Inactive (Temporarily Off)</option>
                                </select>
                            </div>
                        </div>
                    </div>
                    
                    <!-- Size & Pricing Section -->
                    <div class="form-section">
                        <div class="form-section-title">
                            <span class="material-symbols-outlined">attach_money</span>
                            Size & Pricing
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Bedrooms <span class="required">*</span></label>
                                <input type="number" name="bedrooms" class="estate-input" min="0" max="20" step="1" required 
                                       value="${property.bedrooms}">
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Bathrooms <span class="required">*</span></label>
                                <input type="number" name="bathrooms" class="estate-input" min="0" max="10" step="0.5" required 
                                       value="${property.bathrooms}">
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Monthly Rent (NPR) <span class="required">*</span></label>
                                <input type="number" name="monthlyRent" class="estate-input" min="0" step="1000" required 
                                       value="${property.monthlyRent}">
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Security Deposit (NPR)</label>
                                <input type="number" name="securityDeposit" class="estate-input" min="0" step="1000" 
                                       value="${property.securityDeposit}">
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
                                <label class="form-label">Ward Number</label>
                                <input type="number" name="wardNumber" class="estate-input" min="1" max="35" 
                                       value="${property.wardNumber}">
                            </div>
                        </div>
                        
                        <div class="form-group">
                            <label class="form-label">Full Address</label>
                            <input type="text" name="address" class="estate-input" 
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
                                <label class="form-label">Floor Number</label>
                                <input type="number" name="floorNumber" class="estate-input" min="0" 
                                       value="${property.floorNumber}">
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Road Access</label>
                                <select name="roadAccess" class="estate-input">
                                    <option value="both" ${property.roadAccess == 'both' ? 'selected' : ''}>Both (2-Wheeler & 4-Wheeler)</option>
                                    <option value="2w" ${property.roadAccess == '2w' ? 'selected' : ''}>2-Wheeler Only</option>
                                    <option value="4w" ${property.roadAccess == '4w' ? 'selected' : ''}>4-Wheeler Only</option>
                                    <option value="none" ${property.roadAccess == 'none' ? 'selected' : ''}>No Road Access</option>
                                </select>
                            </div>
                        </div>
                        
                        <div class="form-row">
                            <div class="form-group">
                                <label class="form-label">Water Source</label>
                                <select name="waterSource" class="estate-input">
                                    <option value="municipal" ${property.waterSource == 'municipal' ? 'selected' : ''}>Municipal Supply</option>
                                    <option value="tanker" ${property.waterSource == 'tanker' ? 'selected' : ''}>Water Tanker</option>
                                    <option value="well" ${property.waterSource == 'well' ? 'selected' : ''}>Well / Borewell</option>
                                </select>
                            </div>
                            
                            <div class="form-group">
                                <label class="form-label">Power Backup (Hours/Day)</label>
                                <input type="number" name="powerBackupHours" class="estate-input" min="0" max="24" 
                                       value="${property.powerBackupHours}">
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
                            <label class="form-label">Available From</label>
                            <input type="date" name="availableFrom" class="estate-input" 
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
                                        <img src="${pageContext.request.contextPath}${photo.photoUrl}" alt="Property Photo">
                                        <c:if test="${photo.primary}">
                                            <div class="primary-badge">Primary</div>
                                        </c:if>
                                        <div class="photo-actions">
                                            <c:if test="${not photo.primary}">
                                                <button type="button" class="set-primary" onclick="setPrimaryPhoto(${photo.photoId})" title="Set as Primary">
                                                    <span class="material-symbols-outlined">star</span>
                                                </button>
                                            </c:if>
                                            <button type="button" class="delete-photo" onclick="deletePhoto(${photo.photoId})" title="Delete Photo">
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
                                <button type="button" class="btn-outline" onclick="document.getElementById('photoInput').click()">
                                    <span class="material-symbols-outlined">upload</span>
                                    Select Photos
                                </button>
                                <input type="file" id="photoInput" name="photos" multiple 
                                       accept="image/jpeg,image/png,image/jpg" 
                                       style="display: none;">
                                <input type="hidden" name="primaryPhotoIndex" id="primaryPhotoIndex" value="-1">
                            </div>
                            <div class="form-hint">You can select multiple photos. JPEG, PNG only. First photo will be primary if no primary exists.</div>
                            
                            <!-- Photo Preview for new uploads -->
                            <div class="photo-preview" id="photoPreview"></div>
                        </div>
                    </div>
                    
                    <!-- Form Actions -->
                    <div class="form-actions">
                        <a href="${pageContext.request.contextPath}/landlord/properties" class="btn-secondary" style="text-decoration: none; display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.75rem 1.5rem;">
                            <span class="material-symbols-outlined">close</span>
                            Cancel
                        </a>
                        <button type="submit" class="btn-primary" style="display: inline-flex; align-items: center; gap: 0.5rem;">
                            <span class="material-symbols-outlined">save</span>
                            Save Changes
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </main>

    <script>
        // Store selected files in an array to allow appending/removing
        let selectedFiles = [];
        let primaryIndex = -1; // -1 means no new photo is primary (existing primary remains)

        function updatePhotoInput() {
            const input = document.getElementById('photoInput');
            const dt = new DataTransfer();
            selectedFiles.forEach(file => dt.items.add(file));
            input.files = dt.files;
            
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
                        <div class="set-primary-overlay" onclick="setAsNewPrimary(\${index})">
                            \${index === primaryIndex ? 'NEW PRIMARY' : 'SET AS PRIMARY'}
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
                primaryIndex = -1;
            } else if (index < primaryIndex) {
                primaryIndex--;
            }
            renderPreviews();
        }

        function setAsNewPrimary(index) {
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

        // Delete existing photo
        function deletePhoto(photoId) {
            if (confirm('Are you sure you want to delete this photo?')) {
                fetch(contextPath + '/landlord/properties?action=deletePhoto&photoId=' + photoId, {
                    method: 'POST'
                }).then(response => response.json())
                  .then(data => {
                      if (data.success) {
                          // Remove the photo card from DOM
                          const photoCard = document.querySelector(`.photo-card[data-photo-id="\${photoId}"]`);
                          if (photoCard) photoCard.remove();
                          showToast('Photo deleted successfully', 'success');
                      } else {
                          showToast('Failed to delete photo', 'error');
                      }
                  });
            }
        }
        
        // Set primary photo (existing)
        function setPrimaryPhoto(photoId) {
            fetch(contextPath + '/landlord/properties?action=setPrimary&photoId=' + photoId, {
                method: 'POST'
            }).then(response => response.json())
              .then(data => {
                  if (data.success) {
                      // Refresh the page to update primary badge
                      window.location.reload();
                  } else {
                      showToast('Failed to set primary photo', 'error');
                  }
              });
        }
        
        // Form validation
        document.getElementById('editPropertyForm').addEventListener('submit', function(e) {
            const title = document.querySelector('input[name="title"]').value.trim();
            const city = document.querySelector('input[name="city"]').value.trim();
            const monthlyRent = document.querySelector('input[name="monthlyRent"]').value;
            const bathrooms = parseFloat(document.querySelector('input[name="bathrooms"]').value);
            
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
            
            if (bathrooms > 10) {
                e.preventDefault();
                alert('Bathrooms cannot exceed 10');
                return false;
            }
            
            return true;
        });
        
        // Make contextPath available globally
        window.contextPath = '${pageContext.request.contextPath}';
    </script>
    <script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
</body>
</html>