package com.bookshop.Services.Cashier;

import com.bookshop.dao.BookDAO;
import com.bookshop.model.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/BillingDashboard")
public class CashierViewBooksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // OOP: DAO Object to interact with DB
        BookDAO bookDAO = new BookDAO();

        // Get list of books in stock
        List<Book> availableBooks = bookDAO.getAvailableBooks();

        // Pass to JSP
        request.setAttribute("availableBooks", availableBooks);
        request.getRequestDispatcher("/BillingDashboard.jsp").forward(request, response);
    }
}
