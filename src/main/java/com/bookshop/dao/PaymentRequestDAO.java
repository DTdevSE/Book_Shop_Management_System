package com.bookshop.dao;

import com.bookshop.util.DBConnection;
import java.sql.*;

public class PaymentRequestDAO {

    public String getPaymentStatusByRequestId(int requestId) {
        String status = "No Request";

        String sql = "SELECT status FROM payment_requests WHERE request_id = ? ORDER BY payment_time DESC LIMIT 1";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                status = rs.getString("status");
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return status;
    }

        
        public boolean createPaymentRequest(int requestId, String paymentMethod) {
            String sql = "INSERT INTO payment_requests (request_id, payment_method) VALUES (?, ?)";
            try (Connection conn = DBConnection.getConnection();
                 PreparedStatement ps = conn.prepareStatement(sql)) {
                 
                ps.setInt(1, requestId);
                ps.setString(2, paymentMethod);
                int rows = ps.executeUpdate();
                return rows > 0;
            } catch (SQLException e) {
                e.printStackTrace();
            }
            return false;
        }

}

