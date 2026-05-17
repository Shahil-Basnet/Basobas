<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Basobas - Property Rental in Nepal</title>

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">

<!-- Material Icons -->
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
	rel="stylesheet">

<!-- Font Awesome -->
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">

<!-- CSS Files -->
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/public.css">

<!-- JS Files -->
<script>
    window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
<script src="${pageContext.request.contextPath}/js/common/navigation.js"></script>
</head>
<body>

	<!-- Primary Navigation -->
	<header class="primary-nav">
		<div class="container">
			<div class="logo">
				<a href="${pageContext.request.contextPath}/"> <span
					class="logo-icon">🏠</span> <span class="logo-text">Basobas</span>
				</a>
			</div>

			<nav class="nav-links">
				<a href="${pageContext.request.contextPath}/index"
					class="${page == 'home' ? 'active' : ''}">Home</a> 
				<a href="${pageContext.request.contextPath}/properties"
					class="${page == 'properties' ? 'active' : ''}">Properties</a> 
				<a href="${pageContext.request.contextPath}/about"
					class="${page == 'about' ? 'active' : ''}">About</a> 
				<a href="${pageContext.request.contextPath}/contact"
					class="${page == 'contact' ? 'active' : ''}">Contact</a>
			</nav>

			<div class="auth-area">
				<c:choose>
					<c:when test="${empty sessionScope.loggedInUser}">
						<a href="${pageContext.request.contextPath}/login"
							class="btn-outline">Login</a>
						<a href="${pageContext.request.contextPath}/register"
							class="btn-primary">Register</a>
					</c:when>
					<c:otherwise>
						<div class="profile-dropdown">
							<button class="profile-trigger" id="profileTrigger">
								<div class="avatar-small">
									<c:choose>
										<c:when test="${not empty sessionScope.loggedInUser.fullName}">
											${fn:substring(sessionScope.loggedInUser.fullName, 0, 1)}
										</c:when>
										<c:otherwise>U</c:otherwise>
									</c:choose>
								</div>
								<span class="user-name">${sessionScope.loggedInUser.fullName != null ? sessionScope.loggedInUser.fullName : 'User'}</span>
								<span class="material-symbols-outlined dropdown-arrow">expand_more</span>
							</button>
							<div class="dropdown-menu" id="dropdownMenu">
								<!-- Dashboard link for all roles -->
								<c:choose>
									<c:when test="${sessionScope.loggedInUser.role == 'admin'}">
										<a href="${pageContext.request.contextPath}/admin/dashboard" class="dropdown-item">
											<span class="material-symbols-outlined">dashboard</span> Dashboard
										</a>
									</c:when>
									<c:when test="${sessionScope.loggedInUser.role == 'landlord'}">
										<a href="${pageContext.request.contextPath}/landlord/dashboard" class="dropdown-item">
											<span class="material-symbols-outlined">dashboard</span> Dashboard
										</a>
									</c:when>
									<c:otherwise>
										<a href="${pageContext.request.contextPath}/tenant/dashboard" class="dropdown-item">
											<span class="material-symbols-outlined">dashboard</span> Dashboard
										</a>
									</c:otherwise>
								</c:choose>
								<a href="${pageContext.request.contextPath}/profile" class="dropdown-item">
									<span class="material-symbols-outlined">person</span> My Profile
								</a>
								<div class="dropdown-divider"></div>
								<a href="${pageContext.request.contextPath}/logout" class="dropdown-item logout">
									<span class="material-symbols-outlined">logout</span> Logout
								</a>
							</div>
						</div>
					</c:otherwise>
				</c:choose>
			</div>

			<!-- Mobile menu button -->
			<button class="mobile-menu-btn" id="mobileMenuBtn">
				<span class="material-symbols-outlined">menu</span>
			</button>
		</div>
	</header>

	<!-- Mobile Navigation -->
	<div class="mobile-nav" id="mobileNav">
		<div class="mobile-nav-links">
			<a href="${pageContext.request.contextPath}/">Home</a> 
			<a href="${pageContext.request.contextPath}/properties">Properties</a>
			<a href="${pageContext.request.contextPath}/about">About</a> 
			<a href="${pageContext.request.contextPath}/contact">Contact</a>
			<c:if test="${empty sessionScope.loggedInUser}">
				<div class="mobile-auth">
					<a href="${pageContext.request.contextPath}/login" class="btn-outline">Login</a> 
					<a href="${pageContext.request.contextPath}/register" class="btn-primary">Register</a>
				</div>
			</c:if>
			<c:if test="${not empty sessionScope.loggedInUser}">
				<div class="mobile-user-menu">
					<div class="mobile-user-header">${sessionScope.loggedInUser.fullName}</div>
					<c:choose>
						<c:when test="${sessionScope.loggedInUser.role == 'admin'}">
							<a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a>
						</c:when>
						<c:when test="${sessionScope.loggedInUser.role == 'landlord'}">
							<a href="${pageContext.request.contextPath}/landlord/dashboard">Dashboard</a>
							<a href="${pageContext.request.contextPath}/landlord/properties">My Properties</a>
							<a href="${pageContext.request.contextPath}/landlord/requests">Rental Requests</a>
						</c:when>
						<c:otherwise>
							<a href="${pageContext.request.contextPath}/tenant/dashboard">Dashboard</a>
							<a href="${pageContext.request.contextPath}/tenant/rentals">My Rentals</a>
							<a href="${pageContext.request.contextPath}/tenant/requests">My Requests</a>
							<a href="${pageContext.request.contextPath}/tenant/payments">Payments</a>
						</c:otherwise>
					</c:choose>
					<a href="${pageContext.request.contextPath}/profile">Profile</a>
					<div class="mobile-divider"></div>
					<a href="${pageContext.request.contextPath}/logout">Logout</a>
				</div>
			</c:if>
		</div>
	</div>

	<!-- Secondary Navigation (only for logged in tenants) -->
	<c:if test="${not empty sessionScope.loggedInUser and sessionScope.loggedInUser.role == 'tenant'}">
		<div class="secondary-nav">
			<div class="container">
				<div class="secondary-nav-links">
					<a href="${pageContext.request.contextPath}/tenant/dashboard" class="${page == 'dashboard' ? 'active' : ''}">
						<span class="material-symbols-outlined">dashboard</span> Dashboard
					</a>
					<a href="${pageContext.request.contextPath}/tenant/rentals" class="${page == 'rentals' ? 'active' : ''}">
						<span class="material-symbols-outlined">home_work</span> My Rentals
					</a>
					<a href="${pageContext.request.contextPath}/tenant/requests" class="${page == 'requests' ? 'active' : ''}">
						<span class="material-symbols-outlined">pending_actions</span> My Requests
					</a>
					<a href="${pageContext.request.contextPath}/tenant/payments" class="${page == 'payments' ? 'active' : ''}">
						<span class="material-symbols-outlined">payments</span> Payments
					</a>
				</div>
			</div>
		</div>
	</c:if>

	<script>
		document.addEventListener('DOMContentLoaded', function() {
			// Mobile menu toggle
			const mobileBtn = document.getElementById('mobileMenuBtn');
			const mobileNav = document.getElementById('mobileNav');

			if (mobileBtn && mobileNav) {
				mobileBtn.addEventListener('click', function() {
					mobileNav.classList.toggle('active');
				});
			}
		});
	</script>

</body>
</html>