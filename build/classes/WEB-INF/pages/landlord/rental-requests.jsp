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
<title>Rental Requests - Landlord Dashboard | Basobas</title>

<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/dashboard.css">
</head>
<body>

	<!-- SIDEBAR -->
	<c:set var="page" value="requests" scope="request" />
	<jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />

	<!-- MAIN CONTENT -->
	<div class="main-content">
		<jsp:include page="/WEB-INF/includes/topbar.jsp" />

		<div class="dashboard-container">
			<div class="page-header">
				<div>
					<div class="section-badge">LANDLORD PORTAL</div>
					<h1 class="page-title">Rental Requests</h1>
					<p class="page-subtitle">Review and respond to tenant requests
						for your properties</p>
				</div>
				<div class="filter-tabs" style="display: flex; gap: 0.5rem;">
					<a href="${pageContext.request.contextPath}/landlord/requests/list"
						class="btn-filter ${page == 'requests' ? 'active' : ''}">All
						Requests</a> <a
						href="${pageContext.request.contextPath}/landlord/requests/pending"
						class="btn-filter ${page == 'pending' ? 'active' : ''}">
						Pending <c:if test="${pendingCount > 0}">
							<span class="pending-count">${pendingCount}</span>
						</c:if>
					</a>
				</div>
			</div>

			<c:choose>
				<c:when test="${empty requests}">
					<div class="dashboard-card"
						style="text-align: center; padding: 3rem;">
						<span class="material-symbols-outlined"
							style="font-size: 4rem; color: var(--outline);">inbox</span>
						<h3>No rental requests</h3>
						<p>You don't have any rental requests at the moment.</p>
						<a href="${pageContext.request.contextPath}/properties"
							class="btn-primary"
							style="display: inline-block; margin-top: 1rem; text-decoration: none;">
							Browse Properties </a>
					</div>
				</c:when>
				<c:otherwise>
					<div class="requests-list">
						<c:forEach var="req" items="${requests}">
							<div class="request-card" data-request-id="${req.requestId}"
								style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; margin-bottom: 1rem; overflow: hidden;">
								<div class="request-header"
									style="padding: 1rem 1.5rem; background: #f9fafb; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 0.5rem;">
									<div>
										<span class="request-id"
											style="font-weight: 600; font-family: monospace;">${req.displayId}</span>
										<span class="property-name"
											style="margin-left: 1rem; color: var(--primary); font-weight: 500;">${fn:escapeXml(req.propertyTitle)}</span>
									</div>
									<div>
										<span class="status-badge"
											style="
                                        ${req.status == 'pending' ? 'background: #fef3c7; color: #d97706;' : ''}
                                        ${req.status == 'approved' ? 'background: #d1fae5; color: #059669;' : ''}
                                        ${req.status == 'rejected' ? 'background: #fee2e2; color: #dc2626;' : ''}
                                        padding: 0.25rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600;">
											${req.status == 'pending' ? 'Pending' : ''} ${req.status == 'approved' ? 'Approved' : ''}
											${req.status == 'rejected' ? 'Rejected' : ''} </span>
									</div>
								</div>

								<div class="request-body" style="padding: 1.5rem;">
									<div class="tenant-info"
										style="display: grid; grid-template-columns: repeat(auto-fit, minmax(200px, 1fr)); gap: 1rem; margin-bottom: 1rem;">
										<div>
											<span class="material-symbols-outlined"
												style="font-size: 1rem; vertical-align: middle;">person</span>
											<strong>Tenant:</strong> ${fn:escapeXml(req.tenantName)}
										</div>
										<div>
											<span class="material-symbols-outlined"
												style="font-size: 1rem; vertical-align: middle;">email</span>
											<strong>Email:</strong> ${fn:escapeXml(req.tenantEmail)}
										</div>
										<div>
											<span class="material-symbols-outlined"
												style="font-size: 1rem; vertical-align: middle;">event</span>
											<strong>Move-in Date:</strong>
											${req.requestedMoveInDate.toString().replace('-', '/')}
										</div>
										<div>
											<span class="material-symbols-outlined"
												style="font-size: 1rem; vertical-align: middle;">schedule</span>
											<strong>Duration:</strong>
											${req.requestedLeaseDurationMonths} months
										</div>
									</div>

									<c:if test="${not empty req.tenantMessage}">
										<div class="tenant-message"
											style="background: var(--surface-container-low); padding: 1rem; border-radius: 0.5rem; margin-bottom: 1rem;">
											<strong>Message from tenant:</strong>
											<p
												style="margin-top: 0.5rem; color: var(--on-surface-variant);">${fn:escapeXml(req.tenantMessage)}</p>
										</div>
									</c:if>

									<c:if test="${not empty req.landlordResponse}">
										<div class="landlord-response"
											style="background: #e8f5e9; padding: 1rem; border-radius: 0.5rem; margin-bottom: 1rem;">
											<strong>Your response:</strong>
											<p style="margin-top: 0.5rem;">${fn:escapeXml(req.landlordResponse)}</p>
										</div>
									</c:if>

									<c:if test="${req.status == 'pending'}">
										<div class="action-buttons"
											style="display: flex; gap: 1rem; margin-top: 1rem;">
											<button class="btn-approve"
												onclick="openResponseModal(${req.requestId}, 'approve')"
												style="background: #059669; color: white; border: none; padding: 0.5rem 1.5rem; border-radius: 0.5rem; cursor: pointer; display: flex; align-items: center; gap: 0.25rem;">
												<span class="material-symbols-outlined"
													style="font-size: 1rem;">check</span> Approve
											</button>
											<button class="btn-reject"
												onclick="openResponseModal(${req.requestId}, 'reject')"
												style="background: transparent; border: 1px solid #dc2626; color: #dc2626; padding: 0.5rem 1.5rem; border-radius: 0.5rem; cursor: pointer; display: flex; align-items: center; gap: 0.25rem;">
												<span class="material-symbols-outlined"
													style="font-size: 1rem;">close</span> Reject
											</button>
										</div>
									</c:if>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</div>

	<!-- Response Modal -->
	<div id="responseModal" class="modal"
		style="display: none; position: fixed; top: 0; left: 0; right: 0; bottom: 0; background: rgba(0, 0, 0, 0.5); z-index: 1000; align-items: center; justify-content: center;">
		<div class="modal-content"
			style="background: white; border-radius: 1rem; max-width: 500px; width: 90%;">
			<div class="modal-header"
				style="padding: 1rem 1.5rem; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center;">
				<h3 id="modalTitle" style="margin: 0;">Approve Request</h3>
				<button class="modal-close" onclick="closeModal()"
					style="background: none; border: none; font-size: 1.5rem; cursor: pointer;">&times;</button>
			</div>
			<div class="modal-body" style="padding: 1.5rem;">
				<p style="margin-bottom: 0.5rem;">Add an optional message to the
					tenant:</p>
				<textarea id="responseMessage" rows="4"
					style="width: 100%; padding: 0.75rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; font-family: inherit;"
					placeholder="Your message to the tenant..."></textarea>
			</div>
			<div class="modal-footer"
				style="padding: 1rem 1.5rem; border-top: 1px solid #e5e7eb; display: flex; justify-content: flex-end; gap: 0.5rem;">
				<button class="btn-secondary" onclick="closeModal()"
					style="padding: 0.5rem 1rem; border: none; border-radius: 0.5rem; cursor: pointer;">Cancel</button>
				<button id="submitResponseBtn" class="btn-primary"
					style="padding: 0.5rem 1rem; border: none; border-radius: 0.5rem; cursor: pointer;">Confirm</button>
			</div>
		</div>
	</div>

	<style>
.btn-filter {
	padding: 0.5rem 1rem;
	border-radius: 0.5rem;
	text-decoration: none;
	color: var(--on-surface-variant);
	background: var(--surface-container-low);
	font-size: 0.875rem;
	transition: all 0.2s;
}

.btn-filter.active {
	background: var(--primary);
	color: white;
}

.btn-filter:hover:not(.active) {
	background: var(--surface-container);
}

.pending-count {
	background: white;
	color: var(--primary);
	border-radius: 20px;
	padding: 0 6px;
	margin-left: 6px;
	font-size: 0.7rem;
}

.section-badge {
	font-size: 0.75rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.05em;
	color: var(--primary);
	margin-bottom: 0.5rem;
}

.badge {
	background: var(--error);
	color: white;
	border-radius: 20px;
	padding: 2px 8px;
	margin-left: auto;
	font-size: 0.7rem;
}
</style>

	<script src="${pageContext.request.contextPath}/js/landlord/rental-requests.js"></script>

</body>
</html>