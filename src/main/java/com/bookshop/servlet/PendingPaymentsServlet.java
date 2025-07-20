package com.bookshop.servlet;

import com.bookshop.util.DBConnection;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;
import java.sql.*;
import java.util.*;

@WebServlet("/PendingPaymentsServlet")
public class PendingPaymentsServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<Map<String, Object>> payments = new ArrayList<>();

        String sql = "SELECT payment_id, customer_name, total_amount, payment_method, payment_time FROM payment_requests WHERE status = 'Pending'";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> payment = new HashMap<>();
                payment.put("payment_id", rs.getInt("payment_id"));
                payment.put("customer_name", rs.getString("customer_name"));
                payment.put("total_amount", rs.getDouble("total_amount"));
                payment.put("payment_method", rs.getString("payment_method"));
                payment.put("payment_time", rs.getTimestamp("payment_time"));
                payments.add(payment);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        request.setAttribute("payments", payments);
        request.getRequestDispatcher("pendingPayments.jsp").forward(request, response);
    }
}
