package com.bookshop.dao;

import com.bookshop.model.CartItem;
import com.bookshop.util.DBConnection;


import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class CartDAO {

    private static final String INSERT_CART_SQL = 
        "INSERT INTO cart_items (customer_id, book_id, book_name, price, discount, quantity, total) " +
        "VALUES (?, ?, ?, ?, ?, ?, ?)";

    /**
     * Add item to cart with full details.
     * @param customerId customer account number
     * @param bookId book id
     * @param bookName book name
     * @param price price per unit
     * @param discount discount amount or percentage (as per your DB)
     * @param quantity quantity to add
     * @param total total price after discount and quantity
     * @return true if inserted successfully, false otherwise
     */
    public boolean addToCart(int customerId, int bookId, String bookName, double price, double discount, int quantity, double total) {
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(INSERT_CART_SQL)) {

            ps.setInt(1, customerId);
            ps.setInt(2, bookId);
            ps.setString(3, bookName);
            ps.setDouble(4, price);
            ps.setDouble(5, discount);
            ps.setInt(6, quantity);
            ps.setDouble(7, total);

            int rows = ps.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }
    public List<CartItem> getCartItemsByCustomer(int customerId) {
        List<CartItem> items = new ArrayList<>();
        String sql = "SELECT * FROM cart_items WHERE customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    CartItem item = new CartItem();
                    item.setCartId(rs.getInt("cart_id"));
                    item.setCustomerId(rs.getInt("customer_id"));
                    item.setBookId(rs.getInt("book_id"));
                    item.setBookName(rs.getString("book_name"));
                    item.setPrice(rs.getDouble("price"));
                    item.setDiscount(rs.getDouble("discount"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setTotal(rs.getDouble("total"));
                    item.setAddedTime(rs.getTimestamp("added_time"));

                    items.add(item);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return items;
    }
    public List<CartItem> getCartItemsByCustomerId(String customerId) {
        List<CartItem> items = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(
                 "SELECT * FROM cart_items WHERE customer_id = ?")) {
            stmt.setString(1, customerId);
            ResultSet rs = stmt.executeQuery();
            while (rs.next()) {
                CartItem item = new CartItem();
                item.setBookName(rs.getString("book_name"));
                item.setPrice(rs.getDouble("price"));
                item.setDiscount(rs.getDouble("discount"));
                item.setQuantity(rs.getInt("quantity"));
                item.setTotal(rs.getDouble("total"));
                item.setAddedTime(rs.getTimestamp("added_time"));

                items.add(item);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return items;
    }
    public void deleteCartItem(int cartId) {
        String sql = "DELETE FROM cart_items WHERE cart_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, cartId);
            stmt.executeUpdate();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    public int getCartItemCount(int customerId) {
        String sql = "SELECT COUNT(*) FROM cart_items WHERE customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }
    public void clearCartByCustomer(int customerId) throws SQLException {
        String sql = "DELETE FROM cart_items WHERE customer_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.executeUpdate();
        }
    }
    
}

