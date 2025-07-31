package com.bookshop.Services.User;

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

@WebServlet("/CustomerProfile")
@MultipartConfig
public class UpdateProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);

        try {
            if (session == null || session.getAttribute("loggedCustomer") == null) {
                response.sendRedirect("Login.jsp");
                return;
            }
            com.bookshop.model.Customer loggedCustomer = (com.bookshop.model.Customer) session.getAttribute("loggedCustomer");
            int accountNumber = loggedCustomer.getAccountNumber();

            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");

            // Validate telephone: must be exactly 10 digits and numeric
            if (telephone == null || !telephone.matches("\\d{10}")) {
                session.setAttribute("error", "Telephone number must be exactly 10 digits.");
                response.sendRedirect("CustomerProfile.jsp");
                return;
            }

            Part imagePart = request.getPart("image");
            boolean imageUploaded = (imagePart != null && imagePart.getSize() > 0);
            String imagePath = null;

            if (imageUploaded) {
                String fileName = Paths.get(imagePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                String filePath = uploadPath + File.separator + fileName;
                imagePart.write(filePath);

                imagePath = "uploads/" + fileName;
            }

            Connection conn = null;
            PreparedStatement stmt = null;

            try {
                conn = DBConnection.getConnection();

                if (imageUploaded) {
                    String sql = "UPDATE customers SET name=?, address=?, telephone=?, profile_image=? WHERE account_number=?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, name);
                    stmt.setString(2, address);
                    stmt.setString(3, telephone);
                    stmt.setString(4, imagePath);
                    stmt.setInt(5, accountNumber);
                } else {
                    String sql = "UPDATE customers SET name=?, address=?, telephone=? WHERE account_number=?";
                    stmt = conn.prepareStatement(sql);
                    stmt.setString(1, name);
                    stmt.setString(2, address);
                    stmt.setString(3, telephone);
                    stmt.setInt(4, accountNumber);
                }

                int updatedRows = stmt.executeUpdate();
                if (updatedRows == 0) {
                    session.setAttribute("error", "No records updated. Please try again.");
                    response.sendRedirect("CustomerProfile.jsp");
                    return;
                }

            } finally {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            }

            // Update session customer object
            loggedCustomer.setName(name);
            loggedCustomer.setAddress(address);
            loggedCustomer.setTelephone(telephone);
            if (imageUploaded) {
                loggedCustomer.setProfileImage(imagePath);
                session.setAttribute("profileImage", imagePath);
            }
            session.setAttribute("customerName", name);
            session.setAttribute("loggedCustomer", loggedCustomer);

            // Success message and redirect
            session.setAttribute("success", "Profile updated successfully!");
            response.sendRedirect("CustomerProfile.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            if (session != null) {
                session.setAttribute("error", "Profile update failed: " + e.getMessage());
                response.sendRedirect("CustomerProfile.jsp");
            } else {
                response.getWriter().println("Profile update failed: " + e.getMessage());
            }
        }
    }
}
