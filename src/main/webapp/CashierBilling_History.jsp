<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.bookshop.model.Bill, com.bookshop.model.BillItem, com.bookshop.model.Customer" %>

<%
    Customer customer = (Customer) request.getAttribute("customer");
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    Map<Integer, List<BillItem>> billItemsMap = (Map<Integer, List<BillItem>>) request.getAttribute("billItemsMap");
    String error = (String) request.getAttribute("error");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Billing History</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css" rel="stylesheet">
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
        }
        .section-header i {
            color: #fd7e14;
        }
        .card {
            border: none;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .bill-card {
            margin-bottom: 20px;
        }
        .print-section {
            background-color: #fff;
            padding: 15px;
        }
        @media print {
            body * {
                visibility: hidden;
            }
            .print-section, .print-section * {
                visibility: visible;
            }
            .print-section {
                position: absolute;
                left: 0;
                top: 0;
                width: 100%;
            }
        }
        .back-btn {
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
        }
    </style>
</head>
<body>
<div class="container py-4">
<!-- Back Button -->
            <a href="Cashierdashboard.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>
    <h2 class="mb-4 text-primary section-header"><i class="bi bi-receipt"></i> Billing History</h2>

    <% if (error != null) { %>
        <div class="alert alert-danger"><i class="bi bi-exclamation-triangle-fill"></i> <%= error %></div>
    <% } %>

    <form action="SearchBillServlet" method="get" class="input-group mb-4">
    <input type="text" name="customerId" class="form-control" placeholder="Enter Customer ID" required
           value="<%= request.getParameter("customerId") != null ? request.getParameter("customerId") : "" %>">
    <button class="btn btn-outline-primary" type="submit">
        <i class="bi bi-search"></i> Search
    </button>
    <a href="CashierBilling_History.jsp" class="btn btn-outline-secondary">
        <i class="bi bi-arrow-clockwise"></i> Reset
    </a>
</form>


    <% if (customer != null) { %>
        <div class="card mb-4 p-3">
            <h5 class="card-title text-secondary"><i class="bi bi-person-vcard"></i> Customer Information</h5>
            <p><strong>Name:</strong> <%= customer.getName() %></p>
            <p><strong>Account No:</strong> <%= customer.getAccountNumber() %></p>
            <p><strong>Address:</strong> <%= customer.getAddress() %></p>
            <p><strong>Telephone:</strong> <%= customer.getTelephone() %></p>
        </div>

        <% if (bills == null || bills.isEmpty()) { %>
            <div class="alert alert-info"><i class="bi bi-info-circle-fill"></i> No bills found for this customer.</div>
        <% } else { %>
            <% for (Bill bill : bills) { %>
                <div class="card bill-card">
                    <div class="card-header bg-primary text-white d-flex justify-content-between align-items-center">
                        <div>
                            <i class="bi bi-file-earmark-text"></i> Bill ID: <%= bill.getBillId() %>
                        </div>
                        <small><i class="bi bi-calendar-event"></i> <%= bill.getBillingTimestamp() %></small>
                    </div>
                    <div class="card-body">
                        <p><strong>Total:</strong> Rs. <%= String.format("%.2f", bill.getTotalAmount()) %></p>
                        <p><strong>Payment:</strong> <%= bill.getPaymentMethod() %> | 
                           <strong>Amount Given:</strong> Rs. <%= String.format("%.2f", bill.getAmountGiven()) %> | 
                           <strong>Change:</strong> Rs. <%= String.format("%.2f", bill.getChangeDue()) %></p>
                        <p><strong>Shipping:</strong> <%= bill.getShippingAddress() != null ? bill.getShippingAddress() : "N/A" %></p>

                        <div class="print-section" id="printSection<%= bill.getBillId() %>">
                            <table class="table table-bordered table-hover table-sm mt-3">
                                <thead class="table-light">
                                    <tr>
                                        <th>#</th>
                                        <th>Book</th>
                                        <th>Price</th>
                                        <th>Qty</th>
                                        <th>Disc (%)</th>
                                        <th>Total</th>
                                    </tr>
                                </thead>
                                <tbody>
                                <%
                                    List<BillItem> billItems = billItemsMap.get(bill.getBillId());
                                    if (billItems != null) {
                                        int idx = 1;
                                        for (BillItem item : billItems) {
                                            double total = item.getPrice() * item.getQuantity() * (1 - item.getDiscount() / 100);
                                %>
                                <tr>
                                    <td><%= idx++ %></td>
                                    <td><%= item.getBookName() %></td>
                                    <td>Rs. <%= String.format("%.2f", item.getPrice()) %></td>
                                    <td><%= item.getQuantity() %></td>
                                    <td><%= String.format("%.2f", item.getDiscount()) %></td>
                                    <td>Rs. <%= String.format("%.2f", total) %></td>
                                </tr>
                                <% } } else { %>
                                <tr><td colspan="6" class="text-center text-muted">No items found</td></tr>
                                <% } %>
                                </tbody>
                            </table>
                        </div>

                        <div class="mt-3">
                            <a href="BillSummary.jsp?billId=<%= bill.getBillId() %>" target="_blank" class="btn btn-outline-success btn-sm">
                                <i class="bi bi-printer-fill"></i> View & Print
                            </a>
                        </div>
                    </div>
                </div>
            <% } %>
        <% } %>
    <% } %>
</div>

<script>
    function printSection(sectionId) {
        const content = document.getElementById(sectionId).innerHTML;
        const original = document.body.innerHTML;
        document.body.innerHTML = content;
        window.print();
        document.body.innerHTML = original;
        location.reload();
    }
</script>
</body>
</html>
