<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.dao.BillDAO, com.bookshop.model.Bill" %>
<%@ page import="com.bookshop.util.DBConnection" %>

<!-- Bootstrap 5 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>
 <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

<!-- Chart.js -->
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

<!-- html2pdf.js for PDF export -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.9.3/html2pdf.bundle.min.js"></script>

<%
    BillDAO billDAO = new BillDAO();
    List<Bill> bills = billDAO.getAllBills();

    int start = 1;
    int end = (bills != null) ? bills.size() : 0;

    String startParam = request.getParameter("start");
    String endParam = request.getParameter("end");

    if (startParam != null && endParam != null) {
        try {
            start = Integer.parseInt(startParam);
            end = Integer.parseInt(endParam);
        } catch (Exception e) {
            start = 1;
            end = (bills != null) ? bills.size() : 0;
        }
    }

    // Calculate totals
    double totalAmount = 0.0, totalGiven = 0.0, totalChange = 0.0;
    List<Bill> filteredBills = new ArrayList<>();

    if (bills != null && !bills.isEmpty()) {
        for (int i = start - 1; i < end && i < bills.size(); i++) {
            Bill b = bills.get(i);
            filteredBills.add(b);
            totalAmount += b.getTotalAmount();
            totalGiven += b.getAmountGiven();
            totalChange += b.getChangeDue();
        }
    }
