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
<title>Payments - Landlord Dashboard | Basobas</title>

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

	<c:set var="page" value="payments" scope="request" />

	<jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />

	<main class="main-content">
		<jsp:include page="/WEB-INF/includes/topbar.jsp" />

		<div class="dashboard-container">
			<div class="page-header">
				<div>
					<div class="section-badge">LANDLORD PORTAL</div>
					<h1 class="page-title">Payments</h1>
					<p class="page-subtitle">Track rent payments from tenants</p>
				</div>
				<div style="display: flex; gap: 0.5rem;">
					<a href="${pageContext.request.contextPath}/landlord/payments/list"
						class="btn-outline" style="text-decoration: none;">All
						Payments</a> <a
						href="${pageContext.request.contextPath}/landlord/payments/pending"
						class="btn-primary" style="text-decoration: none;">Pending</a>
				</div>
			</div>

			<c:choose>
				<c:when test="${empty payments}">
					<div class="dashboard-card"
						style="text-align: center; padding: 3rem;">
						<span class="material-symbols-outlined"
							style="font-size: 4rem; color: var(--outline);">payments</span>
						<h3>No payment records</h3>
						<p>No payments have been recorded yet.</p>
					</div>
				</c:when>
				<c:otherwise>
					<div class="dashboard-card">
						<div style="overflow-x: auto;">
							<table class="data-table">
								<thead>
									<tr>
										<th>Payment ID</th>
										<th>Property</th>
										<th>Tenant</th>
										<th>Month</th>
										<th>Amount</th>
										<th>Method</th>
										<th>Status</th>
										<th>Date</th>
										<th>Action</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="payment" items="${payments}">
										<tr>
											<td style="font-family: monospace;">${payment.displayId}</td>
											<td>${fn:escapeXml(payment.propertyTitle)}</td>
											<td>${fn:escapeXml(payment.tenantName)}</td>
											<td>${payment.paymentMonth}</td>
											<td style="font-weight: 600; color: var(--primary);">रू
												<fmt:formatNumber value="${payment.amount}"
													groupingUsed="true" />
											</td>
											<td>${payment.paymentMethodDisplay}</td>
											<td><span class="status-badge"
												style="
                                                    ${payment.status == 'completed' ? 'background: #d1fae5; color: #059669;' : ''}
                                                    ${payment.status == 'pending' ? 'background: #fef3c7; color: #d97706;' : ''}
                                                    padding: 0.25rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600;">
													${payment.status == 'completed' ? 'Completed' : 'Pending'}
											</span></td>
											<td style="font-size: 0.8rem;">${payment.paymentDate}</td>
											<td><c:if test="${payment.status == 'pending'}">
													<div style="display: flex; gap: 0.25rem;">
														<button class="action-btn action-view"
															onclick="verifyPayment(${payment.paymentId}, 'completed')"
															title="Approve">
															<span class="material-symbols-outlined">check_circle</span>
														</button>
														<button class="action-btn action-delete"
															onclick="verifyPayment(${payment.paymentId}, 'failed')"
															title="Reject">
															<span class="material-symbols-outlined">cancel</span>
														</button>
													</div>
												</c:if> <c:if test="${payment.status == 'completed'}">
													<span class="material-symbols-outlined"
														style="color: #059669;">verified</span>
												</c:if></td>
										</tr>
									</c:forEach>
								</tbody>
							</table>
						</div>
					</div>

					<!-- Summary Card -->
					<div class="dashboard-card"
						style="margin-top: 1.5rem; background: linear-gradient(135deg, var(--primary), var(--primary-container)); color: white;">
						<div
							style="padding: 1.5rem; display: flex; justify-content: space-between; align-items: center; flex-wrap: wrap; gap: 1rem;">
							<div>
								<div style="font-size: 0.8rem; opacity: 0.8;">Total
									Payments Collected</div>
								<div style="font-size: 2rem; font-weight: 800;">
									रू
									<fmt:formatNumber value="${totalCollected}" groupingUsed="true" />
								</div>
							</div>
							<div>
								<div style="font-size: 0.8rem; opacity: 0.8;">Total
									Transactions</div>
								<div style="font-size: 2rem; font-weight: 800;">${fn:length(payments)}</div>
							</div>
						</div>
					</div>
				</c:otherwise>
			</c:choose>
		</div>
	</main>

	<script src="${pageContext.request.contextPath}/js/landlord/payments.js"></script>

	<style>
.action-btn {
	background: none;
	border: none;
	cursor: pointer;
	padding: 0.25rem;
	border-radius: 0.25rem;
}

.action-view {
	color: #059669;
}

.action-delete {
	color: #dc2626;
}

.btn-outline {
	background: transparent;
	border: 1px solid var(--primary);
	color: var(--primary);
	padding: 0.5rem 1rem;
	border-radius: 0.5rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s;
	display: inline-flex;
	align-items: center;
	gap: 0.25rem;
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
</html>