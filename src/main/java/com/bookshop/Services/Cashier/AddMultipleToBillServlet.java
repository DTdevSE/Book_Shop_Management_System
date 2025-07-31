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

        // Step 1: Validate Customer ID
        String customerIdStr = request.getParameter("customerId");
        if (customerIdStr == null || customerIdStr.isEmpty()) {
            forwardWithError("Customer ID is required.", request, response);
            return;
        }

        int customerId;
        try {
            customerId = Integer.parseInt(customerIdStr);
        } catch (NumberFormatException e) {
            forwardWithError("Customer ID must be a number.", request, response);
            return;
        }

        // Step 2: Validate selected books
        String[] selectedBookIds = request.getParameterValues("selectedBooks");
        if (selectedBookIds == null || selectedBookIds.length == 0) {
            forwardWithError("No books selected for billing.", request, response);
            return;
        }

        // Step 3: Validate Payment Inputs
        String paymentMethod = request.getParameter("paymentMethod");
        String amountGivenStr = request.getParameter("amountGiven");
        String shippingAddress = request.getParameter("shippingAddress");

        if (paymentMethod == null || paymentMethod.trim().isEmpty()) {
            forwardWithError("Payment method is required.", request, response);
            return;
        }

        double amountGiven;
        try {
            amountGiven = Double.parseDouble(amountGivenStr);
        } catch (NumberFormatException e) {
            forwardWithError("Invalid amount given.", request, response);
            return;
        }

        BookDAO bookDAO = new BookDAO();
        List<BillItem> billItems = new ArrayList<>();
        double totalBill = 0;

        try {
            // Step 4: Build Bill Items
            for (String bookIdStr : selectedBookIds) {
                int bookId = Integer.parseInt(bookIdStr);
                String qtyStr = request.getParameter("quantity_" + bookId);
                int quantity = 1;

                try {
                    quantity = Integer.parseInt(qtyStr);
                    if (quantity < 1) quantity = 1;
                } catch (NumberFormatException ignored) {}

                Book book = bookDAO.getBookById(bookId);
                if (book == null) continue;

                if (quantity > book.getStockQuantity()) {
                    forwardWithError("Not enough stock for book: " + book.getName(), request, response);
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
                

                totalBill += itemTotal;
                billItems.add(item);
            }

            // Step 5: Validate Payment Logic
            double changeDue = amountGiven - totalBill;
            if (changeDue < 0) {
                forwardWithError("Amount given is less than total bill.", request, response);
                return;
            }

            // Step 6: Save Bill
            Bill bill = new Bill();
            bill.setCustomerId(customerId);
            bill.setTotalAmount(totalBill);
            bill.setPaymentMethod(paymentMethod);
            bill.setAmountGiven(amountGiven);
            bill.setChangeDue(changeDue);
            bill.setShippingAddress(shippingAddress);

            BillDAO billDAO = new BillDAO();
            int billId = billDAO.insertBill(bill); // returns generated bill ID

            // Step 7: Save Bill Items
            BillItemDAO billItemDAO = new BillItemDAO();
            for (BillItem item : billItems) {
                item.setBillId(billId);
                billItemDAO.insertBillItem(item);
                bookDAO.reduceStock(item.getBookId(), item.getQuantity());
            }

            // Step 8: Fetch customer and forward
            CustomerDAO customerDAO = new CustomerDAO();
            Customer customer = customerDAO.getCustomerById(customerId);

            request.setAttribute("bill", billDAO.getBillById(billId));
            request.setAttribute("billItems", billItemDAO.getItemsByBillId(billId));
            request.setAttribute("customer", customer);

            request.getRequestDispatcher("/Bill.jsp").forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            forwardWithError("Billing failed: " + e.getMessage(), request, response);
        }
    }

    private void forwardWithError(String error, HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.setAttribute("error", error);
        request.getRequestDispatcher("/BillingDashboard.jsp").forward(request, response);
    }
}
