package com.bookshop.Services.Store;

import com.bookshop.dao.SupplierDAO;
import com.bookshop.model.Supplier;

import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.annotation.WebServlet;
import java.io.IOException;

@WebServlet("/SupplierServlet")
public class SupplierServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private SupplierDAO dao;

    @Override
    public void init() {
        dao = new SupplierDAO();
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        try {
            if (action == null) {
                // No action specified
            } else if (action.equals("add")) {
                Supplier s = new Supplier();
                s.setName(request.getParameter("name"));
                s.setEmail(request.getParameter("email"));
                s.setPhone(request.getParameter("phone"));
                s.setAddress(request.getParameter("address"));
                dao.addSupplier(s);

            } else if (action.startsWith("update_")) {
                // Extract supplierId from action like "update_12"
                int supplierId = Integer.parseInt(action.substring("update_".length()));

                String name = request.getParameter("name_" + supplierId);
                String email = request.getParameter("email_" + supplierId);
                String phone = request.getParameter("phone_" + supplierId);
                String address = request.getParameter("address_" + supplierId);

                Supplier s = new Supplier();
                s.setSupplierId(supplierId);
                s.setName(name);
                s.setEmail(email);
                s.setPhone(phone);
                s.setAddress(address);

                dao.updateSupplier(s);

            } else if (action.startsWith("delete_")) {
                // Extract supplierId from action like "delete_12"
                int supplierId = Integer.parseInt(action.substring("delete_".length()));
                dao.deleteSupplier(supplierId);
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Optionally set error message in session or request
        }

        response.sendRedirect("ManageSuppliers.jsp");
    }
}
