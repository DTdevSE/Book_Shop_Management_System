package com.bookshop.servlet;

import java.io.*;
import java.sql.*;
import com.bookshop.dao.AdminUserDAO;
import com.bookshop.model.AdminUser;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/AdminLogin")
public class AdminLoginServlet extends HttpServlet { 
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username"); // fixed parameter name
        String password = request.getParameter("password");

        AdminUser admin = new AdminUser(username, password);

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection conn = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/book_shop_db", "root", "Dinitha@1234");

            AdminUserDAO dao = new AdminUserDAO(conn);

            if (dao.validateAdmin(admin)) {
                HttpSession session = request.getSession();
                session.setAttribute("adminUser", username);
                response.sendRedirect("AdminHome.jsp");
            } else {
                response.sendRedirect("AdminLogin.jsp?error=1");
            }

            conn.close();
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Database Error: " + e.getMessage());
        }
    }
}
