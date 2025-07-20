package com.bookshop.dao;

import java.sql.*;
import com.bookshop.model.AdminUser;

public class AdminUserDAO {
    private Connection conn;

    public AdminUserDAO(Connection conn) {
        this.conn = conn;
    }

    // Method to check admin login
    public boolean validateAdmin(AdminUser admin) throws SQLException {
        String sql = "SELECT * FROM admins WHERE username = ? AND password = ?";
        PreparedStatement stmt = conn.prepareStatement(sql);
        stmt.setString(1, admin.getUsername());
        stmt.setString(2, admin.getPassword());

        ResultSet rs = stmt.executeQuery();
        boolean status = rs.next();

        if (status) {
            // Update login status and last login time
            String updateSql = "UPDATE admins SET login_status = 'ONLINE', last_login = NOW() WHERE username = ?";
            PreparedStatement updateStmt = conn.prepareStatement(updateSql);
            updateStmt.setString(1, admin.getUsername());
            updateStmt.executeUpdate();
        }

        return status;
    }
}
