<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>



<div class="top-bar">
	<div class="search-wrapper">
		<span class="material-symbols-outlined">search</span> <input
			type="text" placeholder="Search...">
	</div>

	<div class="profile-dropdown">
		<button class="profile-trigger" id="profileTrigger">
			<div class="avatar">
				<c:choose>
					<c:when test="${not empty sessionScope.loggedInUser.fullName}">
                        ${fn:substring(sessionScope.loggedInUser.fullName, 0, 1)}
                    </c:when>
					<c:otherwise>U</c:otherwise>
				</c:choose>
			</div>
			<div class="profile-info">
				<p>${sessionScope.loggedInUser.fullName != null ? sessionScope.loggedInUser.fullName : 'User'}</p>
				<span>${sessionScope.loggedInUser.role != null ? sessionScope.loggedInUser.role : 'Role'}</span>
			</div>
			<span class="material-symbols-outlined dropdown-arrow">expand_more</span>
		</button>

		<div class="dropdown-menu" id="dropdownMenu">
			<div class="dropdown-header">
				<div class="dropdown-avatar">
					${fn:substring(sessionScope.loggedInUser.fullName, 0, 1)}</div>
				<div class="dropdown-user-info">
					<div class="dropdown-name">${sessionScope.loggedInUser.fullName != null ? sessionScope.loggedInUser.fullName : 'User'}</div>
					<div class="dropdown-email">${sessionScope.loggedInUser.email != null ? sessionScope.loggedInUser.email : 'user@example.com'}</div>
				</div>
			</div>
			<div class="dropdown-divider"></div>
			<a href="${pageContext.request.contextPath}/profile"
				class="dropdown-item"> <span class="material-symbols-outlined">person</span>
				My Profile
			</a> <a href="${pageContext.request.contextPath}/settings"
				class="dropdown-item"> <span class="material-symbols-outlined">settings</span>
				Settings
			</a>
			<div class="dropdown-divider"></div>
			<a href="${pageContext.request.contextPath}/logout"
				class="dropdown-item logout"> <span
				class="material-symbols-outlined">logout</span> Logout
			</a>
		</div>
	</div>
</div>
<script>
	window.contextPath = "${pageContext.request.contextPath}";
</script>
<script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
<script src="${pageContext.request.contextPath}/js/common/navigation.js"></script>