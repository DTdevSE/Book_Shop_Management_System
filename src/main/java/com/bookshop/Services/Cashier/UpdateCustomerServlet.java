package com.bookshop.Services.Cashier;



import com.bookshop.dao.CustomerDAO;
import com.bookshop.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.sql.Date;

@WebServlet("/UpdateCustomerServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UpdateCustomerServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "uploads";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String accountNumberStr = request.getParameter("accountNumber");
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String address = request.getParameter("address");
        String telephone = request.getParameter("telephone");
        String password = request.getParameter("password");
        String gender = request.getParameter("gender");
        String dobStr = request.getParameter("dob");
        String membershipType = request.getParameter("membership_type");

        String profileImagePath = null;

        try {
            int accountNumber = Integer.parseInt(accountNumberStr);

            // Parse date
            Date dob = null;
            if (dobStr != null && !dobStr.isEmpty()) {
                dob = Date.valueOf(dobStr);
            }

            // Handle image upload
            Part filePart = request.getPart("profileImage");
            if (filePart != null && filePart.getSize() > 0) {
                String fileName = Paths.get(filePart.getSubmittedFileName()).getFileName().toString();
                String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                File uploadDir = new File(uploadPath);
                if (!uploadDir.exists()) uploadDir.mkdir();

                String filePath = uploadPath + File.separator + fileName;
                filePart.write(filePath);
                profileImagePath = UPLOAD_DIR + "/" + fileName;
            }

            CustomerDAO dao = new CustomerDAO();

            // Get existing customer
            Customer existingCustomer = dao.getCustomerById(accountNumber);
            if (existingCustomer == null) {
                request.setAttribute("error", "Customer not found.");
                request.getRequestDispatcher("editCustomer.jsp?accountNumber=" + accountNumber).forward(request, response);
                return;
            }

            // Use existing password if no new one is given
            String finalPassword = (password == null || password.trim().isEmpty()) 
                                    ? existingCustomer.getPassword()
                                    : password;

            Customer customer = new Customer();
            customer.setAccountNumber(accountNumber);
            customer.setName(name);
            customer.setEmail(email);
            customer.setAddress(address);
            customer.setTelephone(telephone);
            customer.setPassword(finalPassword);
            customer.setGender(gender);
            customer.setDob(dob);
            customer.setMembershipType(membershipType);
            customer.setProfileImage(profileImagePath != null ? profileImagePath : existingCustomer.getProfileImage());

            boolean success = dao.updateCustomer(customer);

            if (success) {
                response.sendRedirect("View_customers.jsp?message=Customer updated successfully");
            } else {
                request.setAttribute("error", "Failed to update customer.");
                request.getRequestDispatcher("editCustomer.jsp?accountNumber=" + accountNumber).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("editCustomer.jsp?accountNumber=" + accountNumberStr).forward(request, response);
        }
    }
}
