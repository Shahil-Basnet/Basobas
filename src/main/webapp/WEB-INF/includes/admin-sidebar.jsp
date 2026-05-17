<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>

<aside class="sidebar">
	<div class="sidebar-header">
		<h1>Basobas</h1>
		<p>Admin Portal</p>
	</div>

	<div class="nav-links">
		<a href="${pageContext.request.contextPath}/admin/dashboard"
			class="nav-link ${page == 'dashboard' ? 'active' : ''}"> <span
			class="material-symbols-outlined">dashboard</span> <span>Dashboard</span>
		</a> <a href="${pageContext.request.contextPath}/admin/users"
			class="nav-link ${page == 'users' ? 'active' : ''}"> <span
			class="material-symbols-outlined">group</span> <span>Users</span>
		</a> <a href="${pageContext.request.contextPath}/admin/properties"
			class="nav-link ${page == 'properties' ? 'active' : ''}"> <span
			class="material-symbols-outlined">real_estate_agent</span> <span>Properties</span>
		</a> 
	</div>

	<div class="profile-section">
		<div class="avatar">
			<c:choose>
				<c:when test="${not empty sessionScope.loggedInUser.fullName}">
                    ${fn:substring(sessionScope.loggedInUser.fullName, 0, 1)}
                </c:when>
				<c:otherwise>A</c:otherwise>
			</c:choose>
		</div>
		<div class="profile-info">
			<p>${sessionScope.loggedInUser.fullName != null ? sessionScope.loggedInUser.fullName : 'Admin'}</p>
			<span>Administrator</span>
		</div>
	</div>

	<!-- Profile Link at the bottom -->
	<div style="margin-top: auto; padding: 1rem 16px;">
		<a href="${pageContext.request.contextPath}/profile"
			class="nav-link ${page == 'profile' ? 'active' : ''}"> <span
			class="material-symbols-outlined">person</span> <span>My
				Profile</span>
		</a>
	</div>
</aside>