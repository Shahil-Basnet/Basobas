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
<title>My Payments - Basobas</title>

<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap"
	rel="stylesheet">
<link
	href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200"
	rel="stylesheet">

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
					<h1 class="page-title" style="font-size: 2rem;">Payments</h1>
					<p class="page-subtitle">Track your rent payments and history</p>
				</div>
				<a href="${pageContext.request.contextPath}/tenant/payments/make"
					class="btn-primary" style="text-decoration: none;"> <span
					class="material-symbols-outlined">add</span> Make Payment
				</a>
			</div>

			<c:choose>
				<c:when test="${empty payments}">
					<div class="dashboard-card"
						style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; text-align: center; padding: 3rem;">
						<span class="material-symbols-outlined"
							style="font-size: 4rem; color: #9ca3af;">payments</span>
						<h3 style="margin: 1rem 0 0.5rem;">No payment records</h3>
						<p style="color: #6b7280;">You haven't made any payments yet.</p>
						<a href="${pageContext.request.contextPath}/tenant/payments/make"
							class="btn-primary"
							style="display: inline-block; margin-top: 1rem; text-decoration: none;">Make
							a Payment</a>
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
										<th style="padding: 0.75rem 1rem; text-align: left;">Payment
											ID</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Property</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Month</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Amount</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Method</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Status</th>
										<th style="padding: 0.75rem 1rem; text-align: left;">Date</th>
									</tr>
								</thead>
								<tbody>
									<c:forEach var="payment" items="${payments}">
										<tr style="border-bottom: 1px solid #e5e7eb;">
											<td style="padding: 0.75rem 1rem; font-family: monospace;">${payment.displayId}</td>
											<td style="padding: 0.75rem 1rem;">${fn:escapeXml(payment.propertyTitle)}</td>
											<td style="padding: 0.75rem 1rem;">${payment.paymentMonth}</td>
											<td
												style="padding: 0.75rem 1rem; font-weight: 600; color: var(--primary);">रू
												<fmt:formatNumber value="${payment.amount}"
													groupingUsed="true" />
											</td>
											<td style="padding: 0.75rem 1rem;">${payment.paymentMethodDisplay}</td>
											<td style="padding: 0.75rem 1rem;"><span
												class="status-badge"
												style="
                ${payment.status == 'completed' ? 'background: #d1fae5; color: #059669;' : ''}
                ${payment.status == 'pending' ? 'background: #fef3c7; color: #d97706;' : ''}
                ${payment.status == 'failed' ? 'background: #fee2e2; color: #dc2626;' : ''}
                padding: 0.25rem 0.75rem; border-radius: 2rem; font-size: 0.75rem; font-weight: 600;">
													${payment.status == 'completed' ? 'Completed' : ''}
													${payment.status == 'pending' ? 'Pending' : ''}
													${payment.status == 'failed' ? 'Failed' : ''} </span></td>
											<td
												style="padding: 0.75rem 1rem; font-size: 0.8rem; color: #6b7280;">
												${payment.paymentDate}</td>
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
	justify-content: center;
	gap: 0.5rem;
	text-decoration: none;
}
</style>

</body>
</html>