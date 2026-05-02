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
			<!-- Header -->
			<div class="page-header">
				<div>
					<div class="section-badge">Administration</div>
					<h2 class="page-title">Users Management</h2>
					<p class="page-subtitle">Oversee and manage your estate's
						platform users, roles, and security protocols through this central
						directory.</p>
				</div>
				<button class="create-user-btn">
					<span class="material-symbols-outlined" style="font-size: 1.25rem;">person_add</span>
					Create New User
				</button>
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
								<th data-sort="user_id">User ID</th>
								<th data-sort="full_name">Full Name</th>
								<th data-sort="username">Username</th>
								<th data-sort="email">Email</th>
								<th data-sort="role">Role</th>
								<th data-sort="phone">Phone</th>
								<th data-sort="registered_at">Registered On</th>
								<th data-sort="last_logged_in">Last Login</th>
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

	<script>
		window.contextPath = '${pageContext.request.contextPath}';
		console.log('Context path set:', window.contextPath);
	</script>
	<script src="${pageContext.request.contextPath}/js/admin-users.js"></script>

</body>
</html>