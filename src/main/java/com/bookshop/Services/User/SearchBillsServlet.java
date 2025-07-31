package com.bookshop.Services.User;

import com.bookshop.dao.BillDAO;
import com.bookshop.dao.BillItemDAO;

import com.bookshop.model.Bill;
import com.bookshop.model.BillItem;
import com.bookshop.model.Customer;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.*;

@WebServlet("/SearchBillsServlet")
public class SearchBillsServlet extends HttpServlet {

    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private BillDAO billDAO = new BillDAO();
    private BillItemDAO billItemDAO = new BillItemDAO();
   

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        Customer customer = (Customer) request.getSession().getAttribute("loggedCustomer");

        if (customer == null) {
            response.sendRedirect("CustomerLogin.jsp");
            return;
        }

        try {
            int customerId = customer.getAccountNumber();

            List<Bill> bills = billDAO.getBillsByCustomerId(customerId);
            Map<Integer, List<BillItem>> billItemsMap = new HashMap<>();

            for (Bill bill : bills) {
                List<BillItem> items = billItemDAO.getItemsByBillId(bill.getBillId());
                billItemsMap.put(bill.getBillId(), items);
            }

            request.setAttribute("customer", customer);
            request.setAttribute("bills", bills);
            request.setAttribute("billItemsMap", billItemsMap);
            request.getRequestDispatcher("Billing_history.jsp").forward(request, response);

        } catch (SQLException e) {
            e.printStackTrace();
            request.setAttribute("error", "Error retrieving billing history.");
            request.getRequestDispatcher("Billing_history.jsp").forward(request, response);
        }
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
