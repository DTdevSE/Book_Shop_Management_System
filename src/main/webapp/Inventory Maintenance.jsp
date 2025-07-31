<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookshop.dao.CustomerDAO, com.bookshop.dao.AccountDAO, com.bookshop.dao.BookDAO,com.bookshop.dao.BillDAO,com.bookshop.dao.SupplierDAO" %>
<%@ page import="com.bookshop.model.Account, com.bookshop.model.Book" %>
<%@ page import="java.util.List" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ page import="java.util.Map" %>


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
    <meta charset="UTF-8" />
    <title>Store Keeper Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1" />

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- FontAwesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <!-- Google Fonts -->
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet" />

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
            margin: 0;
            transition: background var(--transition-speed), color var(--transition-speed);
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
            position: relative;
            transition: background var(--transition-speed);
        }
        .sidebar a:hover {
            background: rgba(255, 255, 255, 0.08);
        }
        /* Badge styles */
        .stock-badge {
         color: var(--primary);
            font-size: 0.75rem;
            font-weight: 700;
            padding: 2px 7px;
            margin-left: 8px;
            border-radius: 12px;
            display: inline-block;
            vertical-align: middle;
            min-width: 24px;
            text-align: center;
        }
        .low-stock {
            background-color: #ffc107; /* Yellow */
            color: #000;
            border: 1px solid #e0a800;
        }
        .out-stock {
            background-color: #dc3545; /* Red */
            color: #fff;
            border: 1px solid #b02a37;
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
            cursor: pointer;
        }
        #toggleModeBtn:hover {
            background: var(--hover);
        }
         .datetime {
          background: var(--card-bg);
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
    /* Stock Table */
table {
    background-color: rgba(255, 255, 255, 0.1); /* semi-transparent */
    border-collapse: collapse;
    margin-top: 30px;
    border-radius: 8px;
    overflow: hidden;
    box-shadow: 0 2px 12px rgba(0,0,0,0.05);
}

table th, table td {
    padding: 12px 18px;
    text-align: center;
}

table th {
    background-color: #f9f9f9;
    font-weight: 600;
    color: #555;
}

table td {
    font-size: 0.95rem;
    color: #333;
     color: var(--primary);
}
    </style>
</head>
<body>
<!-- Main Content -->
<div class="main">
    <h1>Welcome, Store Keeper 🤹 <%= name %></h1>

    <!-- Row 1 -->
    <div class="row mt-4 g-4">
        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-users"></i>
                <h3>Total Customers: <%= customerCount %></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-book"></i>
                <h3>Total Books: <%= books.size() %></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-user-cog"></i>
                <h3>Store Keepers: <%= storeKeeperCount %></h3>
            </div>
        </div>

        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i>
                <h3>Low Stock Books: <span style="color: #dc3545;"><%= lowStockCount %></span></h3>
            </div>
        </div>
    </div>

    <!-- Row 2 -->
    <div class="row mt-4 g-4">
        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-exclamation-triangle" style="color: #dc3545;"></i>
                <h3>Out of Stock Books: <span style="color: #dc3545;"><%= outOfStockCount %></span></h3>
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
       
     <h3 class="text-center mt-5">📦 Daily Stock Balancing Report</h3>

<table border="0" style="width:80%; margin:auto; border-collapse: collapse; box-shadow: 0 4px 12px rgba(0,0,0,0.05); border-radius: 8px; overflow: hidden; font-family: sans-serif;">
    <thead style="background-color: #f8f9fa;">
        <tr>
            <th style="padding: 12px 18px;">📅 Date</th>
            <th style="padding: 12px 18px; color:green;">⬆️ Stock IN</th>
            <th style="padding: 12px 18px; color:red;">⬇️ Stock OUT</th>
        </tr>
    </thead>
    <tbody>
        <c:forEach var="row" items="${stockBalancingReport}">
            <tr style="text-align: center; border-top: 1px solid #eee;">
                <td style="padding: 10px 15px;">📆 ${row.date}</td>
                <td style="padding: 10px 15px; color:green;">➕ ${row.stock_in}</td>
                <td style="padding: 10px 15px; color:red;">➖ ${row.stock_out}</td>
            </tr>
        </c:forEach>
    </tbody>
</table>


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

    <!-- You can add your Monthly Inventory Activity chart here -->
</div>

<!-- Sidebar -->
<div class="sidebar">
    <h2>📦 Store Keeper</h2>

    <a href="StoreKeeperViewBooks.jsp" style="white-space: nowrap;">
        <i class="fa fa-book"></i> View Books
        <% if (lowStockCount > 0) { %>
            <span class="stock-badge low-stock" title="Low Stock"><%= lowStockCount %></span>
        <% } %>
        <% if (outOfStockCount > 0) { %>
            <span class="stock-badge out-stock" title="Out of Stock"><%= outOfStockCount %></span>
        <% } %>
    </a>

    <a href="ManageStock.jsp"><i class="fa fa-plus-circle"></i> Manage Stock</a>
    <a href="ManageSuppliers.jsp"><i class="fa fa-user"></i> Manage Suppliers</a>
    <a href="ManageBookSupplierMapping.jsp"><i class="fa fa-truck"></i> Suplier Mapping</a>
    
    
    <a href="StockMonitoring.jsp" style="white-space: nowrap;">
        <i class="fa fa-warehouse"></i> Stock Monitoring
        
        <% if (outOfStockCount > 0) { %>
            <span class="stock-badge out-stock" title="Out of Stock"><%= outOfStockCount %></span>
        <% } %>
    </a>
    <a href="#"><i class="fa fa-question-circle"></i> Help</a>
    <a href="AdminLogout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    
    <div id="dateTime" class="datetime"></div>
    <div class="text-center mt-5 mb-3">
        <img src="<%= profileImg %>" alt="Admin"
             style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%; border: 2px solid #fff;margin-top: 25px;">
        <p style="margin-top: 8px; font-weight: 600; color: var(--primary); font-size: 14px;"><%= name %></p>
       
    </div>
</div>


<!-- Dark Mode Toggle -->
<button id="toggleModeBtn"><i class="fa fa-moon"></i> Dark Mode</button>











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
    
    ////
    
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

</body>
</html>
