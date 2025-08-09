<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Account, com.bookshop.dao.AccountDAO" %>

<%
    AccountDAO dao = new AccountDAO();
    String keyword = request.getParameter("search");
    List<Account> accounts;

    if (keyword != null && !keyword.trim().isEmpty()) {
       accounts = dao.searchAccounts(keyword.trim());
    } else {
        accounts = dao.getAllAccounts();
    }
%>

<!DOCTYPE html>
<html>
<head>
    <title>User Accounts</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        .card-user {
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s ease-in-out;
            height: 100%;
        }
        .card-user:hover {
            transform: translateY(-3px);
        }
        .profile-img {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 50%;
            border: 2px solid #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.15);
        }
        .role-badge {
            font-size: 0.8rem;
            padding: 4px 8px;
            border-radius: 20px;
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
<body class="container py-5">

    <div class="d-flex justify-content-between align-items-center mb-4">
        <div class="d-flex align-items-center gap-3">
            <!-- Back Button -->
            <a href="AdminHome.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <!-- Page Title -->
            <h2 class="mb-0">👤 User Accounts</h2>
        </div>

        <a href="Add Users.jsp" class="btn btn-success">
            ➕ Add New User
        </a>
    </div>

    <!-- 🔍 Search Form -->
    <form method="get" action="View_users.jsp" class="mb-4">
        <div class="input-group">
            <input type="text" name="search" class="form-control" placeholder="Search by name, ID, or role..." value="<%= request.getParameter("search") != null ? request.getParameter("search") : "" %>">
            <button class="btn btn-outline-primary" type="submit">🔍 Search</button>
            <a href="View_users.jsp" class="btn btn-outline-secondary">🔁 Reset</a>
        </div>
    </form>

    <!-- 📝 Search Info -->
    <c:if test="${not empty param.search}">
        <p><strong>🔎 Search results for:</strong> "<c:out value='${param.search}' />"</p>
    </c:if>

    <!-- 👥 User Cards -->
    <div class="row g-4">
        <%
            if (accounts != null && !accounts.isEmpty()) {
                for (Account acc : accounts) {
        %>
        <div class="col-md-4">
            <div class="card card-user p-4">
                <div class="d-flex align-items-center mb-3">
                    <img 
                        src="<%= request.getContextPath() + "/" + acc.getProfileImage() %>?v=<%= System.currentTimeMillis() %>" 
                        alt="Profile"
                        class="profile-img me-3"
                        onerror="this.onerror=null; this.src='https://via.placeholder.com/80x80?text=No+Image';"
                    />
                    <div>
                        <h5 class="mb-0">ID: <%= acc.getIdNumber() %></h5>
                        <span class="badge bg-primary role-badge"><%= acc.getRole() %></span>
                    </div>
                </div>

                <ul class="list-unstyled mb-3">
                    <li><strong>Name:</strong> <%= acc.getFullname() %></li>
                    <li><strong>DOB:</strong> <%= acc.getDob() %></li>
                    <li><strong>Address:</strong> <%= acc.getAddress() %></li>
                    <li><strong>Created:</strong> <%= acc.getCreatedAt() %></li>
                </ul>

                <div class="d-flex justify-content-end gap-2">
                    <a href="EditAccount.jsp?idNumber=<%= acc.getIdNumber() %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="DeleteAccountServlet?idNumber=<%= acc.getIdNumber() %>" 
                       onclick="return confirm('Are you sure you want to delete this account?');" 
                       class="btn btn-danger btn-sm">Delete</a>
                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="col-12">
            <div class="alert alert-warning text-center">
                ⚠️ No users found or database error.
            </div>
        </div>
        <%
            }
        %>
    </div>

</body>
</html>
