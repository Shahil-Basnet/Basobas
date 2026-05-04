//package com.basobas.filter;
//
//import java.io.IOException;
//import jakarta.servlet.Filter;
//import jakarta.servlet.FilterChain;
//import jakarta.servlet.FilterConfig;
//import jakarta.servlet.ServletException;
//import jakarta.servlet.ServletRequest;
//import jakarta.servlet.ServletResponse;
//import jakarta.servlet.annotation.WebFilter;
//import jakarta.servlet.http.HttpServletRequest;
//import jakarta.servlet.http.HttpServletResponse;
//import jakarta.servlet.http.HttpSession;
//
//@WebFilter("/*")
//public class AuthFilter implements Filter {
//    
//    @Override
//    public void init(FilterConfig filterConfig) throws ServletException {
//        // Initialization if needed
//    }
//    
//    @Override
//    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
//            throws IOException, ServletException {
//        
//        HttpServletRequest req = (HttpServletRequest) request;
//        HttpServletResponse res = (HttpServletResponse) response;
//        
//        String path = req.getServletPath();
//        
//        // Public paths (no login required)
//        if (path.equals("/") ||
//            path.equals("/login") ||
//            path.equals("/register") ||
//            path.startsWith("/css/") ||
//            path.startsWith("/js/") ||
//            path.startsWith("/images/")) {
//            chain.doFilter(request, response);
//            return;
//        }
//        
//        // Check if user is logged in
//        HttpSession session = req.getSession(false);
//        
//        if (session != null && session.getAttribute("loggedInUser") != null) {
//            // User is logged in - allow access
//            chain.doFilter(request, response);
//        } else {
//            // Not logged in - redirect to login page
//            res.sendRedirect(req.getContextPath() + "/login");
//        }
//    }
//    
//    @Override
//    public void destroy() {
//        // Cleanup if needed
//    }
//}