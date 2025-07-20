package com.bookshop.servlet;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.io.IOException;
import java.sql.Connection;




import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;


import com.bookshop.util.DBConnection;

@WebServlet("/HandleBuyRequest")
public class HandleBuyRequestServlet extends HttpServlet {
    /**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        int requestId = Integer.parseInt(request.getParameter("requestId"));
        String action = request.getParameter("action");

        try (Connection conn = DBConnection.getConnection()) {
            if ("approve".equalsIgnoreCase(action)) {
                String select = "SELECT book_id, quantity FROM buy_requests WHERE id = ?";
                PreparedStatement ps = conn.prepareStatement(select);
                ps.setInt(1, requestId);
                ResultSet rs = ps.executeQuery();

                if (rs.next()) {
                    int bookId = rs.getInt("book_id");
                    int quantity = rs.getInt("quantity");

                    String updateStock = "UPDATE books SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?";
                    PreparedStatement ps2 = conn.prepareStatement(updateStock);
                    ps2.setInt(1, quantity);
                    ps2.setInt(2, bookId);
                    ps2.setInt(3, quantity);

                    int updated = ps2.executeUpdate();
                    if (updated > 0) {
                        PreparedStatement ps3 = conn.prepareStatement("UPDATE buy_requests SET status='Approved' WHERE id=?");
                        ps3.setInt(1, requestId);
                        ps3.executeUpdate();
                    } else {
                        PreparedStatement ps3 = conn.prepareStatement("UPDATE buy_requests SET status='Rejected' WHERE id=?");
                        ps3.setInt(1, requestId);
                        ps3.executeUpdate();
                    }
                }
            } else if ("reject".equalsIgnoreCase(action)) {
                PreparedStatement ps = conn.prepareStatement("UPDATE buy_requests SET status='Rejected' WHERE id=?");
                ps.setInt(1, requestId);
                ps.executeUpdate();
            }

            response.sendRedirect("AdminBuyRequests.jsp?msg=updated");
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("AdminBuyRequests.jsp?msg=error");
        }
    }
}
