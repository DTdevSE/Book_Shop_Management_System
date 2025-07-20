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
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
	        throws ServletException, IOException {

	    String idNumber = request.getParameter("id_number");
	    String password = request.getParameter("password");
	    String role = request.getParameter("role"); // get selected role

	    AccountDAO accountDAO = new AccountDAO();
	    Account account = accountDAO.validateLogin(idNumber, password, role); // pass role too

	    if (account != null) {
	        HttpSession session = request.getSession();
	        session.setAttribute("account", account);
	        session.setAttribute("loginTime", LocalDateTime.now());

	        switch (role) {
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
	                response.sendRedirect("login.jsp?error=invalidrole");
	                break;
	        }
	    } else {
	        response.sendRedirect("login.jsp?error=invalid");
	    }
	}

    
}
