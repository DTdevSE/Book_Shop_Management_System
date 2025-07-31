package com.bookshop.servlet;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/FinalPaymentServlet")
public class FinalPaymentServlet extends HttpServlet {
    
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String requestIdStr = request.getParameter("requestId");
        String customerName = request.getParameter("customerName");
        //String bookName = request.getParameter("bookName");
        String totalAmountStr = request.getParameter("totalAmount");
        String paymentMethod = request.getParameter("paymentMethod");

        int requestId = Integer.parseInt(requestIdStr);
        double totalAmount = Double.parseDouble(totalAmountStr);

        Connection conn = null;
        PreparedStatement psSelect = null;
        PreparedStatement psInsert = null;
        ResultSet rs = null;

        try {
            // DB Connection
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/book_shop_db", "root", "Dinitha@1234");

            // Get book_id, customer_id, quantity
            String selectSQL = "SELECT book_id, account_number, quantity FROM buy_requests WHERE id = ?";
            psSelect = conn.prepareStatement(selectSQL);
            psSelect.setInt(1, requestId);
            rs = psSelect.executeQuery();

            if (rs.next()) {
                int bookId = rs.getInt("book_id");
                int customerId = rs.getInt("account_number");
                int quantity = rs.getInt("quantity");

                // Get book price
                String priceSQL = "SELECT price FROM books WHERE id = ?";
                PreparedStatement psPrice = conn.prepareStatement(priceSQL);
                psPrice.setInt(1, bookId);
                ResultSet rsPrice = psPrice.executeQuery();

                double pricePerUnit = 0.0;
                if (rsPrice.next()) {
                    pricePerUnit = rsPrice.getDouble("price");
                }
                rsPrice.close();
                psPrice.close();

                // Insert Payment Request
                String insertSQL = "INSERT INTO payment_requests "
                        + "(request_id, book_id, customer_id, customer_name, price_per_unit, quantity, total_amount, payment_method) "
                        + "VALUES (?, ?, ?, ?, ?, ?, ?, ?)";

                psInsert = conn.prepareStatement(insertSQL);
                psInsert.setInt(1, requestId);
                psInsert.setInt(2, bookId);
                psInsert.setInt(3, customerId);
                psInsert.setString(4, customerName);
                psInsert.setDouble(5, pricePerUnit);
                psInsert.setInt(6, quantity);
                psInsert.setDouble(7, totalAmount);
                psInsert.setString(8, paymentMethod);

                int result = psInsert.executeUpdate();

                if (result > 0) {
                    response.sendRedirect("paymentPending.jsp");
                } else {
                    response.getWriter().println("Failed to insert payment request.");
                }

            } else {
                response.getWriter().println("Buy request not found.");
            }

        } catch (Exception e) {
            e.printStackTrace(response.getWriter());
        } finally {
            try {
                if (rs != null) rs.close();
                if (psSelect != null) psSelect.close();
                if (psInsert != null) psInsert.close();
                if (conn != null) conn.close();
            } catch (SQLException ignore) {}
        }
    }
}
