<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8" />
<meta name="viewport" content="width=device-width, initial-scale=1.0" />
<title>Register | Basobas</title>
<link
	href="https://fonts.googleapis.com/css2?family=Manrope:wght@400;600;700;800&amp;family=Public+Sans:wght@400;500;600&amp;display=swap"
	rel="stylesheet" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/css/styles.css">
</head>
<body>
	<!-- TopAppBar -->
	<header class="top-bar">
		<div class="flex justify-between items-center px-8 py-4">
			<div class="logo">Basobas</div>
			<div class="flex gap-4">
				<a class="nav-btn nav-btn-primary"
					href="${pageContext.request.contextPath}/login">Login</a>
			</div>
		</div>
	</header>

	<!-- Main Content -->
	<main class="flex-grow flex items-center justify-center py-16 px-4">
		<div class="w-full max-w-xl card p-8 md:p-12">
			<div class="text-center mb-10">
				<h1 class="text-3xl font-extrabold text-primary mb-2">Join the
					Estate</h1>
				<p class="text-on-surface-variant">Complete your profile to
					access premium property management services.</p>
			</div>

			<form class="space-y-6">
				<!-- Account Security Group -->
				<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
					<div class="input-group">
						<label class="form-label">Username*</label> <input
							class="estate-input" placeholder="unique_handle" required
							type="text" />
					</div>
					<div class="input-group">
						<label class="form-label">Email*</label> <input
							class="estate-input" placeholder="name@domain.com" required
							type="email" />
					</div>
				</div>

				<div class="input-group">
					<label class="form-label">Password*</label>
					<div class="password-wrapper">
						<input class="estate-input w-full" placeholder="••••••••" required
							type="password" id="regPassword" />
						<button class="password-toggle" type="button"
							id="toggleRegPassword">SHOW</button>
					</div>
				</div>

				<!-- Identity Panel -->
				<div class="p-6 bg-surface-container-low rounded-xl space-y-6">
					<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
						<div class="input-group">
							<label class="form-label">Full Name</label> <input
								class="estate-input" placeholder="Eleanor Vance" type="text" />
						</div>
						<div class="input-group">
							<label class="form-label">Phone</label> <input
								class="estate-input" placeholder="+1 (555) 000-0000" type="tel" />
						</div>
					</div>

					<div class="grid grid-cols-1 md:grid-cols-2 gap-6">
						<div class="input-group">
							<label class="form-label">Date of Birth</label> <input
								class="estate-input" type="date" />
						</div>
						<div class="input-group">
							<label class="form-label">I am a</label> <select
								class="estate-input">
								<option value="tenant">Tenant</option>
								<option value="landlord">Landlord</option>
							</select>
						</div>
					</div>
				</div>

				<!-- Register Button -->
				<button class="btn-gradient" type="submit">Register</button>

				<div class="text-center pt-2">
					<a class="text-link text-sm" href="${pageContext.request.contextPath}/login">Already have an account?
						<span class="link-underline">Login here</span>
					</a>
				</div>
			</form>
		</div>
	</main>

	<!-- Footer -->
	<footer class="footer">
		<div
			class="flex flex-col md:flex-row justify-between items-center px-8 gap-4">
			<p class="text-sm text-on-surface-variant">© 2024 Basobas Estate
				Management. All rights reserved.</p>
			<nav class="flex gap-6">
				<a class="footer-link" href="#">Privacy Policy</a> <a
					class="footer-link" href="#">Terms of Service</a> <a
					class="footer-link" href="#">Contact Support</a>
			</nav>
		</div>
	</footer>

	<script>
		var regToggle = document.getElementById('toggleRegPassword');
		var regPassword = document.getElementById('regPassword');
		if (regToggle && regPassword) {
			regToggle
					.addEventListener(
							'click',
							function() {
								var type = regPassword.getAttribute('type') === 'password' ? 'text'
										: 'password';
								regPassword.setAttribute('type', type);
								regToggle.textContent = type === 'password' ? 'Show'
										: 'Hide';
							});
		}
	</script>
</body>
</html>