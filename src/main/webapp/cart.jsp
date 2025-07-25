<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.*, com.bookshop.dao.*" %>

<%
    // Get selected customer from session
    Integer customerId = (Integer) session.getAttribute("selectedCustomerId");

    List<CartItem> cartItems = new ArrayList<>();
    if (customerId != null) {
        CartDAO cartDAO = new CartDAO();
        cartItems = cartDAO.getCartItemsByCustomer(customerId);
    }
%>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Cart</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
</head>

<style>.back-btn {
            display: inline-flex;
            align-items: center;
            background-color: #eee;
            border: 1px solid #ccc;
            padding: 6px 12px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 4px;
            transition: background-color 0.2s ease;
            text-decoration: none;
            color: #333;
        }
        .back-btn i {
            margin-right: 6px;
        }
        .back-btn:hover {
            background-color: #ddd;
            color: #000;
        }</style>


<body class="container py-4">
<a href="BillingDashboard.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>

    <h2 class="mb-4">🛒 Cart for Selected Customer</h2>

    <%
        if (customerId == null) {
    %>
        <div class="alert alert-warning">Please select a customer first in the book browsing page.</div>
    <%
        } else if (cartItems.isEmpty()) {
    %>
        <div class="alert alert-info">This customer's cart is empty.</div>
    <%
        } else {
    %>

    <table class="table table-bordered">
        <thead>
            <tr>
                <th></th>
                <th>Book Name</th>
                <th>Price (Rs.)</th>
                <th>Discount (%)</th>
                <th>Quantity</th>
                <th>Total (Rs.)</th>
                <th>Date and Time</th>
            </tr>
        </thead>
        <tbody>
            <%
                int index = 1;
                double grandTotal = 0;
                for (CartItem item : cartItems) {
                    double total = item.getTotal();
                    grandTotal += total;
            %>
            <tr>
                <td><%= index++ %></td>
                <td><%= item.getBookName() %></td>
                <td><%= String.format("%.2f", item.getPrice()) %></td>
                <td><%= String.format("%.2f", item.getDiscount()) %></td>
                <td><%= item.getQuantity() %></td>
                <td><%= String.format("%.2f", total) %></td>
               <td>
        <%
            java.sql.Timestamp addedTime = item.getAddedTime();
            String formattedDateTime = "";
            if (addedTime != null) {
                java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
                formattedDateTime = sdf.format(addedTime);
            }
        %>
        <%= formattedDateTime %>
    </td>
    <td>
    <form action="DeleteCartItemServlet" method="post" onsubmit="return confirm('Are you sure you want to remove this item?');">
        <input type="hidden" name="cartId" value="<%= item.getCartId() %>">
        <button type="submit" class="btn btn-sm btn-danger">Remove Cart</button>
    </form>
</td>
            </tr>
            <% } %>
            <tr class="table-success fw-bold">
                <td colspan="5" class="text-end">Grand Total:</td>
                <td>Rs. <%= String.format("%.2f", grandTotal) %></td>
            </tr>
        </tbody>
    </table>

   <div class="d-flex justify-content-between mb-3">
  
 <a href="BillingDashboard.jsp?customerId=<%= customerId %>&fromCart=true" class="btn btn-secondary">
    Continue Shopping
</a>

 <form action="CheckoutServlet" method="post" class="d-inline">
    <input type="hidden" name="customerId" value="<%= customerId %>">
    <input type="hidden" name="totalAmount" value="<%= String.format("%.2f", grandTotal) %>">
    <button type="submit" class="btn btn-primary">Proceed to Checkout</button>
</form>
</div>

    <% } %>

</body>
</html>
