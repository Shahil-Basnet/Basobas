<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en" data-context-path="${pageContext.request.contextPath}">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Landlord Dashboard | Basobas</title>

<!-- Google Fonts -->
<link
	href="https://fonts.googleapis.com/css2?family=Inter:opsz,wght@14..32,300;400;500;600;700&family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap"
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
/* Landlord Dashboard Specific Styles */

/* Welcome Section */
.welcome-section {
	display: flex;
	flex-wrap: wrap;
	justify-content: space-between;
	align-items: flex-end;
	margin-bottom: 2rem;
	gap: 1rem;
}

.welcome-section h2 {
	font-size: 1.8rem;
	font-weight: 700;
	color: var(--on-surface);
	margin-bottom: 0.25rem;
}

.welcome-date {
	color: var(--on-surface-variant);
	font-size: 0.875rem;
}

.pending-count {
	color: var(--primary);
	font-weight: 700;
}

.status-badge {
	display: flex;
	align-items: center;
	gap: 0.5rem;
	padding: 0.5rem 1rem;
	background: var(--surface-container-low);
	border-radius: 2rem;
	font-size: 0.75rem;
	font-weight: 500;
	color: var(--on-surface-variant);
}

.status-dot {
	width: 8px;
	height: 8px;
	background: var(--secondary);
	border-radius: 50%;
}

/* Stats Cards with flex row */
.stat-card-row {
	display: flex;
	align-items: center;
	gap: 1rem;
}

.stat-card-row .stat-icon {
	margin-bottom: 0;
	width: 48px;
	height: 48px;
}

.stat-card-row .stat-number {
	font-size: 1.8rem;
	font-weight: 800;
	line-height: 1.2;
}

.stat-subtitle {
	font-size: 0.65rem;
	color: var(--on-surface-variant);
	margin-top: 0.25rem;
}

/* Two Column Layout */
.two-column-layout {
	display: grid;
	grid-template-columns: 1fr 1fr;
	gap: 1.5rem;
	margin-bottom: 2rem;
}

@media ( max-width : 768px) {
	.two-column-layout {
		grid-template-columns: 1fr;
	}
}

/* Section Headers */
.section-header {
	display: flex;
	justify-content: space-between;
	align-items: center;
	margin-bottom: 1rem;
}

.section-header h3 {
	font-size: 1.2rem;
	font-weight: 700;
	color: var(--on-surface);
}

.view-all-link {
	font-size: 0.8rem;
	font-weight: 600;
	color: var(--primary);
	text-decoration: none;
}

.view-all-link:hover {
	text-decoration: underline;
}

/* Badge Statuses */
.badge-status {
	display: inline-block;
	padding: 0.25rem 0.75rem;
	border-radius: 2rem;
	font-size: 0.65rem;
	font-weight: 700;
	text-transform: uppercase;
}

.badge-pending {
	background: var(--secondary-container);
	color: var(--on-secondary-container);
}

.badge-approved {
	background: var(--primary-container);
	color: var(--on-primary-container);
}

.badge-due-soon {
	background: #fef3c7;
	color: #b45309;
}

.badge-overdue {
	background: var(--error-container);
	color: var(--on-error-container);
}

/* Action Buttons */
.btn-respond {
	background: var(--primary);
	color: white;
	border: none;
	padding: 0.25rem 0.75rem;
	border-radius: 0.5rem;
	font-size: 0.7rem;
	font-weight: 600;
	cursor: pointer;
}

.btn-respond:hover {
	opacity: 0.8;
}

.btn-view {
	background: var(--surface-container-high);
	color: var(--on-surface-variant);
	border: none;
	padding: 0.25rem 0.75rem;
	border-radius: 0.5rem;
	font-size: 0.7rem;
	font-weight: 600;
	cursor: pointer;
}

.btn-view:hover {
	background: var(--surface-container-highest);
}

/* Quick Actions */
.quick-actions h3 {
	font-size: 1.1rem;
	font-weight: 700;
	margin-bottom: 0.75rem;
	color: var(--on-surface);
}

