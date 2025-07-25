package com.bookshop.Services.Cashier;

import com.bookshop.dao.BillDAO;
import com.bookshop.dao.BillItemDAO;
import com.bookshop.dao.BookDAO;
import com.bookshop.dao.CartDAO;
import com.bookshop.model.Bill;
import com.bookshop.model.BillItem;
import com.bookshop.model.CartItem;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/CheckoutServlet")
public class CheckoutServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        String customerIdStr = request.getParameter("customerId");
        String totalAmountStr = request.getParameter("totalAmount");
        String paymentMethod = request.getParameter("paymentMethod");
        String amountGivenStr = request.getParameter("amountGiven");
        String shippingAddress = request.getParameter("shippingAddress");

        // Basic validation
        if (customerIdStr == null || totalAmountStr == null || paymentMethod == null || amountGivenStr == null || shippingAddress == null
                || customerIdStr.trim().isEmpty() || totalAmountStr.trim().isEmpty() || paymentMethod.trim().isEmpty() || amountGivenStr.trim().isEmpty()
                || shippingAddress.trim().isEmpty()) {
            request.setAttribute("error", "All fields are required.");
            request.getRequestDispatcher("Checkout.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            double totalAmount = Double.parseDouble(totalAmountStr);
            double amountGiven = Double.parseDouble(amountGivenStr);

            if (amountGiven < totalAmount) {
                request.setAttribute("error", "Amount given cannot be less than total amount.");
                request.getRequestDispatcher("Checkout.jsp").forward(request, response);
                return;
            }

            double changeDue = amountGiven - totalAmount;

            CartDAO cartDAO = new CartDAO();
            BookDAO bookDAO = new BookDAO();
            BillDAO billDAO = new BillDAO();
            BillItemDAO billItemDAO = new BillItemDAO();

            // Get Cart Items for this customer
            List<CartItem> cartItems = cartDAO.getCartItemsByCustomer(customerId);

            if (cartItems.isEmpty()) {
                request.setAttribute("error", "Cart is empty. Cannot checkout.");
                request.getRequestDispatcher("Checkout.jsp").forward(request, response);
                return;
            }

            // Deduct stock for each cart item
            for (CartItem cartItem : cartItems) {
                boolean stockDeducted = bookDAO.reduceStock(cartItem.getBookId(), cartItem.getQuantity());
                if (!stockDeducted) {
                    request.setAttribute("error", "Insufficient stock for book: " + cartItem.getBookName());
                    request.getRequestDispatcher("Checkout.jsp").forward(request, response);
                    return; // stop processing checkout
                }
            }

            // Create Bill
            Bill bill = new Bill();
            bill.setCustomerId(customerId);
            bill.setTotalAmount(totalAmount);
            bill.setPaymentMethod(paymentMethod);
            bill.setAmountGiven(amountGiven);
            bill.setChangeDue(changeDue);
            bill.setShippingAddress(shippingAddress);

            int billId = billDAO.insertBill(bill);

            // Insert Bill Items
            for (CartItem cartItem : cartItems) {
                BillItem billItem = new BillItem();
                billItem.setBillId(billId);
                billItem.setBookId(cartItem.getBookId());
                billItem.setBookName(cartItem.getBookName());
                billItem.setPrice(cartItem.getPrice());
                billItem.setQuantity(cartItem.getQuantity());
                billItem.setDiscount(cartItem.getDiscount());

                billItemDAO.insertBillItem(billItem);
            }

            // Clear Cart after successful checkout
            cartDAO.clearCartByCustomer(customerId);

            // Remove selected customer session attribute if exists
            HttpSession session = request.getSession(false);
            if (session != null) {
                session.removeAttribute("selectedCustomerId");
            }

            // Redirect to Bill Summary page
            response.sendRedirect("BillSummary.jsp?billId=" + billId);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid number format.");
            request.getRequestDispatcher("Checkout.jsp").forward(request, response);
        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Database error during checkout.");
            request.getRequestDispatcher("Checkout.jsp").forward(request, response);
        }
    }
}
