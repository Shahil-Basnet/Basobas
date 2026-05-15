package com.basobas.filter;

import java.io.IOException;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import com.basobas.model.User;

@WebFilter("/*")
public class AuthFilter implements Filter {

	@Override
	public void init(FilterConfig filterConfig) throws ServletException {
		// Initialization if needed
	}

	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {

		HttpServletRequest req = (HttpServletRequest) request;
		HttpServletResponse res = (HttpServletResponse) response;

		String path = req.getServletPath();
		String contextPath = req.getContextPath();

		// ========== PUBLIC PATHS (no login required) ==========
		if (isPublicPath(path)) {
			chain.doFilter(request, response);
			return;
		}

		// ========== CHECK IF USER IS LOGGED IN ==========
		HttpSession session = req.getSession(false);
		User currentUser = null;

		if (session != null) {
			currentUser = (User) session.getAttribute("loggedInUser");
		}

		if (currentUser == null) {
			// Not logged in - redirect to login page
			res.sendRedirect(contextPath + "/login");
			return;
		}

		// ========== ROLE-BASED ACCESS CONTROL ==========
		String role = currentUser.getRole();

		// Admin paths (only admin can access)
		if (path.startsWith("/admin/")) {
			if ("admin".equals(role)) {
				chain.doFilter(request, response);
			} else {
				// Non-admin trying to access admin area
				res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Admin only.");
			}
			return;
		}

		// Landlord paths (only landlord can access)
		if (path.startsWith("/landlord/")) {
			if ("landlord".equals(role)) {
				chain.doFilter(request, response);
			} else {
				// Non-landlord trying to access landlord area
				res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Landlord only.");
			}
			return;
		}

		// Tenant paths (only tenant can access)
		if (path.startsWith("/tenant/")) {
			if ("tenant".equals(role)) {
				chain.doFilter(request, response);
			} else {
				res.sendError(HttpServletResponse.SC_FORBIDDEN, "Access denied. Tenant only.");
			}
			return;
		}

		// For any other paths (like /dashboard, /profile, etc.) - any logged-in user
		// can access
		chain.doFilter(request, response);
	}

	private boolean isPublicPath(String path) {
		return path.equals("/") || path.equals("/login") || path.equals("/register") || path.startsWith("/css/")
				|| path.startsWith("/js/") || path.startsWith("/images/") || path.startsWith("/assets/")
				|| path.startsWith("/uploads/") || path.equals("/logout");
	}

	@Override
	public void destroy() {
		// Cleanup if needed
	}
}