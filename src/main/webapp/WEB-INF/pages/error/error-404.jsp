<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>404 - Page Not Found | Basobas</title>
    <link href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Material+Symbols+Outlined:opsz,wght,FILL,GRAD@20..48,100..700,0..1,-50..200" rel="stylesheet">
    <style>
        * { margin: 0; padding: 0; box-sizing: border-box; }
        body { font-family: 'Manrope', sans-serif; background: #f5f4ed; min-height: 100vh; display: flex; align-items: center; justify-content: center; }
        .error-container { text-align: center; max-width: 500px; padding: 2rem; }
        .error-icon { font-size: 6rem; color: #73796f; margin-bottom: 1rem; }
        h1 { font-size: 8rem; font-weight: 800; color: #334f2b; margin-bottom: 0.5rem; }
        h2 { font-size: 1.8rem; margin-bottom: 1rem; color: #1b1c18; }
        p { color: #434840; margin-bottom: 2rem; }
        .btn { display: inline-flex; align-items: center; gap: 0.5rem; padding: 0.75rem 1.5rem; background: #334f2b; color: white; text-decoration: none; border-radius: 0.5rem; font-weight: 600; transition: opacity 0.2s; }
        .btn:hover { opacity: 0.9; }
    </style>
</head>
<body>
    <div class="error-container">
        <span class="material-symbols-outlined error-icon">error</span>
        <h1>404</h1>
        <h2>Page Not Found</h2>
        <p>The page you are looking for might have been removed, had its name changed, or is temporarily unavailable.</p>
        <a href="${pageContext.request.contextPath}/index" class="btn">
            <span class="material-symbols-outlined">home</span>
            Go to Homepage
        </a>
    </div>
</body>
</html>