<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookshop.dao.CustomerDAO, com.bookshop.dao.BuyRequestDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.model.Customer" %>
<%@ page import="com.bookshop.dao.AccountDAO, com.bookshop.dao.BookDAO" %>
<%@ page import="com.bookshop.model.Account, com.bookshop.model.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.dao.AccountDAO,com.bookshop.dao.SupplierDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.*" %> 

<%@ page import="com.bookshop.dao.BillDAO" %><!-- ✅ This covers Map, HashMap, etc. -->
<%@ page import="com.bookshop.model.Account" %>
<%@ page import="com.bookshop.model.BillItem" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>

<%
    AccountDAO accountDAO = new AccountDAO();

    // Fetch all accounts
    List<Account> allAccounts = accountDAO.getAllAccounts();

    int adminCount = 0;
    int cashierCount = 0;
    int storeKeeperCount = 0;
    int userCount = 0;  // count for role 'user'

    for (Account acc : allAccounts) {
        String role = acc.getRole();
        if ("admin".equalsIgnoreCase(role)) {
            adminCount++;
        } else if ("cashier".equalsIgnoreCase(role)) {
            cashierCount++;
        } else if ("store_keeper".equalsIgnoreCase(role)) {
            storeKeeperCount++;
        } else if ("user".equalsIgnoreCase(role)) {
            userCount++;
        }
    }

    // Total non-admin users (cashier + store_keeper + user)
    int nonAdminUserCount = cashierCount + storeKeeperCount + userCount;
%>
<% 
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
double totalSales = billDAO.getTotalSalesAmount();
double dailySales = billDAO.getDailySalesAmount();
double dailyProfit = billDAO.getDailyProfit();
//Call the method here and store list
int dailyItemsSold = billDAO.getDailyItemsSold();

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
    <title  >Admin Dashboard</title>
  <link rel="icon" type="image/x-icon" href="data:image/webp;base64,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">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <!-- External Libraries -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">

    
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

/* Sidebar */
.sidebar {
    width: 230px;
    background: var(--card-bg);
    position: fixed;
    top: 0; bottom: 0;
    padding-top: 30px;
    transition: var(--transition-speed);
    color: var(--text);
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

/* Main */
.main {
    margin-left: 240px;
    padding: 40px 30px;
}

.card-box {
    background: var(--card-bg);
    border-radius: var(--border-radius);
    box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    padding: 20px;
    text-align: center;
    transition: transform var(--transition-speed), background var(--transition-speed);
}

.card-box:hover {
    transform: translateY(-4px);
}

.card-box i {
    font-size: 30px;
    color: var(--primary);
    margin-bottom: 8px;
    display: block;
    transition: color var(--transition-speed);
}

.card-box h3 {
    font-weight: 500;
    font-size: 20px;
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
    transition: background var(--transition-speed), transform var(--transition-speed);
}

#toggleModeBtn:hover {
    background: var(--hover);
    transform: scale(1.05);
}

/* Loader */
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
			  padding: 10px 10px;
			  border-radius: 12px;
			  box-shadow: 0 4px 20px rgba(0,0,0,0.2);
			  backdrop-filter: blur(8px); /* modern blur effect */
			  -webkit-backdrop-filter: blur(8px); /* Safari support */
			  border: 1px solid rgba(255, 255, 255, 0.3);
			  margin-top: 40px;
			   color: var(--primary);
    }
    .card {
    transition: all 0.3s ease-in-out;
}
.card:hover {
    box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
}
    
    </style>
</head>

<body>
<div id="pageLoader">
    <div class="spinner"></div>
    <p>Loading, please wait...</p>
</div>

<!-- Theme Button -->
<button id="toggleModeBtn"><i class="fa fa-moon"></i> Dark Mode</button>

<!-- Sidebar -->
<div class="sidebar">
    <h2>📚 Pahana EDU</h2>
    <a href="View_users.jsp"><i class="fas fa-user"></i> Manage Users</a>
    <a href="View_books.jsp"><i class="fas fa-book"></i> Manage Books</a>
   
    <a href="AdminBillingSummery.jsp"><i class="fas fa-file-invoice"></i> Billing</a>
    <a href="AdminHelp.jsp"><i class="fas fa-question-circle"></i> Help</a>
    <a href="AdminLogout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
    <!-- Admin Profile Info -->
<div id="dateTime" class="datetime"></div>

    <div class="text-center mt-5 mb-3">
        <img src="<%= profileImg %>" alt="Admin"
             style="width: 80px; height: 80px; object-fit: cover; border-radius: 50%; border: 2px solid #fff;margin-top: 120px;">
        <p style="margin-top: 8px; font-weight: 600; color: var(--primary); font-size: 14px;"><%= name %></p>
       
    </div>
</div>

<!-- Main Content -->
<div class="main">
    <h1>Welcome, Admin 🧑‍💻 <%= name %></h1>

    <!-- Cards row -->
    <div class="row mt-4 g-4">
        <div class="col-md-3">
		    <div class="card-box">
		        <i class="fas fa-users"></i>
		        <h3> System Users  <%= nonAdminUserCount %></h3>
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
                <h3>Admins <%= adminCount %></h3>
            </div>
        </div>
        <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-users"></i>
                <h3>Customers <%= customerCount %></h3>
            </div>
        </div>
         <div class="col-md-3">
            <div class="card-box">
                <i class="fas fa-truck"></i>
                <h3>Total Suppliers: <%= request.getAttribute("supplierCount") %></h3>
            </div>
        </div>

        <div class="col-md-3 col-sm-6">
            <div class="card-box">
                <i class="fas fa-exclamation-triangle" style="color: #ffc107;"></i>
                <h3>Low Stock: <span style="color: #ffc107;"><%= lowStockCount %></span></h3>
            </div>
        </div>

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
        <div class="col-md-3">
		    <div class="card-box">
		        <i class="fas fa-receipt"></i>  <!-- icon for bills -->
		        <h3>Monthly Items Sold: <%= request.getAttribute("totalItemsSold") != null ? request.getAttribute("totalItemsSold") : "0" %></h3>
		    </div>
		</div>
		
		<div class="col-md-3">
		    <div class="card-box">
		     <i class="fa fa-shopping-bag" aria-hidden="true"></i>
		        <h3>Today Sold: <%= dailyItemsSold %></h3>
		    </div>
		</div>
		    
        
     
