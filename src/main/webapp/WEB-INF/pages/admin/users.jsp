<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>User Management | Basobas</title>

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

/* Active sort column */
th[data-sort].sort-asc .sort-indicator .material-symbols-outlined {
	color: var(--primary);
}

th[data-sort].sort-desc .sort-indicator .material-symbols-outlined {
	color: var(--primary);
}

/* Inactive sort column */
th[data-sort] .sort-indicator .material-symbols-outlined {
	color: var(--outline);
	opacity: 0.5;
}

th[data-sort]:hover .sort-indicator .material-symbols-outlined {
	opacity: 1;
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
			<a href="${pageContext.request.contextPath}/admin/dashboard"
				class="nav-link"> <span class="material-symbols-outlined">dashboard</span>
				<span>Dashboard</span>
			</a> <a href="${pageContext.request.contextPath}/admin/users"
				class="nav-link active"> <span class="material-symbols-outlined">group</span>
				<span>Users</span>
			</a> <a href="${pageContext.request.contextPath}/admin/properties"
				class="nav-link"> <span class="material-symbols-outlined">real_estate_agent</span>
				<span>Properties</span>
			</a> <a href="${pageContext.request.contextPath}/admin/rental-requests"
				class="nav-link"> <span class="material-symbols-outlined">key</span>
				<span>Rental Requests</span>
			</a> <a href="${pageContext.request.contextPath}/admin/payments"
				class="nav-link"> <span class="material-symbols-outlined">payments</span>
				<span>Payments</span>
			</a> <a href="${pageContext.request.contextPath}/admin/maintenance"
				class="nav-link"> <span class="material-symbols-outlined">build</span>
				<span>Maintenance</span>
			</a> <a href="#" class="nav-link"> <span
				class="material-symbols-outlined">assessment</span> <span>Reports</span>
			</a>
		</div>
		<div class="profile-section">
			<div class="avatar">AV</div>
			<div class="profile-info">
				<p>Alexander Vance</p>
				<span>Chief Administrator</span>
			</div>
		</div>
	</aside>

	<!-- MAIN CONTENT -->
	<main class="main-content">
		<div class="top-bar">
			<div class="search-wrapper">
				<span class="material-symbols-outlined">search</span> <input
					type="text" placeholder="Search system-wide...">
			</div>
			<div class="admin-badge">
				<button class="icon-btn">
					<span class="material-symbols-outlined">notifications_none</span>
				</button>
				<button class="icon-btn">
					<span class="material-symbols-outlined">settings</span>
				</button>
				<div class="admin-name">Admin</div>
			</div>
		</div>

		<div class="dashboard-container">
			<!-- Alert Messages -->
			<c:if test="${not empty sessionScope.message}">
				<div class="alert alert-${sessionScope.messageType != null ? sessionScope.messageType : 'success'}">
					<span class="material-symbols-outlined">
						${sessionScope.messageType == 'error' ? 'error' : 'check_circle'}
					</span>
					<div>${sessionScope.message}</div>
				</div>
				<%-- Clear the message after displaying it --%>
				<c:remove var="message" scope="session" />
				<c:remove var="messageType" scope="session" />
			</c:if>

			<!-- Header -->
			<div class="page-header">
				<div>
					<div class="section-badge">Administration</div>
					<h2 class="page-title">User Management</h2>
					<p class="page-subtitle">Oversee and manage your estate's
						platform users, roles, and security protocols through this central
						directory.</p>
				</div>
				<button class="create-user-btn" onclick="openCreateUserModal()">
					<span class="material-symbols-outlined" style="font-size: 1.25rem;">person_add</span>
					Create New User
				</button>
			</div>

			<!-- User Metrics Cards -->
			<div class="stats-grid">
				<div class="stat-card">
					<div class="stat-icon" style="background: #eef2fa;">
						<span class="material-symbols-outlined" style="color: #4a627a;">admin_panel_settings</span>
					</div>
					<h4>Total Admins</h4>
					<div class="stat-number">${adminCount}</div>
					<div class="stat-trend">
						<span class="material-symbols-outlined" style="font-size: 1rem;">info</span>
						System Administrators
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon" style="background: #fff8f0;">
						<span class="material-symbols-outlined" style="color: #b45309;">real_estate_agent</span>
					</div>
					<h4>Total Landlords</h4>
					<div class="stat-number">${landlordCount}</div>
					<div class="stat-trend" style="color: #b45309;">
						<span class="material-symbols-outlined" style="font-size: 1rem;">info</span>
						Property Owners
					</div>
				</div>
				<div class="stat-card">
					<div class="stat-icon" style="background: #f0fdf4;">
						<span class="material-symbols-outlined" style="color: #166534;">group</span>
					</div>
					<h4>Total Tenants</h4>
					<div class="stat-number">${tenantCount}</div>
					<div class="stat-trend" style="color: #166534;">
						<span class="material-symbols-outlined" style="font-size: 1rem;">info</span>
						Active Renters
					</div>
				</div>
			</div>

			<!-- Filter Bar -->
			<div class="filter-bar">
				<div class="filter-input-wrapper">
					<span class="material-symbols-outlined">search</span> <input
						type="text" class="filter-input" id="searchInput"
						placeholder="Search by name, email, or role...">
				</div>
				<div class="flex" style="gap: 0.5rem;">
					<select id="roleFilter" class="filter-input"
						style="appearance: auto;">
						<option value="all">Role: All</option>
						<option value="tenant">Tenant</option>
						<option value="landlord">Landlord</option>
						<option value="admin">Admin</option>
					</select>
				</div>
			</div>

			<!-- User Table -->
			<div class="dashboard-card">
				<div class="bulk-actions"
					style="display: none; margin-bottom: 1rem;">
					<button id="bulkDeleteBtn" class="btn-reject"
						style="background: #dc3545; color: white; border-color: #dc3545; font-family: 'Manrope', sans-serif; font-weight: 500;">
						<span class="material-symbols-outlined" style="font-size: 0.7rem;">delete</span>
						Delete Selected
					</button>
				</div>
				<div class="table-responsive">
					<table class="data-table">
						<thead>
							<tr>
								<th></th>
								<th data-sort="user_id" id="sort-user_id">User ID <span
									class="sort-indicator"> <span
										class="material-symbols-outlined">unfold_more</span>
								</span>
								</th>
								<th data-sort="full_name" id="sort-full_name">Full Name <span
									class="sort-indicator"> <span
										class="material-symbols-outlined">unfold_more</span>
								</span>
								</th>
								<th data-sort="username" id="sort-username">Username <span
									class="sort-indicator"> <span
										class="material-symbols-outlined">unfold_more</span>
								</span>
								</th>
								<th data-sort="email" id="sort-email">Email <span
									class="sort-indicator"> <span
										class="material-symbols-outlined">unfold_more</span>
								</span>
								</th>
								<th data-sort="role" id="sort-role">Role <span
									class="sort-indicator"> <span
										class="material-symbols-outlined">unfold_more</span>
								</span>
								</th>
								<th data-sort="phone" id="sort-phone">Phone <span
									class="sort-indicator"> <span
										class="material-symbols-outlined">unfold_more</span>
								</span>
								</th>
								<th data-sort="registered_at" id="sort-registered_at">
									Registered On <span class="sort-indicator"> <span
										class="material-symbols-outlined">unfold_more</span>
								</span>
								</th>
								<th data-sort="last_logged_in" id="sort-last_logged_in">
									Last Login <span class="sort-indicator"> <span
										class="material-symbols-outlined">unfold_more</span>
								</span>
								</th>
								<th style="text-align: center;">Actions</th>
							</tr>
						</thead>
						<tbody>
							<!-- Data will be loaded dynamically -->
						</tbody>
					</table>
				</div>

				<!-- Pagination -->
				<div class="pagination">
					<p class="text-muted" style="font-size: 0.75rem;">
						Showing <strong>${fn:length(userList)}</strong> users
					</p>
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

	<button class="fab">
		<span class="material-symbols-outlined">add</span>
	</button>

	<!-- Create User Modal -->
	<div id="createUserModal" class="modal" style="display: none;">
		<div class="modal-content">
			<div class="modal-header">
				<h3>Create New User</h3>
				<button class="modal-close" onclick="closeCreateUserModal()">&times;</button>
			</div>
			<form id="createUserForm">
				<div class="modal-body">
					<div class="form-row">
						<div class="form-group">
							<label>Full Name *</label> 
							<input type="text" id="fullName" class="estate-input" required>
						</div>
						<div class="form-group">
							<label>Username *</label> 
							<input type="text" id="username" class="estate-input" required>
						</div>
					</div>
					<div class="form-row">
						<div class="form-group">
							<label>Email *</label> 
							<input type="email" id="email" class="estate-input" required>
						</div>
						<div class="form-group">
							<label>Phone</label> 
							<input type="tel" id="phone" class="estate-input">
						</div>
					</div>
					<div class="form-row">
						<div class="form-group">
							<label>Role *</label> 
							<select id="role" class="estate-input" required>
								<option value="tenant">Tenant</option>
								<option value="landlord">Landlord</option>
								<option value="admin">Admin</option>
							</select>
						</div>
						<div class="form-group">
							<label>Date of Birth</label> 
							<input type="date" id="dateOfBirth" class="estate-input">
						</div>
					</div>
					<div class="form-group">
						<label>Address</label>
						<textarea id="address" class="estate-input" rows="2"></textarea>
					</div>
					<div class="form-row">
						<div class="form-group">
							<label>Password *</label> 
							<input type="password" id="password" class="estate-input" required>
						</div>
						<div class="form-group">
							<label>Confirm Password *</label> 
							<input type="password" id="confirmPassword" class="estate-input" required>
						</div>
					</div>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn-secondary" onclick="closeCreateUserModal()">Cancel</button>
					<button type="submit" class="btn-primary">Create User</button>
				</div>
			</form>
		</div>
	</div>

	<!-- Scripts -->
	<script>
		window.contextPath = '${pageContext.request.contextPath}';
		console.log('Context path set:', window.contextPath);
	</script>
	<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
	<script src="${pageContext.request.contextPath}/js/admin/users.js"></script>

</body>
</html>