<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Login | Basobas</title>
<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&amp;family=Public+Sans:wght@400;500;600&amp;display=swap"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css">
<style>
.icon-error::before {
	content: "⚠️";
}

</style>
</head>
<body>
	<!-- TopAppBar -->
	<header class="top-bar">
		<div class="flex justify-between items-center px-8 py-4">
			<div class="logo">Basobas</div>
			<div class="flex gap-4">
				<a class="nav-btn nav-btn-primary"
					href="${pageContext.request.contextPath}/register">Register</a>
			</div>
		</div>
	</header>

	<!-- Main Content -->
	<main class="flex-grow flex items-center justify-center px-6 py-16">
		<div class="w-full max-w-md card p-8 md:p-12">
			<div class="text-center mb-10">
				<h1
					class="text-3xl font-extrabold text-on-surface tracking-tight mb-2">Welcome
					Back</h1>
				<p class="text-on-surface-variant text-sm font-medium">Manage
					your estate with curated precision.</p>
			</div>

			<!-- Display error message if exists -->
			<%
				String error = (String) request.getAttribute("error");
				if (error != null && !error.isEmpty()) {
			%>
				<div class="error-alert" style="background-color: #fee2e2; color: #dc2626; padding: 12px; border-radius: 8px; margin-bottom: 20px;">
					<span class="error-icon">⚠️</span>
					<p class="error-text" style="margin: 0; display: inline-block;"><%= error %></p>
				</div>
			<%
				}
			%>

			<form class="space-y-6" action="${pageContext.request.contextPath}/login" method="post">
				<!-- Username Field -->
				<div class="input-group">
					<label class="form-label" for="username">Username</label> 
					<input class="estate-input" id="username" name="username"
						placeholder="Enter your username" type="text" required />
				</div>

				<!-- Password Field -->
				<div class="input-group">
					<div class="flex justify-between items-center">
						<label class="form-label" for="password">Password</label> 
						<a class="text-xs font-semibold text-primary hover:underline" href="#">Forgot password?</a>
					</div>
					<div class="password-wrapper">
						<input class="estate-input w-full" id="password" name="password"
							placeholder="••••••••" type="password" required />
						<button class="password-toggle" type="button" id="togglePassword">Show</button>
					</div>
				</div>

				<!-- Login Button -->
				<button class="btn-gradient" type="submit">Login</button>
			</form>

			<div class="divider text-center">
				<p class="text-sm text-on-surface-variant">
					Don't have an account? <a class="link ml-1"
						href="${pageContext.request.contextPath}/register">Register
						here</a>
				</p>
			</div>
		</div>
	</main>

	<!-- Footer -->
	<footer class="footer">
		<div
			class="flex flex-col md:flex-row justify-between items-center px-8 gap-4">
			<p class="text-sm text-on-surface-variant">© 2026 Basobas Estate
				Management. All rights reserved.</p>
			<nav class="flex gap-6">
				<a class="footer-link" href="#">Privacy Policy</a> 
				<a class="footer-link" href="#">Terms of Service</a> 
				<a class="footer-link" href="#">Contact Support</a>
			</nav>
		</div>
	</footer>

	<script>
		var toggleBtn = document.getElementById('togglePassword');
		var passwordInput = document.getElementById('password');
		if (toggleBtn && passwordInput) {
			toggleBtn
					.addEventListener(
							'click',
							function() {
								var type = passwordInput.getAttribute('type') === 'password' ? 'text'
										: 'password';
								passwordInput.setAttribute('type', type);
								toggleBtn.textContent = type === 'password' ? 'Show'
										: 'Hide';
							});
		}
	</script>
</body>
</html>