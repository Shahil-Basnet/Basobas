<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>About Us - Basobas</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&family=Public+Sans:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/styles.css">
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/public.css">
</head>
<body>
    <jsp:include page="/WEB-INF/includes/header.jsp" />
    
    <main>
        <div class="container" style="padding: 3rem 1rem;">
            <div style="max-width: 800px; margin: 0 auto; text-align: center;">
                <h1 style="font-size: 2.5rem; margin-bottom: 1rem;">About Basobas</h1>
                <p style="color: var(--on-surface-variant); margin-bottom: 2rem;">Making rental properties easier to find and manage in Nepal</p>
                
                <div style="text-align: left;">
                    <h2 style="margin: 1.5rem 0 1rem;">Our Mission</h2>
                    <p>To simplify the rental process by connecting landlords and tenants through a single, easy-to-use digital platform.</p>
                    
                    <h2 style="margin: 1.5rem 0 1rem;">What We Offer</h2>
                    <ul style="list-style: none; padding: 0;">
                        <li style="margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.5rem;">
                            <span class="material-symbols-outlined" style="color: var(--primary);">check_circle</span>
                            Easy property listing for landlords
                        </li>
                        <li style="margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.5rem;">
                            <span class="material-symbols-outlined" style="color: var(--primary);">check_circle</span>
                            Simple search and filter for tenants
                        </li>
                        <li style="margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.5rem;">
                            <span class="material-symbols-outlined" style="color: var(--primary);">check_circle</span>
                            Secure rental request system
                        </li>
                        <li style="margin-bottom: 0.75rem; display: flex; align-items: center; gap: 0.5rem;">
                            <span class="material-symbols-outlined" style="color: var(--primary);">check_circle</span>
                            Payment tracking and management
                        </li>
                    </ul>
                    
                    <h2 style="margin: 1.5rem 0 1rem;">Contact Us</h2>
                    <p>Have questions? Reach out to us at <a href="mailto:info@basobas.com" style="color: var(--primary);">info@basobas.com</a></p>
                </div>
            </div>
        </div>
    </main>
    
    <jsp:include page="/WEB-INF/includes/footer.jsp" />
</body>
</html>