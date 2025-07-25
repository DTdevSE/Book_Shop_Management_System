package com.bookshop.Services.Cashier;

import com.bookshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;

@WebServlet("/AddToCartServlet")
public class AddToCartServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    private static final String INSERT_CART_SQL =
        "INSERT INTO cart_items (customer_id, book_id, book_name, price, discount, quantity, total) VALUES (?, ?, ?, ?, ?, ?, ?)";

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("application/json;charset=UTF-8");
        PrintWriter out = resp.getWriter();

        String customerIdStr = req.getParameter("customerId");
        String bookIdStr = req.getParameter("bookId");
        String bookName = req.getParameter("bookName");
        String priceStr = req.getParameter("price");
        String discountStr = req.getParameter("discount");
        String quantityStr = req.getParameter("quantity");
        String totalStr = req.getParameter("total");

        if (customerIdStr == null || bookIdStr == null || bookName == null ||
            priceStr == null || discountStr == null || quantityStr == null || totalStr == null) {
            out.print("{\"success\":false, \"message\":\"Missing parameters.\"}");
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);
            int bookId = Integer.parseInt(bookIdStr);
            double price = Double.parseDouble(priceStr);
            double discount = Double.parseDouble(discountStr);
            int quantity = Integer.parseInt(quantityStr);
            double total = Double.parseDouble(totalStr);

            try (Connection conn = DBConnection.getConnection()) {
                // ✅ Insert into cart_items
                try (PreparedStatement ps = conn.prepareStatement(INSERT_CART_SQL)) {
                    ps.setInt(1, customerId);
                    ps.setInt(2, bookId);
                    ps.setString(3, bookName);
                    ps.setDouble(4, price);
                    ps.setDouble(5, discount);
                    ps.setInt(6, quantity);
                    ps.setDouble(7, total);

                    int rows = ps.executeUpdate();

                    if (rows > 0) {
                        // ✅ Store selected customer in session
                        HttpSession session = req.getSession();
                        session.setAttribute("selectedCustomerId", customerId);

                        // ✅ Get updated cart count and quantity for this book
                        int updatedCartCount = getCartItemCount(conn, customerId);
                        int qtyInCart = getQuantityForBook(conn, customerId, bookId);

                        // ✅ Return full JSON response
                        out.print("{"
                                + "\"success\": true,"
                                + "\"cartCount\": " + updatedCartCount + ","
                                + "\"bookId\": " + bookId + ","
                                + "\"qtyInCart\": " + qtyInCart
                                + "}");
                    } else {
                        out.print("{\"success\":false, \"message\":\"Failed to add to cart.\"}");
                    }
                }
            }
        } catch (NumberFormatException e) {
            out.print("{\"success\":false, \"message\":\"Invalid number format.\"}");
        } catch (Exception e) {
            e.printStackTrace();
            out.print("{\"success\":false, \"message\":\"" + e.getMessage().replace("\"", "\\\"") + "\"}");
        }
    }

    private int getCartItemCount(Connection conn, int customerId) throws SQLException {
        String sql = "SELECT COUNT(*) FROM cart_items WHERE customer_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }
        }
        return 0;
    }

    private int getQuantityForBook(Connection conn, int customerId, int bookId) throws SQLException {
        String sql = "SELECT SUM(quantity) FROM cart_items WHERE customer_id = ? AND book_id = ?";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ps.setInt(2, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1); // will return 0 if no rows match
                }
            }
        }
        return 0;
    }
}
