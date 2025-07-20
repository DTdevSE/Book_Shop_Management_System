package com.bookshop.Services.Admin;

import com.bookshop.dao.AccountDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;

@WebServlet("/DeleteAccountServlet")
public class DeleteAccountServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idNumber = request.getParameter("idNumber");
        System.out.println("🛠 Deleting ID: " + idNumber); // Debug

        if (idNumber == null || idNumber.isEmpty()) {
            System.out.println("❌ idNumber is missing!");
            response.sendRedirect("View_users.jsp?message=Missing+ID");
            return;
        }

        AccountDAO dao = new AccountDAO();
        boolean isDeleted = dao.deleteAccount(idNumber);

        if (isDeleted) {
            System.out.println("✅ Successfully deleted.");
            response.sendRedirect("View_users.jsp?message=Account+deleted+successfully");
        } else {
            System.out.println("❌ Failed to delete.");
            response.sendRedirect("View_users.jsp?message=Failed+to+delete+account");
        }
    }

}
