<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ page import="java.util.List"%>
<%@ page import="com.basobas.model.Property"%>

<c:set var="page" value="home" scope="request" />

<jsp:include page="/WEB-INF/includes/header.jsp" />

<main>
	<!-- Hero Section -->
	<section class="hero">
		<div class="container">
			<h1>Find Your Perfect Rental Home in Nepal</h1>
			<p>Discover thousands of verified properties. Connect directly
				with landlords. No brokerage fees.</p>
			<div class="search-bar">
				<input type="text" id="homeSearch"
					placeholder="Search by city, property name, or area...">
				<button class="btn-primary" onclick="searchProperties()">
					<span class="material-symbols-outlined">search</span> Search
				</button>
			</div>
		</div>
	</section>

	<!-- Stats Section -->
	<section class="stats-section">
		<div class="container">
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">home_work</span>
					</div>
					<div class="stat-number">${totalProperties}+</div>
					<div class="stat-label">Properties Listed</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">real_estate_agent</span>
					</div>
					<div class="stat-number">${activeLandlords}+</div>
					<div class="stat-label">Active Landlords</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">groups</span>
					</div>
					<div class="stat-number">${happyTenants}+</div>
					<div class="stat-label">Happy Tenants</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">verified</span>
					</div>
					<div class="stat-number">100%</div>
					<div class="stat-label">No Brokerage</div>
				</div>
			</div>
		</div>
	</section>

	<!-- Featured Properties Section -->
	<section class="featured-section">
		<div class="container">
			<div class="section-header">
				<h2>Featured Properties</h2>
				<p>Handpicked properties just for you</p>
			</div>

			<c:choose>
				<c:when test="${empty featuredProperties}">
					<div class="no-results">
						<span class="material-symbols-outlined" style="font-size: 4rem;">inventory_2</span>
						<h3>No properties available yet</h3>
						<p>Check back soon for new listings!</p>
					</div>
				</c:when>
				<c:otherwise>
					<div class="properties-grid">
						<c:forEach items="${featuredProperties}" var="property">
							<div class="property-card">
								<c:choose>
									<c:when test="${not empty property.primaryPhotoUrl}">
										<img
											src="${pageContext.request.contextPath}${property.primaryPhotoUrl}"
											alt="${property.title}" class="property-image"
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
										<span class="material-symbols-outlined">location_on</span> <span>${fn:escapeXml(property.city)}</span>
										<c:if test="${not empty property.wardNumber}">
											<span>, Ward ${property.wardNumber}</span>
										</c:if>
									</div>
									<div class="property-price">रू ${String.format("%,.0f", property.monthlyRent)}/month</div>
									<div class="property-details">
										<span> <span class="material-symbols-outlined">bed</span>
											${property.bedrooms} Beds
										</span> <span> <span class="material-symbols-outlined">bathtub</span>
											${property.bathrooms} Baths
										</span>
									</div>
									<a
										href="${pageContext.request.contextPath}/property?id=${property.displayId}"
										class="btn-outline"
										style="width: 100%; text-align: center; justify-content: center;">
										View Details </a>
								</div>
							</div>
						</c:forEach>
					</div>

					<div class="view-all-container"
						style="text-align: center; margin-top: 2rem;">
						<a href="${pageContext.request.contextPath}/properties"
							class="btn-primary">View All Properties</a>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</section>

	<!-- How It Works Section -->
	<section class="how-it-works">
		<div class="container">
			<div class="section-header">
				<h2>How It Works</h2>
				<p>Simple steps to find your next home</p>
			</div>
			<div class="steps-grid">
				<div class="step-card">
					<div class="step-number">1</div>
					<div class="step-icon">
						<span class="material-symbols-outlined">search</span>
					</div>
					<h3>Browse Properties</h3>
					<p>Search through hundreds of verified properties across Nepal.
						Filter by city, price, and more.</p>
				</div>
				<div class="step-card">
					<div class="step-number">2</div>
					<div class="step-icon">
						<span class="material-symbols-outlined">send</span>
					</div>
					<h3>Send Request</h3>
					<p>Interested in a property? Send a rental request to the
						landlord directly.</p>
				</div>
				<div class="step-card">
					<div class="step-number">3</div>
					<div class="step-icon">
						<span class="material-symbols-outlined">home</span>
					</div>
					<h3>Move In</h3>
					<p>Once approved, complete the process and move into your new
						home.</p>
				</div>
			</div>
		</div>
	</section>

	<!-- Why Choose Basobas Section -->
	<section class="why-choose">
		<div class="container">
			<div class="section-header">
				<h2>Why Choose Basobas?</h2>
				<p>We make renting in Nepal simple and transparent</p>
			</div>
			<div class="features-grid">
				<div class="feature-card">
					<div class="feature-icon">
						<span class="material-symbols-outlined">verified</span>
					</div>
					<h3>Verified Properties</h3>
					<p>All properties are verified for authenticity before listing.</p>
				</div>
				<div class="feature-card">
					<div class="feature-icon">
						<span class="material-symbols-outlined">currency_rupee</span>
					</div>
					<h3>No Brokerage</h3>
					<p>Connect directly with landlords. No hidden fees or
						commissions.</p>
				</div>
				<div class="feature-card">
					<div class="feature-icon">
						<span class="material-symbols-outlined">support_agent</span>
					</div>
					<h3>24/7 Support</h3>
					<p>Our team is always here to help you with any questions.</p>
				</div>
				<div class="feature-card">
					<div class="feature-icon">
						<span class="material-symbols-outlined">payments</span>
					</div>
					<h3>Secure Payments</h3>
					<p>Track all your rental payments securely through our
						platform.</p>
				</div>
			</div>
		</div>
	</section>

	<!-- CTA Section -->
	<section class="cta-section">
		<div class="container">
			<div class="cta-content">
				<h2>Ready to Find Your Dream Rental?</h2>
				<p>Join thousands of happy tenants who found their perfect home
					through Basobas.</p>
				<div class="cta-buttons">
					<a href="${pageContext.request.contextPath}/properties"
						class="btn-primary btn-large">Browse Properties</a>
					<c:if test="${empty sessionScope.loggedInUser}">
						<a href="${pageContext.request.contextPath}/register"
							class="btn-outline btn-large">Register as Landlord</a>
					</c:if>
					<c:if
						test="${not empty sessionScope.loggedInUser and sessionScope.loggedInUser.role == 'landlord'}">
						<a
							href="${pageContext.request.contextPath}/landlord/properties?action=add"
							class="btn-outline btn-large">List Your Property</a>
					</c:if>
				</div>
			</div>
		</div>
</main>

<script src="${pageContext.request.contextPath}/js/index.js"></script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />