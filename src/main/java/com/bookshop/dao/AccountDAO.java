package com.bookshop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.bookshop.model.Account;
import com.bookshop.util.DBConnection;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

import org.mindrot.jbcrypt.BCrypt;

public class AccountDAO {

	public Account validateLogin(String idNumber, String password, String role) {
        Account account = null;
        String sql = "SELECT * FROM accounts WHERE id_number = ? AND role = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, idNumber);
            ps.setString(2, role);

            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                String hashedPassword = rs.getString("password");

                if (BCrypt.checkpw(password, hashedPassword)) { // ✅ bcrypt validation
                    account = new Account();
                    account.setId(rs.getInt("id"));
                    account.setFullname(rs.getString("fullname"));
                    account.setIdNumber(rs.getString("id_number"));
                    account.setPassword(hashedPassword);
                    account.setRole(rs.getString("role"));
                    account.setDob(rs.getDate("dob"));
                    account.setAddress(rs.getString("address"));
                    account.setProfileImage(rs.getString("profile_image"));

                    if (rs.getTimestamp("created_at") != null)
                        account.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
                    if (rs.getTimestamp("last_updated") != null)
                        account.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return account;
    }

	    public boolean addAccount(Account account) {
	        String sql = "INSERT INTO accounts (fullname, id_number, dob, address, password, role, profile_image, created_at) " +
	                     "VALUES (?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setString(1, account.getFullname());
	            ps.setString(2, account.getIdNumber());
	            ps.setDate(3, account.getDob());
	            ps.setString(4, account.getAddress());
	            ps.setString(5, account.getPassword());  // Ideally hashed!
	            ps.setString(6, account.getRole());
	            ps.setString(7, account.getProfileImage());

	            int rowsAffected = ps.executeUpdate();
	            return rowsAffected > 0;

	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	        }
	    }
	    public boolean deleteAccount(String idNumber) {
	        String sql = "DELETE FROM accounts WHERE id_number=?";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setString(1, idNumber);

	            int rowsAffected = ps.executeUpdate();
	            return rowsAffected > 0;

	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	        }
	    }

	   

	    public List<Account> getAllAccounts() {
	        List<Account> accounts = new ArrayList<>();
	        String sql = "SELECT * FROM accounts ORDER BY fullname";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {
	                Account account = new Account();
	                account.setId(rs.getInt("id"));
	                account.setFullname(rs.getString("fullname"));
	                account.setIdNumber(rs.getString("id_number"));
	                account.setPassword(rs.getString("password"));
	                account.setRole(rs.getString("role"));
	                account.setDob(rs.getDate("dob"));
	                account.setAddress(rs.getString("address"));
	                account.setProfileImage(rs.getString("profile_image"));

	                if (rs.getTimestamp("created_at") != null)
	                    account.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

	                if (rs.getTimestamp("last_updated") != null)
	                    account.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());

	                accounts.add(account);
	            }

	        } catch (Exception e) {
	            e.printStackTrace(); // check console/log
	        }

	        return accounts;
	    }
	  //... your existing methods ...

	    public boolean updateAccount(Account account) {
	        String sql = "UPDATE accounts SET fullname=?, dob=?, address=?, password=?, role=?, profile_image=?, last_updated=CURRENT_TIMESTAMP WHERE id_number=?";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setString(1, account.getFullname());
	            ps.setDate(2, account.getDob());
	            ps.setString(3, account.getAddress());
	            ps.setString(4, account.getPassword());
	            ps.setString(5, account.getRole());
	            ps.setString(6, account.getProfileImage());
	            ps.setString(7, account.getIdNumber());

	            int rowsAffected = ps.executeUpdate();
	            return rowsAffected > 0;

	        } catch (Exception e) {
	            e.printStackTrace();
	            return false;
	        }
	    }
	    public Account getAccountByIdNumber(String idNumber) {
	        Account account = null;
	        String sql = "SELECT * FROM accounts WHERE id_number=?";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setString(1, idNumber);
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                account = new Account();
	                account.setId(rs.getInt("id"));
	                account.setFullname(rs.getString("fullname"));
	                account.setIdNumber(rs.getString("id_number"));
	                account.setPassword(rs.getString("password"));
	                account.setRole(rs.getString("role"));
	                account.setDob(rs.getDate("dob"));
	                account.setAddress(rs.getString("address"));
	                account.setProfileImage(rs.getString("profile_image"));
	                if (rs.getTimestamp("created_at") != null)
	                    account.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
	                if (rs.getTimestamp("last_updated") != null)
	                    account.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }
	        return account;
	    }
	  
	    public double getAverageUsersPerMonth() {
	        String sql = "SELECT COUNT(*) AS total, TIMESTAMPDIFF(MONTH, MIN(created_at), MAX(created_at)) + 1 AS months FROM accounts";
	        double average = 0.0;

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            if (rs.next()) {
	                int totalUsers = rs.getInt("total");
	                int totalMonths = rs.getInt("months");

	                if (totalMonths > 0) {
	                    average = (double) totalUsers / totalMonths;
	                } else {
	                    average = totalUsers; // fallback if only 1 month
	                }
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return average;
	    }
	    public Map<String, Integer> getWeeklyUserRegistrations() {
	        Map<String, Integer> weeklyData = new LinkedHashMap<>();
	        String sql = "SELECT YEARWEEK(created_at, 1) AS week, COUNT(*) AS count " +
	                     "FROM accounts GROUP BY YEARWEEK(created_at, 1) ORDER BY week";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql);
	             ResultSet rs = ps.executeQuery()) {

	            while (rs.next()) {
	                String week = rs.getString("week");
	                int count = rs.getInt("count");
	                weeklyData.put("Week " + week, count);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return weeklyData;
	    }
	    public Account validateLogin(String idNumber, String password) {
	        Account account = null;
	        String sql = "SELECT * FROM accounts WHERE id_number = ?";

	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement ps = conn.prepareStatement(sql)) {

	            ps.setString(1, idNumber);
	            ResultSet rs = ps.executeQuery();

	            if (rs.next()) {
	                String hashedPassword = rs.getString("password");

	                if (BCrypt.checkpw(password, hashedPassword)) {
	                    account = new Account();
	                    account.setId(rs.getInt("id"));
	                    account.setFullname(rs.getString("fullname"));
	                    account.setIdNumber(rs.getString("id_number"));
	                    account.setPassword(hashedPassword); // store hashed
	                    account.setRole(rs.getString("role"));
	                    account.setDob(rs.getDate("dob"));
	                    account.setAddress(rs.getString("address"));
	                    account.setProfileImage(rs.getString("profile_image"));

	                    if (rs.getTimestamp("created_at") != null)
	                        account.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());
	                    if (rs.getTimestamp("last_updated") != null)
	                        account.setLastUpdated(rs.getTimestamp("last_updated").toLocalDateTime());
	                }
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return account;
	    }
	    public int getNonAdminUserCount() throws SQLException {
	        String sql = "SELECT COUNT(*) FROM accounts WHERE role != 'admin'";
	        try (Connection conn = DBConnection.getConnection();
	             PreparedStatement stmt = conn.prepareStatement(sql);
	             ResultSet rs = stmt.executeQuery()) {
	            
	            if (rs.next()) {
	                return rs.getInt(1);
	            }
	        }
	        return 0;
	    }
	    public List<Account> searchAccounts(String keyword) {
	        List<Account> accounts = new ArrayList<>();
	        String sql = "SELECT * FROM accounts WHERE fullname LIKE ? OR id_number LIKE ? OR role LIKE ?";

	        try (Connection conn = DBConnection.getConnection(); // make sure you're not using DBUtil unless that's defined
	             PreparedStatement stmt = conn.prepareStatement(sql)) {

	            String searchPattern = "%" + keyword + "%";
	            stmt.setString(1, searchPattern);
	            stmt.setString(2, searchPattern);
	            stmt.setString(3, searchPattern);

	            ResultSet rs = stmt.executeQuery();

	            while (rs.next()) {
	                Account acc = new Account();
	                acc.setFullname(rs.getString("fullname"));
	                acc.setIdNumber(rs.getString("id_number"));
	                acc.setRole(rs.getString("role"));
	                acc.setDob(rs.getDate("dob"));
	                acc.setAddress(rs.getString("address"));
	                acc.setProfileImage(rs.getString("profile_image"));
	                acc.setCreatedAt(rs.getTimestamp("created_at").toLocalDateTime());

	                accounts.add(acc);
	            }

	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return accounts;
	    }


	}


