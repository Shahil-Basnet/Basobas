<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>${fn:escapeXml(property.title)}-Basobas|Property Details</title>

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@400;500;600;700&display=swap"
	rel="stylesheet">

<!-- Material Symbols -->
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />

<!-- CSS Files -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>

	<!-- Include Header -->
	<jsp:include page="/WEB-INF/includes/header.jsp" />

	<main>
		<div class="container" style="padding: 2rem 1rem;">

			<!-- Breadcrumb -->
			<div class="breadcrumb" style="margin-bottom: 1.5rem;">
				<a href="${pageContext.request.contextPath}/"
					style="color: var(--on-surface-variant); text-decoration: none;">Home</a>
				<span class="material-symbols-outlined"
					style="font-size: 1rem; vertical-align: middle;">chevron_right</span>
				<a href="${pageContext.request.contextPath}/properties"
					style="color: var(--on-surface-variant); text-decoration: none;">Properties</a>
				<span class="material-symbols-outlined"
					style="font-size: 1rem; vertical-align: middle;">chevron_right</span>
				<span style="color: var(--primary);">${fn:escapeXml(property.title)}</span>
			</div>

			<!-- Property Details Grid -->
			<div class="property-details-grid"
				style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">

				<!-- LEFT COLUMN: Photo Gallery -->
				<div class="property-gallery">
					<!-- Main Image -->
					<div class="main-image-container">
						<c:set var="photoDAO"
							value="<%=new com.basobas.dao.PropertyPhotoDAO()%>" />
						<c:set var="allPhotos"
							value="${photoDAO.getPhotosByPropertyId(property.propertyId)}" />
						<c:set var="primaryPhoto"
							value="${photoDAO.getPrimaryPhoto(property.propertyId)}" />

						<img id="mainImage"
							src="${pageContext.request.contextPath}${not empty primaryPhoto ? primaryPhoto.fullPhotoUrl : '/assets/no-image.jpg'}"
							alt="${fn:escapeXml(property.title)}" class="property-main-image"
							style="width: 100%; height: 400px; object-fit: cover; border-radius: 1rem;"
							onerror="this.src='${pageContext.request.contextPath}/assets/no-image.jpg'">
					</div>

					<!-- Thumbnails -->
					<c:if test="${not empty allPhotos and allPhotos.size() > 0}">
						<div class="property-thumbnails"
							style="display: flex; gap: 0.5rem; margin-top: 1rem; flex-wrap: wrap;">
							<c:forEach var="photo" items="${allPhotos}" varStatus="status">
								<img
									src="${pageContext.request.contextPath}${photo.fullPhotoUrl}"
									alt="Thumbnail ${status.index + 1}" class="thumbnail"
									data-full-url="${pageContext.request.contextPath}${photo.fullPhotoUrl}"
									style="width: 80px; height: 80px; object-fit: cover; border-radius: 0.5rem; cursor: pointer; border: 2px solid ${photo.primary ? 'var(--primary)' : 'transparent'};"
									onerror="this.src='${pageContext.request.contextPath}/assets/no-image.jpg'"
									onclick="document.getElementById('mainImage').src = this.dataset.fullUrl; document.querySelectorAll('.thumbnail').forEach(t => t.style.borderColor = 'transparent'); this.style.borderColor = 'var(--primary)'">
							</c:forEach>
						</div>
					</c:if>
				</div>

				<!-- RIGHT COLUMN: Property Info -->
				<div class="property-info-section">
					<div class="property-header">
						<h1 class="property-title"
							style="font-size: 1.8rem; margin-bottom: 0.5rem;">${fn:escapeXml(property.title)}</h1>
						<div class="property-location"
							style="display: flex; align-items: center; gap: 0.25rem; color: var(--on-surface-variant); margin-bottom: 1rem;">
							<span class="material-symbols-outlined"
								style="font-size: 1.2rem;">location_on</span> <span> <c:choose>
									<c:when test="${not empty property.address}">
                                    ${fn:escapeXml(property.address)}, ${fn:escapeXml(property.city)}
                                </c:when>
									<c:otherwise>
                                    ${fn:escapeXml(property.city)}
                                </c:otherwise>
								</c:choose> <c:if
									test="${not empty property.wardNumber and property.wardNumber > 0}">
                                , Ward ${property.wardNumber}
                            </c:if>
							</span>
						</div>
					</div>

					<!-- Price -->
					<div class="property-price-section" style="margin-bottom: 1.5rem;">
						<div class="property-price"
							style="font-size: 2rem; font-weight: 800; color: var(--primary);">
							रू
							<fmt:formatNumber value="${property.monthlyRent}"
								groupingUsed="true" />
							/month
						</div>
						<div class="property-deposit"
							style="color: var(--on-surface-variant); font-size: 0.875rem;">
							Security Deposit: रू
							<fmt:formatNumber value="${property.securityDeposit}"
								groupingUsed="true" />
						</div>
					</div>

					<!-- Key Specs -->
					<div class="property-specs"
						style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 1rem; margin-bottom: 1.5rem; padding: 1rem; background: var(--surface-container-low); border-radius: 1rem;">
						<div class="spec-item"
							style="display: flex; align-items: center; gap: 0.5rem;">
							<span class="material-symbols-outlined"
								style="color: var(--primary);">bed</span> <span>${property.bedrooms}
								Bedroom${property.bedrooms != 1 ? 's' : ''}</span>
						</div>
						<div class="spec-item"
							style="display: flex; align-items: center; gap: 0.5rem;">
							<span class="material-symbols-outlined"
								style="color: var(--primary);">bathtub</span> <span>${property.bathrooms}
								Bathroom${property.bathrooms != 1 ? 's' : ''}</span>
						</div>
						<div class="spec-item"
							style="display: flex; align-items: center; gap: 0.5rem;">
							<span class="material-symbols-outlined"
								style="color: var(--primary);">height</span> <span>Floor
								${not empty property.floorNumber ? property.floorNumber : 'Ground'}</span>
						</div>
					</div>

					<!-- Nepal-Specific Features -->
					<div class="nepal-features" style="margin-bottom: 1.5rem;">
						<h3 style="font-size: 1.1rem; margin-bottom: 0.75rem;">Property
							Features</h3>
						<div style="display: flex; flex-wrap: wrap; gap: 0.75rem;">
							<c:if
								test="${property.powerBackupHours != null and property.powerBackupHours > 0}">
								<span class="feature-tag"
									style="background: var(--surface-container-high); padding: 0.5rem 1rem; border-radius: 2rem; font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem;">
									<span class="material-symbols-outlined"
									style="font-size: 1rem;">bolt</span>
									${property.powerBackupHours}h Power Backup
								</span>
							</c:if>
							<c:if test="${not empty property.waterSource}">
								<span class="feature-tag"
									style="background: var(--surface-container-high); padding: 0.5rem 1rem; border-radius: 2rem; font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem;">
									<span class="material-symbols-outlined"
									style="font-size: 1rem;">water_drop</span> <c:choose>
										<c:when test="${property.waterSource == 'municipal'}">Municipal Water</c:when>
										<c:when test="${property.waterSource == 'tanker'}">Water Tanker</c:when>
										<c:when test="${property.waterSource == 'well'}">Well/Borewell</c:when>
										<c:otherwise>${property.waterSource}</c:otherwise>
									</c:choose>
								</span>
							</c:if>
							<c:if test="${not empty property.roadAccess}">
								<span class="feature-tag"
									style="background: var(--surface-container-high); padding: 0.5rem 1rem; border-radius: 2rem; font-size: 0.875rem; display: flex; align-items: center; gap: 0.5rem;">
									<span class="material-symbols-outlined"
									style="font-size: 1rem;">directions_car</span> <c:choose>
										<c:when test="${property.roadAccess == '2w'}">2-Wheeler Access</c:when>
										<c:when test="${property.roadAccess == '4w'}">4-Wheeler Access</c:when>
										<c:when test="${property.roadAccess == 'both'}">2W & 4W Access</c:when>
										<c:otherwise>Road Access: ${property.roadAccess}</c:otherwise>
									</c:choose>
								</span>
							</c:if>
						</div>
					</div>

					<!-- Description -->
					<div class="property-description" style="margin-bottom: 1.5rem;">
						<h3 style="font-size: 1.1rem; margin-bottom: 0.5rem;">Description</h3>
						<p style="color: var(--on-surface-variant); line-height: 1.6;">${fn:escapeXml(property.description)}</p>
					</div>

					<!-- Request to Rent Button / Form -->
					<div class="request-section"
						style="margin-top: 1.5rem; padding-top: 1.5rem; border-top: 1px solid var(--outline-variant);">
						<c:choose>
							<c:when test="${sessionScope.loggedInUser.role == 'tenant'}">
								<%-- Create DAO instance first --%>
								<c:set var="rentalRequestDAO"
									value="<%=new com.basobas.dao.RentalRequestDAO()%>" />
								<c:set var="hasPendingRequest"
									value="${rentalRequestDAO.hasPendingRequest(sessionScope.loggedInUser.userId, property.propertyId)}" />

								<c:if test="${hasPendingRequest}">
									<div
										style="text-align: center; padding: 1rem; background: #fef3c7; border-radius: 0.5rem; margin-bottom: 1rem;">
										<span class="material-symbols-outlined"
											style="vertical-align: middle;">info</span> You already have
										a pending request for this property.
									</div>
								</c:if>

								<button id="showRequestFormBtn" class="btn-primary"
									style="width: 100%; justify-content: center; ${hasPendingRequest ? 'display: none;' : ''}">
									<span class="material-symbols-outlined">send</span> Request to
									Rent
								</button>

								<div id="requestForm" style="display: none; margin-top: 1rem;">
									<form id="rentalRequestForm" method="post"
										action="${pageContext.request.contextPath}/tenant/submit-request">
										<input type="hidden" name="propertyId"
											value="${property.propertyId}"> <input type="hidden"
											name="propertyDisplayId" value="${property.displayId}">

										<div class="form-group" style="margin-bottom: 1rem;">
											<label for="moveInDate"
												style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Preferred
												Move-in Date <span style="color: var(--error);">*</span>
											</label> <input type="date" id="moveInDate" name="moveInDate"
												required
												style="width: 100%; padding: 0.75rem; border: 1px solid var(--outline-variant); border-radius: 0.5rem; font-family: inherit;">
										</div>

										<div class="form-group" style="margin-bottom: 1rem;">
											<label for="leaseDuration"
												style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Lease
												Duration (months) <span style="color: var(--error);">*</span>
											</label> <select id="leaseDuration" name="leaseDuration" required
												style="width: 100%; padding: 0.75rem; border: 1px solid var(--outline-variant); border-radius: 0.5rem;">
												<option value="6">6 months</option>
												<option value="12" selected>12 months</option>
												<option value="18">18 months</option>
												<option value="24">24 months</option>
												<option value="36">36 months</option>
											</select>
										</div>

										<div class="form-group" style="margin-bottom: 1rem;">
											<label for="message"
												style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Message
												to Landlord</label>
											<textarea id="message" name="message" rows="3"
												style="width: 100%; padding: 0.75rem; border: 1px solid var(--outline-variant); border-radius: 0.5rem; font-family: inherit;"
												placeholder="Tell the landlord about yourself (occupation, family members, etc.) and any questions you have..."></textarea>
										</div>

										<div style="display: flex; gap: 1rem;">
											<button type="submit" class="btn-primary"
												style="flex: 1; justify-content: center;">Submit
												Request</button>
											<button type="button" id="cancelRequestBtn"
												class="btn-outline"
												style="flex: 1; justify-content: center;">Cancel</button>
										</div>
									</form>
								</div>
							</c:when>
							<c:otherwise>
								<div
									style="text-align: center; padding: 1rem; background: var(--surface-container-low); border-radius: 1rem;">
									<p>You are logged in as ${sessionScope.loggedInUser.role}.
										Only tenants can request properties.</p>
									<c:if test="${sessionScope.loggedInUser.role == 'landlord'}">
										<p style="margin-top: 0.5rem; font-size: 0.875rem;">This
											is your property listing.</p>
									</c:if>
								</div>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
			</div>

			<!-- Landlord Info Section -->
			<div class="landlord-section"
				style="margin-top: 2rem; padding: 1.5rem; background: var(--surface-container-low); border-radius: 1rem;">
				<h3 style="font-size: 1.1rem; margin-bottom: 1rem;">About the
					Landlord</h3>
				<div style="display: flex; align-items: center; gap: 1rem;">
					<div class="landlord-avatar"
						style="width: 60px; height: 60px; background: var(--primary); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: white; font-weight: 700; font-size: 1.5rem;">
						${fn:substring(property.landlordName, 0, 1)}</div>
					<div>
						<h4 style="margin-bottom: 0.25rem;">${fn:escapeXml(property.landlordName)}</h4>
						<p style="color: var(--on-surface-variant); font-size: 0.875rem;">Member
							since 2026</p>
					</div>
				</div>
			</div>

		</div>
	</main>

	<jsp:include page="/WEB-INF/includes/footer.jsp" />

	<script src="${pageContext.request.contextPath}/js/property-details.js"></script>

	<style>
.breadcrumb {
	display: flex;
	align-items: center;
	gap: 0.25rem;
	flex-wrap: wrap;
}

.breadcrumb a:hover {
	text-decoration: underline;
}

.property-main-image {
	transition: opacity 0.3s ease;
}

.thumbnail {
	transition: transform 0.2s, border-color 0.2s;
}

.thumbnail:hover {
	transform: scale(1.05);
}

.feature-tag {
	transition: background 0.2s;
}

.feature-tag:hover {
	background: var(--surface-container-highest);
}

@media ( max-width : 768px) {
	.property-details-grid {
		grid-template-columns: 1fr !important;
		gap: 1rem !important;
	}
	.property-main-image {
		height: 250px !important;
	}
	.property-specs {
		grid-template-columns: repeat(2, 1fr) !important;
	}
	.property-title {
		font-size: 1.4rem !important;
	}
	.property-price {
		font-size: 1.5rem !important;
	}
}
</style>

</body>
</html>