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
    <title>🛒 Checkout - Pahana Edu Bookshop</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet"/>
    <style>
        body { background-color: #f8f9fa; }
        .card { border-radius: 1rem; box-shadow: 0 0 10px rgba(0,0,0,0.1); }
        .emoji-header { font-size: 1.5rem; }
        .form-section { background-color: #ffffff; padding: 2rem; border-radius: 1rem; }
        .table thead th { vertical-align: middle; }
        
        .blinking {
        animation: blink 1s infinite;
    }
    @keyframes blink {
        0% { opacity: 1; }
        50% { opacity: 0; }
        100% { opacity: 1; }
    }
    </style>
</head>
<body class="container py-5">

<div class="text-center mb-4">
    <h2 class="emoji-header">🛒 Checkout Page</h2>
</div>

<% if (customerId == null) { %>
    <div class="alert alert-warning text-center">
        ⚠️ Please select a customer first.
    </div>
<% } else if (cartItems.isEmpty()) { %>
    <div class="alert alert-info text-center">
        📝 Your cart is empty.
    </div>
<% } else { %>

    <div class="row">
        <!-- Cart Items -->
        <div class="col-lg-8 mb-4">
            <div class="card p-3">
                <h5 class="mb-3">🛍️ Cart Items</h5>
                <div class="table-responsive">
                    <table class="table table-striped table-hover align-middle text-center">
                        <thead class="table-dark">
                            <tr>
                                <th>📚 Book</th>
                                <th>💵 Price (Rs.)</th>
                                <th>🔢 Quantity</th>
                                <th>🎁 Discount (%)</th>
                                <th>💰 Total (Rs.)</th>
                            </tr>
                        </thead>
                        <tbody>
                        <% for (CartItem item : cartItems) { %>
                            <tr>
                                <td><i class="bi bi-journal-bookmark"></i> <%= item.getBookName() %></td>
                                <td>Rs. <%= String.format("%.2f", item.getPrice()) %></td>
                                <td><%= item.getQuantity() %></td>
                                <td><%= String.format("%.2f", item.getDiscount()) %></td>
                                <td>Rs. <%= String.format("%.2f", item.getTotal()) %></td>
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
                </div>
            </div>
        </div>

        <!-- Payment & Shipping Form -->
        <div class="col-lg-4">
            <div class="form-section shadow-sm">
                <h5 class="mb-3">💳 Payment & Shipping Info</h5>

                <% String error = (String) request.getAttribute("error"); 
                   if (error != null) { %>
                   <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> <%= error %></div>
                <% } %>

                <form action="CheckoutServlet" method="post">
                    <input type="hidden" name="customerId" value="<%= customerId %>"/>
                    <input type="hidden" name="totalAmount" value="<%= totalAmount %>"/>

                    <div class="mb-3">
                        <label for="paymentMethod" class="form-label">💳 Payment Method</label>
                       <div class="mb-3">
						  
						    <select id="paymentMethod" name="paymentMethod" class="form-select" required>
						        <option value="">-- Select Payment Method --</option>
						        <option value="Cash">💵 Cash</option>
						        <option value="Credit Card" disabled>💳 Credit Card (Available Soon)</option>
						        <option value="Mobile Payment" disabled>📱 Mobile Payment (Available Soon)</option>
						    </select>
						    <div class="form-text text-warning blinking">⚠️ Credit Card & Mobile Payment will be available soon!</div>
						</div>
                    </div>

                    <div class="mb-3">
                        <label for="amountGiven" class="form-label">💰 Amount Given (Rs.)</label>
                        <input type="number" step="0.01" min="0" id="amountGiven" name="amountGiven" class="form-control" required />
                    </div>

                    <div class="mb-3">
                        <label for="shippingAddress" class="form-label">📍 Shipping Address</label>
                        <textarea id="shippingAddress" name="shippingAddress" class="form-control" rows="3" required></textarea>
                    </div>

                    <button type="submit" class="btn btn-success w-100">
                        <i class="bi bi-check-circle"></i> Complete Checkout
                    </button>
                </form>
            </div>
        </div>
    </div>

<% } %>

</body>
</html>
