package com.bookshop.Services.Cashier;



import com.bookshop.dao.CustomerDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteCustomerServlet")
public class DeleteCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idParam = request.getParameter("id");
        System.out.println("🧹 Deleting Customer ID: " + idParam); // Debug

        if (idParam == null || idParam.isEmpty()) {
            System.out.println("⚠️ Missing customer ID");
            response.sendRedirect("view_customers.jsp?message=Missing+Customer+ID");
            return;
        }

        try {
            int customerId = Integer.parseInt(idParam);
            CustomerDAO dao = new CustomerDAO();
            boolean isDeleted = dao.deleteCustomer(customerId);

            if (isDeleted) {
                System.out.println("✅ Customer deleted successfully");
                response.sendRedirect("View_customers.jsp?message=Customer+Deleted+Successfully");
            } else {
                System.out.println("❌ Customer deletion failed");
                response.sendRedirect("view_customers.jsp?message=Failed+to+Delete+Customer");
            }
        } catch (NumberFormatException e) {
            System.out.println("❌ Invalid ID format: " + idParam);
            response.sendRedirect("view_customers.jsp?message=Invalid+Customer+ID");
        }
    }
}
