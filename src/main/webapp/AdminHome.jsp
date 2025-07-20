<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.bookshop.dao.CustomerDAO, com.bookshop.dao.BuyRequestDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.model.Customer" %>
<%@ page import="com.bookshop.dao.AccountDAO, com.bookshop.dao.BookDAO" %>
<%@ page import="com.bookshop.model.Account, com.bookshop.model.Book" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bookshop.dao.AccountDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.*" %> 
<%@ page import="com.bookshop.dao.BillDAO" %><!-- ✅ This covers Map, HashMap, etc. -->

<%
    AccountDAO accountDAO = new AccountDAO();
    List<Account> accounts = accountDAO.getAllAccounts();

    List<Account> admins = new ArrayList<>();
    List<Account> users = new ArrayList<>();

    for(Account acc : accounts) {
        if("admin".equalsIgnoreCase(acc.getRole())) {
            admins.add(acc);
        } else {
            users.add(acc);
        }
    }
%>
<%
    BookDAO bookDAO = new BookDAO();
    List<Book> book = bookDAO.getAllBooks(); 
%>
<%
    BillDAO billDAO = new BillDAO();
    int billCount = billDAO.getBillCount();  // call method that returns count of bills
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
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

/* Sidebar */
.sidebar {
    width: 220px;
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
    <h2>📘 Admin Panel</h2>
    <a href="View_users.jsp"><i class="fas fa-user"></i> Manage Users</a>
    <a href="View_books.jsp"><i class="fas fa-book"></i> Manage Books</a>
   
    <a href="pendingPayments.jsp"><i class="fas fa-file-invoice"></i> Billing</a>
    <a href="Help.jsp"><i class="fas fa-question-circle"></i> Help</a>
    <a href="AdminLogout.jsp"><i class="fas fa-sign-out-alt"></i> Logout</a>
</div>

<!-- Main Content -->
<div class="main">
    <h1>Welcome, Admin</h1>

   <div class="row mt-4 g-4">
    <div class="col-md-3">
        <div class="card-box">
            <i class="fas fa-users"></i>
           <h3> Users <%= users.size() %></h3>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card-box">
            <i class="fas fa-book"></i>
            <h3> Books <%= book.size() %></h3>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card-box">
            <i class="fas fa-file-invoice-dollar"></i>
             <h3>Bills <%= billCount %></h3> <%-- Update this if you have a BillDAO later --%>
        </div>
    </div>

    <div class="col-md-3">
        <div class="card-box">
            <i class="fas fa-user-shield"></i>
            <h3> Admins <%= admins.size() %></h3>
        </div>
    </div>
</div>

    <div class="content-section mt-5">
    <h4 class="mb-3">Average Users Per Month</h4>
    <canvas id="myChart" height="100"></canvas>
</div>

</div>

<!-- Chart Script -->


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
</script>




</body>
</html>
