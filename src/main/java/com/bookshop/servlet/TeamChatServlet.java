package com.bookshop.servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.*;
import java.text.SimpleDateFormat;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/TeamChatServlet")
public class TeamChatServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    /** Database connection */
    private Connection getConnection() throws SQLException {
        try { Class.forName("com.mysql.cj.jdbc.Driver"); }
        catch (ClassNotFoundException e) { throw new SQLException("MySQL Driver not found", e); }

        return DriverManager.getConnection(
            "jdbc:mysql://localhost:3306/book_shop_db?useSSL=false&serverTimezone=UTC&characterEncoding=UTF-8",
            "root", "Dinitha@1234"
        );
    }

    /** Escape text for JSON */
    private String escapeJson(String text) {
        if (text == null) return "";
        return text.replace("\\", "\\\\")
                   .replace("\"", "\\\"")
                   .replace("\n", "\\n")
                   .replace("\r", "\\r");
    }

    /** Handle POST: send or delete message */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws IOException {
        request.setCharacterEncoding("UTF-8");
        response.setContentType("application/json;charset=UTF-8");
        HttpSession session = request.getSession(false);

        if (session == null || session.getAttribute("username") == null) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"error\":\"Not logged in\"}");
            return;
        }

        String username = (String) session.getAttribute("username");
        String role = (String) session.getAttribute("role");
        String profileImage = (String) session.getAttribute("profileImage");

        String deleteId = request.getParameter("deleteId");
        String message = request.getParameter("message");

        try (Connection conn = getConnection()) {
            if (deleteId != null && !deleteId.isEmpty()) {
                // Delete message logic
                String sqlCheck = "SELECT sender FROM team_chat WHERE id = ?";
                try (PreparedStatement psCheck = conn.prepareStatement(sqlCheck)) {
                    psCheck.setInt(1, Integer.parseInt(deleteId));
                    ResultSet rs = psCheck.executeQuery();
                    if (rs.next()) {
                        String sender = rs.getString("sender");
                        if (!sender.equals(username) && !role.equals("Admin")) {
                            response.setStatus(HttpServletResponse.SC_FORBIDDEN);
                            response.getWriter().write("{\"error\":\"Cannot delete this message\"}");
                            return;
                        }
                        // Delete
                        String sqlDelete = "DELETE FROM team_chat WHERE id = ?";
                        try (PreparedStatement psDel = conn.prepareStatement(sqlDelete)) {
                            psDel.setInt(1, Integer.parseInt(deleteId));
                            psDel.executeUpdate();
                        }
                        response.getWriter().write("{\"status\":\"deleted\"}");
                        return;
                    } else {
                        response.setStatus(HttpServletResponse.SC_NOT_FOUND);
                        response.getWriter().write("{\"error\":\"Message not found\"}");
                        return;
                    }
                }
            } else if (message != null && !message.trim().isEmpty()) {
                // Insert new message
                String sqlInsert = "INSERT INTO team_chat (sender, role, message, profile_image, timestamp) VALUES (?, ?, ?, ?, NOW())";
                try (PreparedStatement ps = conn.prepareStatement(sqlInsert)) {
                    ps.setString(1, username);
                    ps.setString(2, role);
                    ps.setString(3, message.trim());
                    ps.setString(4, profileImage != null ? profileImage : "");
                    ps.executeUpdate();
                }
                response.getWriter().write("{\"status\":\"ok\"}");
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"error\":\"Message is empty\"}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error\"}");
        }
    }

    /** Handle GET: fetch messages */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws IOException {
        response.setContentType("application/json;charset=UTF-8");
        StringBuilder json = new StringBuilder("[");
        String query = "SELECT id, sender, role, message, profile_image, timestamp FROM team_chat ORDER BY timestamp ASC";

        try (Connection conn = getConnection();
             PreparedStatement ps = conn.prepareStatement(query);
             ResultSet rs = ps.executeQuery()) {

            boolean first = true;
            SimpleDateFormat fmt = new SimpleDateFormat("yyyy-MM-dd HH:mm");

            while (rs.next()) {
                if (!first) json.append(",");
                first = false;

                int id = rs.getInt("id");
                String sender = rs.getString("sender");
                String role = rs.getString("role");
                String message = rs.getString("message");
                String profileImage = rs.getString("profile_image");
                Timestamp ts = rs.getTimestamp("timestamp");
                String time = ts != null ? fmt.format(ts) : "";

                json.append("{")
                    .append("\"id\":").append(id).append(",")
                    .append("\"sender\":\"").append(escapeJson(sender)).append("\",")
                    .append("\"role\":\"").append(escapeJson(role)).append("\",")
                    .append("\"message\":\"").append(escapeJson(message)).append("\",")
                    .append("\"timestamp\":\"").append(escapeJson(time)).append("\",")
                    .append("\"profile\":\"").append(escapeJson(profileImage)).append("\"")
                    .append("}");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"error\":\"Database error\"}");
            return;
        }

        json.append("]");
        PrintWriter out = response.getWriter();
        out.write(json.toString());
        out.flush();
    }
}
