package com.bookshop.dao;


import com.bookshop.model.BookSupplierMap;
import com.bookshop.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;

import java.util.List;

public class BookSupplierMapDAO {
    private Connection conn;

    public BookSupplierMapDAO() {
        conn = DBConnection.getConnection();
    }

    // Add new mapping and update stock_quantity in books table
    public boolean addMapping(BookSupplierMap map) {
        String insertSQL = "INSERT INTO book_supplier_map (book_id, supplier_id, supply_price, supply_qty) VALUES (?, ?, ?, ?)";
        String updateStockSQL = "UPDATE books SET stock_quantity = stock_quantity + ? WHERE id = ?";
        try {
            conn.setAutoCommit(false);

            try (PreparedStatement psInsert = conn.prepareStatement(insertSQL)) {
                psInsert.setInt(1, map.getBookId());
                psInsert.setInt(2, map.getSupplierId());
                psInsert.setDouble(3, map.getSupplyPrice());
                psInsert.setInt(4, map.getSupplyQty());
                psInsert.executeUpdate();
            }

            try (PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSQL)) {
                psUpdateStock.setInt(1, map.getSupplyQty());
                psUpdateStock.setInt(2, map.getBookId());
                psUpdateStock.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try { conn.rollback(); } catch(SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            try { conn.setAutoCommit(true); } catch(SQLException ignored) {}
        }
    }

    // Update existing mapping and adjust stock quantity accordingly
    public boolean updateMapping(BookSupplierMap map) {
        String selectSQL = "SELECT supply_qty FROM book_supplier_map WHERE id = ?";
        String updateMappingSQL = "UPDATE book_supplier_map SET book_id=?, supplier_id=?, supply_price=?, supply_qty=?, supply_date=NOW() WHERE id=?";
        String updateStockSQL = "UPDATE books SET stock_quantity = stock_quantity + ? WHERE id = ?";
        try {
            conn.setAutoCommit(false);

            int oldQty = 0;
            try (PreparedStatement psSelect = conn.prepareStatement(selectSQL)) {
                psSelect.setInt(1, map.getId());
                ResultSet rs = psSelect.executeQuery();
                if (rs.next()) {
                    oldQty = rs.getInt("supply_qty");
                }
            }

            try (PreparedStatement psUpdateMap = conn.prepareStatement(updateMappingSQL)) {
                psUpdateMap.setInt(1, map.getBookId());
                psUpdateMap.setInt(2, map.getSupplierId());
                psUpdateMap.setDouble(3, map.getSupplyPrice());
                psUpdateMap.setInt(4, map.getSupplyQty());
                psUpdateMap.setInt(5, map.getId());
                psUpdateMap.executeUpdate();
            }

            int diffQty = map.getSupplyQty() - oldQty;

            try (PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSQL)) {
                psUpdateStock.setInt(1, diffQty);
                psUpdateStock.setInt(2, map.getBookId());
                psUpdateStock.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try { conn.rollback(); } catch(SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            try { conn.setAutoCommit(true); } catch(SQLException ignored) {}
        }
    }

    // Delete mapping and reduce stock accordingly
    public boolean deleteMapping(int id) {
        String selectSQL = "SELECT supply_qty, book_id FROM book_supplier_map WHERE id = ?";
        String deleteSQL = "DELETE FROM book_supplier_map WHERE id = ?";
        String updateStockSQL = "UPDATE books SET stock_quantity = stock_quantity - ? WHERE id = ?";
        try {
            conn.setAutoCommit(false);

            int supplyQty = 0, bookId = 0;
            try (PreparedStatement psSelect = conn.prepareStatement(selectSQL)) {
                psSelect.setInt(1, id);
                ResultSet rs = psSelect.executeQuery();
                if (rs.next()) {
                    supplyQty = rs.getInt("supply_qty");
                    bookId = rs.getInt("book_id");
                }
            }

            try (PreparedStatement psDelete = conn.prepareStatement(deleteSQL)) {
                psDelete.setInt(1, id);
                psDelete.executeUpdate();
            }

            try (PreparedStatement psUpdateStock = conn.prepareStatement(updateStockSQL)) {
                psUpdateStock.setInt(1, supplyQty);
                psUpdateStock.setInt(2, bookId);
                psUpdateStock.executeUpdate();
            }

            conn.commit();
            return true;

        } catch (SQLException e) {
            e.printStackTrace();
            try { conn.rollback(); } catch(SQLException ex) { ex.printStackTrace(); }
            return false;
        } finally {
            try { conn.setAutoCommit(true); } catch(SQLException ignored) {}
        }
    }

    // List all mappings with book and supplier names (JOIN)
    public List<BookSupplierMap> getAllMappings() {
        List<BookSupplierMap> list = new ArrayList<>();
        String sql = "SELECT m.*, b.name AS book_name, s.name AS supplier_name FROM book_supplier_map m " +
                     "JOIN books b ON m.book_id = b.id " +
                     "JOIN suppliers s ON m.supplier_id = s.supplier_id ORDER BY m.supply_date DESC";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                BookSupplierMap map = new BookSupplierMap();
                map.setId(rs.getInt("id"));
                map.setBookId(rs.getInt("book_id"));
                map.setSupplierId(rs.getInt("supplier_id"));
                map.setSupplyPrice(rs.getDouble("supply_price"));
                map.setSupplyQty(rs.getInt("supply_qty"));
                map.setSupplyDate(rs.getTimestamp("supply_date"));

                // For display: You may want to extend the model with bookName and supplierName
                // Or create a DTO for UI that contains these fields
                // For simplicity: you can store in request attributes in servlet

                list.add(map);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
 // In your DAO class
    public int getSupplyPriceErrorCount() {
        String sql = "SELECT COUNT(*) FROM book_supplier_map m " +
                     "JOIN books b ON m.book_id = b.id " +
                     "WHERE m.supply_price > b.price";
        try (PreparedStatement ps = conn.prepareStatement(sql)) {
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

}
