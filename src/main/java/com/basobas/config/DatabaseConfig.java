package com.basobas.config;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBConnection provides the central database connectivity for the application.
 * It uses the MySQL JDBC driver to connect to the database.
 */
public class DatabaseConfig {
    // Database URL, credentials and driver configuration
	private static final String DB_NAME = "basobas";
	//"?useSSL=false&serverTimezone=UTC" : this forces the connection to use UTC timezone, preventing timestamp/datetime mismatches between Java app and MySQL server 
	private static final String URL = "jdbc:mysql://localhost:3306/" + DB_NAME + "?useSSL=false&serverTimezone=UTC"; 
    private static final String USER = "root";
    private static final String PASSWORD = ""; 

    static {
        try {
            // Registering the JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    /**
     * Establishes and returns a database connection.
     */
    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
