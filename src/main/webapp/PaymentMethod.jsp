<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String requestId = request.getParameter("requestId");
    String customerName = request.getParameter("customerName");
    String bookName = request.getParameter("bookName");
    String totalAmount = request.getParameter("totalAmount");
%>
<!DOCTYPE html>
<html>
<head>
    <title>Select Payment Method</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f8f9fa;
        }
        .payment-card {
            max-width: 550px;
            margin: 60px auto;
            padding: 30px;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
            background: #fff;
        }
        .form-check-label {
            font-size: 1.05rem;
            margin-left: 10px;
        }
        .payment-icon {
            font-size: 1.4rem;
            vertical-align: middle;
            margin-right: 8px;
        }
        .disabled-label {
            color: #6c757d !important;
        }
    </style>
</head>
<body>

<div class="payment-card">
    <h3 class="mb-4 text-center">
        <i class="bi bi-credit-card-fill text-primary"></i> Confirm Payment
    </h3>

    <div class="mb-4">
        <p><strong><i class="bi bi-book"></i> Book:</strong> <%= bookName %></p>
        <p><strong><i class="bi bi-person-circle"></i> Buyer:</strong> <%= customerName %></p>
        <p><strong><i class="bi bi-currency-rupee"></i> Total Amount:</strong> Rs. <%= totalAmount %></p>
    </div>

    <form action="FinalPaymentServlet" method="post">
        <!-- Hidden fields -->
        <input type="hidden" name="requestId" value="<%= requestId %>">
        <input type="hidden" name="customerName" value="<%= customerName %>">
        <input type="hidden" name="bookName" value="<%= bookName %>">
        <input type="hidden" name="totalAmount" value="<%= totalAmount %>">

        <div class="mb-4">
            <label class="form-label fw-semibold">Select Payment Method:</label>

            <div class="form-check mb-3">
                <input class="form-check-input" type="radio" name="paymentMethod" value="Cash on Delivery" id="cod" required>
                <label class="form-check-label" for="cod">
                    <i class="bi bi-box-seam payment-icon text-success"></i> Cash on Delivery
                </label>
            </div>

            <div class="form-check mb-3">
                <input class="form-check-input" type="radio" name="paymentMethod" value="Card Payment" id="card" disabled>
                <label class="form-check-label disabled-label" for="card">
                    <i class="bi bi-credit-card payment-icon text-primary"></i> Card Payment 
                    <small class="ms-1">(Unavailable)</small>
                </label>
            </div>

            <div class="form-check mb-3">
                <input class="form-check-input" type="radio" name="paymentMethod" value="Bank Transfer" id="bank" disabled>
                <label class="form-check-label disabled-label" for="bank">
                    <i class="bi bi-bank payment-icon text-warning"></i> Bank Transfer 
                    <small class="ms-1">(Unavailable)</small>
                </label>
            </div>
        </div>

        <div class="d-grid gap-2">
            <button type="submit" class="btn btn-success">
                <i class="bi bi-check-circle-fill"></i> Confirm Payment
            </button>
            <a href="cart.jsp" class="btn btn-outline-secondary">
                <i class="bi bi-x-circle"></i> Cancel
            </a>
        </div>
    </form>
</div>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
