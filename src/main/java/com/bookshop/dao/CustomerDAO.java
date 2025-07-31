package com.bookshop.dao;

import com.bookshop.model.Customer;
import com.bookshop.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import org.mindrot.jbcrypt.BCrypt;

public class CustomerDAO {

    // Add new customer - include registered_time (set to current timestamp)
    public boolean addCustomer(Customer customer) {
        String sql = "INSERT INTO customers (name, email, address, telephone, password, profile_image, gender, dob, membership_type, login_status, registered_time) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, CURRENT_TIMESTAMP)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getTelephone());
            ps.setString(5, customer.getPassword());  // Ideally hashed
            ps.setString(6, customer.getProfileImage());
            ps.setString(7, customer.getGender());
            ps.setDate(8, customer.getDob());
            ps.setString(9, customer.getMembershipType());
            ps.setString(10, customer.getLoginStatus());

            int rowsInserted = ps.executeUpdate();
            return rowsInserted > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get customer by accountNumber including registered_time
    public Customer getCustomerById(int accountNumber) {
        String sql = "SELECT * FROM customers WHERE account_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountNumber);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                Customer customer = new Customer();
                customer.setAccountNumber(rs.getInt("account_number"));
                customer.setName(rs.getString("name"));
                customer.setEmail(rs.getString("email"));
                customer.setAddress(rs.getString("address"));
                customer.setTelephone(rs.getString("telephone"));
                customer.setPassword(rs.getString("password"));
                customer.setProfileImage(rs.getString("profile_image"));
                customer.setGender(rs.getString("gender"));
                customer.setDob(rs.getDate("dob"));
                customer.setMembershipType(rs.getString("membership_type"));
                customer.setLoginStatus(rs.getString("login_status"));
                customer.setRegisteredTime(rs.getTimestamp("registered_time")); // New field
                return customer;
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    // Update customer info (typically registered_time not updated)
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE customers SET name=?, email=?, address=?, telephone=?, password=?, gender=?, dob=?, membership_type=?, profile_image=? WHERE account_number=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getEmail());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getTelephone());
            // Hash password before update
            String hashedPassword = BCrypt.hashpw(customer.getPassword(), BCrypt.gensalt());
            ps.setString(5, hashedPassword);
            ps.setString(6, customer.getGender());
            ps.setDate(7, customer.getDob());
            ps.setString(8, customer.getMembershipType());
            ps.setString(9, customer.getProfileImage());
            ps.setInt(10, customer.getAccountNumber());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Delete customer
    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM customers WHERE account_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get all customers including registered_time
    public List<Customer> getAllCustomers() {
        List<Customer> list = new ArrayList<>();
        String sql = "SELECT * FROM customers";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Customer customer = new Customer();
                customer.setAccountNumber(rs.getInt("account_number"));
                customer.setName(rs.getString("name"));
                customer.setEmail(rs.getString("email"));
                customer.setAddress(rs.getString("address"));
                customer.setTelephone(rs.getString("telephone"));
                customer.setPassword(rs.getString("password"));
                customer.setProfileImage(rs.getString("profile_image"));
                customer.setGender(rs.getString("gender"));
                customer.setDob(rs.getDate("dob"));
                customer.setMembershipType(rs.getString("membership_type"));
                customer.setLoginStatus(rs.getString("login_status"));
                customer.setRegisteredTime(rs.getTimestamp("registered_time")); // New field
                list.add(customer);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
  
    public Customer getCustomerId(int customerId) {
        Customer customer = null;
        String sql = "SELECT * FROM customers WHERE account_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    customer = new Customer();
                    customer.setAccountNumber(rs.getInt("account_number"));
                    customer.setName(rs.getString("name"));
                    customer.setAddress(rs.getString("address"));
                    customer.setTelephone(rs.getString("telephone"));
                    // Set other fields as needed
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return customer;
    }
    public Customer loginCustomer(int accountNumber, String password) {
        String sql = "SELECT * FROM customers WHERE account_number = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, accountNumber);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    String hashedPassword = rs.getString("password");
                    // Verify password
                    if (BCrypt.checkpw(password, hashedPassword)) {
                        Customer customer = new Customer();
                        customer.setAccountNumber(rs.getInt("account_number"));
                        customer.setName(rs.getString("name"));
                        customer.setEmail(rs.getString("email"));
                        customer.setAddress(rs.getString("address"));
                        customer.setTelephone(rs.getString("telephone"));
                        customer.setPassword(hashedPassword);  // store hashed password
                        customer.setProfileImage(rs.getString("profile_image"));
                        customer.setGender(rs.getString("gender"));
                        customer.setDob(rs.getDate("dob"));
                        customer.setMembershipType(rs.getString("membership_type"));
                        customer.setLoginStatus(rs.getString("login_status"));
                        customer.setRegisteredTime(rs.getTimestamp("registered_time"));
                        return customer;
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
    public int getTotalStoreKeepers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM customers WHERE role = 'storekeeper'";

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
    public int getTotalCustomers() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM customers";

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

}
