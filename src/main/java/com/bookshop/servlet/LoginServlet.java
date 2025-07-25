package com.bookshop.servlet;

import com.bookshop.dao.AccountDAO;
import com.bookshop.model.Account;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.time.LocalDateTime;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idNumber = request.getParameter("id_number");
        String password = request.getParameter("password");

        AccountDAO accountDAO = new AccountDAO();
        Account account = accountDAO.validateLogin(idNumber, password);

        if (account != null) {
            String role = account.getRole();

            HttpSession session = request.getSession();
            session.setAttribute("account", account);
            session.setAttribute("role", role);
            session.setAttribute("loginTime", LocalDateTime.now());

            switch (role.toLowerCase()) {
                case "admin":
                    response.sendRedirect("AdminHome.jsp");
                    break;
                case "user":
                    response.sendRedirect("user_dashboard.jsp");
                    break;
                case "store_keeper":
                    response.sendRedirect("Inventory Maintenance.jsp");
                    break;
                case "cashier":
                    response.sendRedirect("Cashierdashboard.jsp");
                    break;
                default:
                    session.setAttribute("error", "Unknown user role.");
                    response.sendRedirect("login.jsp");
            }
        } else {
            HttpSession session = request.getSession();
            session.setAttribute("error", "Invalid username or password.");
            response.sendRedirect("login.jsp");
        }
    }
}
