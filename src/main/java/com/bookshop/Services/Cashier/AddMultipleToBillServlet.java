package com.bookshop.Services.Cashier;

import com.bookshop.dao.*;
import com.bookshop.model.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.*;

@WebServlet("/AddMultipleToBillServlet")
public class AddMultipleToBillServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Step 1: Validate customer ID param
        String customerIdStr = request.getParameter("customerId");
        if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
            forwardWithError("Customer ID is required.", request, response);
            return;
        }

        int customerId;
        try {
            customerId = Integer.parseInt(customerIdStr);
        } catch (NumberFormatException e) {
            forwardWithError("Customer ID is not valid, please check.", request, response);
            return;
        }

        // Step 2: Validate selected books
        String[] selectedBookIds = request.getParameterValues("selectedBooks");
        if (selectedBookIds == null || selectedBookIds.length == 0) {
            forwardWithError("No books selected.", request, response);
            return;
        }

        BookDAO bookDAO = new BookDAO();
        List<BillItem> billItems = new ArrayList<>();
        double totalBill = 0;

        try {
            for (String bookIdStr : selectedBookIds) {
                int bookId = Integer.parseInt(bookIdStr);

                String qtyStr = request.getParameter("quantity_" + bookId);
                int quantity = 1;
                try {
                    quantity = Integer.parseInt(qtyStr);
                    if (quantity < 1) quantity = 1;
                } catch (NumberFormatException ex) {
                    quantity = 1; // fallback to 1 if invalid
                }

                Book book = bookDAO.getBookById(bookId);
                if (book == null) continue;

                if (quantity > book.getStockQuantity()) {
                    forwardWithError("Quantity for book " + book.getName() + " exceeds available stock.", request, response);
                    return;
                }

                double discount = book.getDiscount();
                double unitPrice = book.getPrice();
                double discountedPrice = unitPrice - (unitPrice * discount / 100);
                double itemTotal = discountedPrice * quantity;

                BillItem item = new BillItem();
                item.setBookId(bookId);
                item.setBookName(book.getName());
                item.setPrice(unitPrice);
                item.setDiscount(discount);
                item.setQuantity(quantity);
                item.setTotal(itemTotal);

                totalBill += itemTotal;
                billItems.add(item);
            }

            // Step 3: Create Bill
            Bill bill = new Bill();
            bill.setCustomerId(customerId);
            bill.setTotalAmount(totalBill);

            BillDAO billDAO = new BillDAO();
            int billId = billDAO.createBill(bill);

            BillItemDAO billItemDAO = new BillItemDAO();

            for (BillItem item : billItems) {
                item.setBillId(billId);
                billItemDAO.createBillItem(item);

                boolean success = bookDAO.reduceStock(item.getBookId(), item.getQuantity());
                if (!success) {
                    forwardWithError("Failed to deduct stock for book: " + item.getBookName(), request, response);
                    return;
                }
            }

            // Step 4: Load Customer for JSP
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerId);

            // Step 5: Pass to JSP
            request.setAttribute("bill", billDAO.getBillById(billId));
            request.setAttribute("billItems", billItemDAO.getItemsByBillId(billId));
            request.setAttribute("customer", customer);
            request.getRequestDispatcher("/Bill.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError("Billing error: " + e.getMessage(), request, response);
        }
    }

    private void forwardWithError(String errorMsg, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", errorMsg);
        request.getRequestDispatcher("/BillingDashboard.jsp").forward(request, response);
    }
}

