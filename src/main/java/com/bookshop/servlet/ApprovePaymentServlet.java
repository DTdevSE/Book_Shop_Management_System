package com.bookshop.servlet;

import com.bookshop.util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/ApprovePaymentServlet")
public class ApprovePaymentServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paymentId = request.getParameter("paymentId");
        String action = request.getParameter("action");  // "approve" or "reject"

        if (paymentId != null && !paymentId.isEmpty()) {

            String status = "Approved";  // default
            if ("reject".equalsIgnoreCase(action)) {
                status = "Rejected";
            }

            String sql = "UPDATE payment_requests SET status = ?, approval_time = NOW() WHERE payment_id = ?";

            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {

                ps.setString(1, status);
                ps.setInt(2, Integer.parseInt(paymentId));

                int updatedRows = ps.executeUpdate();

                if (updatedRows > 0) {
                    System.out.println("Payment " + paymentId + " " + status.toLowerCase() + " successfully.");
                } else {
                    System.out.println("No payment found with id: " + paymentId);
                }

            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        response.sendRedirect("PendingPaymentsServlet");
    }
}
