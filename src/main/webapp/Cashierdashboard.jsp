<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookshop.dao.CustomerDAO, com.bookshop.dao.BuyRequestDAO" %>
<%@ page import="com.bookshop.model.Customer, com.bookshop.model.Account, com.bookshop.model.Book,com.bookshop.dao.SupplierDAO" %>
<%@ page import="com.bookshop.dao.AccountDAO, com.bookshop.dao.BookDAO" %>
<%@ page import="java.util.*" %>
<%@ page import="com.bookshop.dao.BillDAO" %>
<%@ page import="com.bookshop.model.Bill" %>


<%
    // Load all accounts and count roles
    AccountDAO accountDAO = new AccountDAO();
    List<Account> allAccounts = accountDAO.getAllAccounts();

    int adminCount = 0;
    int cashierCount = 0;
    int storeKeeperCount = 0;

    for (Account acc : allAccounts) {
        String role = acc.getRole();
        if ("admin".equalsIgnoreCase(role)) {
            adminCount++;
        } else if ("cashier".equalsIgnoreCase(role)) {
            cashierCount++;
        } else if ("store_keeper".equalsIgnoreCase(role)) {
            storeKeeperCount++;
        }
    }

    // Load customers count
    CustomerDAO customerDAO = new CustomerDAO();
    int customerCount = customerDAO.getAllCustomers().size();

    // Load books and count stock alerts
    BookDAO bookDAO = new BookDAO();
    List<Book> books = bookDAO.getAllBooks();

    int lowStockCount = 0;
    int outOfStockCount = 0;

    for (Book b : books) {
        int qty = b.getStockQuantity();
        if (qty == 0) {
            outOfStockCount++;
        } else if (qty > 0 && qty < 5) {
            lowStockCount++;
        }
    }
%>
<%
    Account account = (Account) session.getAttribute("account");
    String name = (account != null) ? account.getFullname() : "Admin";
    int userId = (account != null) ? account.getId() : -1;
    String profileImg = (account != null && account.getProfileImage() != null)
                        ? account.getProfileImage()
                        : "assets/img/default-avatar.png";
%>
<%BillDAO billDAO = new BillDAO();
int billCount = billDAO.getTotalBillCount();
request.setAttribute("billCount", billCount);

int totalItemsSold = billDAO.getTotalItemsSold();
request.setAttribute("totalItemsSold", totalItemsSold);

 %>
 <%SupplierDAO supplierDAO = new SupplierDAO();
 int supplierCount = supplierDAO.getTotalSupplierCount();
 request.setAttribute("supplierCount", supplierCount);
 %>

<%

int totalStock = bookDAO.getTotalStock();
request.setAttribute("totalStock", totalStock);

%>
 

 <% 
 List<Map<String, Object>> stockBalancingReport = bookDAO.getDailyStockBalancing();
 request.setAttribute("stockBalancingReport", stockBalancingReport);
 %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Cashier Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- External Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>

    <style>
        :root {
            --bg: #181818;
            --card-bg: #252525;
            --text: #eaeaea;
            --primary: #ffa94d;
            --hover: #ffb866;
            --border-radius: 12px;
            --transition-speed: 0.3s;
        }

        body.light-mode {
            --bg: #f9fafc;
            --card-bg: #ffffff;
            --text: #1c1c1c;
            --primary: #2b8aef;
            --hover: #007bff;
        }

        body {
            background: var(--bg);
            color: var(--text);
            font-family: 'Inter', sans-serif;
            transition: background var(--transition-speed), color var(--transition-speed);
            margin: 0;
        }

        .sidebar {
            width: 240px;
            background: var(--card-bg);
            position: fixed;
            top: 0; bottom: 0;
            padding-top: 30px;
            color: var(--text);
            height: 100vh;
        }

        .sidebar h2 {
            color: var(--primary);
            text-align: center;
            margin-bottom: 20px;
            font-size: 20px;
        }

        .sidebar a {
            display: block;
            color: var(--text);
            padding: 12px 20px;
            text-decoration: none;
            transition: background var(--transition-speed);
        }

        .sidebar a:hover {
            background: rgba(255,255,255,0.08);
        }

        .main {
            margin-left: 240px;
            padding: 40px 30px;
        }

        .card-box {
            background: var(--card-bg);
            border-radius: var(--border-radius);
            box-shadow: 0 2px 8px rgba(0,0,0,0.1);
            padding: 20px;
            margin-bottom: 30px;
            transition: transform var(--transition-speed);
        }

        .card-box:hover {
            transform: translateY(-3px);
        }

        .card-box h3 {
            font-size: 20px;
            margin-bottom: 15px;
            color: var(--primary);
        }

        #toggleModeBtn {
            position: fixed;
            top: 15px;
            right: 15px;
            background: var(--primary);
            color: white;
            border: none;
            border-radius: 8px;
            padding: 8px 14px;
            z-index: 1000;
        }

        #toggleModeBtn:hover {
            background: var(--hover);
        }

        #pageLoader {
            position: fixed;
            inset: 0;
            background: rgba(0,0,0,0.85);
            display: none;
            justify-content: center;
            align-items: center;
            flex-direction: column;
            color: white;
            z-index: 9999;
        }

        .spinner {
            width: 60px;
            height: 60px;
            border: 8px solid #eee;
            border-top: 8px solid var(--primary);
            border-radius: 50%;
            animation: spin 1s linear infinite;
            margin-bottom: 10px;
        }

        @keyframes spin {
            to { transform: rotate(360deg); }
        }
        .datetime {
       color: var(--primary);
			  font-size: 10px;
			  color: #fff;
			  background: rgba(255, 255, 255, 0.1); /* semi-transparent */
			  padding: 10px 15px;
			  border-radius: 12px;
			  box-shadow: 0 4px 20px rgba(0,0,0,0.2);
			  backdrop-filter: blur(8px); /* modern blur effect */
			  -webkit-backdrop-filter: blur(8px); /* Safari support */
			  border: 1px solid rgba(255, 255, 255, 0.3);
			  margin-top: 40px;
			   color: var(--primary);
    }
    </style>
