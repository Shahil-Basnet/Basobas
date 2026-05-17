<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>
<%@ taglib uri="jakarta.tags.functions" prefix="fn" %>
<%@ taglib uri="jakarta.tags.fmt" prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile - Basobas</title>
    
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    
    <c:choose>
        <c:when test="${sessionScope.loggedInUser.role == 'admin' or sessionScope.loggedInUser.role == 'landlord'}">
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/dashboard.css">
        </c:when>
        <c:otherwise>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
        </c:otherwise>
    </c:choose>
</head>
<body>

    <!-- For Admin and Landlord: Show Sidebar -->
    <c:if test="${sessionScope.loggedInUser.role == 'admin' or sessionScope.loggedInUser.role == 'landlord'}">
        <c:choose>
            <c:when test="${sessionScope.loggedInUser.role == 'admin'}">
                <c:set var="page" value="profile" scope="request" />
                <jsp:include page="/WEB-INF/includes/admin-sidebar.jsp" />
            </c:when>
            <c:when test="${sessionScope.loggedInUser.role == 'landlord'}">
                <c:set var="page" value="profile" scope="request" />
                <jsp:include page="/WEB-INF/includes/landlord-sidebar.jsp" />
            </c:when>
        </c:choose>
    </c:if>

    <!-- For Tenant: Show Header (Double Nav Bar) -->
    <c:if test="${sessionScope.loggedInUser.role == 'tenant'}">
        <c:set var="page" value="profile" scope="request" />
        <jsp:include page="/WEB-INF/includes/header.jsp" />
    </c:if>

    <!-- MAIN CONTENT -->
    <main class="${sessionScope.loggedInUser.role == 'admin' or sessionScope.loggedInUser.role == 'landlord' ? 'main-content' : ''}">
        
        <c:if test="${sessionScope.loggedInUser.role == 'admin' or sessionScope.loggedInUser.role == 'landlord'}">
            <jsp:include page="/WEB-INF/includes/topbar.jsp" />
        </c:if>

        <div class="${sessionScope.loggedInUser.role == 'admin' or sessionScope.loggedInUser.role == 'landlord' ? 'dashboard-container' : 'container'}" style="padding: 2rem 1rem;">
            
            <div class="page-header" style="margin-bottom: 2rem;">
                <div>
                    <div class="section-badge">MY ACCOUNT</div>
                    <h1 class="page-title" style="font-size: 2rem;">Profile Settings</h1>
                    <p class="page-subtitle">Manage your personal information and password</p>
                </div>
            </div>

            <!-- Alert Messages -->
            <c:if test="${not empty sessionScope.message}">
                <div class="alert" style="margin-bottom: 1.5rem; padding: 1rem; border-radius: 0.5rem; background: ${sessionScope.messageType == 'success' ? '#d1fae5' : '#fee2e2'}; color: ${sessionScope.messageType == 'success' ? '#059669' : '#dc2626'};">
                    ${sessionScope.message}
                </div>
                <c:remove var="message" scope="session" />
                <c:remove var="messageType" scope="session" />
            </c:if>

            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                <!-- Profile Information Card -->
                <div class="profile-card" style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; overflow: hidden;">
                    <div class="card-header" style="padding: 1rem 1.5rem; border-bottom: 1px solid #e5e7eb;">
                        <h3 style="font-size: 1rem; font-weight: 700; margin: 0;">Profile Information</h3>
                    </div>
                    <div style="padding: 1.5rem;">
                        <form method="post" action="${pageContext.request.contextPath}/profile">
                            <input type="hidden" name="action" value="updateProfile">
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Display ID</label>
                                <input type="text" value="${profileUser.displayId}" class="form-input" disabled style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; background: #f3f4f6;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Username</label>
                                <input type="text" value="${profileUser.username}" class="form-input" disabled style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; background: #f3f4f6;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Email</label>
                                <input type="email" value="${profileUser.email}" class="form-input" disabled style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; background: #f3f4f6;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Full Name</label>
                                <input type="text" name="fullName" value="${profileUser.fullName}" class="form-input" required style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Phone Number</label>
                                <input type="tel" name="phone" value="${profileUser.phone}" class="form-input" placeholder="+977 XXXXXXXXX" style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Address</label>
                                <textarea name="address" rows="2" class="form-input" placeholder="Your address" style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">${profileUser.address}</textarea>
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Role</label>
                                <input type="text" value="${profileUser.role}" class="form-input" disabled style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; background: #f3f4f6; text-transform: capitalize;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Member Since</label>
                                <input type="text" value="${profileUser.registeredAt}" class="form-input" disabled style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem; background: #f3f4f6;">
                            </div>
                            
                            <button type="submit" class="btn-primary" style="width: 100%; justify-content: center; background: linear-gradient(135deg, var(--primary), var(--primary-container)); color: white; padding: 0.625rem 1.25rem; border-radius: 0.5rem; font-weight: 600; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 0.5rem;">
                                <span class="material-symbols-outlined">save</span>
                                Save Changes
                            </button>
                        </form>
                    </div>
                </div>

                <!-- Change Password Card -->
                <div class="profile-card" style="background: white; border-radius: 1rem; border: 1px solid #e5e7eb; overflow: hidden;">
                    <div class="card-header" style="padding: 1rem 1.5rem; border-bottom: 1px solid #e5e7eb;">
                        <h3 style="font-size: 1rem; font-weight: 700; margin: 0;">Change Password</h3>
                    </div>
                    <div style="padding: 1.5rem;">
                        <form method="post" action="${pageContext.request.contextPath}/profile">
                            <input type="hidden" name="action" value="changePassword">
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Current Password</label>
                                <input type="password" name="currentPassword" class="form-input" required style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">New Password</label>
                                <input type="password" name="newPassword" class="form-input" required style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">
                                <div class="form-hint" style="font-size: 0.7rem; color: #6b7280; margin-top: 0.25rem;">Minimum 4 characters</div>
                            </div>
                            
                            <div class="form-group" style="margin-bottom: 1rem;">
                                <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Confirm New Password</label>
                                <input type="password" name="confirmPassword" class="form-input" required style="width: 100%; padding: 0.625rem 0.875rem; border: 1px solid #e5e7eb; border-radius: 0.5rem;">
                            </div>
                            
                            <button type="submit" class="btn-primary" style="width: 100%; justify-content: center; background: linear-gradient(135deg, var(--primary), var(--primary-container)); color: white; padding: 0.625rem 1.25rem; border-radius: 0.5rem; font-weight: 600; border: none; cursor: pointer; display: inline-flex; align-items: center; gap: 0.5rem;">
                                <span class="material-symbols-outlined">lock</span>
                                Change Password
                            </button>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </main>

    <c:if test="${sessionScope.loggedInUser.role == 'tenant'}">
        <jsp:include page="/WEB-INF/includes/footer.jsp" />
    </c:if>

    <script src="${pageContext.request.contextPath}/js/common/utils.js"></script>
    <script src="${pageContext.request.contextPath}/js/common/navigation.js"></script>

    <style>
        .section-badge {
            font-size: 0.75rem;
            font-weight: 600;
            text-transform: uppercase;
            letter-spacing: 0.05em;
            color: var(--primary);
            margin-bottom: 0.5rem;
        }
        .page-title {
            font-size: 2rem;
            font-weight: 800;
            margin-bottom: 0.25rem;
        }
        .page-subtitle {
            color: var(--on-surface-variant);
        }
        .form-input:focus {
            outline: none;
            border-color: var(--primary);
            ring: 2px solid var(--primary);
        }
        .btn-primary:hover {
            opacity: 0.9;
        }
    </style>

</body>
</html>