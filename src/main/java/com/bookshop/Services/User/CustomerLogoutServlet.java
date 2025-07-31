package com.bookshop.Services.User;


import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.*;
import java.io.IOException;

@WebServlet("/CustomerLogout")
public class CustomerLogoutServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Invalidate the session
        HttpSession session = request.getSession(false); // false = don't create a new session
        if (session != null) {
            session.invalidate();
        }

        // Redirect to login page or home page
        response.sendRedirect(request.getContextPath() + "/CustomerLogin.jsp");
    }
}