%>
<style>
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
<div class="container mt-5">
<!-- Back Button -->
            <a href="AdminHome.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>
    <h3 class="mb-4 text-center">🧾 Billing History</h3>

    <!-- Filter Form -->
    <form method="get" class="row g-3 mb-4 justify-content-center">
        <div class="col-auto">
            <label class="form-label">Start #</label>
            <input type="number" class="form-control" name="start" value="<%= start %>" min="1">
        </div>
        <div class="col-auto">
            <label class="form-label">End #</label>
            <input type="number" class="form-control" name="end" value="<%= end %>" min="1">
        </div>
        <div class="col-auto align-self-end">
        
            <button type="submit" class="btn btn-primary"><i class="bi bi-funnel"></i> Filter</button>
            <button type="button" onclick="downloadPDF()" class="btn btn-danger">
                <i class="bi bi-file-earmark-pdf"></i> Download PDF
            </button>
             <button type="button" class="btn btn-secondary" onclick="restoreDefaults()">
        <i class="bi bi-arrow-counterclockwise"></i> Restore
    </button>
        </div>
    </form>

    <!-- 📄 Wrap TABLE + SUMMARY + CHART for PDF export -->
    <div id="pdfContent">

        <!-- Table -->
        <div class="table-responsive shadow-sm rounded">
            <table class="table table-striped table-hover align-middle text-center border">
                <thead class="table-dark">
                    <tr>
                        <th>📄 Bill No</th>
                        <th>👤 Customer ID</th>
                        <th>💰 Total (Rs.)</th>
                        <th>💳 Method</th>
                        <th>💵 Amount Given</th>
                        <th>🔄 Change Due</th>
                        <th>📍 Address</th>
                        <th>⏰ Time</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                        int count = start;
                        if (!filteredBills.isEmpty()) {
                            for (Bill b : filteredBills) {
                    %>
                    <tr>
                        <td><i class="bi bi-receipt-cutoff text-primary"></i> #<%= count++ %></td>
                        <td><i class="bi bi-person-circle text-info"></i> <%= b.getCustomerId() %></td>
                        <td><i class="bi bi-cash-coin text-success"></i> <%= String.format("%.2f", b.getTotalAmount()) %></td>
                        <td>
                            <% if("Cash".equalsIgnoreCase(b.getPaymentMethod())) { %>
                                💵 Cash
                            <% } else if("Card".equalsIgnoreCase(b.getPaymentMethod())) { %>
                                💳 Card
                            <% } else { %>
                                🏦 <%= b.getPaymentMethod() %>
                            <% } %>
                        </td>
                        <td><i class="bi bi-wallet2 text-warning"></i> <%= String.format("%.2f", b.getAmountGiven()) %></td>
                        <td><i class="bi bi-arrow-repeat text-danger"></i> <%= String.format("%.2f", b.getChangeDue()) %></td>
                        <td><i class="bi bi-geo-alt-fill text-secondary"></i> <%= b.getShippingAddress() %></td>
                        <td><i class="bi bi-clock-history text-dark"></i> <%= b.getBillingTimestamp() %></td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
                    <tr>
                        <td colspan="8" class="text-center">⚠️ No billing history available.</td>
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>

        <!-- Totals -->
        <div class="mt-4 p-3 border rounded bg-light">
            <h5>📊 Summary (Bills #<%= start %> to #<%= end %>)</h5>
            <p>💰 Total Amount: <strong><%= String.format("%.2f", totalAmount) %></strong></p>
            <p>💵 Total Given: <strong><%= String.format("%.2f", totalGiven) %></strong></p>
            <p>🔄 Total Change: <strong><%= String.format("%.2f", totalChange) %></strong></p>
        </div>

        <!-- Chart -->
        <div class="mt-4">
            <canvas id="summaryChart" height="120"></canvas>
        </div>
    </div>
</div>

<script>
    // Chart
    const ctx = document.getElementById('summaryChart').getContext('2d');
    new Chart(ctx, {
        type: 'bar',
        data: {
            labels: ['Total Amount', 'Total Given', 'Total Change'],
            datasets: [{
                label: 'Summary (Rs.)',
                data: [<%= totalAmount %>, <%= totalGiven %>, <%= totalChange %>],
                backgroundColor: ['#198754', '#0d6efd', '#dc3545']
            }]
        }
    });

    // PDF Download (Table + Summary only, with watermark)
function downloadPDF() {
    const element = document.getElementById('pdfContent');

    // Clone content for PDF
    const clone = element.cloneNode(true);

    // Remove chart from clone
    const charts = clone.querySelectorAll("canvas");
    charts.forEach(c => c.remove());

    // Create header
    const header = document.createElement("div");
    header.innerHTML = "<h2 style='text-align:center;'>📚 Pahana Edu Billing Summary</h2>";
    header.style.width = "100%";
    header.style.textAlign = "center";
    header.style.marginBottom = "20px";
    clone.insertBefore(header, clone.firstChild);

    // Create footer
    const footer = document.createElement("div");
    footer.innerHTML = "<p style='text-align:center;'>© All rights received by Admin, Pahana Edu Book Shop</p>";
    footer.style.width = "100%";
    footer.style.textAlign = "center";
    footer.style.marginTop = "20px";
    clone.appendChild(footer);

    // Add centered watermark
    const watermark = document.createElement("div");
    watermark.innerText = "Admin Only";
    watermark.style.position = "fixed";
    watermark.style.top = "50%";
    watermark.style.left = "50%";
    watermark.style.transform = "translate(-50%, -50%) rotate(-30deg)";
    watermark.style.fontSize = "60px";
    watermark.style.fontWeight = "bold";
    watermark.style.color = "rgba(150,150,150,0.2)";
    watermark.style.zIndex = "0";
    clone.appendChild(watermark);

    // Export to PDF
    const opt = {
        margin: 0.5,
        filename: 'Billing_History.pdf',
        image: { type: 'jpeg', quality: 0.98 },
        html2canvas: { scale: 2, scrollY: -window.scrollY },
        jsPDF: { unit: 'in', format: 'a4', orientation: 'portrait' }
    };

    html2pdf().set(opt).from(clone).save();
}

function restoreDefaults() {
    // Reset the start and end input values to defaults
    document.querySelector("input[name='start']").value = 1;
    document.querySelector("input[name='end']").value = <%= (bills != null ? bills.size() : 0) %>;
    
    // Optionally, submit the form to reload the page with default values
    document.querySelector("form").submit();
}

</script>
