<%@ page import="java.sql.*, java.util.*, com.bookshop.util.DBConnection" %>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<!-- Bootstrap Icons -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

<!-- Optional: Custom page styling -->
<style>
    body {
        background-color: #f8f9fa;
    }
    h3 {
        font-weight: 600;
    }
    .table-responsive {
        background-color: #ffffff;
    }
</style>

<div class="container mt-5">
    <h3 class="mb-4 text-center">Pending Buy Requests</h3>

    <div class="table-responsive shadow-sm rounded">
        <table class="table table-striped table-hover align-middle text-center border">
            <thead class="table-dark">
                <tr>
                    <th>B:No</th>
                    <th>Book</th>
                    <th> User</th>
                    <th>Qty</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    Connection conn = null;
                    Statement st = null;
                    ResultSet rs = null;

                    try {
                        conn = DBConnection.getConnection();
                        st = conn.createStatement();
                        rs = st.executeQuery(
                            "SELECT br.*, b.name AS book_name, c.name AS customer_name " +
                            "FROM buy_requests br " +
                            "JOIN books b ON br.book_id = b.id " +
                            "JOIN customers c ON br.account_number = c.account_number " +
                            "WHERE br.status = 'Pending'"
                        );

                        while (rs.next()) {
                %>
                <tr>
                    <td><%= rs.getInt("id") %></td>
                    <td class="text-start ps-3"><%= rs.getString("book_name") %></td>
                    <td><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getInt("quantity") %></td>
                    <td>
                        <span class="badge bg-warning text-dark rounded-pill px-3 py-2">
                            <%= rs.getString("status") %>
                        </span>
                    </td>
                    <td>
                        <div class="btn-group" role="group">
                            <form action="HandleBuyRequest" method="post">
                                <input type="hidden" name="requestId" value="<%= rs.getInt("id") %>" />
                                <input type="hidden" name="action" value="approve" />
                                <button type="submit" class="btn btn-success btn-sm" data-bs-toggle="tooltip" title="Approve Request">
                                    <i class="bi bi-check-circle"></i>
                                </button>
                            </form>
                            <form action="HandleBuyRequest" method="post">
                                <input type="hidden" name="requestId" value="<%= rs.getInt("id") %>" />
                                <input type="hidden" name="action" value="reject" />
                                <button type="submit" class="btn btn-danger btn-sm" data-bs-toggle="tooltip" title="Reject Request">
                                    <i class="bi bi-x-circle"></i>
                                </button>
                            </form>
                        </div>
                    </td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='6'>Error fetching data: " + e.getMessage() + "</td></tr>");
                    } finally {
                        if (rs != null) rs.close();
                        if (st != null) st.close();
                        if (conn != null) conn.close();
                    }
                %>
            </tbody>
        </table>
    </div>
</div>

<!-- Bootstrap tooltip init -->
<script>
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    })
</script>
