<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.*" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    Customer customer = (Customer) request.getAttribute("customer");
    List<Bill> bills = (List<Bill>) request.getAttribute("bills");
    Map<Integer, List<BillItem>> billItemsMap = (Map<Integer, List<BillItem>>) request.getAttribute("billItemsMap");

    SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd HH:mm");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Billing History</title>

    <!-- Bootstrap 5 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"/>

    <!-- FontAwesome for icons -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet"/>

    <!-- Chart.js -->
    <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.1/dist/chart.umd.min.js"></script>

    <style>
        body {
            font-family: 'Segoe UI', Arial, sans-serif;
            background: #f8f9fa;
        }
        .bill-card {
            margin-bottom: 2rem;
        }
        .table-sm {
            font-size: 0.9rem;
        }
        .emoji {
            font-size: 1.25rem;
            margin-right: 0.25rem;
        }
        .chart-wrap {
            background: #fff;
            border-radius: 1rem;
            padding: 1.5rem;
            box-shadow: 0 0.5rem 1rem rgba(0, 0, 0, 0.1);
            margin-bottom: 2rem;
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
            margin-bottom: 1rem;
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
<body class="container py-4">

<% if (customer != null) { %>
    <a href="Home.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>
    <h2 class="mb-4">
        🧾 Billing History for <strong><%= customer.getName() %></strong>
        <small class="text-muted">(Acct #<%= customer.getAccountNumber() %>)</small>
    </h2>
<% } else { %>
    <div class="alert alert-warning">Customer information not available.</div>
<% } %>

<%-- Chart container --%>


<%-- Bills listing --%>
<% if (bills == null || bills.isEmpty()) { %>
    <div class="alert alert-info">No billing records found.</div>
<% } else { 
       for (Bill bill : bills) { 
           List<BillItem> items = billItemsMap.get(bill.getBillId());
%>
    <div class="card bill-card shadow-sm">
        <div class="card-header bg-primary-subtle">
            <div class="d-flex justify-content-between align-items-center">
                <span class="fs-5">
                    <i class="fa-solid fa-receipt me-2"></i>
                    Bill #<%= bill.getBillId() %>
                </span>
                <span class="text-muted">
                    <i class="fa-regular fa-clock me-1"></i> <%= df.format(bill.getBillingTimestamp()) %>
                </span>
                <button class="btn btn-sm btn-outline-primary" onclick="printBill('bill-<%= bill.getBillId() %>')">
                <i class="fa fa-print"></i> Print
            </button>
            </div>
        </div>

        <div class="card-body">
            <!-- Items table -->
            <div class="table-responsive">
                <table class="table table-sm table-bordered align-middle">
                    <thead class="table-light">
                        <tr>
                            <th>📚 Book</th>
                            <th class="text-center">Qty</th>
                            <th class="text-end">Price</th>
                            <th class="text-end">Discount %</th>
                            <th class="text-end">Total</th>
                        </tr>
                    </thead>
                    <tbody>
                    <% if (items != null) {
                           for (BillItem it : items) { %>
                        <tr>
                            <td><%= it.getBookName() %></td>
                            <td class="text-center"><%= it.getQuantity() %></td>
                            <td class="text-end">Rs <%= String.format("%.2f", it.getPrice()) %></td>
                            <td class="text-end"><%= String.format("%.2f", it.getDiscount()) %>%</td>
                            <td class="text-end">Rs <%= String.format("%.2f", it.getPrice() * it.getQuantity() - it.getDiscount()) %></td>
                            
                        </tr>
                        
                    <%   }
                       } else { %>
                        <tr>
                            <td colspan="5" class="text-center">No items found for this bill.</td>
                        </tr>
                    <% } %>
                    
                    </tbody>
                </table>
            </div>

            <!-- Summary with payment info -->
            <div class="row g-3 mt-3">
                <div class="col-md-6">
                    <div class="p-3 bg-body-secondary rounded-3">
                        <span class="emoji">💵</span>
                        <strong>Total Amount:</strong> Rs <%= String.format("%.2f", bill.getTotalAmount()) %><br/>
                        <span class="emoji">💳</span>
                        <strong>Payment Method:</strong>
                        <span class="badge bg-success text-uppercase"><%= bill.getPaymentMethod() %></span><br/>
                        <span class="emoji">🤲</span>
                        Amount Given: Rs <%= String.format("%.2f", bill.getAmountGiven()) %><br/>
                        <span class="emoji">💰</span>
                        Change Due: Rs <%= String.format("%.2f", bill.getChangeDue()) %>
                    </div>
                </div>

                <div class="col-md-6">
                    <div class="p-3 bg-body-secondary rounded-3">
                        <span class="emoji">🚚</span>
                        <strong>Shipping Address:</strong><br/>
                        <%= bill.getShippingAddress() %>
                    </div>
                </div>
            </div>
        </div>
    </div>
<%   } // end for each bill
   } %>

<%-- Error message --%>
<% if (request.getAttribute("error") != null) { %>
    <div class="alert alert-danger mt-4">
        <i class="fa-solid fa-triangle-exclamation me-2"></i>
        <%= request.getAttribute("error") %>
    </div>
<% } %>

<!-- Bootstrap JS Bundle (optional) -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>

<%-- Chart.js script for bill totals --%>
<% if (bills != null && !bills.isEmpty()) { %>
<script>
    const ctx = document.getElementById('billChart');
    const billLabels = [<%
        for (Iterator<Bill> it = bills.iterator(); it.hasNext();) {
            Bill b = it.next();
            out.print("\"#" + b.getBillId() + "\"");
            if (it.hasNext()) out.print(",");
        } %>];
    const billTotals = [<%
        for (Iterator<Bill> it = bills.iterator(); it.hasNext();) {
            Bill b = it.next();
            out.print(b.getTotalAmount());
            if (it.hasNext()) out.print(",");
        } %>];

    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: billLabels,
            datasets: [{
                label: 'Total Amount (Rs)',
                data: billTotals,
                backgroundColor: 'rgba(42, 122, 226, 0.7)'
            }]
        },
        options: {
            plugins: {
                legend: { display: false }
            },
            scales: {
                y: {
                    beginAtZero: true,
                    title: {
                        display: true,
                        text: 'Rs'
                    }
                },
                x: {
                    title: {
                        display: true,
                        text: 'Bill ID'
                    }
                }
            }
        }
    });
</script>
<% } %>

</body>
</html>
