<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<footer class="footer">
	<div class="container">
		<div class="footer-grid">
			<div class="footer-brand">
				<h3>Basobas</h3>
				<p>Find your perfect rental home in Nepal. Connect directly with
					landlords, no brokerage fees.</p>
				<div class="social-links">
					<a href="#" class="social-link" title="Facebook"> 
						<i class="fab fa-facebook-f"></i>
					</a> <a href="#" class="social-link" title="Instagram"> 
						<i class="fab fa-instagram"></i>
					</a> <a href="#" class="social-link" title="Twitter"> 
						<i class="fab fa-twitter"></i>
					</a>
				</div>
			</div>

			<div class="footer-links">
				<h4>For Tenants</h4>
				<ul>
					<li><a href="${pageContext.request.contextPath}/properties">Browse
							Properties</a></li>
					<li><a
						href="${pageContext.request.contextPath}/tenant/rentals">My
							Rentals</a></li>
					<li><a
						href="${pageContext.request.contextPath}/tenant/requests">Rental
							Requests</a></li>
					<li><a
						href="${pageContext.request.contextPath}/tenant/payments">Payments</a></li>
				</ul>
			</div>

			<div class="footer-links">
				<h4>For Landlords</h4>
				<ul>
					<li><a
						href="${pageContext.request.contextPath}/landlord/properties?action=add">List
							Property</a></li>
					<li><a
						href="${pageContext.request.contextPath}/landlord/properties">Manage
							Properties</a></li>
				</ul>
			</div>

			<div class="footer-links">
				<h4>Company</h4>
				<ul>
					<li><a href="${pageContext.request.contextPath}/about">About
							Us</a></li>
					<li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>
					<li><a href="#">Privacy Policy</a></li>
					<li><a href="#">Terms of Service</a></li>
				</ul>
			</div>
		</div>

		<div class="footer-bottom">
			<p>&copy; 2026 Basobas. All rights reserved.</p>
			<p class="footer-note">Making rental easy in Nepal 🏔️</p>
		</div>
	</div>
</footer>

</body>
</html>