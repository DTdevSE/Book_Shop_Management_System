package com.bookshop.servlet;

import com.bookshop.util.DBConnection;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/CustomerLogin")  // Matches form action in your login form
public class LoginCustomerServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get input values
            int accountNumber = Integer.parseInt(request.getParameter("account_number")); // input type="number"
            String password = request.getParameter("password");

            // Get DB connection
            Connection conn = DBConnection.getConnection();

            // Query by account number
            String sql = "SELECT * FROM customers WHERE account_number = ?";
            PreparedStatement stmt = conn.prepareStatement(sql);
            stmt.setInt(1, accountNumber);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");

                // Compare entered password with hashed one
                if (BCrypt.checkpw(password, hashedPassword)) {

                    // Update login status to 'online'
                    String updateSql = "UPDATE customers SET login_status = 'online' WHERE account_number = ?";
                    PreparedStatement updateStmt = conn.prepareStatement(updateSql);
                    updateStmt.setInt(1, accountNumber);
                    updateStmt.executeUpdate();

                    HttpSession session = request.getSession();
                    session.setAttribute("account_number", accountNumber);
                    session.setAttribute("customerName", rs.getString("name"));
                    session.setAttribute("profileImage", rs.getString("profile_image"));


                    response.sendRedirect("Home.jsp"); // or any dashboard page
                } else {
                    response.getWriter().println("Invalid password.");
                }
            } else {
                response.getWriter().println("Account not found.");
            }

        } catch (NumberFormatException e) {
            response.getWriter().println("Invalid account number format.");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Login Error: " + e.getMessage());
        }
    }
}
