package com.bookshop.Services.Store;

import com.bookshop.dao.BookDAO;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;


import java.util.Enumeration;

@WebServlet("/UpdateStockServlet")
public class UpdateStockServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private BookDAO bookDAO;

    @Override
    public void init() throws ServletException {
        bookDAO = new BookDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Get all parameter names
        Enumeration<String> paramNames = request.getParameterNames();

        while (paramNames.hasMoreElements()) {
            String paramName = paramNames.nextElement();

            // We only care about "stock_XXX" and "discount_XXX"
            if (paramName.startsWith("stock_")) {
                try {
                    // Extract book ID from param name
                    int bookId = Integer.parseInt(paramName.substring(6));
                    int stock = Integer.parseInt(request.getParameter(paramName));
                    String discountParam = request.getParameter("discount_" + bookId);
                    double discount = (discountParam != null && !discountParam.isEmpty()) ? Double.parseDouble(discountParam) : 0.0;

                    // Update the stock and discount in DB
                    bookDAO.updateBookStockAndDiscount(bookId, stock, discount);

                } catch (Exception e) {
                    e.printStackTrace(); // Log error
                }
            }
        }

        // Redirect to the same page or a success page
        response.sendRedirect("ManageStock.jsp?status=success");
    }
}

