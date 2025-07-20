package com.bookshop.Services.Admin;

import com.bookshop.dao.AccountDAO;
import com.bookshop.model.Account;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.util.List;

@WebServlet("/ViewAllAccounts")
public class ViewAllAccountsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        AccountDAO dao = new AccountDAO();
        List<Account> accounts = dao.getAllAccounts();
        request.setAttribute("accounts", accounts);

        request.getRequestDispatcher("/View_users.jsp").forward(request, response);
    }
}
