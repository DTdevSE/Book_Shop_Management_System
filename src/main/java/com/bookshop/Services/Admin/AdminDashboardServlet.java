package com.bookshop.Services.Admin;

import java.time.LocalDate;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.bookshop.dao.BookDAO;

@WebServlet("/AdminDashboard")
public class AdminDashboardServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, java.io.IOException {
        try {
            BookDAO bookDAO = new BookDAO();

            // Get today's profit
            double dailyProfit = bookDAO.getDailyProfitForDate(LocalDate.now());

            // Get total profit
            double totalProfit = bookDAO.getTotalProfit();

            // Pass values to JSP
            request.setAttribute("dailyProfit", dailyProfit);
            request.setAttribute("totalProfit", totalProfit);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("dailyProfit", 0.0);
            request.setAttribute("totalProfit", 0.0);
        }

        // Forward to AdminHome.jsp
        request.getRequestDispatcher("AdminHome.jsp").forward(request, response);
    }
}
