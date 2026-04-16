package com.basobas.controller;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

/**
 * Servlet implementation class AuthController
 */
@WebServlet(urlPatterns = { "/login", "/register", "/logout" })
public class AuthController extends HttpServlet {
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/login":
                // Show login page
                request.getRequestDispatcher("/WEB-INF/pages/jsps/login.jsp").forward(request, response);
                break;
                
            case "/register":
                // Show register page
                request.getRequestDispatcher("/WEB-INF/pages/jsps/register.jsp").forward(request, response);
                break;
                
            case "/logout":
                // Logout
                request.getSession().invalidate();
                response.sendRedirect("login");
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String path = request.getServletPath();
        
        switch (path) {
            case "/login":
                // Process login
                break;
                
            case "/register":
                // Process registration
                break;
        }
    }
}