package com.bookshop.Services.Store;

import com.bookshop.dao.BookDAO;
import com.bookshop.model.Book;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/OutOfStockBooksServlet")
public class OutOfStockBooksServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        BookDAO dao = new BookDAO();
        List<Book> outOfStockBooks = dao.getOutOfStockBooks();

        request.setAttribute("outOfStockBooks", outOfStockBooks);
        request.getRequestDispatcher("StockMonitoring.jsp").forward(request, response);
    }
}
