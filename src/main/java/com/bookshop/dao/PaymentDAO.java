package com.bookshop.dao;

import com.bookshop.model.Payment;
import com.bookshop.util.DBConnection;


import java.sql.*;

public class PaymentDAO {
    private Connection conn;

    public PaymentDAO() {
        conn = DBConnection.getConnection();
    }

    public boolean savePayment(Payment payment) {
        String sql = "INSERT INTO payments (bill_id, customer_id, total_price, payment_method, amount_given, change_due, payment_status) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, payment.getBillId());
            stmt.setInt(2, payment.getCustomerId());
            stmt.setDouble(3, payment.getTotalPrice());
            stmt.setString(4, payment.getPaymentMethod());
            stmt.setDouble(5, payment.getAmountGiven());
            stmt.setDouble(6, payment.getChangeDue());
            stmt.setString(7, payment.getPaymentStatus());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public boolean saveMinimalPayment(Payment payment) {
        String sql = "INSERT INTO payments (bill_id, customer_id, total_price, payment_method, payment_status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, payment.getBillId());
            stmt.setInt(2, payment.getCustomerId());
            stmt.setDouble(3, payment.getTotalPrice());
            stmt.setString(4, payment.getPaymentMethod());
            stmt.setString(5, payment.getPaymentStatus());

            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

}
