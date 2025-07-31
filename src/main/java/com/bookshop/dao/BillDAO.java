package com.bookshop.dao;

import com.bookshop.model.Bill;
import com.bookshop.model.BillItem;
import com.bookshop.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

public class BillDAO {

	public int insertBill(Bill bill) throws SQLException {
	    String sql = "INSERT INTO bills (customer_id, total_amount, payment_method, amount_given, change_due, shipping_address) VALUES (?, ?, ?, ?, ?, ?)";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

	        ps.setInt(1, bill.getCustomerId());
	        ps.setDouble(2, bill.getTotalAmount());
	        ps.setString(3, bill.getPaymentMethod());
	        ps.setDouble(4, bill.getAmountGiven());
	        ps.setDouble(5, bill.getChangeDue());
	        ps.setString(6, bill.getShippingAddress());

	        int affectedRows = ps.executeUpdate();
	        if (affectedRows == 0) {
	            throw new SQLException("Creating bill failed, no rows affected.");
	        }

	        try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
	            if (generatedKeys.next()) {
	                return generatedKeys.getInt(1);  // return generated bill_id
	            } else {
	                throw new SQLException("Creating bill failed, no ID obtained.");
	            }
	        }
	    }
	}


    public Bill getBillById(int billId) {
        Bill bill = null;
        String sql = "SELECT * FROM bills WHERE bill_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {

            stmt.setInt(1, billId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setCustomerId(rs.getInt("customer_id"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaymentMethod(rs.getString("payment_method"));
                bill.setAmountGiven(rs.getDouble("amount_given"));
                bill.setChangeDue(rs.getDouble("change_due"));
                bill.setShippingAddress(rs.getString("shipping_address"));
                bill.setBillingTimestamp(rs.getTimestamp("billing_timestamp"));
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return bill;
    }
    public List<Bill> getBillsByCustomerId(int customerId) throws SQLException {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM bills WHERE customer_id = ? ORDER BY billing_timestamp DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customerId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Bill bill = new Bill();
                    bill.setBillId(rs.getInt("bill_id"));
                    bill.setCustomerId(rs.getInt("customer_id"));
                    bill.setTotalAmount(rs.getDouble("total_amount"));
                    bill.setPaymentMethod(rs.getString("payment_method"));
                    bill.setAmountGiven(rs.getDouble("amount_given"));
                    bill.setChangeDue(rs.getDouble("change_due"));
                    bill.setShippingAddress(rs.getString("shipping_address"));
                    bill.setBillingTimestamp(rs.getTimestamp("billing_timestamp"));
                    bills.add(bill);
                }
            }
        }
        return bills;
    }

    public Map<Integer, List<BillItem>> getBillItemsByBillIds(List<Integer> billIds) throws SQLException {
        Map<Integer, List<BillItem>> billItemsMap = new HashMap<>();
        if (billIds == null || billIds.isEmpty()) {
            return billItemsMap;  // empty map if no bill IDs
        }

        // Prepare placeholders for IN clause (?, ?, ?, ...)
        String placeholders = billIds.stream().map(id -> "?").collect(Collectors.joining(", "));
        String sql = "SELECT * FROM bill_items WHERE bill_id IN (" + placeholders + ")";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < billIds.size(); i++) {
                ps.setInt(i + 1, billIds.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    BillItem item = new BillItem();
                    item.setBillItemId(rs.getInt("bill_item_id"));
                    item.setBillId(rs.getInt("bill_id"));
                    item.setBookName(rs.getString("book_name"));
                    item.setPrice(rs.getDouble("price"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setDiscount(rs.getDouble("discount"));

                    int billId = item.getBillId();
                    billItemsMap.computeIfAbsent(billId, k -> new ArrayList<>()).add(item);
                }
            }
        }
        return billItemsMap;
    }
    public Map<Integer, List<BillItem>> getBillItemsMap(List<Bill> bills) throws SQLException {
        Map<Integer, List<BillItem>> billItemsMap = new HashMap<>();

        String sql = "SELECT * FROM bill_items WHERE bill_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (Bill bill : bills) {
                ps.setInt(1, bill.getBillId());
                try (ResultSet rs = ps.executeQuery()) {
                    List<BillItem> items = new ArrayList<>();
                    while (rs.next()) {
                        BillItem item = new BillItem();
                        item.setBookName(rs.getString("book_name"));
                        item.setQuantity(rs.getInt("quantity"));
                        items.add(item);
                    }
                    billItemsMap.put(bill.getBillId(), items);
                }
            }
        }

        return billItemsMap;
    }
    public List<Bill> fetchBillsByCustomer(int customerId) {
        List<Bill> bills = new ArrayList<>();
        String query = "SELECT * FROM bills WHERE customer_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(query)) {

            stmt.setInt(1, customerId);
            ResultSet rs = stmt.executeQuery();

            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setCustomerId(rs.getInt("customer_id"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaymentMethod(rs.getString("payment_method"));
                bill.setAmountGiven(rs.getDouble("amount_given"));
                bill.setChangeDue(rs.getDouble("change_due"));
                bill.setShippingAddress(rs.getString("shipping_address"));
                bill.setBillingTimestamp(rs.getTimestamp("billing_timestamp"));
                bills.add(bill);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bills;
    }

    public List<Bill> getAllBills() throws SQLException {
        List<Bill> bills = new ArrayList<>();
        String sql = "SELECT * FROM bills ORDER BY billing_timestamp DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Bill bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setCustomerId(rs.getInt("customer_id"));
                bill.setBillingTimestamp(rs.getTimestamp("billing_timestamp"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
                bill.setPaymentMethod(rs.getString("payment_method"));
                bill.setAmountGiven(rs.getDouble("amount_given"));
                bill.setChangeDue(rs.getDouble("change_due"));
                bill.setShippingAddress(rs.getString("shipping_address"));
                bills.add(bill);
            }
        }
        return bills;
    }

    public int getTotalBillCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM bills";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql);
             ResultSet rs = stmt.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    public int getTotalItemsSold() {
        int count = 0;
        String sql = "SELECT SUM(quantity) FROM bill_items";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    public int getBillCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM bills"; // your bills table

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return count;
    }
    public List<Map<String, Object>> getDailyStockOut() throws SQLException {
        String sql = "SELECT DATE(b.billing_timestamp) AS bill_date, " +
                     "SUM(bi.quantity) AS total_out " +
                     "FROM bills b " +
                     "JOIN bill_items bi ON b.bill_id = bi.bill_id " +
                     "GROUP BY bill_date " +
                     "ORDER BY bill_date ASC";

        List<Map<String, Object>> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("date", rs.getDate("bill_date"));
                row.put("out", rs.getInt("total_out"));
                list.add(row);
            }
        }
        return list;
    }
    public List<Map<String, Object>> getDailySalesProfit() throws SQLException {
        String sql = "SELECT DATE(b.billing_timestamp) AS sale_date, " +
                     "SUM(b.total_amount) AS total_sales, " +
                     "SUM((bi.price - bi.discount) * bi.quantity) - SUM(bsm.supply_price * bi.quantity) AS total_profit " +
                     "FROM bills b " +
                     "JOIN bill_items bi ON b.bill_id = bi.bill_id " +
                     "LEFT JOIN book_supplier_map bsm ON bi.book_id = bsm.book_id " +
                     "GROUP BY DATE(b.billing_timestamp) " +
                     "ORDER BY sale_date DESC";

        List<Map<String, Object>> result = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> map = new HashMap<>();
                map.put("date", rs.getDate("sale_date"));
                map.put("sales", rs.getDouble("total_sales"));
                map.put("profit", rs.getDouble("total_profit"));
                result.add(map);
            }
        }

        return result;
    }

}

