package com.bookshop.servlet;

import com.bookshop.util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;

@WebServlet("/HandlePaymentServlet")
public class HandlePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String paymentIdStr = request.getParameter("paymentId");
        String action = request.getParameter("action");

        if (paymentIdStr == null || action == null) {
            response.sendRedirect("pendingPayments.jsp"); // or error page
            return;
        }

        int paymentId = Integer.parseInt(paymentIdStr);
        String newStatus = null;

        if ("approve".equalsIgnoreCase(action)) {
            newStatus = "Approved";
        } else if ("reject".equalsIgnoreCase(action)) {
            newStatus = "Rejected";
        } else {
            response.sendRedirect("pendingPayments.jsp");
            return;
        }

        String sql = "UPDATE payment_requests SET status = ?, approval_time = NOW() WHERE payment_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, paymentId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }

        response.sendRedirect("PendingPaymentsServlet");
    }
}
