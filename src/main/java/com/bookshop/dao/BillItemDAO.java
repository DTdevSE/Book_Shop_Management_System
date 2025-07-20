package com.bookshop.dao;

import com.bookshop.model.BillItem;
import com.bookshop.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BillItemDAO {

    public void createBillItem(BillItem item) throws SQLException {
        String sql = "INSERT INTO bill_items (bill_id, book_id, book_name, price, discount, quantity, total) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getBillId());
            ps.setInt(2, item.getBookId());
            ps.setString(3, item.getBookName());
            ps.setDouble(4, item.getPrice());
            ps.setDouble(5, item.getDiscount());
            ps.setInt(6, item.getQuantity());
            ps.setDouble(7, item.getTotal());
            ps.executeUpdate();
        }
    }

    public List<BillItem> getItemsByBillId(int billId) throws SQLException {
        List<BillItem> items = new ArrayList<>();
        String sql = "SELECT * FROM bill_items WHERE bill_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, billId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BillItem item = new BillItem();
                item.setItemId(rs.getInt("item_id"));
                item.setBillId(rs.getInt("bill_id"));
                item.setBookId(rs.getInt("book_id"));
                item.setBookName(rs.getString("book_name"));
                item.setPrice(rs.getDouble("price"));
                item.setDiscount(rs.getDouble("discount"));
                item.setQuantity(rs.getInt("quantity"));
                item.setTotal(rs.getDouble("total"));
                items.add(item);
            }
        }
        return items;
    }
}
