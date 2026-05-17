document.addEventListener('DOMContentLoaded', function() {
	// Mobile menu toggle
	const mobileBtn = document.getElementById('mobileMenuBtn');
	const mobileNav = document.getElementById('mobileNav');

	if (mobileBtn && mobileNav) {
		mobileBtn.addEventListener('click', function() {
			mobileNav.classList.toggle('active');
		});
	}
});
