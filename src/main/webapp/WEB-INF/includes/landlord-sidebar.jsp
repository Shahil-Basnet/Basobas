<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>

<!-- SIDEBAR -->
<aside class="sidebar">
    <div class="sidebar-header">
        <h1>Basobas</h1>
        <p>Landlord Portal</p>
    </div>
    
    <div class="nav-links">
        <a href="${pageContext.request.contextPath}/landlord/dashboard" class="nav-link ${page == 'dashboard' ? 'active' : ''}">
            <span class="material-symbols-outlined">dashboard</span>
            <span>Dashboard</span>
        </a>
        
        <a href="${pageContext.request.contextPath}/landlord/properties" class="nav-link ${page == 'properties' ? 'active' : ''}">
            <span class="material-symbols-outlined">real_estate_agent</span>
            <span>My Properties</span>
        </a>
        
        <a href="${pageContext.request.contextPath}/landlord/properties?action=add" class="nav-link ${page == 'add-property' ? 'active' : ''}">
            <span class="material-symbols-outlined">add_business</span>
            <span>Add Property</span>
        </a>
        
        <a href="${pageContext.request.contextPath}/landlord/requests/list" class="nav-link ${page == 'requests' ? 'active' : ''}">
            <span class="material-symbols-outlined">pending_actions</span>
            <span>Rental Requests</span>
            <c:if test="${pendingCount > 0}">
                <span class="badge-count">${pendingCount}</span>
            </c:if>
        </a>
        
        <a href="${pageContext.request.contextPath}/landlord/leases" class="nav-link ${page == 'leases' ? 'active' : ''}">
            <span class="material-symbols-outlined">description</span>
            <span>My Leases</span>
        </a>
        
        <a href="${pageContext.request.contextPath}/landlord/payments" class="nav-link ${page == 'payments' ? 'active' : ''}">
            <span class="material-symbols-outlined">payments</span>
            <span>Payments</span>
        </a>
        
        <a href="${pageContext.request.contextPath}/landlord/reviews" class="nav-link ${page == 'reviews' ? 'active' : ''}">
            <span class="material-symbols-outlined">reviews</span>
            <span>Reviews</span>
        </a>
        
        <a href="${pageContext.request.contextPath}/profile" class="nav-link ${page == 'profile' ? 'active' : ''}">
            <span class="material-symbols-outlined">person</span>
            <span>Profile</span>
        </a>
    </div>
    
    <div class="profile-section">
        <div class="avatar">
            <c:choose>
                <c:when test="${not empty sessionScope.loggedInUser.fullName}">
                    ${fn:substring(sessionScope.loggedInUser.fullName, 0, 1)}
                </c:when>
                <c:otherwise>L</c:otherwise>
            </c:choose>
        </div>
        <div class="profile-info">
            <p>${sessionScope.loggedInUser.fullName != null ? sessionScope.loggedInUser.fullName : 'Landlord'}</p>
            <span>Property Owner</span>
        </div>
    </div>
</aside>