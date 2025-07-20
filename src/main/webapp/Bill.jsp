<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="com.bookshop.model.BillItem" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
    com.bookshop.model.Bill bill = (com.bookshop.model.Bill) request.getAttribute("bill");
    com.bookshop.model.Customer customer = (com.bookshop.model.Customer) request.getAttribute("customer");
    java.util.List<BillItem> billItems = (java.util.List<BillItem>) request.getAttribute("billItems");
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Pahadu Edu Book Shop - Payment Bill</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <style>
        body {
            background: #f8f9fa;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .bill-header {
            border-bottom: 3px solid #007bff;
            padding-bottom: 10px;
            margin-bottom: 20px;
        }
        .bill-info p {
            margin-bottom: 0.4rem;
        }
        .table thead {
            background-color: #007bff;
            color: white;
        }
        .total-row {
            font-weight: 700;
            font-size: 1.1rem;
            background-color: #e9ecef;
        }
        .payment-section {
            margin-top: 30px;
        }
        /* PRINT WATERMARK */
        @media print {
          body {
            position: relative;
          }
          .watermark {
            position: fixed;
            top: 50%;
            left: 50%;
            transform: translate(-50%, -50%) rotate(-45deg);
            font-size: 72px;
            color: rgba(0, 123, 255, 0.15);
            user-select: none;
            pointer-events: none;
            z-index: 9999;
            white-space: nowrap;
          }
          /* Hide buttons and form during printing */
          button, form, a.btn {
            display: none !important;
          }
          /* Show payment details and greeting on print */
          #paymentDetails, #greetingMessage {
            display: block !important;
          }
        }

        /* Hidden initially */
        #paymentDetails, #greetingMessage {
          display: none;
        }
    </style>
