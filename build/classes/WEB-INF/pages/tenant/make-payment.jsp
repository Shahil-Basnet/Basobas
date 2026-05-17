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
<title>Make Payment - Basobas</title>

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
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/property-form.css">
</head>
<body>

	<jsp:include page="/WEB-INF/includes/header.jsp" />

	<main>
		<div class="container" style="padding: 2rem 1rem;">

			<div class="page-header" style="margin-bottom: 2rem;">
				<div>
					<div class="section-badge">TENANT PORTAL</div>
					<h1 class="page-title" style="font-size: 2rem;">Make a Payment</h1>
					<p class="page-subtitle">Record your rent payment</p>
				</div>
				<a href="${pageContext.request.contextPath}/tenant/payments"
					class="btn-outline" style="text-decoration: none;"> <span
					class="material-symbols-outlined">arrow_back</span> Back to
					Payments
				</a>
			</div>

			<div class="dashboard-card"
				style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; max-width: 600px; margin: 0 auto;">
				<div style="padding: 1.5rem;">
					<form id="paymentForm" method="post">
						<!-- Property Selection -->
						<div class="form-group" style="margin-bottom: 1rem;">
							<label
								style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Select
								Property <span style="color: var(--error);">*</span>
							</label> <select id="propertyId" name="propertyId" required
								class="estate-input">
								<option value="">Select a property</option>
								<c:forEach var="property" items="${properties}">
									<option value="${property.propertyId}"
										data-rent="${property.monthlyRent}">
										${fn:escapeXml(property.title)} (रू
										<fmt:formatNumber value="${property.monthlyRent}"
											groupingUsed="true" />)
									</option>
								</c:forEach>
							</select>
						</div>

						<!-- Amount -->
						<div class="form-group" style="margin-bottom: 1rem;">
							<label
								style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Amount
								<span style="color: var(--error);">*</span>
							</label> <input type="number" id="amount" name="amount"
								class="estate-input" step="0.01" required
								placeholder="Enter amount">
						</div>

						<!-- Year and Month Dropdowns -->
						<div
							style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem; margin-bottom: 1rem;">
							<div class="form-group">
								<label
									style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Year</label>
								<select id="paymentYear" name="paymentYear" required
									class="estate-input"></select>
							</div>
							<div class="form-group">
								<label
									style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Month</label>
								<select id="paymentMonthName" name="paymentMonthName" required
									class="estate-input">
									<option value="">Select Month</option>
									<option value="1">January</option>
									<option value="2">February</option>
									<option value="3">March</option>
									<option value="4">April</option>
									<option value="5">May</option>
									<option value="6">June</option>
									<option value="7">July</option>
									<option value="8">August</option>
									<option value="9">September</option>
									<option value="10">October</option>
									<option value="11">November</option>
									<option value="12">December</option>
								</select>
							</div>
						</div>

						<!-- Payment Method -->
						<div class="form-group" style="margin-bottom: 1rem;">
							<label
								style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Payment
								Method <span style="color: var(--error);">*</span>
							</label> <select id="paymentMethod" name="paymentMethod" required
								class="estate-input">
								<option value="">Select payment method</option>
								<option value="bank_transfer">Bank Transfer</option>
								<option value="cash">Cash</option>
								<option value="card">Card</option>
								<option value="khalti">Khalti</option>
								<option value="esewa">eSewa</option>
								<option value="ime_pay">IME Pay</option>
								<option value="connectips">ConnectIPS</option>
							</select>
						</div>

						<!-- Transaction Reference -->
						<div class="form-group" style="margin-bottom: 1rem;">
							<label
								style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Transaction
								Reference</label> <input type="text" id="transactionReference"
								name="transactionReference" class="estate-input"
								placeholder="Transaction ID or reference number">
						</div>

						<!-- Notes -->
						<div class="form-group" style="margin-bottom: 1rem;">
							<label
								style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Notes
								(Optional)</label>
							<textarea id="notes" name="notes" rows="3" class="estate-input"
								placeholder="Any additional information..."></textarea>
						</div>

						<!-- Buttons -->
						<div style="display: flex; gap: 1rem; margin-top: 1.5rem;">
							<button type="submit" class="btn-primary"
								style="flex: 1; justify-content: center;">Submit
								Payment</button>
							<a href="${pageContext.request.contextPath}/tenant/payments"
								class="btn-outline"
								style="flex: 1; text-align: center; text-decoration: none;">Cancel</a>
						</div>
					</form>
				</div>
			</div>

		</div>
	</main>

	<jsp:include page="/WEB-INF/includes/footer.jsp" />

	<script src="${pageContext.request.contextPath}/js/tenant/make-payment.js"></script>

	<style>
.section-badge {
	font-size: 0.75rem;
	font-weight: 600;
	text-transform: uppercase;
	letter-spacing: 0.05em;
	color: var(--primary);
	margin-bottom: 0.5rem;
}

.btn-outline {
	background: transparent;
	border: 1px solid var(--primary);
	color: var(--primary);
	padding: 0.625rem 1.25rem;
	border-radius: 0.5rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	gap: 0.5rem;
	text-decoration: none;
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
}

.btn-primary:disabled {
	opacity: 0.6;
	cursor: not-allowed;
}
</style>

</body>
</html>