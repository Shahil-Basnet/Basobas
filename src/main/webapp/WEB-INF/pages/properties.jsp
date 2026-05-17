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
<title>Properties for Rent - Basobas | Find Your Perfect Home in
	Nepal</title>

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
		<!-- Hero Section -->
		<section class="hero">
			<div class="container">
				<h1>Find Your Perfect Rental Property</h1>
				<p>Discover thousands of properties across Nepal. From
					apartments to family homes, find your next home with Basobas.</p>

				<!-- Quick Search Bar -->
				<form action="${pageContext.request.contextPath}/properties"
					method="get" class="search-bar">
					<input type="text" name="search"
						placeholder="Search by city, property name, or keyword..."
						value="${param.search}">
					<button type="submit" class="btn-primary">Search</button>
				</form>
			</div>
		</section>

		<!-- Main Content with Filters -->
		<div class="container" style="padding: 2rem;">
			<div class="flex" style="gap: 2rem; flex-wrap: wrap;">

				<!-- Filters Sidebar -->
				<aside class="filters-sidebar" style="flex: 0 0 280px;">
					<h3 class="filters-title">Filter Properties</h3>

					<form method="get"
						action="${pageContext.request.contextPath}/properties">
						<!-- Preserve search keyword if present -->
						<c:if test="${not empty param.search}">
							<input type="hidden" name="search" value="${param.search}">
						</c:if>

						<!-- City Filter -->
						<div class="filter-group">
							<label>City / District</label> <select name="city">
								<option value="all"
									${param.city == 'all' or empty param.city ? 'selected' : ''}>All
									Cities</option>
								<c:forEach var="city" items="${cities}">
									<option value="${city}" ${param.city == city ? 'selected' : ''}>${city}</option>
								</c:forEach>
							</select>
						</div>

						<!-- Price Range -->
						<div class="filter-group">
							<label>Min Rent (NPR)</label> <input type="number" name="minRent"
								placeholder="e.g., 10000" value="${param.minRent}">
						</div>

						<div class="filter-group">
							<label>Max Rent (NPR)</label> <input type="number" name="maxRent"
								placeholder="e.g., 50000" value="${param.maxRent}">
						</div>

						<!-- Bedrooms -->
						<div class="filter-group">
							<label>Bedrooms</label> <select name="bedrooms">
								<option value="all"
									${param.bedrooms == 'all' or empty param.bedrooms ? 'selected' : ''}>Any</option>
								<option value="1" ${param.bedrooms == '1' ? 'selected' : ''}>1
									Bedroom</option>
								<option value="2" ${param.bedrooms == '2' ? 'selected' : ''}>2
									Bedrooms</option>
								<option value="3" ${param.bedrooms == '3' ? 'selected' : ''}>3
									Bedrooms</option>
								<option value="4" ${param.bedrooms == '4' ? 'selected' : ''}>4+
									Bedrooms</option>
							</select>
						</div>

						<!-- Nepal-Specific Filters -->
						<div class="filter-group">
							<label> <input type="checkbox" name="hasPowerBackup"
								value="1" ${param.hasPowerBackup == '1' ? 'checked' : ''}>
								Has Power Backup
							</label>
						</div>

						<div class="filter-actions">
							<button type="submit" class="btn-primary" style="flex: 1;">Apply
								Filters</button>
							<a href="${pageContext.request.contextPath}/properties"
								class="btn-outline"
								style="text-align: center; text-decoration: none;">Reset</a>
						</div>
					</form>
				</aside>

				<!-- Property Results -->
				<div style="flex: 1;">
					<!-- Results Header -->
					<div class="flex justify-between items-center"
						style="margin-bottom: 1.5rem; flex-wrap: wrap; gap: 1rem;">
						<div>
							<span class="text-on-surface-variant"> <c:choose>
									<c:when test="${empty properties or properties.size() == 0}">
                                    0 properties found
                                </c:when>
									<c:otherwise>
                                    ${properties.size()} propert${properties.size() == 1 ? 'y' : 'ies'} found
                                </c:otherwise>
								</c:choose>
							</span>
						</div>
					</div>

					<!-- Properties Grid -->
					<c:choose>
						<c:when test="${empty properties or properties.size() == 0}">
							<div class="no-results"
								style="text-align: center; padding: 3rem;">
								<div class="material-symbols-outlined"
									style="font-size: 4rem; color: var(--outline);">search_off</div>
								<h3>No properties found</h3>
								<p>Try adjusting your filters or search criteria.</p>
								<a href="${pageContext.request.contextPath}/properties"
									class="btn-outline"
									style="margin-top: 1rem; display: inline-block;">Clear all
									filters</a>
							</div>
						</c:when>
						<c:otherwise>
							<div class="properties-grid">
								<c:forEach var="property" items="${properties}">
									<a
										href="${pageContext.request.contextPath}/property?id=${property.displayId}"
										class="property-card"> 
										<c:choose>
											<c:when test="${not empty property.primaryPhotoUrl}">
												<img
													src="${pageContext.request.contextPath}${property.primaryPhotoUrl}"
													alt="${fn:escapeXml(property.title)}"
													class="property-image"
													onerror="this.src='${pageContext.request.contextPath}/assets/no-image.jpg'">
											</c:when>
											<c:otherwise>
												<div class="property-image"
													style="display: flex; align-items: center; justify-content: center; background: var(--surface-container-high);">
													<span class="material-symbols-outlined"
														style="font-size: 4rem; color: var(--outline);">photo_camera</span>
												</div>
											</c:otherwise>
										</c:choose>
										<div class="property-info">
											<h3 class="property-title">${fn:escapeXml(property.title)}</h3>
											<div class="property-location">
												<span class="material-symbols-outlined">location_on</span> <span>
													<c:choose>
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
											<div class="property-price">
												रू
												<fmt:formatNumber value="${property.monthlyRent}"
													groupingUsed="true" />
												/month
											</div>
											<div class="property-details">
												<span> <span class="material-symbols-outlined">bed</span>
													${property.bedrooms} bed${property.bedrooms != 1 ? 's' : ''}
												</span> <span> <span class="material-symbols-outlined">bathtub</span>
													${property.bathrooms} bath${property.bathrooms != 1 ? 's' : ''}
												</span>
											</div>
											<c:if
												test="${property.powerBackupHours != null and property.powerBackupHours > 0}">
												<div class="property-features">
													<span class="feature-badge"> <span
														class="material-symbols-outlined">bolt</span>
														${property.powerBackupHours}h Backup
													</span>
												</div>
											</c:if>
											<div class="property-status status-available">
												Available Now</div>
										</div>
									</a>
								</c:forEach>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</div>
	</main>

	<!-- Include Footer -->
	<jsp:include page="/WEB-INF/includes/footer.jsp" />

	<style>
