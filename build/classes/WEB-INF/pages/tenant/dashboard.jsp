<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Tenant Dashboard - Basobas</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20,400,0,0" />
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>

<!-- Include Header -->
<jsp:include page="/WEB-INF/includes/header.jsp" />

<main>
    <div class="container" style="padding: 2rem 1rem;">
        
        <!-- Page Header -->
        <div class="page-header" style="margin-bottom: 2rem;">
            <div>
                <div class="section-badge">TENANT PORTAL</div>
                <h1 class="page-title" style="font-size: 2rem;">My Dashboard</h1>
                <p class="page-subtitle">Welcome back, ${fn:escapeXml(sessionScope.loggedInUser.fullName)}! Here's an overview of your rental activity.</p>
            </div>
        </div>
        
        <!-- Stats Cards -->
        <div class="stats-grid" style="display: grid; grid-template-columns: repeat(auto-fit, minmax(240px, 1fr)); gap: 1.5rem; margin-bottom: 2rem;">
            <div class="stat-card" style="background: white; border-radius: 1rem; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <div class="stat-icon" style="width: 48px; height: 48px; background: #e8f5e9; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <span class="material-symbols-outlined" style="color: var(--primary);">home</span>
                </div>
                <h4 style="font-size: 0.8rem; color: var(--on-surface-variant); margin-bottom: 0.5rem;">ACTIVE RENTALS</h4>
                <div class="stat-number" style="font-size: 2rem; font-weight: 800;">${rentalsCount}</div>
                <div class="stat-trend" style="font-size: 0.7rem; color: #6b7280;">Properties you're renting</div>
            </div>
            
            <div class="stat-card" style="background: white; border-radius: 1rem; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <div class="stat-icon" style="width: 48px; height: 48px; background: #fff3e0; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <span class="material-symbols-outlined" style="color: #ed6c02;">pending_actions</span>
                </div>
                <h4 style="font-size: 0.8rem; color: var(--on-surface-variant); margin-bottom: 0.5rem;">PENDING REQUESTS</h4>
                <div class="stat-number" style="font-size: 2rem; font-weight: 800;">${pendingRequests}</div>
                <div class="stat-trend" style="font-size: 0.7rem; color: #6b7280;">Waiting for landlord response</div>
            </div>
            
            <div class="stat-card" style="background: white; border-radius: 1rem; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <div class="stat-icon" style="width: 48px; height: 48px; background: #e8f5e9; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <span class="material-symbols-outlined" style="color: #2e7d32;">check_circle</span>
                </div>
                <h4 style="font-size: 0.8rem; color: var(--on-surface-variant); margin-bottom: 0.5rem;">APPROVED REQUESTS</h4>
                <div class="stat-number" style="font-size: 2rem; font-weight: 800;">${approvedRequests}</div>
                <div class="stat-trend" style="font-size: 0.7rem; color: #6b7280;">Ready to move in</div>
            </div>
            
            <div class="stat-card" style="background: white; border-radius: 1rem; padding: 1.5rem; box-shadow: 0 1px 3px rgba(0,0,0,0.1);">
                <div class="stat-icon" style="width: 48px; height: 48px; background: #e3f2fd; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin-bottom: 1rem;">
                    <span class="material-symbols-outlined" style="color: #1565c0;">description</span>
                </div>
                <h4 style="font-size: 0.8rem; color: var(--on-surface-variant); margin-bottom: 0.5rem;">TOTAL REQUESTS</h4>
                <div class="stat-number" style="font-size: 2rem; font-weight: 800;">${totalRequests}</div>
                <div class="stat-trend" style="font-size: 0.7rem; color: #6b7280;">All time</div>
            </div>
        </div>
        
        <!-- Quick Actions -->
        <div class="dashboard-card" style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; overflow: hidden; margin-bottom: 2rem;">
            <div class="card-header" style="padding: 1rem 1.5rem; border-bottom: 1px solid #e5e7eb;">
                <h3 style="font-size: 1.1rem;">Quick Actions</h3>
            </div>
            <div style="padding: 1.5rem; display: flex; gap: 1rem; flex-wrap: wrap;">
                <a href="${pageContext.request.contextPath}/properties" class="btn-primary" style="text-decoration: none;">
                    <span class="material-symbols-outlined">search</span>
                    Browse Properties
                </a>
                <a href="${pageContext.request.contextPath}/tenant/requests" class="btn-outline" style="text-decoration: none;">
                    <span class="material-symbols-outlined">request_page</span>
                    View My Requests
                </a>
            </div>
        </div>
        
        <!-- Recent Rentals -->
        <c:if test="${not empty rentals}">
            <div class="dashboard-card" style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; overflow: hidden;">
                <div class="card-header" style="padding: 1rem 1.5rem; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center;">
                    <h3 style="font-size: 1.1rem;">Current Rentals</h3>
                    <a href="${pageContext.request.contextPath}/tenant/rentals" class="link-arrow" style="font-size: 0.8rem;">View All →</a>
                </div>
                <div style="overflow-x: auto;">
                    <table class="data-table" style="width: 100%; border-collapse: collapse;">
                        <thead>
                            <tr style="background: #f9fafb;">
                                <th style="padding: 0.75rem 1rem; text-align: left;">Property</th>
                                <th style="padding: 0.75rem 1rem; text-align: left;">Location</th>
                                <th style="padding: 0.75rem 1rem; text-align: left;">Monthly Rent</th>
                                <th style="padding: 0.75rem 1rem; text-align: left;">Status</th>
                                <th style="padding: 0.75rem 1rem; text-align: left;"></th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach items="${rentals}" var="rental" end="2">
                                <tr style="border-bottom: 1px solid #e5e7eb;">
                                    <td style="padding: 0.75rem 1rem;">${fn:escapeXml(rental.title)}</td>
                                    <td style="padding: 0.75rem 1rem;">${fn:escapeXml(rental.city)}</td>
                                    <td style="padding: 0.75rem 1rem;">रू <fmt:formatNumber value="${rental.monthlyRent}" groupingUsed="true"/></td>
                                    <td style="padding: 0.75rem 1rem;"><span class="badge-role role-tenant" style="background: #e8f5e9; color: #2e7d32; padding: 0.25rem 0.5rem; border-radius: 0.25rem; font-size: 0.7rem;">Active</span></td>
                                    <td style="padding: 0.75rem 1rem;"><a href="${pageContext.request.contextPath}/property?id=${rental.displayId}" class="action-btn action-view">View</a></td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </div>
        </c:if>
        
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