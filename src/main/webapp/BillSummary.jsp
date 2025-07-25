<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.model.*, com.bookshop.dao.*" %>
<%@ page import="java.util.List" %>

<%
    String billIdParam = request.getParameter("billId");
    if (billIdParam == null) {
        out.println("<div class='alert alert-danger'>Bill ID is missing.</div>");
        return;
    }
    int billId = Integer.parseInt(billIdParam);

    BillDAO billDAO = new BillDAO();
    BillItemDAO billItemDAO = new BillItemDAO();
    CustomerDAO customerDAO = new CustomerDAO();

    Bill bill = billDAO.getBillById(billId);
    List<BillItem> billItems = billItemDAO.getItemsByBillId(billId);

    Customer customer = null;
    if (bill != null) {
        customer = customerDAO.getCustomerById(bill.getCustomerId());
    }

    if (bill == null) {
        out.println("<div class='alert alert-danger'>Bill not found.</div>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Bill Summary - Bill #<%= billId %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        @page {
            size: A4;
            margin: 20mm 15mm 20mm 15mm;
        }

        body {
            background-color: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            min-height: 100vh;
        }
        .bill-card {
            max-width: 900px;
            margin: 40px auto;
            padding: 40px 50px;
            background: white;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
            /* Make sure watermark inside */
        }
        .bill-header {
            border-bottom: 2px solid #dee2e6;
            margin-bottom: 20px;
        }
        .bill-header h2 {
            font-weight: 700;
            color: #343a40;
        }
        .table thead th {
            background-color: #343a40;
            color: white;
        }
        .total-row {
            font-weight: 700;
            font-size: 1.1rem;
            background-color: #e9ecef;
        }

        /* Watermark inside bill-card */
        .watermark {
            position: absolute;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 6rem;
            color: rgba(0, 0, 0, 0.07);
            font-weight: 900;
            user-select: none;
            pointer-events: none;
            white-space: nowrap;
            text-transform: uppercase;
            letter-spacing: 0.5em;
            z-index: 0;
        }
        .watermark.secondary {
            position: absolute;
            top: 62%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 4rem;
            color: rgba(0, 0, 0, 0.05);
            letter-spacing: 0.3em;
            font-weight: 700;
            z-index: 0;
        }

        /* Content above watermark */
        .bill-card > *:not(.watermark) {
            position: relative;
            z-index: 1;
        }

        /* Print styles */
        @media print {
            @page {
                size: A4;
                margin: 20mm 15mm 20mm 15mm;
            }
            body {
                background-color: white !important;
                margin: 0;
                padding: 0;
            }
            .no-print {
                display: none !important;
            }
            .bill-card {
                box-shadow: none !important;
                border-radius: 0 !important;
                margin: 0 !important;
                padding: 40px 50px !important;
            }
            .watermark, .watermark.secondary {
                color: rgba(0, 0, 0, 0.1) !important;
                position: absolute !important;
                /* keep them visible in print */
            }
        }
    </style>
</head>
<body>

<div class="bill-card">
    <!-- Watermarks inside bill card -->
    <div class="watermark">Authorized Bill</div>
    <div class="watermark secondary">Original</div>

    <div class="bill-header d-flex justify-content-between align-items-center">
        <h2>Bill Summary</h2>
        <span class="text-muted">Bill ID: <%= billId %></span>
    </div>

    <div class="mb-4">
        <h5>Customer Information</h5>
        <p><strong>Name:</strong> <%= (customer != null) ? customer.getName() : "N/A" %></p>
        <p><strong>Account Number:</strong> <%= (customer != null) ? customer.getAccountNumber() : "N/A" %></p>
    </div>

    <div class="mb-4">
        <h5>Bill Details</h5>
        <p><strong>Date:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(bill.getBillingTimestamp()) %></p>
        <p><strong>Payment Method:</strong> <%= bill.getPaymentMethod() %></p>
        <p><strong>Amount Given:</strong> Rs. <%= String.format("%.2f", bill.getAmountGiven()) %></p>
        <p><strong>Change Due:</strong> Rs. <%= String.format("%.2f", bill.getChangeDue()) %></p>
        <p><strong>Shipping Address:</strong> <%= (bill.getShippingAddress() != null) ? bill.getShippingAddress() : "N/A" %></p>
    </div>

    <h5>Items Purchased</h5>
    <table class="table table-striped table-bordered">
        <thead>
            <tr>
                <th>#</th>
                <th>Book Name</th>
                <th>Price (Rs.)</th>
                <th>Quantity</th>
                <th>Discount (%)</th>
                <th>Total (Rs.)</th>
            </tr>
        </thead>
        <tbody>
            <%
                int idx = 1;
                double grandTotal = 0;
                for (BillItem item : billItems) {
                    double itemTotal = item.getPrice() * item.getQuantity() * (1 - item.getDiscount() / 100);
                    grandTotal += itemTotal;
            %>
                <tr>
                    <td><%= idx++ %></td>
                    <td><%= item.getBookName() %></td>
                    <td><%= String.format("%.2f", item.getPrice()) %></td>
                    <td><%= item.getQuantity() %></td>
                    <td><%= String.format("%.2f", item.getDiscount()) %></td>
                    <td><%= String.format("%.2f", itemTotal) %></td>
                </tr>
            <% } %>
            <tr class="total-row">
                <td colspan="5" class="text-end">Grand Total:</td>
                <td>Rs. <%= String.format("%.2f", grandTotal) %></td>
            </tr>
        </tbody>
    </table>

    <div class="d-flex justify-content-between mt-4 no-print">
        <a href="BillingDashboard.jsp" class="btn btn-outline-primary">Back to Dashboard</a>
        <button class="btn btn-success" onclick="window.print()">Print Bill</button>
    </div>
</div>

</body>
</html>
