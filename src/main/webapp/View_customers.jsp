<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Customer, com.bookshop.dao.CustomerDAO" %>

<%
    CustomerDAO dao = new CustomerDAO();
    List<Customer> customers = dao.getAllCustomers();
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customers</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        .card-customer {
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s ease-in-out;
            height: 100%;
        }
        .card-customer:hover {
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
            <a href="Cashierdashboard.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <!-- Page Title -->
            <h2 class="mb-0">👥 Registered Customers</h2>
            
        </div>
         <a href="AddCustomer.jsp" class="btn btn-success">
            ➕ Add New Customer
        </a>
    </div>

    <div class="row g-4">
        <%
            if (customers != null && !customers.isEmpty()) {
                for (Customer c : customers) {
        %>
        <div class="col-md-4">
            <div class="card card-customer p-4">
                <div class="d-flex align-items-center mb-3">
                    <img 
                        src="<%= (c.getProfileImage() != null && !c.getProfileImage().isEmpty()) ? c.getProfileImage() : "default-profile.png" %>?v=<%= System.currentTimeMillis() %>"
                        alt="Profile"
                        class="profile-img me-3"
                        onerror="this.onerror=null; this.src='https://via.placeholder.com/80x80?text=No+Image';"
                    />
                    <div>
                        <h5 class="mb-0">ID: <%= c.getAccountNumber() %></h5>
                        <span class="badge bg-secondary"><%= c.getMembershipType() %></span>
                    </div>
                </div>

                <ul class="list-unstyled mb-3">
                    <li><strong>Name:</strong> <%= c.getName() %></li>
                    <li><strong>Email:</strong> <%= c.getEmail() %></li>
                    <li><strong>Phone:</strong> <%= c.getTelephone() %></li>
                    <li><strong>Gender:</strong> <%= c.getGender() %></li>
                    <li><strong>Address:</strong> <%= c.getAddress() %></li>
                  <li><strong>Date of Birth:</strong> <%= c.getDob() != null ? c.getDob().toString() : "N/A" %></li>
                    

                    
                   
                </ul>

                <div class="d-flex justify-content-end gap-2">
                    <a href="EditCustomer.jsp?id=<%= c.getAccountNumber() %>" class="btn btn-warning btn-sm">Edit</a>
                    <a href="DeleteCustomerServlet?id=<%= c.getAccountNumber() %>"
   onclick="return confirm('Are you sure you want to delete this customer?');"
   class="btn btn-danger btn-sm">
   Delete
</a>

                </div>
            </div>
        </div>
        <%
                }
            } else {
        %>
        <div class="col-12">
            <div class="alert alert-warning text-center">
                ⚠️ No customers found.
            </div>
        </div>
        <%
            }
        %>
    </div>

</body>
</html>
