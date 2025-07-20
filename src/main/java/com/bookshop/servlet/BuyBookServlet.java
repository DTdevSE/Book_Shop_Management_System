package com.bookshop.servlet;

import com.bookshop.dao.BuyRequestDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/BuyBook")
public class BuyBookServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            HttpSession session = request.getSession(false);
            if (session == null || session.getAttribute("account_number") == null) {
                System.out.println("No session/account number found.");
                response.sendRedirect("CustomerLogin.jsp");
                return;
            }

            int accountNumber = (Integer) session.getAttribute("account_number");
            int bookId = Integer.parseInt(request.getParameter("bookId"));
            int quantity = Integer.parseInt(request.getParameter("quantity"));

            BuyRequestDAO dao = new BuyRequestDAO();
            boolean added = dao.addRequest(accountNumber, bookId, quantity);

            if (added) {
                response.sendRedirect("cart.jsp");
            } else {
                response.sendRedirect("error.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp");
        }
    }
}
