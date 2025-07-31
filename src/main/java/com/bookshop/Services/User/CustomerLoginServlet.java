package com.bookshop.Services.User;

import com.bookshop.dao.CustomerDAO;
import com.bookshop.model.Customer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/CustomerLogin")
public class CustomerLoginServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        try {
            int accountNumber = Integer.parseInt(request.getParameter("account_number"));
            String password = request.getParameter("password");

            CustomerDAO dao = new CustomerDAO();
            Customer customer = dao.loginCustomer(accountNumber, password);

            if (customer != null) {
                HttpSession session = request.getSession();
                session.setAttribute("loggedCustomer", customer);
                session.setAttribute("customerName", customer.getName());
                session.setAttribute("customerId", customer.getAccountNumber());  // Add this for easy access

                String profileImage = customer.getProfileImage();
                if (profileImage == null || profileImage.trim().isEmpty()) {
                    profileImage = "https://i.pravatar.cc/40?img=5";
                }
                session.setAttribute("profileImage", profileImage);

                // ✅ Redirect to home after login
                response.sendRedirect("Home.jsp");
            } else {
                request.setAttribute("error", "Invalid account number or password");
                request.getRequestDispatcher("Login.jsp").forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Login error. Please try again.");
            request.getRequestDispatcher("Login.jsp").forward(request, response);
        }
    }
}
