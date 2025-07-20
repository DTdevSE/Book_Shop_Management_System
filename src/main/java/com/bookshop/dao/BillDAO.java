package com.bookshop.dao;

import com.bookshop.model.Bill;
import com.bookshop.util.DBConnection;

import java.sql.*;

public class BillDAO {

    public int createBill(Bill bill) throws SQLException {
        String sql = "INSERT INTO bills (customer_id, total_amount) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setInt(1, bill.getCustomerId());
            ps.setDouble(2, bill.getTotalAmount());
            ps.executeUpdate();

            ResultSet rs = ps.getGeneratedKeys();
            if (rs.next()) {
                return rs.getInt(1);
            }
        }
        return -1;
    }

    public Bill getBillById(int billId) throws SQLException {
        String sql = "SELECT * FROM bills WHERE bill_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, billId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setCustomerId(rs.getInt("customer_id"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setBillingTimestamp(rs.getTimestamp("billing_timestamp"));
                return bill;
            }
        }
        return null;
    }
    public int getBillCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) AS total FROM bills";  // assuming your table is 'bills'

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt("total");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return count;
    }
}
