<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
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

			<!-- Stats Cards -->
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">groups</span>
					</div>
					<h4>Total Users</h4>
					<div class="stat-number">1,284</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">trending_up</span>
						+12% vs last month
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">apartment</span>
					</div>
					<h4>Properties</h4>
					<div class="stat-number">452</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">location_city</span>
						14 regions
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">description</span>
					</div>
					<h4>Active Leases</h4>
					<div class="stat-number">398</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">verified</span>
						88% occupied
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">pending_actions</span>
					</div>
					<h4>Pending Requests</h4>
					<div class="stat-number">27</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">schedule</span>
						5 urgent
					</div>
				</div>
			</div>

			<!-- Dashboard Content -->
			<div class="space-y-8">
				<!-- Recent Properties -->
				<div class="dashboard-card">
					<div class="card-header">
						<h3>Recent Properties</h3>
						<span class="badge-last">Last 5</span>
					</div>
					<div style="overflow-x: auto;">
						<table class="data-table">
							<thead>
								<tr>
									<th>ID</th>
									<th>Title</th>
									<th>Landlord</th>
									<th>City</th>
									<th>Monthly Rent</th>
									<th>Added On</th>
								</tr>
							</thead>
							<tbody>
								<tr>
									<td class="text-muted">123</td>
									<td class="font-bold">Sunny Apt</td>
									<td>John D.</td>
									<td>Miami</td>
									<td class="text-primary font-bold">$1,200</td>
									<td>2025-04-15</td>
								</tr>
								<tr>
									<td class="text-muted">124</td>
									<td class="font-bold">Downtown Loft</td>
									<td>Jane S.</td>
									<td>Chicago</td>
									<td class="text-primary font-bold">$1,800</td>
									<td>2025-04-14</td>
								</tr>
								<tr>
									<td class="text-muted">125</td>
									<td class="font-bold">Greenfield House</td>
									<td>Robert L.</td>
									<td>Austin</td>
									<td class="text-primary font-bold">$2,100</td>
									<td>2025-04-12</td>
								</tr>
							</tbody>
						</table>
					</div>
					<div class="card-header"
						style="border-top: 1px solid #eef2f0; border-bottom: none;">
						<a href="#" class="link-arrow">View All Properties <span
							class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span></a>
					</div>
				</div>

				<!-- 2 Column: Pending Requests + Activity -->
				<div class="grid-2cols">
					<div class="dashboard-card">
						<div class="card-header">
							<h3>Pending Rental Requests</h3>
							<span class="badge-last">Needs Landlord Action</span>
						</div>
						<div style="overflow-x: auto;">
							<table class="data-table">
								<thead>
									<tr>
										<th>ID</th>
										<th>Property</th>
										<th>Tenant</th>
										<th>Request Date</th>
										<th>Status</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>R01</td>
										<td class="font-bold">Sunny Apt</td>
										<td>Mike T.</td>
										<td>2025-04-15</td>
										<td><span
											style="background: #fff3e0; color: #b45f06; padding: 2px 10px; border-radius: 30px;">Pending</span></td>
									</tr>
									<tr>
										<td>R02</td>
										<td class="font-bold">Green House</td>
										<td>Sarah K.</td>
										<td>2025-04-14</td>
										<td><span
											style="background: #fff3e0; color: #b45f06; padding: 2px 10px; border-radius: 30px;">Pending</span></td>
									</tr>
								</tbody>
							</table>
						</div>
						<div class="card-header"
							style="border-top: 1px solid #eef2f0; border-bottom: none;">
							<a href="#" class="link-arrow">View All Requests <span
								class="material-symbols-outlined" style="font-size: 1rem;">arrow_forward</span></a>
						</div>
					</div>

					<div class="dashboard-card">
						<div class="card-header">
							<h3>Recent Activity Feed</h3>
						</div>
						<div class="activity-feed">
							<div class="feed-item">
								<div class="feed-dot"></div>
								<div class="feed-title">
									New user registered: <strong>john_doe</strong> (Tenant)
								</div>
								<div class="feed-time">2 minutes ago</div>
							</div>
							<div class="feed-item">
								<div class="feed-dot secondary"></div>
								<div class="feed-title">
									Property listed: <strong>Beach Apartment</strong> by
									jane_landlord
								</div>
								<div class="feed-time">1 hour ago</div>
							</div>
							<div class="feed-item">
								<div class="feed-dot warning"></div>
								<div class="feed-title">
									Maintenance request: <strong>Leaking pipe</strong> (Urgent)
								</div>
								<div class="feed-time">5 hours ago</div>
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