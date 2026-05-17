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
	background: #fef3c7;
	color: #d97706;
}

.badge-approved {
	background: #d1fae5;
	color: #059669;
}

.badge-rejected {
	background: #fee2e2;
	color: #dc2626;
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
	text-decoration: none;
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

/* Table overrides */
.data-table td {
	vertical-align: middle;
	padding: 0.75rem 1rem;
}

.font-bold {
	font-weight: 700;
}

.text-muted {
	color: var(--on-surface-variant);
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
	<c:set var="page" value="dashboard" scope="request" />
	<jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />

	<!-- MAIN CONTENT -->
	<main class="main-content">
		<!-- Top Bar -->
		<jsp:include page="/WEB-INF/includes/topbar.jsp" />

		<div class="dashboard-container">
			<!-- Welcome Section -->
			<div class="welcome-section">
				<div>
					<h2>Welcome back, ${fn:escapeXml(landlordName)}</h2>
					<p class="welcome-date">
						${currentDate} • <span class="pending-count">${pendingRequestsCount}
							pending requests</span>
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
						<div class="stat-number">${totalProperties}</div>
						<p class="stat-subtitle">Listed properties</p>
					</div>
				</div>
				<div class="stat-card stat-card-row">
					<div class="stat-icon">
						<span class="material-symbols-outlined">contract</span>
					</div>
					<div>
						<h4>Active Leases</h4>
						<div class="stat-number">${activeLeases}</div>
						<p class="stat-subtitle">Current tenants</p>
					</div>
				</div>
				<div class="stat-card stat-card-row">
					<div class="stat-icon">
						<span class="material-symbols-outlined">payments</span>
					</div>
					<div>
						<h4>Monthly Earnings</h4>
						<div class="stat-number">
							रु
							<fmt:formatNumber value="${monthlyEarnings}" groupingUsed="true" />
						</div>
						<p class="stat-subtitle">This month's rent collected</p>
					</div>
				</div>
				<div class="stat-card stat-card-row">
					<div class="stat-icon">
						<span class="material-symbols-outlined">pending_actions</span>
					</div>
					<div>
						<h4>Pending Requests</h4>
						<div class="stat-number">${pendingRequestsCount}</div>
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
						<a
							href="${pageContext.request.contextPath}/landlord/requests/list"
							class="view-all-link">View All →</a>
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
									<c:forEach var="request" items="${recentRequests}">
										<tr>
											<td class="font-bold">${fn:escapeXml(request.propertyTitle)}</td>
											<td>${fn:escapeXml(request.tenantName)}</td>
											<td>${request.createdAt}</td>
											<td><span class="badge-status badge-pending">Pending</span>
											</td>
											<td style="text-align: center;"><a
												href="${pageContext.request.contextPath}/landlord/requests/list"
												class="btn-respond">Respond</a></td>
										</tr>
									</c:forEach>
									<c:if test="${empty recentRequests}">
										<tr>
											<td colspan="5" style="text-align: center; padding: 2rem;">
												No pending requests</td>
										</tr>
									</c:if>
								</tbody>
							</table>
						</div>
					</div>
				</div>

				<!-- Right: Quick Actions -->
				<div class="quick-actions">
					<h3>Quick Actions</h3>
					<div class="actions-grid">
						<a
							href="${pageContext.request.contextPath}/landlord/properties?action=add"
							class="action-btn primary"> <span
							class="material-symbols-outlined">add_business</span> Add New
							Property
						</a> <a href="${pageContext.request.contextPath}/landlord/properties"
							class="action-btn secondary"> <span
							class="material-symbols-outlined">settings</span> Manage
							Properties
						</a> <a
							href="${pageContext.request.contextPath}/landlord/requests/list"
							class="action-btn secondary"> <span
							class="material-symbols-outlined">list_alt</span> View Rental
							Requests
						</a> <a href="${pageContext.request.contextPath}/landlord/payments"
							class="action-btn secondary"> <span
							class="material-symbols-outlined">receipt_long</span> View
							Payments
						</a>
					</div>
				</div>
			</div>
		</div>
	</main>

	<!-- Scripts -->
	 <script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
</body>
</html>