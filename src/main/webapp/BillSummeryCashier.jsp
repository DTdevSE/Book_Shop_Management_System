<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.model.*, com.bookshop.dao.*" %>
<%@ page import="java.util.List" %>

<%
    String billIdParam = request.getParameter("billId");
    if (billIdParam == null) {
        out.println("<div class='alert alert-danger'>⚠️ Bill ID is missing.</div>");
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
        out.println("<div class='alert alert-danger'>⚠️ Bill not found.</div>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>🧾 Pahana Edu Billing - Bill #<%= billId %></title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>
    <style>
        body { background-color: #f2f2f2; font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; }
        .bill-card {
            max-width: 900px;
            margin: 40px auto;
            padding: 40px 50px;
            background: #fff;
            border-radius: 12px;
            box-shadow: 0 6px 18px rgba(0,0,0,0.1);
            position: relative;
            overflow: hidden;
        }
        .bill-header { border-bottom: 2px solid #dee2e6; margin-bottom: 20px; text-align:center; }
        .bill-header h2 { font-weight: 700; color: #343a40; }
        .table thead th { background-color: #343a40; color: white; }
        .total-row { font-weight: 700; font-size: 1.1rem; background-color: #e9ecef; }

        /* Watermarks */
        .watermark {
            position: absolute; top: 50%; left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 6rem; color: rgba(0,0,0,0.07); font-weight: 900;
            text-align: center; user-select: none; pointer-events: none;
            text-transform: uppercase; letter-spacing: 0.5em; z-index: 0;
        }
        .watermark.secondary {
            position: absolute; top: 62%; left: 50%;
            transform: translate(-50%, -50%) rotate(-30deg);
            font-size: 4rem; color: rgba(0,0,0,0.05);
            font-weight: 700; letter-spacing: 0.3em; z-index: 0;
        }

        /* Content above watermark */
        .bill-card > *:not(.watermark) { position: relative; z-index: 1; }

        /* Footer */
        .bill-footer {
            text-align: center;
            margin-top: 40px;
            font-style: italic;
            color: #6c757d;
            font-size: 0.95rem;
        }
 /* Faint footer for PDF */
    .bill-footer.pdf-footer {
        text-align: center;
        font-style: italic;
        color: rgba(0,0,0,0.3);
        font-size: 0.95rem;
        margin-top: 30px;
    }
      @media print {
    .no-print {
        display: none !important;
    }
}
    </style>
</head>
<body>

<div class="bill-card" id="pdfContent">
   
    <div class="bill-header">
        <h2>🏫 Pahana Edu Billing</h2>
        <span class="text-muted">Bill ID: <%= billId %></span>
    </div>

    <div class="mb-4">
        <h5>👤 Customer Information</h5>
        <p><strong>📝 Name:</strong> <%= (customer != null) ? customer.getName() : "N/A" %></p>
        <p><strong>🔢 Account:</strong> <%= (customer != null) ? customer.getAccountNumber() : "N/A" %></p>
    </div>

    <div class="mb-4">
        <h5>💳 Bill Details</h5>
        <p><strong>📅 Date:</strong> <%= new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(bill.getBillingTimestamp()) %></p>
        <p><strong>💰 Payment Method:</strong> <%= bill.getPaymentMethod() %></p>
        <p><strong>💵 Amount Given:</strong> Rs. <%= String.format("%.2f", bill.getAmountGiven()) %></p>
        <p><strong>🔄 Change Due:</strong> Rs. <%= String.format("%.2f", bill.getChangeDue()) %></p>
        <p><strong>📍 Shipping:</strong> <%= (bill.getShippingAddress() != null) ? bill.getShippingAddress() : "N/A" %></p>
    </div>

    <h5>📚 Items Purchased</h5>
    <table class="table table-striped table-bordered">
        <thead>
        <tr>
            <th>#</th>
            <th>📖 Book Name</th>
            <th>💰 Price (Rs.)</th>
            <th>🔢 Quantity</th>
            <th>🏷️ Discount (%)</th>
            <th>💵 Total (Rs.)</th>
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
            <td colspan="5" class="text-end">💰 Grand Total:</td>
            <td>Rs. <%= String.format("%.2f", grandTotal) %></td>
        </tr>
        </tbody>
    </table>

    <!-- Buttons (hide in PDF) -->
    <div class="d-flex justify-content-between mt-4 no-print">
   <a href="SearchBillServlet" class="btn btn-outline-primary">
    ⬅️ Back to Dashboard
</a>

        <div>
            <!--  <button class="btn btn-success" onclick="window.print()">🖨️ Print Bill</button>-->
            <button class="btn btn-danger" onclick="downloadPDF()">💾 Download PDF</button>
        </div>
    </div>

    <!-- Footer -->
    <div class="bill-footer no-print">
        🙏 Thank you for choosing Pahana Edu. Come again! 💖
    </div>
</div>

<script>
function downloadPDF() {
    const element = document.getElementById('pdfContent');
    const clone = element.cloneNode(true);

    // Remove buttons only
    clone.querySelectorAll('.no-print').forEach(el => el.remove());

    // Remove existing watermark if any
    clone.querySelectorAll('.watermark').forEach(el => el.remove());

    // Ensure top header shows "Original Copy" in red
    let header = clone.querySelector('.original-copy-header');
    if (!header) {
        header = document.createElement('h2');
        header.className = 'original-copy-header';
        header.innerText = 'ORIGINAL COPY';
        header.style.color = 'red';
        header.style.textAlign = 'center';
        header.style.fontWeight = 'bold';
        header.style.marginBottom = '20px';
        clone.prepend(header); // add to top of clone
    }

    // Add PDF footer
    if (!clone.querySelector('.pdf-footer')) {
        const footer = document.createElement('div');
        footer.className = 'bill-footer pdf-footer';
        footer.style.textAlign = 'center';
        footer.style.marginTop = '30px';
        footer.style.fontWeight = 'bold';
        footer.innerHTML = '🙏 Thank you for choosing Pahana Edu. 💖';
        clone.appendChild(footer);
    }

    const opt = {
        margin: 0.5,
        filename: 'Bill_<%= billId %>.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2, scrollY: -window.scrollY },
        jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
    };
    html2pdf().set(opt).from(clone).save();
}


</script>

</body>
</html>
