<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.*, com.bookshop.dao.*" %>

<%
    Integer customerId = (Integer) session.getAttribute("selectedCustomerId");

    List<CartItem> cartItems = new ArrayList<>();
    double totalAmount = 0;

    if (customerId != null) {
        CartDAO cartDAO = new CartDAO();
        cartItems = cartDAO.getCartItemsByCustomer(customerId);

        for (CartItem item : cartItems) {
            totalAmount += item.getTotal();
        }
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Checkout</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
</head>
<body class="container py-4">

<h2>Checkout Page</h2>

<% if (customerId == null) { %>
    <div class="alert alert-warning">Please select a customer first.</div>
<% } else if (cartItems.isEmpty()) { %>
    <div class="alert alert-info">Your cart is empty.</div>
<% } else { %>

    <h5>Cart Items</h5>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>Book</th><th>Price (Rs.)</th><th>Quantity</th><th>Discount (%)</th><th>Total (Rs.)</th>
            </tr>
        </thead>
        <tbody>
        <% for (CartItem item : cartItems) { %>
            <tr>
                <td><%= item.getBookName() %></td>
                <td><%= String.format("%.2f", item.getPrice()) %></td>
                <td><%= item.getQuantity() %></td>
                <td><%= String.format("%.2f", item.getDiscount()) %></td>
                <td><%= String.format("%.2f", item.getTotal()) %></td>
            </tr>
        <% } %>
        </tbody>
        <tfoot>
            <tr class="table-success fw-bold">
                <td colspan="4" class="text-end">Grand Total:</td>
                <td>Rs. <%= String.format("%.2f", totalAmount) %></td>
            </tr>
        </tfoot>
    </table>

    <h5>Payment & Shipping Information</h5>
    
    <% String error = (String) request.getAttribute("error"); 
       if(error != null) { %>
       <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <form action="CheckoutServlet" method="post" class="w-50">

        <!-- Hidden fields -->
        <input type="hidden" name="customerId" value="<%= customerId %>"/>
        <input type="hidden" name="totalAmount" value="<%= totalAmount %>"/>

        <div class="mb-3">
            <label for="paymentMethod" class="form-label">Payment Method</label>
            <select id="paymentMethod" name="paymentMethod" class="form-select" required>
                <option value="">-- Select Payment Method --</option>
                <option value="Cash">Cash</option>
                <option value="Credit Card">Credit Card</option>
                <option value="Mobile Payment">Mobile Payment</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="amountGiven" class="form-label">Amount Given (Rs.)</label>
            <input type="number" step="0.01" min="0" id="amountGiven" name="amountGiven" class="form-control" required />
        </div>

        <div class="mb-3">
            <label for="shippingAddress" class="form-label">Shipping Address</label>
            <textarea id="shippingAddress" name="shippingAddress" class="form-control" rows="3" required></textarea>
        </div>

        <button type="submit" class="btn btn-primary">Complete Checkout</button>
    </form>

<% } %>

</body>
</html>
