<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>My Properties | Basobas</title>

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
/* Sorting indicators */
th[data-sort] {
	cursor: pointer;
	user-select: none;
	transition: background 0.2s;
}

th[data-sort]:hover {
	background: var(--surface-container-high);
}

.sort-indicator {
	display: inline-flex;
	align-items: center;
	margin-left: 0.5rem;
	font-size: 0.75rem;
	vertical-align: middle;
}

.sort-indicator .material-symbols-outlined {
	font-size: 1rem;
	transition: color 0.2s;
}

th[data-sort].sort-asc .sort-indicator .material-symbols-outlined {
	color: var(--primary);
}

th[data-sort].sort-desc .sort-indicator .material-symbols-outlined {
	color: var(--primary);
}

th[data-sort] .sort-indicator .material-symbols-outlined {
	color: var(--outline);
	opacity: 0.5;
}

/* Status badges */
.badge-status {
	font-size: 0.6875rem;
	font-weight: 700;
	padding: 0.25rem 0.75rem;
	border-radius: 9999px;
	text-transform: uppercase;
	letter-spacing: 0.5px;
	display: inline-block;
}

.status-available {
	background: var(--secondary-container);
	color: var(--on-secondary-container);
}

.status-rented {
	background: var(--surface-container-highest);
	color: var(--on-surface-variant);
}

/* Stats cards */
.stat-card {
	cursor: default;
}

.stat-card .stat-icon {
	background: #eef2fa;
}

.stat-card .stat-icon .material-symbols-outlined {
	color: var(--primary);
}

/* Action buttons */
.action-btn {
	background: none;
	border: none;
	padding: 0.5rem;
	border-radius: 0.5rem;
	cursor: pointer;
	transition: background 0.2s;
	display: inline-flex;
	align-items: center;
	justify-content: center;
}

.action-edit {
	color: var(--tertiary);
}

.action-edit:hover {
	background: rgba(100, 64, 25, 0.1);
}

.action-delete {
	color: var(--error);
}

.action-delete:hover {
	background: rgba(186, 26, 26, 0.1);
}

.action-view {
	color: var(--primary);
}

.action-view:hover {
	background: rgba(51, 79, 43, 0.1);
}

/* Filter bar */
.filter-bar {
	display: flex;
	flex-wrap: wrap;
	gap: 1rem;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 1.5rem;
}

.filter-controls {
	display: flex;
	gap: 0.5rem;
	align-items: center;
}

.filter-input-wrapper {
	flex: 1;
	min-width: 250px;
}

/* Bulk actions */
.bulk-actions {
	padding: 0.75rem 1.5rem;
	background: var(--surface-container-low);
	border-bottom: 1px solid var(--outline-variant);
	display: none;
	align-items: center;
	justify-content: space-between;
}

.bulk-actions.active {
	display: flex;
}

.bulk-delete-btn {
	background: var(--error);
	color: white;
	border: none;
	padding: 0.5rem 1rem;
	border-radius: 0.5rem;
	font-size: 0.75rem;
	font-weight: 600;
	cursor: pointer;
	display: flex;
	align-items: center;
	gap: 0.5rem;
}

/* Empty state */
.empty-properties {
	text-align: center;
	padding: 4rem 2rem;
}

.empty-properties .material-symbols-outlined {
	font-size: 4rem;
	color: var(--outline);
	margin-bottom: 1rem;
}

.empty-properties h3 {
	font-size: 1.25rem;
	font-weight: 700;
	margin-bottom: 0.5rem;
}

.empty-properties p {
	color: var(--on-surface-variant);
	margin-bottom: 1.5rem;
}

/* Loading spinner */
.loading-spinner {
	display: inline-block;
	width: 2rem;
	height: 2rem;
	border: 3px solid var(--outline-variant);
	border-top-color: var(--primary);
	border-radius: 50%;
	animation: spin 0.8s linear infinite;
}

