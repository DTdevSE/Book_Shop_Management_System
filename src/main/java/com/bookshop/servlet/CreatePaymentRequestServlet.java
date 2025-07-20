package com.bookshop.servlet;

import com.bookshop.util.DBConnection;
import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/CreatePaymentRequestServlet")
public class CreatePaymentRequestServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

        String customerName = request.getParameter("customerName");
        double totalAmount = Double.parseDouble(request.getParameter("totalAmount"));
        String paymentMethod = request.getParameter("paymentMethod");
        int bookId = Integer.parseInt(request.getParameter("bookId"));
        int customerId = Integer.parseInt(request.getParameter("customerId"));

        try (Connection conn = DBConnection.getConnection()) {
            String sql = "INSERT INTO payment_requests (book_id, customer_id, customer_name, total_amount, payment_method, payment_time, status) VALUES (?, ?, ?, ?, ?, NOW(), 'Pending')";
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, bookId);
            ps.setInt(2, customerId);
            ps.setString(3, customerName);
            ps.setDouble(4, totalAmount);
            ps.setString(5, paymentMethod);

            int rows = ps.executeUpdate();
            ps.close();

            if (rows > 0) {
                response.sendRedirect("PendingPaymentsServlet"); // Redirect to show pending payments
            } else {
                response.getWriter().println("Failed to create payment request.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error: " + e.getMessage());
        }
    }
}
