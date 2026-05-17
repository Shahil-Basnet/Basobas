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
<title>My Requests - Basobas</title>

<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@400;500;600;700&display=swap"
	rel="stylesheet">
<link rel="stylesheet"
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />

<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css">
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>

	<jsp:include page="/WEB-INF/includes/header.jsp" />

	<main>
		<div class="container" style="padding: 2rem 1rem;">

			<div class="page-header"
				style="margin-bottom: 2rem; display: flex; justify-content: space-between; align-items: flex-end; flex-wrap: wrap; gap: 1rem;">
				<div>
					<div class="section-badge">TENANT PORTAL</div>
					<h1 class="page-title" style="font-size: 2rem;">My Rental
						Requests</h1>
					<p class="page-subtitle">Track all your property requests</p>
				</div>
				<a href="${pageContext.request.contextPath}/properties"
					class="btn-primary" style="text-decoration: none;"> <span
					class="material-symbols-outlined">add</span> New Request
				</a>
			</div>

			<c:choose>
				<c:when test="${empty requests}">
					<div class="dashboard-card"
						style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; text-align: center; padding: 3rem;">
						<span class="material-symbols-outlined"
							style="font-size: 4rem; color: #9ca3af;">request_page</span>
						<h3 style="margin: 1rem 0 0.5rem;">No requests yet</h3>
						<p style="color: #6b7280;">You haven't submitted any rental
							requests.</p>
						<a href="${pageContext.request.contextPath}/properties"
							class="btn-primary"
							style="display: inline-block; margin-top: 1rem; text-decoration: none;">
							Browse Properties </a>
					</div>
				</c:when>
				<c:otherwise>
					<div class="dashboard-card"
						style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; overflow: hidden;">
						<div style="overflow-x: auto;">
							<table class="data-table"
								style="width: 100%; border-collapse: collapse;">
								<thead>
									<tr style="background: #f9fafb;">
										<th style="padding: 0.75rem 1rem; text-align: left;">Request
											ID</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Property</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Move-in
											Date</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Duration</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Status</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Requested
											On</th>
										<th style="padding: 0.75rem 1rem; text-align: left;"></th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="req" items="${requests}">
										<tr style="border-bottom: 1px solid #e5e7eb;">
											<td style="padding: 0.75rem 1rem;">${req.displayId}</td>
											<td style="padding: 0.75rem 1rem;"><a
												href="${pageContext.request.contextPath}/property?id=${req.propertyDisplayId}"
												style="color: var(--primary); text-decoration: none;">
													${fn:escapeXml(req.propertyTitle)} </a></td>
											<td style="padding: 0.75rem 1rem;">${req.requestedMoveInDate}</td>
											<td style="padding: 0.75rem 1rem;">${req.requestedLeaseDurationMonths}
												months</td>
											<td style="padding: 0.75rem 1rem;"><span
												class="status-badge"
												style="
                ${req.status == 'pending' ? 'background: #fef3c7; color: #d97706;' : ''}
                ${req.status == 'approved' ? 'background: #d1fae5; color: #059669;' : ''}
                ${req.status == 'rejected' ? 'background: #fee2e2; color: #dc2626;' : ''}
                ${req.status == 'cancelled' ? 'background: #f3f4f6; color: #6b7280;' : ''}
                padding: 0.25rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600;">
													${req.status == 'pending' ? 'Pending' : ''} ${req.status == 'approved' ? 'Approved' : ''}
													${req.status == 'rejected' ? 'Rejected' : ''} ${req.status == 'cancelled' ? 'Cancelled' : ''}
											</span></td>
											<td style="padding: 0.75rem 1rem;">${req.createdAt}</td>
											<td style="padding: 0.75rem 1rem;"><c:if
													test="${req.status == 'pending'}">
													<button class="action-btn action-delete"
														onclick="cancelRequest(${req.requestId})"
														title="Cancel Request"
														style="background: none; border: none; cursor: pointer; color: #dc2626;">
														<span class="material-symbols-outlined">cancel</span>
													</button>
												</c:if> <c:if test="${req.status == 'approved'}">
													<a href="${pageContext.request.contextPath}/tenant/rentals"
														class="action-btn action-view" title="View Rental"
														style="background: none; border: none; cursor: pointer; color: var(--primary); text-decoration: none;">
														<span class="material-symbols-outlined">visibility</span>
													</a>
												</c:if></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>
				</c:otherwise>
			</c:choose>

		</div>
	</main>

	<jsp:include page="/WEB-INF/includes/footer.jsp" />

	<script src="${pageContext.request.contextPath}/js/tenant/requests.js"></script>

	<style>
.section-badge {
	font-size: 0.75rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.05em;
	color: var(--primary);
	margin-bottom: 0.5rem;
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
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
}
</style>

</body>
</html>