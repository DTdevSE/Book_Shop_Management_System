package com.bookshop.servlet;

import com.bookshop.dao.BuyRequestDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/RemoveFromCartServlet")
public class RemoveFromCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private BuyRequestDAO buyRequestDAO = new BuyRequestDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String reqIdStr = request.getParameter("requestId");
        if (reqIdStr != null) {
            try {
                int requestId = Integer.parseInt(reqIdStr);

                boolean deleted = buyRequestDAO.deleteRequestById(requestId);

                if (deleted) {
                    // Optional: add a message in session or request to show confirmation
                    HttpSession session = request.getSession();
                    session.setAttribute("message", "Item removed from cart successfully.");
                } else {
                    HttpSession session = request.getSession();
                    session.setAttribute("message", "Failed to remove item from cart.");
                }
            } catch (NumberFormatException e) {
                // Invalid requestId parameter
                e.printStackTrace();
            }
        }
        // Redirect back to cart page after removal
        response.sendRedirect("cart.jsp");
    }

    // doPost can just call doGet if you want
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        doGet(request, response);
    }
}
