<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Basobas | Admin Dashboard</title>

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;400;500;600;700&family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600&display=swap"
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
</head>
<body>

	<!-- SIDEBAR -->
	<c:set var="page" value="dashboard" scope="request" />
	<jsp:include page="/WEB-INF/includes/admin-sidebar.jsp" />

	<!-- MAIN CONTENT -->
	<main class="main-content">
		<jsp:include page="/WEB-INF/includes/topbar.jsp" />

		<div class="dashboard-container">
			<!-- Welcome -->
			<div class="welcome">
				<h2>Portfolio Overview</h2>
				<p>Track and manage all rentals, tenants, and properties from
					one place.</p>
			</div>

			<!-- Stats Cards with Real Data -->
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">groups</span>
					</div>
					<h4>Total Users</h4>
					<div class="stat-number">${totalUsers}</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">person</span>
						Registered users
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">apartment</span>
					</div>
					<h4>Properties</h4>
					<div class="stat-number">${totalProperties}</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">location_city</span>
						Total listings
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">description</span>
					</div>
					<h4>Occupied Properties</h4>
					<div class="stat-number">${occupiedProperties}</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">verified</span>
						${occupancyRate}% occupied
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">pending_actions</span>
					</div>
					<h4>Pending Requests</h4>
					<div class="stat-number">${pendingRequests}</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">schedule</span>
						Awaiting response
					</div>
				</div>
			</div>

			<!-- Dashboard Content -->
			<div class="space-y-8">
				<!-- Recent Properties -->
				<div class="dashboard-card">
					<div class="card-header">
						<h3>Recent Properties</h3>
						<span class="badge-last">Last
							${fn:length(recentProperties)}</span>
					</div>
					<div style="overflow-x: auto;">
						<table class="data-table">
							<thead>
								<tr>
									<th>Property ID</th>
									<th>Title</th>
									<th>Landlord</th>
									<th>City</th>
									<th>Monthly Rent</th>
									<th>Status</th>
									<th>Added On</th>
								</tr>
							</thead>
							<tbody>
								<c:forEach var="property" items="${recentProperties}">
									<tr>
										<td class="text-muted">${property.displayId}</td>
										<td class="font-bold">${fn:escapeXml(property.title)}</td>
										<td>${fn:escapeXml(property.landlordName)}</td>
										<td>${fn:escapeXml(property.city)}</td>
										<td class="text-primary font-bold">रू <fmt:formatNumber
												value="${property.monthlyRent}" groupingUsed="true" /></td>
										<td><c:choose>
												<c:when test="${property.status == 'available'}">
													<span
														style="background: #d1fae5; color: #059669; padding: 2px 10px; border-radius: 30px; font-size: 0.7rem;">Available</span>
												</c:when>
												<c:when test="${property.status == 'rented'}">
													<span
														style="background: #fee2e2; color: #dc2626; padding: 2px 10px; border-radius: 30px; font-size: 0.7rem;">Rented</span>
												</c:when>
												<c:otherwise>
													<span
														style="background: #f3f4f6; color: #6b7280; padding: 2px 10px; border-radius: 30px; font-size: 0.7rem;">${property.status}</span>
												</c:otherwise>
											</c:choose></td>
										<td class="text-muted">${property.createdAt}</td>
									</tr>
								</c:forEach>
								<c:if test="${empty recentProperties}">
									<tr>
										<td colspan="7" style="text-align: center; padding: 2rem;">No
											properties found</td>
									</tr>
								</c:if>
							</tbody>
						</table>
					</div>
					<div class="card-header"
						style="border-top: 1px solid #eef2f0; border-bottom: none;">
						<a href="${pageContext.request.contextPath}/admin/properties"
							class="link-arrow">View All Properties <span
							class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
						</a>
					</div>
				</div>

				<!-- 2 Column: Pending Requests + Activity -->
				<div class="grid-2cols">
					<div class="dashboard-card">
						<div class="card-header">
							<h3>Recent Rental Requests</h3>
							<span class="badge-last">Latest</span>
						</div>
						<div style="overflow-x: auto;">
							<table class="data-table">
								<thead>
									<tr>
										<th>Request ID</th>
										<th>Property</th>
										<th>Tenant</th>
										<th>Request Date</th>
										<th>Status</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="request" items="${recentRequests}">
										<tr>
											<td class="text-muted">${request.displayId}</td>
											<td class="font-bold">${fn:escapeXml(request.propertyTitle)}</td>
											<td>${fn:escapeXml(request.tenantName)}</td>
											<td class="text-muted">${request.createdAt}</td>
											<td><c:choose>
													<c:when test="${request.status == 'pending'}">
														<span
															style="background: #fff3e0; color: #b45f06; padding: 2px 10px; border-radius: 30px; font-size: 0.7rem;">Pending</span>
													</c:when>
													<c:when test="${request.status == 'approved'}">
														<span
															style="background: #d1fae5; color: #059669; padding: 2px 10px; border-radius: 30px; font-size: 0.7rem;">Approved</span>
													</c:when>
													<c:when test="${request.status == 'rejected'}">
														<span
															style="background: #fee2e2; color: #dc2626; padding: 2px 10px; border-radius: 30px; font-size: 0.7rem;">Rejected</span>
													</c:when>
													<c:otherwise>
														<span
															style="background: #f3f4f6; color: #6b7280; padding: 2px 10px; border-radius: 30px; font-size: 0.7rem;">${request.status}</span>
													</c:otherwise>
												</c:choose></td>
										</tr>
									</c:forEach>
									<c:if test="${empty recentRequests}">
										<tr>
											<td colspan="5" style="text-align: center; padding: 2rem;">No
												rental requests found</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
						<div class="card-header"
							style="border-top: 1px solid #eef2f0; border-bottom: none;">
							<a href="#" class="link-arrow">View All Requests <span
								class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span>
							</a>
						</div>
					</div>

					<div class="dashboard-card">
						<div class="card-header">
							<h3>Quick Stats</h3>
						</div>
						<div class="activity-feed">
							<div class="feed-item">
								<div class="feed-dot"></div>
								<div class="feed-title">
									Total Users: <strong>${totalUsers}</strong>
								</div>
								<div class="feed-time">Across all roles</div>
							</div>
							<div class="feed-item">
								<div class="feed-dot secondary"></div>
								<div class="feed-title">
									Total Properties: <strong>${totalProperties}</strong>
								</div>
								<div class="feed-time">Listed on platform</div>
							</div>
							<div class="feed-item">
								<div class="feed-dot warning"></div>
								<div class="feed-title">
									Occupancy Rate: <strong>${occupancyRate}%</strong>
								</div>
								<div class="feed-time">${occupiedProperties}out of
									${totalProperties} properties rented</div>
							</div>
							<div class="feed-item">
								<div class="feed-dot error"></div>
								<div class="feed-title">
									Available Properties: <strong>${totalProperties - occupiedProperties}</strong>
								</div>
								<div class="feed-time">Ready for rent</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>

	<button class="fab" aria-label="Quick add">
		<span class="material-symbols-outlined">add</span>
	</button>

	<!-- Scripts -->
	<script>
		window.contextPath = "${pageContext.request.contextPath}";
	</script>
	<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/common/navigation.js"></script>
</body>
</html>