@
keyframes spin {to { transform:rotate(360deg);
	
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
				class="nav-link active"> <span class="material-symbols-outlined">real_estate_agent</span>
				<span>My Properties</span>
			</a> <a
				href="${pageContext.request.contextPath}/landlord/properties?action=add"
				class="nav-link"> <span class="material-symbols-outlined">add_business</span>
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
			<!-- Alert Messages -->
			<c:if test="${not empty sessionScope.message}">
				<div class="error-alert"
					style="margin-bottom: 1.5rem; background: ${sessionScope.messageType == 'success' ? 'rgba(51, 79, 43, 0.1)' : 'rgba(186, 26, 26, 0.1)'}; border-left-color: ${sessionScope.messageType == 'success' ? 'var(--primary)' : 'var(--error)'};">
					<span class="material-symbols-outlined error-icon"
						style="color: ${sessionScope.messageType == 'success' ? 'var(--primary)' : 'var(--error)'};">
						${sessionScope.messageType == 'success' ? 'check_circle' : 'error'}
					</span>
					<div class="error-text"
						style="color: ${sessionScope.messageType == 'success' ? 'var(--primary)' : 'var(--on-error-container)'};">${sessionScope.message}</div>
				</div>
				<c:remove var="message" scope="session" />
				<c:remove var="messageType" scope="session" />
			</c:if>

			<!-- Header -->
			<div class="page-header">
				<div>
					<div class="section-badge">Property Management</div>
					<h2 class="page-title">My Properties</h2>
					<p class="page-subtitle">Manage your rental properties, update
						listings, and track occupancy status.</p>
				</div>
				<a
					href="${pageContext.request.contextPath}/landlord/properties?action=add"
					class="create-user-btn" style="text-decoration: none;"> <span
					class="material-symbols-outlined" style="font-size: 1.25rem;">add_business</span>
					Add New Property
				</a>
			</div>

			<!-- Property Metrics Cards -->
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">inventory_2</span>
					</div>
					<h4>Total Properties</h4>
					<div class="stat-number" id="totalCount">0</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">home</span>
						Active Listings
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">task_alt</span>
					</div>
					<h4>Available</h4>
					<div class="stat-number" id="availableCount">0</div>
					<div class="stat-trend" style="color: var(--secondary);">
						<span class="material-symbols-outlined" style="font-size: 1rem;">check_circle</span>
						Ready to Rent
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon">
						<span class="material-symbols-outlined">key</span>
					</div>
					<h4>Rented</h4>
					<div class="stat-number" id="rentedCount">0</div>
					<div class="stat-trend" style="color: var(--tertiary);">
						<span class="material-symbols-outlined" style="font-size: 1rem;">home_work</span>
						Occupied
					</div>
				</div>
			</div>

			<!-- Filter Bar -->
			<div class="filter-bar">
				<div class="filter-input-wrapper">
					<span class="material-symbols-outlined">search</span> <input
						type="text" class="filter-input" id="searchInput"
						placeholder="Search by title, city, or ID...">
				</div>
				<div class="filter-controls">
					<select id="statusFilter" class="filter-input"
						style="width: 140px;">
						<option value="all">All Status</option>
						<option value="available">Available</option>
						<option value="rented">Rented</option>
					</select>
					<button id="resetFiltersBtn" class="filter-btn"
						style="background: transparent; border: 1px solid var(--outline-variant);">
						<span class="material-symbols-outlined">refresh</span> Reset
					</button>
				</div>
			</div>

			<!-- Properties Table -->
			<div class="dashboard-card">
				<div class="bulk-actions" id="bulkActions">
					<span>Selected <strong id="selectedCount">0</strong>
						properties
					</span>
					<button id="bulkDeleteBtn" class="bulk-delete-btn">
						<span class="material-symbols-outlined" style="font-size: 1rem;">delete</span>
						Delete Selected
					</button>
				</div>
				<div class="table-responsive">
					<table class="data-table">
						<thead>
							<tr>
								<th style="width: 40px;"><input type="checkbox"
									id="selectAllCheckbox"></th>
								<th data-sort="display_id">Property ID</th>
								<th data-sort="title">Title</th>
								<th data-sort="city">Location</th>
								<th data-sort="monthly_rent">Rent (NPR)</th>
								<th data-sort="bedrooms">Beds/Baths</th>
								<th data-sort="property_type">Type</th>
								<th data-sort="status">Status</th>
								<th data-sort="created_at">Listed On</th>
								<th style="text-align: center;">Actions</th>
							</tr>
						</thead>
						<tbody id="propertiesTableBody">
							<tr>
								<td colspan="10" style="text-align: center; padding: 3rem;">
									<div class="loading-spinner"></div>
									<div style="margin-top: 1rem;">Loading properties...</div>
								</td>
							</tr>
						</tbody>
					</table>
				</div>

				<!-- Pagination -->
				<div class="pagination">
					<p class="text-muted" style="font-size: 0.75rem;"
						id="paginationInfo">Loading...</p>
					<div class="flex items-center" style="gap: 0.25rem;"
						id="paginationControls"></div>
				</div>
			</div>
		</div>
	</main>

	<!-- Delete Confirmation Modal -->
	<div id="deleteModal" class="modal" style="display: none;">
		<div class="modal-content">
			<div class="modal-header">
				<h3>Delete Property</h3>
				<button class="modal-close" onclick="closeDeleteModal()">&times;</button>
			</div>
			<div class="modal-body">
				<p>
					Are you sure you want to delete <strong id="deletePropertyTitle"></strong>?
				</p>
				<p style="color: var(--error); margin-top: 0.5rem;">This action
					cannot be undone. All photos and associated data will be
					permanently removed.</p>
			</div>
			<div class="modal-footer">
				<button type="button" class="btn-secondary"
					onclick="closeDeleteModal()">Cancel</button>
				<button type="button" class="btn-primary" id="confirmDeleteBtn"
					style="background: var(--error);">Delete Property</button>
			</div>
		</div>
	</div>

	<!-- Scripts -->
	<script>
		window.contextPath = '${pageContext.request.contextPath}';
		console.log('Context path set:', window.contextPath);
	</script>
	<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
	<script
		src="${pageContext.request.contextPath}/js/landlord/landlord-properties.js"></script>
</body>
</html>