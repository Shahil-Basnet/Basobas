<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Properties Management | Basobas</title>

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
</head>
<body>

	<!-- SIDEBAR -->
	<c:set var="page" value="properties" scope="request" />
	<jsp:include page="/WEB-INF/includes/admin-sidebar.jsp" />

	<!-- MAIN CONTENT -->
	<main class="main-content">
		<jsp:include page="/WEB-INF/includes/topbar.jsp" />

		<div class="dashboard-container">
			<!-- Header -->
			<div class="page-header">
				<div>
					<div class="section-badge">Property Management</div>
					<h2 class="page-title">Properties</h2>
					<p class="page-subtitle">View all property listings across your
						estate platform. (Read-only)</p>
				</div>
			</div>

			<!-- Filter Bar -->
			<div class="filter-bar">
				<div class="filter-input-wrapper">
					<span class="material-symbols-outlined">search</span> <input
						type="text" class="filter-input" id="searchInput"
						placeholder="Search by title, city, or landlord...">
				</div>
				<div class="flex" style="gap: 0.5rem;">
					<select id="statusFilter" class="filter-input"
						style="width: 140px;">
						<option value="all">All Status</option>
						<option value="available">Available</option>
						<option value="rented">Rented</option>
						<option value="maintenance">Maintenance</option>
					</select>
				</div>
			</div>

			<!-- Properties Table -->
			<div class="dashboard-card">
				<div class="table-responsive">
					<table class="data-table">
						<thead>
							<tr>
								<th data-sort="display_id">Property ID</th>
								<th data-sort="title">Title</th>
								<th data-sort="landlord_name">Landlord</th>
								<th data-sort="city">City</th>
								<th data-sort="monthly_rent">Rent</th>
								<th data-sort="bedrooms">Beds</th>
								<th data-sort="property_type">Type</th>
								<th data-sort="status">Status</th>
								<th data-sort="created_at">Listed On</th>
								<th style="text-align: center;">Details</th>
							</tr>
						</thead>
						<tbody>
							<!-- Data loaded dynamically by JavaScript -->
						</tbody>
					</table>
				</div>

				<!-- Pagination -->
				<div class="pagination">
					<p class="text-muted" style="font-size: 0.75rem;">Loading
						properties...</p>
					<div class="flex items-center" style="gap: 0.25rem;">
						<button class="pagination-btn" disabled>
							<span class="material-symbols-outlined">chevron_left</span>
						</button>
						<button class="page-number active">1</button>
						<button class="pagination-btn">
							<span class="material-symbols-outlined">chevron_right</span>
						</button>
					</div>
				</div>
			</div>
		</div>
	</main>

	<script>
		window.contextPath = "${pageContext.request.contextPath}";
	</script>
	<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/common/navigation.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/properties.js"></script>
</body>
</html>