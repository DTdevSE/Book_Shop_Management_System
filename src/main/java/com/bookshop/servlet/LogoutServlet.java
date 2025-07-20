package com.bookshop.servlet;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookshop.util.DBConnection;

@WebServlet("/AdminLogout")

public class LogoutServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {
	    try {
	        HttpSession session = request.getSession(false);
	        if (session != null && session.getAttribute("account_number") != null) {

	            int accountNumber = (int) session.getAttribute("account_number");

	            Connection conn = DBConnection.getConnection();
	            String updateSql = "UPDATE customers SET login_status = 'offline' WHERE account_number = ?";
	            PreparedStatement stmt = conn.prepareStatement(updateSql);
	            stmt.setInt(1, accountNumber);
	            stmt.executeUpdate();

	            session.invalidate(); // destroy session
	        }

	        response.sendRedirect("CustomerLogin.jsp");

	    } catch (Exception e) {
	        e.printStackTrace();
	        response.getWriter().println("Logout Error: " + e.getMessage());
	    }
	}

    }

