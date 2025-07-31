package com.bookshop.Services.Cashier;

import com.bookshop.dao.BillDAO;
import com.bookshop.dao.BillItemDAO;
import com.bookshop.dao.CustomerDAO;
import com.bookshop.model.Bill;
import com.bookshop.model.BillItem;
import com.bookshop.model.Customer;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@WebServlet("/SearchBillServlet")
public class SearchBillServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private BillDAO billDAO = new BillDAO();
    private BillItemDAO billItemDAO = new BillItemDAO();
    private CustomerDAO customerDAO = new CustomerDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String customerIdStr = request.getParameter("customerId");

        if (customerIdStr == null || customerIdStr.trim().isEmpty()) {
            request.setAttribute("error", "Please enter a customer ID to search.");
            request.getRequestDispatcher("CashierBilling_History.jsp").forward(request, response);
            return;
        }

        try {
            int customerId = Integer.parseInt(customerIdStr);

            // Get customer details
            Customer customer = customerDAO.getCustomerById(customerId);

            if (customer == null) {
                request.setAttribute("error", "No customer found with ID: " + customerId);
                request.getRequestDispatcher("Billing_history.jsp").forward(request, response);
                return;
            }

            // Get all bills for this customer
            List<Bill> bills = billDAO.getBillsByCustomerId(customerId);

            // For each bill, get its items, store in a map: billId -> List<BillItem>
            Map<Integer, List<BillItem>> billItemsMap = new HashMap<>();
            for (Bill bill : bills) {
                List<BillItem> items = billItemDAO.getItemsByBillId(bill.getBillId());
                billItemsMap.put(bill.getBillId(), items);
            }

            // Set attributes to pass to JSP
            request.setAttribute("customer", customer);
            request.setAttribute("bills", bills);
            request.setAttribute("billItemsMap", billItemsMap);
            request.setAttribute("searchedCustomerId", customerId);

        } catch (NumberFormatException e) {
            request.setAttribute("error", "Invalid customer ID format. Please enter a valid number.");
        } catch (SQLException e) {
            request.setAttribute("error", "Database error occurred while searching bills.");
            e.printStackTrace();
        }

        request.getRequestDispatcher("CashierBilling_History.jsp").forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
