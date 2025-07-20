package com.bookshop.Services.Admin;

import com.bookshop.dao.AccountDAO;
import com.bookshop.model.Account;

import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

@WebServlet("/UpdateAccountServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UpdateAccountServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idNumber = request.getParameter("idNumber");
        String fullname = request.getParameter("fullname");
        String dobStr = request.getParameter("dob");
        String address = request.getParameter("address");
        String password = request.getParameter("password"); // May be empty if no change
        String role = request.getParameter("role");

        String profileImagePath = null;

        try {
            // Parse DOB if provided
            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                dob = Date.valueOf(dobStr);
            }

            // Handle image upload if any
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                // Upload directory
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);

                profileImagePath = UPLOAD_DIR + "/" + fileName;
            }

            AccountDAO dao = new AccountDAO();

            // Get existing account from DB (so we can keep password if not changed)
            Account existingAccount = dao.getAccountByIdNumber(idNumber);
            if (existingAccount == null) {
                // Handle account not found error
                request.setAttribute("error", "Account not found.");
                request.getRequestDispatcher("editAccount.jsp?idNumber=" + idNumber).forward(request, response);
                return;
            }

            // If password field is empty, keep existing hashed password
            String hashedPassword;
            if (password == null || password.trim().isEmpty()) {
                hashedPassword = existingAccount.getPassword();
            } else {
                // Hash new password
                hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());
            }

            // Prepare updated Account object
            Account account = new Account();
            account.setIdNumber(idNumber);
            account.setFullname(fullname);
            account.setDob(dob);
            account.setAddress(address);
            account.setPassword(hashedPassword);
            account.setRole(role);

            if (profileImagePath != null) {
                account.setProfileImage(profileImagePath);
            } else {
                // Keep existing image if no new upload
                account.setProfileImage(existingAccount.getProfileImage());
            }

            // Update in DB
            boolean success = dao.updateAccount(account);

            if (success) {
                response.sendRedirect("View_users.jsp?message=Account updated successfully");
            } else {
                request.setAttribute("error", "Failed to update account.");
                request.getRequestDispatcher("editAccount.jsp?idNumber=" + idNumber).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("editAccount.jsp?idNumber=" + idNumber).forward(request, response);
        }
    }
}
