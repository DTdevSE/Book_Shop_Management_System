package com.bookshop.Services.Store;


import com.bookshop.dao.BookSupplierMapDAO;
import com.bookshop.model.BookSupplierMap;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/BookSupplierMapServlet")
public class BookSupplierMapServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	private BookSupplierMapDAO dao;

    @Override
    public void init() {
        dao = new BookSupplierMapDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // List all mappings
        request.setAttribute("mappingList", dao.getAllMappings());
        // Also get books and suppliers list for dropdowns
        // You'll need BookDAO and SupplierDAO instances here (not shown - create and use)
        // Example: request.setAttribute("books", new BookDAO().getAllBooks());
        // request.setAttribute("suppliers", new SupplierDAO().getAllSuppliers());
        request.getRequestDispatcher("ManageBookSupplierMapping.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("add".equals(action)) {
            BookSupplierMap map = new BookSupplierMap();
            map.setBookId(Integer.parseInt(request.getParameter("bookId")));
            map.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
            map.setSupplyPrice(Double.parseDouble(request.getParameter("supplyPrice")));
            map.setSupplyQty(Integer.parseInt(request.getParameter("supplyQty")));

            dao.addMapping(map);

        } else if ("update".equals(action)) {
            BookSupplierMap map = new BookSupplierMap();
            map.setId(Integer.parseInt(request.getParameter("id")));
            map.setBookId(Integer.parseInt(request.getParameter("bookId")));
            map.setSupplierId(Integer.parseInt(request.getParameter("supplierId")));
            map.setSupplyPrice(Double.parseDouble(request.getParameter("supplyPrice")));
            map.setSupplyQty(Integer.parseInt(request.getParameter("supplyQty")));

            dao.updateMapping(map);

        } else if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            dao.deleteMapping(id);
        }

        response.sendRedirect("BookSupplierMapServlet");
    }
}

