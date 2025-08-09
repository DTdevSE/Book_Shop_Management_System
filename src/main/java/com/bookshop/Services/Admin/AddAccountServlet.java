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

@WebServlet("/AddAccountServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,    // 1MB
    maxFileSize = 1024 * 1024 * 5,      // 5MB
    maxRequestSize = 1024 * 1024 * 10   // 10MB
)
public class AddAccountServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private AccountDAO accountDAO = new AccountDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Get form fields
            String fullname = request.getParameter("fullname");
            String idNumber = request.getParameter("id_number");
            String dobStr = request.getParameter("dob");
            String address = request.getParameter("address");
            String password = request.getParameter("password");
            String role = request.getParameter("role");

            // Basic server-side validation
            if (isNullOrEmpty(fullname) || isNullOrEmpty(idNumber) || isNullOrEmpty(password) ||
                    isNullOrEmpty(role)) {
                response.sendRedirect("add_user.jsp?error=missingFields");
                return;
            }

            // Parse DOB string to java.sql.Date
            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                try {
                    dob = Date.valueOf(dobStr);
                } catch (IllegalArgumentException e) {
                    response.sendRedirect("add_user.jsp?error=invalidDOB");
                    return;
                }
            }

            // Get uploaded file
            Part filePart = request.getPart("profile_image");
            if (filePart == null || filePart.getSize() == 0) {
                response.sendRedirect("add_user.jsp?error=noImage");
                return;
            }

            // Handle file upload
            String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
            String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
            File uploadDir = new File(uploadPath);
            if (!uploadDir.exists()) uploadDir.mkdir();

            String filePath = uploadPath + File.separator + fileName;
            filePart.write(filePath);
            String dbImagePath = "uploads/" + fileName;

            // Hash password using BCrypt
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Populate Account object
            Account newAccount = new Account();
            newAccount.setFullname(fullname);
            newAccount.setIdNumber(idNumber);
            newAccount.setDob(dob);
            newAccount.setAddress(address);
            newAccount.setPassword(hashedPassword);
            newAccount.setRole(role);
            newAccount.setProfileImage(dbImagePath);

            // Save to DB
            boolean success = accountDAO.addAccount(newAccount);

            if (success) {
                response.sendRedirect("View_users.jsp?msg=AccountAdded");
            } else {
                response.sendRedirect("add_user.jsp?error=failedToAdd");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("add_user.jsp?error=exception");
        }
    }

    private boolean isNullOrEmpty(String value) {
        return value == null || value.trim().isEmpty();
    }
}
