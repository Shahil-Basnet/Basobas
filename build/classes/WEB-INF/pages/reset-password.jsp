<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c"%>
<%@ taglib uri="jakarta.tags.functions" prefix="fn"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Reset Password - Basobas</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    
    <main>
        <div class="container" style="padding: 3rem 1rem;">
            <div class="card" style="max-width: 450px; margin: 0 auto; padding: 2rem;">
                <div style="text-align: center; margin-bottom: 1.5rem;">
                    <span class="material-symbols-outlined" style="font-size: 3rem; color: var(--primary);">key</span>
                    <h2 style="margin-top: 0.5rem;">Set New Password</h2>
                    <p style="color: var(--on-surface-variant); font-size: 0.875rem;">Create a new password for your account</p>
                </div>
                
                <c:if test="${not empty error}">
                    <div style="background: #fee2e2; color: #dc2626; padding: 0.75rem; border-radius: 0.5rem; margin-bottom: 1rem;">
                        ${error}
                    </div>
                </c:if>
                
                <c:if test="${not empty message}">
                    <div style="background: #d1fae5; color: #059669; padding: 0.75rem; border-radius: 0.5rem; margin-bottom: 1rem;">
                        ${message}
                    </div>
                </c:if>
                
                <form method="post" action="${pageContext.request.contextPath}/reset-password">
                    <input type="hidden" name="email" value="${email}">
                    
                    <div class="form-group" style="margin-bottom: 1rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">New Password</label>
                        <input type="password" name="newPassword" class="estate-input" required style="width: 100%;" minlength="4">
                        <div class="form-hint" style="font-size: 0.7rem; color: #6b7280;">Minimum 4 characters</div>
                    </div>
                    
                    <div class="form-group" style="margin-bottom: 1rem;">
                        <label style="display: block; margin-bottom: 0.5rem; font-weight: 600;">Confirm Password</label>
                        <input type="password" name="confirmPassword" class="estate-input" required style="width: 100%;">
                    </div>
                    
                    <button type="submit" class="btn-primary" style="width: 100%; justify-content: center;">
                        <span class="material-symbols-outlined">check_circle</span>
                        Reset Password
                    </button>
                </form>
                
                <div style="text-align: center; margin-top: 1rem;">
                    <a href="${pageContext.request.contextPath}/login" style="color: var(--primary); text-decoration: none;">Back to Login</a>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>