.actions-grid {
	display: flex;
	flex-direction: column;
	gap: 0.5rem;
}

.action-btn {
	width: 100%;
	padding: 0.65rem 0.875rem;
	border-radius: 0.6rem;
	font-weight: 600;
	font-size: 0.8rem;
	cursor: pointer;
	transition: all 0.2s;
	text-align: left;
	display: flex;
	align-items: center;
	gap: 0.6rem;
	background: var(--surface-container-lowest);
	border: 1px solid var(--outline-variant);
	color: var(--on-surface);
}

.action-btn.primary {
	background: linear-gradient(135deg, var(--primary),
		var(--primary-container));
	color: white;
	border: none;
}

.action-btn.primary:hover {
	opacity: 0.9;
	transform: translateX(4px);
}

.action-btn.secondary:hover {
	background: var(--surface-container-high);
	transform: translateX(2px);
}

/* Reviews */
.reviews-list {
	display: flex;
	flex-direction: column;
	gap: 1rem;
}

.review-card {
	background: var(--surface-container-lowest);
	padding: 1rem;
	border-radius: 0.75rem;
	border: 1px solid var(--outline-variant);
}

.review-header {
	display: flex;
	justify-content: space-between;
	align-items: flex-start;
	margin-bottom: 0.5rem;
}

.stars {
	display: flex;
	gap: 0.125rem;
}

.stars .material-symbols-outlined {
	font-size: 1rem;
}

.stars .filled {
	color: #f59e0b;
	font-variation-settings: 'FILL' 1;
}

.review-text {
	font-size: 0.8rem;
	color: var(--on-surface-variant);
	font-style: italic;
	line-height: 1.4;
}

/* Table overrides */
.data-table td {
	vertical-align: middle;
}

.text-error {
	color: var(--error);
}

.text-primary {
	color: var(--primary);
}