<!-- Sales & Profit Cards -->
<div class="row mt-4 g-4">
    
    <!-- Total Sales Amount -->
    <div class="col-lg-4 col-md-6 col-sm-12">
        <div class="card shadow-sm border-0 rounded-4 p-4 h-100 text-center" style="background-color: #ffffff;background: var(--card-bg);">
            <div class="d-flex flex-column align-items-center justify-content-center h-100">
                <i class="fas fa-dollar-sign fa-2x mb-3 text-success"></i>
                <h6 class="mb-1 fw-normal text-light">Total Sales Amount</h6>
                <h4 class="fw-bold text-success">Rs. <%= String.format("%.2f", totalSales) %></h4>
            </div>
        </div>
    </div>

    <!-- Today's Profit -->
    <div class="col-lg-4 col-md-6 col-sm-12">
        <div class="card shadow-sm border-0 rounded-4 p-4 h-100 text-center" style="background-color: #ffffff;background: var(--card-bg);">
            <div class="d-flex flex-column align-items-center justify-content-center h-100">
                <i class="fas fa-chart-line fa-2x mb-3 text-success"></i>
                <h6 class="mb-1 fw-normal text-light">Today's Profit</h6>
                <h4 class="fw-bold text-success">Rs. <%= String.format("%.2f", dailyProfit) %></h4>
            </div>
        </div>
    </div>

    <!-- Daily Sales Total -->
    <div class="col-lg-4 col-md-6 col-sm-12">
        <div class="card shadow-sm border-0 rounded-4 p-4 h-100 text-center" style="background-color: #ffffff;background: var(--card-bg);">
            <div class="d-flex flex-column align-items-center justify-content-center h-100">
                <i class="bi bi-bag-check-fill fa-2x mb-3 text-info"></i>
                <h6 class="mb-1 fw-normal text-light">Daily Sales Total</h6>
                <h4 class="fw-bold text-info">Rs. <%= String.format("%.2f", dailySales) %></h4>
            </div>
        </div>
    </div>

</div>



<div class="col-md-12 mt-4">
    <div class="card shadow-sm border-0 rounded-4 p-4" style="background: linear-gradient(to right, #f5f7fa, #e8f0fe);background: var(--card-bg);color: var(--primary);">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h5 class="fw-semibold text-primary mb-0">📈 Sales Trend (Last 7 Days)</h5>
            <i class="fas fa-calendar-week text-primary fs-4"></i>
        </div>
        <canvas id="areaChart" height="200"></canvas>
    </div>
</div>



    <!-- Footer -->
    <footer class="py-4 text-center mt-4" style="font-size: 14px; background-color:#181818; border-radius: 8px;">
        <div class="container">
            <p style="color: #ddd; margin-bottom: 5px;">
                © 2025 <strong style="color: #FF6F00;">PahanaEdu</strong>. All rights reserved.
            </p>
            <p style="color: #999;">
                Developed by <strong style="color: #007BFF;">Dinitha Thewmika</strong>, 
                Undergraduate, <em style="color: #28a745;">ICBT Campus</em> 🎓
            </p>
        </div>
    </footer>
</div>
</div>




<!-- Mode + Loader Script -->
<script>
    const toggleBtn = document.getElementById('toggleModeBtn');
    const icon = toggleBtn.querySelector('i');

    function updateThemeMode() {
        const isLight = document.body.classList.contains('light-mode');
        toggleBtn.innerHTML = isLight
            ? '<i class="fa fa-sun"></i> Light Mode'
            : '<i class="fa fa-moon"></i> Dark Mode';
        localStorage.setItem('darkMode', isLight ? 'disabled' : 'enabled');
    }

    // Apply saved mode on load
    if (localStorage.getItem('darkMode') === 'disabled') {
        document.body.classList.add('light-mode');
    }
    updateThemeMode();

    // Toggle theme
    toggleBtn.addEventListener('click', () => {
        document.body.classList.toggle('light-mode');
        updateThemeMode();
    });
    
    //
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

<script>
    const ctx = document.getElementById('areaChart');

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], // You can make this dynamic
            datasets: [{
                label: 'Daily Sales (Rs.)',
                data: [12000, 9500, 10500, 15500, 13800, 17000, 21000], // Replace with dynamic data
                fill: true,
                backgroundColor: 'rgba(33, 150, 243, 0.2)',
                borderColor: '#2196f3',
                tension: 0.4,
                pointBackgroundColor: '#2196f3',
                pointBorderColor: '#fff',
                pointHoverBackgroundColor: '#fff',
                pointHoverBorderColor: '#2196f3'
            }]
        },
        options: {
            responsive: true,
            plugins: {
                legend: {
                    display: false
                }
            },
            scales: {
                x: {
                    ticks: {
                        color: '#444'
                    },
                    grid: {
                        color: '#eee'
                    }
                },
                y: {
                    ticks: {
                        color: '#444'
                    },
                    grid: {
                        color: '#eee'
                    }
                }
            }
        }
    });
</script>





</body>
</html>
