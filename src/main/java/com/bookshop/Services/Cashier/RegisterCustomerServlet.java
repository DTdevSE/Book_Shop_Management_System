package com.bookshop.Services.Cashier;

import com.bookshop.dao.CustomerDAO;
import com.bookshop.model.Customer;
import org.mindrot.jbcrypt.BCrypt;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

@WebServlet("/AddCustomer")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 1, // 1MB
    maxFileSize = 1024 * 1024 * 10,      // 10MB
    maxRequestSize = 1024 * 1024 * 15    // 15MB
)
public class RegisterCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        try {
            // Read form parameters
            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String address = request.getParameter("address");
            String telephone = request.getParameter("telephone");
            String password = request.getParameter("password");
            String gender = request.getParameter("gender");
            String dobStr = request.getParameter("dob");
            String membershipType = request.getParameter("membershipType");
            Date dob = (dobStr != null && !dobStr.isEmpty()) ? Date.valueOf(dobStr) : null;

            // Handle file upload
            Part filePart = request.getPart("profileImage");
            String profileImage = null;

            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();

                // Upload directory path
                String uploadPath = getServletContext().getRealPath("") + File.separator + "uploads";
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) {
                    uploadDir.mkdir();
                }

                // Save the file on server
                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);

                // Relative path saved in DB
                profileImage = "uploads/" + fileName;
            } else {
                // Optional: set default profile image path or leave null
                profileImage = "uploads/default-profile.png";
            }

            // Hash the password using BCrypt
            String hashedPassword = BCrypt.hashpw(password, BCrypt.gensalt());

            // Create Customer object
            Customer customer = new Customer();
            customer.setName(name);
            customer.setEmail(email);
            customer.setAddress(address);
            customer.setTelephone(telephone);
            customer.setPassword(hashedPassword);
            customer.setProfileImage(profileImage);
            customer.setGender(gender);
            customer.setDob(dob);
            customer.setMembershipType(membershipType != null ? membershipType : "regular");
            customer.setLoginStatus("offline");

            // Save customer to DB
            CustomerDAO dao = new CustomerDAO();
            boolean success = dao.addCustomer(customer);

            if (success) {
                response.sendRedirect("View_customers.jsp?message=Customer+registered+successfully");
            } else {
                response.sendRedirect("error.jsp?message=Failed+to+register+customer");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("error.jsp?message=Exception+occurred");
        }
    }
}
