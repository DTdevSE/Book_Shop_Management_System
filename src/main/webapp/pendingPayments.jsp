<%@ page import="java.sql.*, java.util.*, com.bookshop.util.DBConnection" %>

<!-- Bootstrap 5 CSS -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

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
    <h3 class="mb-4 text-center">Pending Payment Requests</h3>

    <div class="table-responsive shadow-sm rounded">
        <table class="table table-striped table-hover align-middle text-center border">
            <thead class="table-dark">
                <tr>
                    <th>Pay No</th>
                    <th>Customer</th>
                    <th>Amount (Rs.)</th>
                    <th>Method</th>
                    <th>Time</th>
                    <th>Status</th>
                    <th>Action</th>
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
                            "SELECT payment_id, customer_name, total_amount, payment_method, payment_time, status " +
                            "FROM payment_requests " +
                            "WHERE status = 'Pending'"
                        );

                        boolean hasData = false;
                        while (rs.next()) {
                            hasData = true;
                %>
                <tr>
                    <td><%= rs.getInt("payment_id") %></td>
                    <td class="text-start ps-3"><%= rs.getString("customer_name") %></td>
                    <td><%= rs.getDouble("total_amount") %></td>
                    <td><%= rs.getString("payment_method") %></td>
                    <td><%= rs.getTimestamp("payment_time") %></td>
                    <td>
                        <span class="badge bg-warning text-dark rounded-pill px-3 py-2">
                            <%= rs.getString("status") %>
                        </span>
                    </td>
                    <td>
                        <div class="btn-group" role="group">

    <!-- Approve Form -->
    <form action="ApprovePaymentServlet" method="get" onsubmit="return confirm('Approve this payment?');" style="display:inline;">
        <input type="hidden" name="paymentId" value="<%= rs.getInt("payment_id") %>" />
        <input type="hidden" name="action" value="approve" />
        <button type="submit" class="btn btn-success btn-sm" data-bs-toggle="tooltip" title="Approve Payment">
            <i class="bi bi-check-circle"></i> Approve
        </button>
    </form>

    <!-- Reject Form -->
    <form action="ApprovePaymentServlet" method="get" onsubmit="return confirm('Reject this payment?');" style="display:inline; margin-left: 5px;">
        <input type="hidden" name="paymentId" value="<%= rs.getInt("payment_id") %>" />
        <input type="hidden" name="action" value="reject" />
        <button type="submit" class="btn btn-danger btn-sm" data-bs-toggle="tooltip" title="Reject Payment">
            <i class="bi bi-x-circle"></i> Reject
        </button>
    </form>

</div>

                    </td>
                </tr>
                <%
                        }

                        if (!hasData) {
                %>
                <tr>
                    <td colspan="7" class="text-center">No pending payment requests found.</td>
                </tr>
                <%
                        }
                    } catch (Exception e) {
                        out.println("<tr><td colspan='7'>Error fetching data: " + e.getMessage() + "</td></tr>");
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

<script>
    var tooltipTriggerList = [].slice.call(document.querySelectorAll('[data-bs-toggle="tooltip"]'))
    var tooltipList = tooltipTriggerList.map(function (tooltipTriggerEl) {
        return new bootstrap.Tooltip(tooltipTriggerEl)
    })
</script>
