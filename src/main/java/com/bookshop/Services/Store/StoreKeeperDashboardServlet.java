package com.bookshop.Services.Store;

import com.bookshop.dao.BookDAO;
import com.bookshop.dao.CustomerDAO;
import com.bookshop.dao.BillDAO;
import com.bookshop.dao.SupplierDAO;

import javax.servlet.*;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;
import java.util.Map;

@WebServlet("/StoreKeeperDashboard")
public class StoreKeeperDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Create DAO instances
        CustomerDAO customerDAO = new CustomerDAO();
        BookDAO bookDAO = new BookDAO();
        BillDAO billDAO = new BillDAO();
        SupplierDAO supplierDAO = new SupplierDAO();

        try {
            // 1️⃣ Dashboard Cards
            int customerCount = customerDAO.getTotalCustomers();
            int storeKeeperCount = customerDAO.getTotalStoreKeepers(); // if you maintain store keepers
            int lowStockCount = bookDAO.getLowStockCount();             // need to create this if not exists
            int outOfStockCount = bookDAO.getOutOfStockCount();
            int billCount = billDAO.getBillCount();
            int supplierCount = supplierDAO.getSupplierCount();
            int totalItemsSold = billDAO.getTotalItemsSold();
            int totalStock = bookDAO.getTotalStock();

            // 2️⃣ Get All Books (for total books)
            request.setAttribute("books", bookDAO.getAllBooks());

            // 3️⃣ Stock Balancing Report
            List<Map<String, Object>> stockReport = bookDAO.getStockBalancingReport();

            // 4️⃣ Set Attributes to JSP
            request.setAttribute("customerCount", customerCount);
            request.setAttribute("storeKeeperCount", storeKeeperCount);
            request.setAttribute("lowStockCount", lowStockCount);
            request.setAttribute("outOfStockCount", outOfStockCount);
            request.setAttribute("billCount", billCount);
            request.setAttribute("supplierCount", supplierCount);
            request.setAttribute("totalItemsSold", totalItemsSold);
            request.setAttribute("totalStock", totalStock);
            request.setAttribute("stockReport", stockReport);
            request.setAttribute("stockBalancingReport", bookDAO.getDailyStockBalancing());

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Forward to Store Keeper Dashboard JSP
        RequestDispatcher dispatcher = request.getRequestDispatcher("Inventory Maintenance.jsp");
        dispatcher.forward(request, response);
    }
}