.property-card {
	background: var(--surface-container-lowest);
	border-radius: 1rem;
	overflow: hidden;
	border: 1px solid var(--outline-variant);
	transition: transform 0.2s, box-shadow 0.2s;
	text-decoration: none;
	display: block;
	color: inherit;
}

.property-card:hover {
	transform: translateY(-4px);
	box-shadow: 0 12px 24px rgba(0, 0, 0, 0.1);
}

.property-image {
	width: 100%;
	height: 220px;
	object-fit: cover;
	background: var(--surface-container-high);
}

.property-info {
	padding: 1rem;
}

.property-title {
	font-size: 1.1rem;
	font-weight: 700;
	color: var(--on-surface);
	margin-bottom: 0.5rem;
	display: -webkit-box;
	-webkit-line-clamp: 1;
	-webkit-box-orient: vertical;
	overflow: hidden;
}

.property-location {
	display: flex;
	align-items: center;
	gap: 0.25rem;
	color: var(--on-surface-variant);
	font-size: 0.875rem;
	margin-bottom: 0.5rem;
}

.property-location .material-symbols-outlined {
	font-size: 1rem;
}

.property-price {
	font-size: 1.25rem;
	font-weight: 700;
	color: var(--primary);
	margin-bottom: 0.5rem;
}

.property-details {
	display: flex;
	gap: 1rem;
	color: var(--on-surface-variant);
	font-size: 0.875rem;
	margin-bottom: 0.75rem;
}

.property-details span {
	display: flex;
	align-items: center;
	gap: 0.25rem;
}

.property-features {
	display: flex;
	gap: 0.5rem;
	flex-wrap: wrap;
	margin-top: 0.5rem;
}

.feature-badge {
	background: var(--surface-container-high);
	padding: 0.25rem 0.5rem;
	border-radius: 0.25rem;
	font-size: 0.7rem;
	color: var(--on-surface-variant);
	display: flex;
	align-items: center;
	gap: 0.25rem;
}

.feature-badge .material-symbols-outlined {
	font-size: 0.8rem;
}

.property-status {
	display: inline-block;
	padding: 0.25rem 0.75rem;
	border-radius: 2rem;
	font-size: 0.7rem;
	font-weight: 600;
	margin-top: 0.5rem;
}

.status-available {
	background: var(--primary-container);
	color: var(--on-primary-container);
}

.filter-actions {
	display: flex;
	gap: 0.75rem;
	margin-top: 1.5rem;
}

.btn-outline {
	background: transparent;
	border: 1px solid var(--primary);
	color: var(--primary);
	padding: 0.625rem 1.25rem;
	border-radius: 0.5rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s;
	display: inline-block;
}

.btn-outline:hover {
	background: rgba(51, 79, 43, 0.05);
}

.properties-grid {
	display: grid;
	grid-template-columns: repeat(auto-fill, minmax(320px, 1fr));
	gap: 1.5rem;
	margin: 1.5rem 0;
}

.no-results {
	text-align: center;
	padding: 3rem;
}

.no-results .material-symbols-outlined {
	font-size: 4rem;
	color: var(--outline);
}

.filter-group select, .filter-group input {
	width: 100%;
	padding: 0.5rem;
	border: 1px solid var(--outline-variant);
	border-radius: 0.5rem;
	background: var(--surface-container-lowest);
	font-family: inherit;
}

@media ( max-width : 768px) {
	.filters-sidebar {
		flex: 0 0 100%;
	}
	.properties-grid {
		grid-template-columns: 1fr;
	}
	.container {
		padding: 1rem;
	}
}
</style>

</body>
</html>