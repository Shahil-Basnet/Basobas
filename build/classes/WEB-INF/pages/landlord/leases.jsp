<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Active Leases - Landlord Dashboard | Basobas</title>

<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
	rel="stylesheet">

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

	<c:set var="page" value="leases" scope="request" />

	<jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />

	<main class="main-content">
		<jsp:include page="/WEB-INF/includes/topbar.jsp" />

		<div class="dashboard-container">
			<div class="page-header">
				<div>
					<div class="section-badge">LANDLORD PORTAL</div>
					<h1 class="page-title">Active Leases</h1>
					<p class="page-subtitle">Properties currently rented by tenants</p>
				</div>
			</div>

			<c:choose>
				<c:when test="${empty leases}">
					<div class="dashboard-card"
						style="text-align: center; padding: 3rem;">
						<span class="material-symbols-outlined"
							style="font-size: 4rem; color: var(--outline);">description</span>
						<h3>No active leases</h3>
						<p>You don't have any properties that are currently rented.</p>
						<a href="${pageContext.request.contextPath}/landlord/properties"
							class="btn-primary"
							style="display: inline-block; margin-top: 1rem; text-decoration: none;">
							<span class="material-symbols-outlined">real_estate_agent</span>
							View My Properties
						</a>
					</div>
				</c:when>
				<c:otherwise>
					<div class="leases-grid"
						style="display: grid; grid-template-columns: repeat(auto-fill, minmax(380px, 1fr)); gap: 1.5rem;">
						<c:forEach var="lease" items="${leases}">
							<div class="lease-card"
								style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; overflow: hidden;">
								<div
									style="padding: 1rem; background: linear-gradient(135deg, var(--primary), var(--primary-container)); color: white;">
									<div
										style="display: flex; justify-content: space-between; align-items: center;">
										<span style="font-weight: 700; font-family: monospace;">${lease.displayId}</span>
										<span class="status-badge"
											style="background: rgba(255, 255, 255, 0.2); padding: 0.25rem 0.75rem; border-radius: 2rem; font-size: 0.7rem;">
											Active Lease </span>
									</div>
								</div>
								<div style="padding: 1rem;">
									<h3 style="margin-bottom: 0.5rem;">${fn:escapeXml(lease.title)}</h3>
									<div
										style="display: flex; align-items: center; gap: 0.25rem; color: #6b7280; font-size: 0.875rem; margin-bottom: 1rem;">
										<span class="material-symbols-outlined"
											style="font-size: 1rem;">location_on</span> <span>${fn:escapeXml(lease.city)}</span>
										<c:if
											test="${not empty lease.wardNumber and lease.wardNumber > 0}">
											<span>, Ward ${lease.wardNumber}</span>
										</c:if>
									</div>

									<div
										style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.75rem; margin-bottom: 1rem; padding: 0.75rem; background: #f9fafb; border-radius: 0.5rem;">
										<div>
											<div
												style="display: flex; align-items: center; gap: 0.25rem; font-size: 0.7rem; color: #6b7280; margin-bottom: 0.25rem;">
												<span class="material-symbols-outlined"
													style="font-size: 0.8rem;">payments</span> Monthly Rent
											</div>
											<div style="font-weight: 700; color: var(--primary);">
												रू
												<fmt:formatNumber value="${lease.monthlyRent}"
													groupingUsed="true" />
											</div>
										</div>
										<div>
											<div
												style="display: flex; align-items: center; gap: 0.25rem; font-size: 0.7rem; color: #6b7280; margin-bottom: 0.25rem;">
												<span class="material-symbols-outlined"
													style="font-size: 0.8rem;">savings</span> Security Deposit
											</div>
											<div style="font-weight: 500;">
												रू
												<fmt:formatNumber value="${lease.securityDeposit}"
													groupingUsed="true" />
											</div>
										</div>
									</div>

									<div style="margin-bottom: 1rem;">
										<div
											style="display: flex; align-items: center; gap: 0.25rem; font-size: 0.75rem; font-weight: 600; margin-bottom: 0.5rem;">
											<span class="material-symbols-outlined"
												style="font-size: 0.9rem;">info</span> Property Details
										</div>
										<div
											style="display: flex; flex-wrap: wrap; gap: 1rem; font-size: 0.8rem;">
											<span
												style="display: flex; align-items: center; gap: 0.25rem;">
												<span class="material-symbols-outlined"
												style="font-size: 0.9rem;">bed</span> ${lease.bedrooms}
												Bed${lease.bedrooms != 1 ? 's' : ''}
											</span> <span
												style="display: flex; align-items: center; gap: 0.25rem;">
												<span class="material-symbols-outlined"
												style="font-size: 0.9rem;">bathtub</span> ${lease.bathrooms}
												Bath${lease.bathrooms != 1 ? 's' : ''}
											</span>
											<c:if
												test="${lease.powerBackupHours != null and lease.powerBackupHours > 0}">
												<span
													style="display: flex; align-items: center; gap: 0.25rem;">
													<span class="material-symbols-outlined"
													style="font-size: 0.9rem;">bolt</span>
													${lease.powerBackupHours}h Backup
												</span>
											</c:if>
										</div>
									</div>

									<div
										style="margin-bottom: 1rem; padding-top: 0.5rem; border-top: 1px solid #e5e7eb;">
										<div
											style="display: flex; align-items: center; gap: 0.25rem; font-size: 0.75rem; font-weight: 600; margin-bottom: 0.5rem;">
											<span class="material-symbols-outlined"
												style="font-size: 0.9rem;">person</span> Tenant Info
										</div>
										<div style="display: flex; align-items: center; gap: 0.5rem;">
											<div
												style="width: 32px; height: 32px; background: var(--surface-container-high); border-radius: 50%; display: flex; align-items: center; justify-content: center;">
												<span class="material-symbols-outlined"
													style="font-size: 1rem; color: #6b7280;">person</span>
											</div>
											<div>
												<div style="font-weight: 500;">Tenant Assigned</div>
												<div
													style="font-size: 0.7rem; color: #6b7280; display: flex; align-items: center; gap: 0.25rem;">
													<span class="material-symbols-outlined"
														style="font-size: 0.7rem;">info</span> Contact info
													available after lease start
												</div>
											</div>
										</div>
									</div>

									<div style="display: flex; gap: 0.5rem;">
										<a
											href="${pageContext.request.contextPath}/landlord/property-view?id=${lease.displayId}"
											class="btn-outline"
											style="flex: 1; text-align: center; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 0.25rem;">
											<span class="material-symbols-outlined"
											style="font-size: 1rem;">visibility</span> View Details
										</a> <a
											href="${pageContext.request.contextPath}/landlord/payments?propertyId=${lease.propertyId}"
											class="btn-primary"
											style="flex: 1; text-align: center; text-decoration: none; display: inline-flex; align-items: center; justify-content: center; gap: 0.25rem;">
											<span class="material-symbols-outlined"
											style="font-size: 1rem;">payments</span> View Payments
										</a>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>

	<style>
.btn-outline {
	background: transparent;
	border: 1px solid var(--primary);
	color: var(--primary);
	padding: 0.625rem 1.25rem;
	border-radius: 0.5rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s;
}

.btn-outline:hover {
	background: rgba(51, 79, 43, 0.05);
}

.btn-primary {
	background: linear-gradient(135deg, var(--primary),
		var(--primary-container));
	color: white;
	padding: 0.625rem 1.25rem;
	border-radius: 0.5rem;
	font-weight: 600;
	border: none;
	cursor: pointer;
	transition: opacity 0.2s;
}

.btn-primary:hover {
	opacity: 0.9;
}

.section-badge {
	font-size: 0.75rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.05em;
	color: var(--primary);
	margin-bottom: 0.5rem;
}
</style>

</body>
<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
</html>