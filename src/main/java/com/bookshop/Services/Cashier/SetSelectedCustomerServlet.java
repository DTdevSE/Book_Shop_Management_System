package com.bookshop.Services.Cashier;

import java.io.PrintWriter;

import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.bookshop.dao.CartDAO;
import com.itextpdf.io.IOException;

@WebServlet("/SetSelectedCustomerServlet")
public class SetSelectedCustomerServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException, java.io.IOException {
        String customerIdStr = request.getParameter("customerId");
        response.setContentType("application/json");
        try (PrintWriter out = response.getWriter()) {
            if (customerIdStr != null) {
                int customerId = Integer.parseInt(customerIdStr);
                HttpSession session = request.getSession();
                session.setAttribute("selectedCustomerId", customerId);

                // Get cart count for this customer
                CartDAO cartDAO = new CartDAO();
                int cartCount = cartDAO.getCartItemCount(customerId);

                out.print("{\"success\":true, \"cartCount\":" + cartCount + "}");
            } else {
                out.print("{\"success\":false, \"message\":\"Missing customerId\"}");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().print("{\"success\":false, \"message\":\"" + e.getMessage() + "\"}");
        }
    }
}

