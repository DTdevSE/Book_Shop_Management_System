package com.bookshop.servlet;

import com.bookshop.util.DBConnection;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.Timestamp;

@WebServlet("/CustomerProfile")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            int accountNumber = Integer.parseInt(request.getParameter("account_number"));
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");

            // Check if user uploaded a new image
            Part imagePart = request.getPart("image");
            String imagePath = null;
            boolean imageUploaded = (imagePart != null && imagePart.getSize() > 0);

            if (imageUploaded) {
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();
                String filePath = uploadPath + File.separator + fileName;
                imagePart.write(filePath);
                imagePath = "uploads/" + fileName;
            }

            Connection conn = DBConnection.getConnection();
            PreparedStatement stmt;

            if (imageUploaded) {
                // Update including profile image
                String sql = "UPDATE customers SET name=?, address=?, telephone=?, profile_image=?, created_at=? WHERE account_number=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, address);
                stmt.setString(3, telephone);
                stmt.setString(4, imagePath);
                stmt.setTimestamp(5, new Timestamp(System.currentTimeMillis()));
                stmt.setInt(6, accountNumber);
            } else {
                // Update without changing profile image
                String sql = "UPDATE customers SET name=?, address=?, telephone=?, created_at=? WHERE account_number=?";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, name);
                stmt.setString(2, address);
                stmt.setString(3, telephone);
                stmt.setTimestamp(4, new Timestamp(System.currentTimeMillis()));
                stmt.setInt(5, accountNumber);
            }

            stmt.executeUpdate();

            // Refresh session values
            HttpSession session = request.getSession();
            session.setAttribute("customerName", name);
            if (imageUploaded) {
                session.setAttribute("profileImage", imagePath);
            }

            response.sendRedirect("Home.jsp");
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Update Error: " + e.getMessage());
        }
    }
}
