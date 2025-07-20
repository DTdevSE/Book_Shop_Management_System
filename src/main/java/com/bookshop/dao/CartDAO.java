package com.bookshop.dao;


import com.bookshop.util.DBConnection;

import java.sql.Connection;
import java.sql.PreparedStatement;

public class CartDAO {
    public boolean addToCart(int accountNumber, int bookId, int quantity) {
        String sql = "INSERT INTO cart (account_number, book_id, quantity) VALUES (?, ?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountNumber);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (Exception e) {
            e.printStackTrace();
        }
        return false;
    }
}