@media ( max-width : 768px) {
	.welcome-section {
		flex-direction: column;
		align-items: flex-start;
	}
	.stats-grid {
		gap: 1rem;
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
				class="nav-link active"> <span class="material-symbols-outlined">dashboard</span>
				<span>Dashboard</span>
			</a> <a href="${pageContext.request.contextPath}/landlord/properties"
				class="nav-link"> <span class="material-symbols-outlined">real_estate_agent</span>
				<span>My Properties</span>
			</a> <a href="${pageContext.request.contextPath}/landlord/add-property"
				class="nav-link"> <span class="material-symbols-outlined">add_business</span>
				<span>Add Property</span>
			</a> <a
				href="${pageContext.request.contextPath}/landlord/rental-requests"
				class="nav-link"> <span class="material-symbols-outlined">pending_actions</span>
				<span>Rental Requests</span>
			</a> <a href="${pageContext.request.contextPath}/landlord/leases"
				class="nav-link"> <span class="material-symbols-outlined">description</span>
				<span>My Leases</span>
			</a> <a href="${pageContext.request.contextPath}/landlord/payments"
				class="nav-link"> <span class="material-symbols-outlined">payments</span>
				<span>Payments</span>
			</a> <a href="${pageContext.request.contextPath}/landlord/reviews"
				class="nav-link"> <span class="material-symbols-outlined">reviews</span>
				<span>Reviews</span>
			</a> <a href="${pageContext.request.contextPath}/landlord/profile"
				class="nav-link"> <span class="material-symbols-outlined">person</span>
				<span>Profile</span>
			</a>
		</div>
		<div class="profile-section">
			<div class="avatar">RS</div>
			<div class="profile-info">
				<p>Ram Sharma</p>
				<span>Verified Landlord</span>
			</div>
		</div>
	</aside>

	<!-- MAIN CONTENT -->
	<main class="main-content">
		<!-- Top Bar -->
		<div class="top-bar">
			<div class="search-wrapper">
				<span class="material-symbols-outlined">search</span> <input
					type="text" placeholder="Search properties or tenants...">
			</div>
			<div class="admin-badge">
				<button class="icon-btn">
					<span class="material-symbols-outlined">notifications_none</span>
				</button>
				<button class="icon-btn">
					<span class="material-symbols-outlined">settings</span>
				</button>
				<div class="admin-name">Landlord</div>
			</div>
		</div>

		<div class="dashboard-container">
			<!-- Welcome Section -->
			<div class="welcome-section">
				<div>
					<h2>Welcome back, Ram Sharma</h2>
					<p class="welcome-date">
						October 24, 2026 • <span class="pending-count">2 pending
							requests</span>
					</p>
				</div>
				<div class="status-badge">
					<span class="status-dot"></span> <span>Status: Active
						Management</span>
				</div>
			</div>

			<!-- Stats Cards -->
			<div class="stats-grid">
				<div class="stat-card stat-card-row">
					<div class="stat-icon">
						<span class="material-symbols-outlined">real_estate_agent</span>
					</div>
					<div>
						<h4>Total Properties</h4>
						<div class="stat-number">4</div>
						<p class="stat-subtitle">Listed properties</p>
					</div>
				</div>
				<div class="stat-card stat-card-row">
					<div class="stat-icon">
						<span class="material-symbols-outlined">contract</span>
					</div>
					<div>
						<h4>Active Leases</h4>
						<div class="stat-number">3</div>
						<p class="stat-subtitle">Current tenants</p>
					</div>
				</div>
				<div class="stat-card stat-card-row">
					<div class="stat-icon">
						<span class="material-symbols-outlined">payments</span>
					</div>
					<div>
						<h4>Monthly Earnings</h4>
						<div class="stat-number">रु 85,000</div>
						<p class="stat-subtitle">This month's rent collected</p>
					</div>
				</div>
				<div class="stat-card stat-card-row">
					<div class="stat-icon">
						<span class="material-symbols-outlined">pending_actions</span>
					</div>
					<div>
						<h4>Pending Requests</h4>
						<div class="stat-number">2</div>
						<p class="stat-subtitle">Awaiting response</p>
					</div>
				</div>
			</div>

			<!-- Middle Section: Recent Requests + Quick Actions -->
			<div class="two-column-layout">
				<!-- Left: Recent Rental Requests -->
				<div class="recent-requests">
					<div class="section-header">
						<h3>Recent Rental Requests</h3>
						<a href="#" class="view-all-link">View All →</a>
					</div>
					<div class="dashboard-card">
						<div class="table-responsive">
							<table class="data-table">
								<thead>
									<tr>
										<th>Property Title</th>
										<th>Tenant Name</th>
										<th>Request Date</th>
										<th>Status</th>
										<th style="text-align: center;">Action</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td class="font-bold">Hattisar Studio Apt</td>
										<td>Sunil Thapa</td>
										<td>Oct 22, 2026</td>
										<td><span class="badge-status badge-pending">Pending</span></td>
										<td style="text-align: center;"><button
												class="btn-respond">Respond</button></td>
									</tr>
									<tr>
										<td class="font-bold">Lazimpat 2BHK</td>
										<td>Maya Shrestha</td>
										<td>Oct 20, 2026</td>
										<td><span class="badge-status badge-pending">Pending</span></td>
										<td style="text-align: center;"><button
												class="btn-respond">Respond</button></td>
									</tr>
									<tr>
										<td class="font-bold">Jhamsikhel Villa</td>
										<td>Pratik Gurung</td>
										<td>Oct 18, 2026</td>
										<td><span class="badge-status badge-approved">Approved</span></td>
										<td style="text-align: center;"><button class="btn-view">View</button></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<!-- Right: Quick Actions -->
				<div class="quick-actions">
					<h3>Quick Actions</h3>
					<div class="actions-grid">
						<button class="action-btn primary">
							<span class="material-symbols-outlined">add_business</span> Add
							New Property
						</button>
						<button class="action-btn secondary">
							<span class="material-symbols-outlined">add_a_photo</span> Manage
							Photos
						</button>
						<button class="action-btn secondary">
							<span class="material-symbols-outlined">list_alt</span> View
							Rental Requests
						</button>
						<button class="action-btn secondary">
							<span class="material-symbols-outlined">receipt_long</span>
							Record Payment
						</button>
						<button class="action-btn secondary">
							<span class="material-symbols-outlined">settings</span> Manage
							Properties
						</button>
					</div>
				</div>
			</div>

			<!-- Bottom Section: Upcoming Payments + Reviews -->
			<div class="two-column-layout">
				<!-- Upcoming Payments -->
				<div class="upcoming-payments">
					<div class="section-header">
						<h3>Upcoming Payments (Next 30 Days)</h3>
						<a href="#" class="view-all-link">View All →</a>
					</div>
					<div class="dashboard-card">
						<div class="table-responsive">
							<table class="data-table">
								<thead>
									<tr>
										<th>Property</th>
										<th>Due Date</th>
										<th>Amount</th>
										<th>Status</th>
									</tr>
								</thead>
								<tbody>
									<tr>
										<td>
											<div class="font-bold">Lazimpat 2BHK</div>
											<div class="text-muted" style="font-size: 0.7rem;">Tenant:
												Maya Shrestha</div>
										</td>
										<td>Nov 01, 2026</td>
										<td class="text-primary font-bold">रु 25,000</td>
										<td><span class="badge-status badge-due-soon">Due
												Soon</span></td>
									</tr>
									<tr>
										<td>
											<div class="font-bold">Hattisar Studio</div>
											<div
												style="font-size: 0.7rem; color: var(--on-surface-variant);">Tenant:
												Sunil Thapa</div>
										</td>
										<td>Oct 28, 2026</td>
										<td class="text-error font-bold">रु 15,000</td>
										<td><span class="badge-status badge-overdue">Overdue</span></td>
									</tr>
									<tr>
										<td>
											<div class="font-bold">Jhamsikhel Villa</div>
											<div
												style="font-size: 0.7rem; color: var(--on-surface-variant);">Tenant:
												Pratik Gurung</div>
										</td>
										<td>Nov 15, 2026</td>
										<td class="text-primary font-bold">रु 45,000</td>
										<td><span class="badge-status"
											style="background: var(--surface-container-high); color: var(--on-surface-variant);">Upcoming</span></td>
									</tr>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<!-- Recent Reviews -->
				<div class="recent-reviews">
					<div class="section-header">
						<h3>Recent Tenant Reviews</h3>
						<a href="#" class="view-all-link">View All →</a>
					</div>
					<div class="reviews-list">
						<div class="review-card">
							<div class="review-header">
								<div>
									<div class="font-bold">Pratik Gurung</div>
									<div class="text-muted" style="font-size: 0.7rem;">Jhamsikhel
										Villa</div>
								</div>
								<div class="stars">
									<span class="material-symbols-outlined filled">star</span> <span
										class="material-symbols-outlined filled">star</span> <span
										class="material-symbols-outlined filled">star</span> <span
										class="material-symbols-outlined filled">star</span> <span
										class="material-symbols-outlined filled">star</span>
								</div>
							</div>
							<p class="review-text">"Ram is an excellent landlord. Any
								maintenance issues are addressed within 24 hours. Highly
								recommend his properties."</p>
						</div>
						<div class="review-card">
							<div class="review-header">
								<div>
									<div class="font-bold">Sunil Thapa</div>
									<div class="text-muted" style="font-size: 0.7rem;">Hattisar
										Studio</div>
								</div>
								<div class="stars">
									<span class="material-symbols-outlined filled">star</span> <span
										class="material-symbols-outlined filled">star</span> <span
										class="material-symbols-outlined filled">star</span> <span
										class="material-symbols-outlined filled">star</span> <span
										class="material-symbols-outlined">star</span>
								</div>
							</div>
							<p class="review-text">"Great location and well-maintained.
								The move-in process was very smooth and professional."</p>
						</div>
					</div>
				</div>
			</div>
		</div>
	</main>

	<!-- FAB Button -->
	<button class="fab">
		<span class="material-symbols-outlined">add</span>
	</button>

	<!-- Scripts -->
	<script>
		window.contextPath = '${pageContext.request.contextPath}';
		console.log('Context path set:', window.contextPath);
	</script>
	<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>

</body>
</html>