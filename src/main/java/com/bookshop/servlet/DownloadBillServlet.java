package com.bookshop.servlet;

import java.io.IOException;
import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

import com.bookshop.dao.BookDAO;
import com.bookshop.dao.BuyRequestDAO;
import com.bookshop.model.Book;
import com.bookshop.model.BuyRequest;

@WebServlet("/DownloadBillServlet") // You can rename to "ViewBillServlet" if displaying instead of downloading
public class DownloadBillServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		int requestId;
		try {
			requestId = Integer.parseInt(request.getParameter("requestId"));
		} catch (NumberFormatException e) {
			response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid request ID");
			return;
		}

		BuyRequestDAO buyRequestDAO = new BuyRequestDAO();
		BookDAO bookDAO = new BookDAO();

		BuyRequest br = buyRequestDAO.getRequestById(requestId);
		if (br == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "Buy request not found.");
			return;
		}

		Book book = bookDAO.getBookById(br.getBookId());
		if (book == null) {
			response.sendError(HttpServletResponse.SC_NOT_FOUND, "Book not found.");
			return;
		}

		// Calculation
		double unitPrice = book.getPrice();
		double discount = book.getDiscount();
		int quantity = br.getQuantity();
		double subtotal = unitPrice * quantity;
		double discountAmount = subtotal * discount / 100;
		double deliveryCharge = "Drazee".equalsIgnoreCase(br.getCustomerAddress()) ? 300.0 :
								"Colombo".equalsIgnoreCase(br.getCustomerAddress()) ? 200.0 : 350.0;
		double total = subtotal - discountAmount + deliveryCharge;

		LocalDate placedDate = br.getRequestTime().toLocalDate();
		LocalDate arrivalDate = placedDate.plusDays(3);

		// Pass all values to JSP
		request.setAttribute("customerName", br.getCustomerName());
		request.setAttribute("bookName", book.getName());
		request.setAttribute("category", book.getCategory());
		request.setAttribute("orderDate", placedDate);
		request.setAttribute("arrivalDate", arrivalDate);
		request.setAttribute("unitPrice", unitPrice);
		request.setAttribute("quantity", quantity);
		request.setAttribute("subtotal", subtotal);
		request.setAttribute("discountAmount", discountAmount);
		request.setAttribute("deliveryCharge", deliveryCharge);
		request.setAttribute("deliveryLocation", br.getCustomerAddress()); // ✅ DELIVERY LOCATION
		request.setAttribute("total", total);

		// Forward to JSP page for display
		request.getRequestDispatcher("/viewBill.jsp").forward(request, response);
	}
}
