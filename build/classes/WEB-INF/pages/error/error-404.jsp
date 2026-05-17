<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>Page Not Found - Basobas</title>

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

	<c:choose>
		<c:when test="${empty sessionScope.loggedInUser}">
			<jsp:include page="/WEB-INF/includes/header.jsp" />
		</c:when>
		<c:otherwise>
			<c:choose>
				<c:when test="${sessionScope.loggedInUser.role == 'admin'}">
					<jsp:include page="/WEB-INF/includes/admin-sidebar.jsp" />
					<main class="main-content">
						<jsp:include page="/WEB-INF/includes/topbar.jsp" />
				</c:when>
				<c:when test="${sessionScope.loggedInUser.role == 'landlord'}">
					<jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />
					<main class="main-content">
						<jsp:include page="/WEB-INF/includes/topbar.jsp" />
				</c:when>
				<c:otherwise>
					<jsp:include page="/WEB-INF/includes/header.jsp" />
				</c:otherwise>
			</c:choose>
		</c:otherwise>
	</c:choose>

	<div class="container" style="padding: 4rem 1rem; text-align: center;">
		<div class="error-content">
			<span class="material-symbols-outlined"
				style="font-size: 6rem; color: var(--outline);">error</span>
			<h1
				style="font-size: 6rem; font-weight: 800; color: var(--primary); margin: 1rem 0;">404</h1>
			<h2 style="font-size: 1.5rem; margin-bottom: 1rem;">Page Not
				Found</h2>
			<p
				style="color: var(--on-surface-variant); max-width: 500px; margin: 0 auto 2rem;">
				The page you are looking for might have been removed, had its name
				changed, or is temporarily unavailable.</p>
			<div
				style="display: flex; gap: 1rem; justify-content: center; flex-wrap: wrap;">
				<a href="javascript:history.back()" class="btn-outline"
					style="text-decoration: none;"> <span
					class="material-symbols-outlined">arrow_back</span> Go Back
				</a> <a href="${pageContext.request.contextPath}/" class="btn-primary"
					style="text-decoration: none;"> <span
					class="material-symbols-outlined">home</span> Go to Homepage
				</a>
			</div>
		</div>
	</div>

	<c:if
		test="${not empty sessionScope.loggedInUser and sessionScope.loggedInUser.role == 'admin'}">
		</main>
	</c:if>
	<c:if
		test="${not empty sessionScope.loggedInUser and sessionScope.loggedInUser.role == 'landlord'}">
		</main>
	</c:if>

	<c:if test="${empty sessionScope.loggedInUser}">
		<jsp:include page="/WEB-INF/includes/footer.jsp" />
	</c:if>

	<style>
.btn-outline {
	background: transparent;
	border: 1px solid var(--primary);
	color: var(--primary);
	padding: 0.75rem 1.5rem;
	border-radius: 0.5rem;
	font-weight: 600;
	cursor: pointer;
	transition: all 0.2s;
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
}

.btn-outline:hover {
	background: rgba(51, 79, 43, 0.05);
}

.btn-primary {
	background: linear-gradient(135deg, var(--primary),
		var(--primary-container));
	color: white;
	padding: 0.75rem 1.5rem;
	border-radius: 0.5rem;
	font-weight: 600;
	border: none;
	cursor: pointer;
	transition: opacity 0.2s;
	display: inline-flex;
	align-items: center;
	gap: 0.5rem;
}

.btn-primary:hover {
	opacity: 0.9;
}
</style>

</body>
</html>