</head>
<body class="container py-4">

    <div class="bill-header text-center">
        <h1 class="display-5">Pahadu Edu Book Shop</h1>
        <p class="text-muted fst-italic">Payment Bill & Receipt</p>
        <small>🧾 Bill ID: <%= bill != null ? bill.getBillId() : "N/A" %></small>
    </div>

    <div class="row mb-4 bill-info">
        <div class="col-md-6">
            <h5>Customer Information</h5>
            <p><strong>Name:</strong> <%= customer != null ? customer.getName() : "N/A" %></p>
            <p><strong>Address:</strong> <%= customer != null ? customer.getAddress() : "N/A" %></p>
            <p><strong>Telephone:</strong> <%= customer != null ? customer.getTelephone() : "N/A" %></p>
        </div>
        <div class="col-md-6">
            <h5>Billing Details</h5>
            <p><strong>Date/Time:</strong> <%= bill != null ? sdf.format(bill.getBillingTimestamp()) : "N/A" %></p>
            <p><strong>Total Amount:</strong> Rs. <%= bill != null ? String.format("%.2f", bill.getTotalAmount()) : "0.00" %></p>
        </div>
    </div>

    <h4>Purchased Items</h4>
    <table class="table table-striped shadow-sm">
        <thead>
            <tr>
                <th>Book Name</th>
                <th>Unit Price (Rs.)</th>
                <th>Discount (%)</th>
                <th>Quantity</th>
                <th>Total (Rs.)</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="item" items="${billItems}">
                <tr>
                    <td>${item.bookName}</td>
                    <td>${item.price}</td>
                    <td>${item.discount}</td>
                    <td>${item.quantity}</td>
                    <td>${item.total}</td>
                </tr>
            </c:forEach>
        </tbody>
        <tfoot>
            <tr class="total-row">
                <td colspan="4" class="text-end">Total Payable:</td>
                <td>Rs. <%= bill != null ? String.format("%.2f", bill.getTotalAmount()) : "0.00" %></td>
            </tr>
        </tfoot>
    </table>

    <!-- Payment Method Section -->
    <div class="payment-section shadow p-4 rounded bg-white">
        <h5>Payment Method</h5>
        <form id="paymentForm">
            <div class="mb-3">
                <label for="paymentMethod" class="form-label">Select Payment Method</label>
                <select id="paymentMethod" name="paymentMethod" class="form-select" required>
                    <option value="" disabled selected>Select...</option>
                    <option value="cash">Cash</option>
                    <option value="card">Card</option>
                    <option value="upi">UPI</option>
                </select>
            </div>

            <!-- Amount Given and Change will show only if Cash is selected -->
            <div id="cashPaymentSection" style="display:none;">
                <div class="mb-3">
                    <label for="amountGiven" class="form-label">Amount Given (Rs.)</label>
                    <input type="number" min="0" step="0.01" class="form-control" id="amountGiven" placeholder="Enter amount customer gave" />
                </div>
                <div class="mb-3">
                    <label class="form-label">Change Due (Rs.)</label>
                    <input type="text" class="form-control" id="changeDue" readonly value="0.00" />
                </div>
            </div>

            <button type="submit" class="btn btn-success">Confirm Payment</button>
        </form>
    </div>

    <a href="BillingDashboard.jsp" class="btn btn-outline-primary mt-4">← Back to Billing Dashboard</a>

    <div class="watermark">Authorized Bill - Pahadu Edu</div>

    <!-- Payment Details for printing -->
    <div id="paymentDetails" class="mt-4 p-3 bg-light border rounded">
        <h5>Payment Details</h5>
        <p><strong>Payment Method:</strong> <span id="paymentMethodDisplay"></span></p>
        <p id="amountGivenDisplayP" style="display:none;"><strong>Amount Given:</strong> Rs. <span id="amountGivenDisplay"></span></p>
        <p id="changeDueDisplayP" style="display:none;"><strong>Change Due:</strong> Rs. <span id="changeDueDisplay"></span></p>
    </div>

    <!-- Greeting message -->
    <div id="greetingMessage" class="text-center mt-5 mb-5 fst-italic fw-semibold" style="font-size:1.3rem;">
        Thank you for choosing <strong>Pahadu Edu Book Shop!</strong>
    </div>

    <script>
        const paymentMethod = document.getElementById('paymentMethod');
        const cashPaymentSection = document.getElementById('cashPaymentSection');
        const amountGivenInput = document.getElementById('amountGiven');
        const changeDueInput = document.getElementById('changeDue');

        const paymentDetailsDiv = document.getElementById('paymentDetails');
        const paymentMethodDisplay = document.getElementById('paymentMethodDisplay');
        const amountGivenDisplayP = document.getElementById('amountGivenDisplayP');
        const amountGivenDisplay = document.getElementById('amountGivenDisplay');
        const changeDueDisplayP = document.getElementById('changeDueDisplayP');
        const changeDueDisplay = document.getElementById('changeDueDisplay');

        const totalAmount = <%= bill != null ? bill.getTotalAmount() : 0.00 %>;

        paymentMethod.addEventListener('change', () => {
            if(paymentMethod.value === 'cash') {
                cashPaymentSection.style.display = 'block';
                amountGivenInput.required = true;
            } else {
                cashPaymentSection.style.display = 'none';
                amountGivenInput.value = '';
                changeDueInput.value = '0.00';
                amountGivenInput.required = false;
            }
        });

        amountGivenInput.addEventListener('input', () => {
            let amountGiven = parseFloat(amountGivenInput.value);
            if (!isNaN(amountGiven) && amountGiven >= totalAmount) {
                changeDueInput.value = (amountGiven - totalAmount).toFixed(2);
            } else {
                changeDueInput.value = '0.00';
            }
        });

        document.getElementById('paymentForm').addEventListener('submit', function(e) {
            e.preventDefault();

            let method = paymentMethod.value;
            if (!method) {
                alert('Please select a payment method.');
                return;
            }

            if(method === 'cash') {
                let amountGiven = parseFloat(amountGivenInput.value);
                if(isNaN(amountGiven) || amountGiven < totalAmount) {
                    alert('Amount given should be equal or greater than total amount.');
                    return;
                }
                alert(`Payment successful!\nMethod: Cash\nChange to return: Rs. ${changeDueInput.value}`);

                // Show payment details
                paymentMethodDisplay.textContent = 'Cash';
                amountGivenDisplay.textContent = amountGiven.toFixed(2);
                changeDueDisplay.textContent = changeDueInput.value;
                amountGivenDisplayP.style.display = 'block';
                changeDueDisplayP.style.display = 'block';

            } else {
                alert(`Payment successful!\nMethod: ${method.charAt(0).toUpperCase() + method.slice(1)}`);

                // Show payment details for non-cash
                paymentMethodDisplay.textContent = method.charAt(0).toUpperCase() + method.slice(1);
                amountGivenDisplayP.style.display = 'none';
                changeDueDisplayP.style.display = 'none';
            }

            paymentDetailsDiv.style.display = 'block';

            // Trigger browser print dialog after payment confirmation
            window.print();
        });
    </script>

</body>
</html>
