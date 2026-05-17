<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Rentals - Basobas</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>

<jsp:include page="/WEB-INF/includes/header.jsp" />

<main>
    <div class="container" style="padding: 2rem 1rem;">
        
        <div class="page-header" style="margin-bottom: 2rem;">
            <div>
                <div class="section-badge">TENANT PORTAL</div>
                <h1 class="page-title" style="font-size: 2rem;">My Rentals</h1>
                <p class="page-subtitle">Properties you are currently renting</p>
            </div>
        </div>
        
        <c:choose>
            <c:when test="${empty rentals}">
                <div class="dashboard-card" style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; text-align: center; padding: 3rem;">
                    <span class="material-symbols-outlined" style="font-size: 4rem; color: #9ca3af;">home</span>
                    <h3 style="margin: 1rem 0 0.5rem;">No active rentals yet</h3>
                    <p style="color: #6b7280;">You don't have any active rental agreements.</p>
                    <a href="${pageContext.request.contextPath}/properties" class="btn-primary" style="display: inline-block; margin-top: 1rem; text-decoration: none;">
                        Browse Properties
                    </a>
                </div>
            </c:when>
            <c:otherwise>
                <div class="properties-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 1.5rem;">
                    <c:forEach var="rental" items="${rentals}">
                        <div class="rental-card" style="background: white; border-radius: 1rem; overflow: hidden; border: 1px solid #e5e7eb;">
                            <img src="${pageContext.request.contextPath}${rental.primaryPhotoUrl}" 
                                 alt="${fn:escapeXml(rental.title)}"
                                 style="width: 100%; height: 200px; object-fit: cover;"
                                 onerror="this.src='${pageContext.request.contextPath}/assets/no-image.jpg'">
                            <div style="padding: 1rem;">
                                <h3 style="font-size: 1.1rem; margin-bottom: 0.5rem;">${fn:escapeXml(rental.title)}</h3>
                                <div style="display: flex; align-items: center; gap: 0.25rem; color: #6b7280; font-size: 0.875rem; margin-bottom: 0.5rem;">
                                    <span class="material-symbols-outlined" style="font-size: 1rem;">location_on</span>
                                    <span>${fn:escapeXml(rental.city)}</span>
                                </div>
                                <div style="font-size: 1.25rem; font-weight: 700; color: var(--primary); margin-bottom: 1rem;">
                                    रू <fmt:formatNumber value="${rental.monthlyRent}" groupingUsed="true"/>/month
                                </div>
                                <div style="display: flex; gap: 0.5rem;">
                                    <a href="${pageContext.request.contextPath}/property?id=${rental.displayId}" class="btn-outline" style="flex: 1; text-align: center; text-decoration: none;">View Details</a>
                                    <a href="${pageContext.request.contextPath}/tenant/payments" class="btn-primary" style="flex: 1; text-align: center; text-decoration: none;">Pay Rent</a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:otherwise>
        </c:choose>
        
    </div>
</main>

<jsp:include page="/WEB-INF/includes/footer.jsp" />

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
    display: inline-flex;
    align-items: center;
    justify-content: center;
    gap: 0.5rem;
}
.btn-outline:hover {
    background: rgba(51, 79, 43, 0.05);
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