</head>

<body>

<!-- Loader -->
<div id="pageLoader">
    <div class="spinner"></div>
    <p>Loading, please wait...</p>
</div>

<!-- Theme Button -->
<button id="toggleModeBtn"><i class="fa fa-moon"></i> Dark Mode</button>

<!-- Sidebar -->
<div class="sidebar">
    <h2>📘 Cashier Panel</h2>
    <a href="View_customers.jsp"><i class="fa fa-user-plus"></i> Register Customer</a>
    
    <a href="BillingDashboard.jsp"><i class="fa fa-file-invoice"></i> Billing  Payment</a>
    <a href="CashierBilling_History.jsp"><i class="fa fa-history"></i> Billing History</a>
    <a href="#help"><i class="fa fa-question-circle"></i> Help</a>
    <a href="AdminLogout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <div id="dateTime" class="datetime"></div>
    <div class="text-center mt-5 mb-3">
        <img src="<%= profileImg %>" alt="Admin"
             style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%; border: 2px solid #fff;margin-top: 50px;">
        <p style="margin-top: 8px; font-weight: 600; color: var(--primary); font-size: 14px;"><%= name %></p>
       
    </div>
</div>

<!-- Main Content -->
<div class="main">
    <h1>Welcome, Cashier🧞 <%= name %></h1>

    <div class="row mt-4 g-4">
        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-users"></i>
                <h3>Customers <%= customerCount %></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-book"></i>
                <h3>Books <%= books.size() %></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-user-shield"></i>
                <h3>Cashiers <%= cashierCount %></h3>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="card-box">
                <i class="fas fa-exclamation-triangle" style="color: #ffc107;"></i>
                <h3>Low Stock: <span style="color: #ffc107;"><%= lowStockCount %></span></h3>
            </div>
        </div>

        <!-- Out of Stock -->
        <div class="col-md-3 col-sm-6">
            <div class="card-box">
                <i class="fas fa-exclamation-circle" style="color: #dc3545;"></i>
                <h3>Out of Stock: <span style="color: #dc3545;"><%= outOfStockCount %></span></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-file-invoice-dollar"></i>
                <h3>Total Bills: <%= request.getAttribute("billCount") %></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-truck"></i>
                <h3>Total Suppliers: <%= request.getAttribute("supplierCount") %></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-boxes"></i>
                <h3>Total Items Sold: <%= totalItemsSold %></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-warehouse"></i>
                <h3>Total Stock: <%= request.getAttribute("totalStock") %></h3>
            </div>
        </div>
        
       <!-- Footer -->
		<footer class="py-4 text-center" style="font-size: 14px; background-color:#181818;">
		  <div class="container">
		    <p style="color: #343a40;">© 2025 <strong style="color: #FF6F00;">PahanaEdu</strong>. All rights reserved.</p>
		    <p style="color: #6c757d;">
		      Developed by <strong style="color: #007BFF;">Dinitha Thewmika</strong>, 
		      Undergraduate, <em style="color: #28a745;">ICBT Campus</em> 🎓
		    </p>
		  </div>
		</footer>
    </div>
</div>


<!-- Scripts -->
<script>
    const toggleBtn = document.getElementById('toggleModeBtn');

    function updateThemeMode() {
        const isLight = document.body.classList.contains('light-mode');
        toggleBtn.innerHTML = isLight
            ? '<i class="fa fa-sun"></i> Light Mode'
            : '<i class="fa fa-moon"></i> Dark Mode';
        localStorage.setItem('darkMode', isLight ? 'disabled' : 'enabled');
    }

    if (localStorage.getItem('darkMode') === 'disabled') {
        document.body.classList.add('light-mode');
    }
    updateThemeMode();

    toggleBtn.addEventListener('click', () => {
        document.body.classList.toggle('light-mode');
        updateThemeMode();
    });
    
    ///
     function updateDateTime() {
      const now = new Date();
      const options = { 
        weekday: 'long', 
        year: 'numeric', 
        month: 'long', 
        day: 'numeric', 
        hour: '2-digit', 
        minute: '2-digit', 
        second: '2-digit' 
      };
      document.getElementById('dateTime').textContent = now.toLocaleString('en-US', options);
    }

    // Update immediately and every second
    updateDateTime();
    setInterval(updateDateTime, 1000);
</script>

<!-- Chart -->

</body>
</html>
