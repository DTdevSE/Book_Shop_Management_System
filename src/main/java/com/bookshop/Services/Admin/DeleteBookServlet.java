package com.bookshop.Services.Admin;
import com.bookshop.dao.BookDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteBookServlet")
public class DeleteBookServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        int bookId = Integer.parseInt(request.getParameter("id"));

        BookDAO dao = new BookDAO();
        dao.deleteBook(bookId);

        response.sendRedirect("View_books.jsp?delete=success");
    }
}