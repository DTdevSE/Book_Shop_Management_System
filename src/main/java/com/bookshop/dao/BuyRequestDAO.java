package com.bookshop.dao;

import com.bookshop.model.BuyRequest;
import com.bookshop.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BuyRequestDAO {
	public List<BuyRequest> getRequestsByCustomer(int accountNumber) {
	    List<BuyRequest> requests = new ArrayList<>();
	    String sql = "SELECT br.*, b.name AS book_name, c.name AS customer_name, c.address AS customer_address " +
	                 "FROM buy_requests br " +
	                 "JOIN books b ON br.book_id = b.id " +
	                 "JOIN customers c ON br.account_number = c.account_number " +
	                 "WHERE br.account_number = ?";

	    try (Connection conn = DBConnection.getConnection();
	         PreparedStatement ps = conn.prepareStatement(sql)) {

	        ps.setInt(1, accountNumber);
	        try (ResultSet rs = ps.executeQuery()) {
	            while (rs.next()) {
	                BuyRequest br = new BuyRequest();
	                br.setId(rs.getInt("id"));
	                br.setAccountNumber(rs.getInt("account_number"));
	                br.setBookId(rs.getInt("book_id"));
	                br.setQuantity(rs.getInt("quantity"));
	                br.setStatus(rs.getString("status"));
	                br.setRequestTime(rs.getTimestamp("request_time").toLocalDateTime());
	                br.setBookName(rs.getString("book_name"));
	                br.setCustomerName(rs.getString("customer_name"));
	                br.setCustomerAddress(rs.getString("customer_address"));  // Set address here

	                requests.add(br);
	            }
	        }

	    } catch (Exception e) {
	        e.printStackTrace();
	    }
	    return requests;
	}

    // ✅ Method to count pending requests
    public int getPendingRequestCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM buy_requests WHERE status = 'Pending'";

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

    public boolean addRequest(int accountNumber, int bookId, int quantity) {
        String sql = "INSERT INTO buy_requests (account_number, book_id, quantity, status, request_time) VALUES (?, ?, ?, 'Pending', NOW())";
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

    public boolean deleteRequestById(int requestId) {
        String sql = "DELETE FROM buy_requests WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            int affectedRows = ps.executeUpdate();
            return affectedRows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public BuyRequest getRequestById(int requestId) {
        BuyRequest br = null;
        String sql = "SELECT br.*, b.name AS book_name, c.name AS customer_name, c.address AS customer_address " +
                     "FROM buy_requests br " +
                     "JOIN books b ON br.book_id = b.id " +
                     "JOIN customers c ON br.account_number = c.account_number " +
                     "WHERE br.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, requestId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    br = new BuyRequest();
                    br.setId(rs.getInt("id"));
                    br.setAccountNumber(rs.getInt("account_number"));
                    br.setBookId(rs.getInt("book_id"));
                    br.setQuantity(rs.getInt("quantity"));
                    br.setStatus(rs.getString("status"));
                    br.setRequestTime(rs.getTimestamp("request_time").toLocalDateTime());
                    br.setBookName(rs.getString("book_name"));              // book name from join
                    br.setCustomerName(rs.getString("customer_name"));      // customer name from join
                    br.setCustomerAddress(rs.getString("customer_address"));// customer address from join
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return br;
    }

    }


    // ✅ (Optional) You can add other methods like getRequestById(), addBuyRequest(), etc.

