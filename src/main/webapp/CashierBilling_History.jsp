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
    <style>
        .bill-items-table th, .bill-items-table td {
            font-size: 0.9rem;
        }
        .nested-table {
            margin-top: 0.5rem;
            margin-bottom: 1rem;
        }
        .print-section {
            padding: 15px;
            background-color: #fff;
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
    </style>
</head>
<body class="p-4">
<div class="container">
    <h2>Billing History</h2>

    <% if (error != null) { %>
        <div class="alert alert-danger"><%= error %></div>
    <% } %>

    <form action="SearchBillServlet" method="get" class="mb-4">
        <div class="input-group">
            <input type="text" name="customerId" placeholder="Enter Customer ID" class="form-control" required
                   value="<%= request.getParameter("customerId") != null ? request.getParameter("customerId") : "" %>" />
            <button class="btn btn-primary" type="submit">Search</button>
        </div>
    </form>

    <% if (customer != null) { %>
        <div class="mb-4 p-3 border rounded bg-light">
            <h4>Customer Information</h4>
            <p><strong>Name:</strong> <%= customer.getName() %></p>
            <p><strong>Account Number:</strong> <%= customer.getAccountNumber() %></p>
            <p><strong>Address:</strong> <%= customer.getAddress() %></p>
            <p><strong>Telephone:</strong> <%= customer.getTelephone() %></p>
        </div>

        <% if (bills == null || bills.isEmpty()) { %>
            <div class="alert alert-info">No bills found for this customer.</div>
        <% } else { %>
            <table class="table table-bordered table-striped">
                <thead class="table-dark">
                    <tr>
                        <th>Bill ID</th>
                        <th>Date</th>
                        <th>Total (Rs.)</th>
                        <th>Payment</th>
                        <th>Amount Given (Rs.)</th>
                        <th>Change (Rs.)</th>
                        <th>Shipping</th>
                        <th>Items & Print</th>
                    </tr>
                </thead>
                <tbody>
                <% for (Bill bill : bills) { %>
                    <tr>
                        <td><%= bill.getBillId() %></td>
                        <td><%= bill.getBillingTimestamp() %></td>
                        <td><%= String.format("%.2f", bill.getTotalAmount()) %></td>
                        <td><%= bill.getPaymentMethod() %></td>
                        <td><%= String.format("%.2f", bill.getAmountGiven()) %></td>
                        <td><%= String.format("%.2f", bill.getChangeDue()) %></td>
                        <td><%= bill.getShippingAddress() != null ? bill.getShippingAddress() : "N/A" %></td>
                        <td style="min-width: 300px;">
                            <div class="print-section" id="printSection<%= bill.getBillId() %>">
                                <table class="table table-sm nested-table bill-items-table">
                                    <thead>
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
                                            <td><%= String.format("%.2f", item.getPrice()) %></td>
                                            <td><%= item.getQuantity() %></td>
                                            <td><%= String.format("%.2f", item.getDiscount()) %></td>
                                            <td><%= String.format("%.2f", total) %></td>
                                        </tr>
                                        <% } } else { %>
                                        <tr><td colspan="6" class="text-center">No items found</td></tr>
                                        <% } %>
                                    </tbody>
                                </table>
                                <p><strong>Total Bill:</strong> Rs. <%= String.format("%.2f", bill.getTotalAmount()) %></p>
                                <p><strong>Payment Method:</strong> <%= bill.getPaymentMethod() %></p>
                            </div>
                           <a href="BillSummary.jsp?billId=<%= bill.getBillId() %>" class="btn btn-sm btn-primary" target="_blank">View & Print</a>

                        </td>
                    </tr>
                <% } %>
                </tbody>
            </table>
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
        location.reload(); // Refresh to restore original state
    }
</script>
</body>
</html>
