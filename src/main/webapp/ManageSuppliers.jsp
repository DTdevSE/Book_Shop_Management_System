<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.bookshop.model.Supplier, com.bookshop.dao.SupplierDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    SupplierDAO dao = new SupplierDAO();
    List<Supplier> list = dao.getAllSuppliers();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Suppliers 📋</title>

    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <!-- Font Awesome -->
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            padding: 30px;
            background: #f8f9fa;
        }
        h2 {
            margin-bottom: 30px;
            color: #2c3e50;
        }
        form.add-supplier-form {
            max-width: 700px;
            margin-bottom: 40px;
        }
        table {
            background: white;
            box-shadow: 0 0 10px rgb(0 0 0 / 0.1);
        }
        input[type="text"], input[type="email"] {
            width: 100%;
        }
        button {
            min-width: 100px;
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
<body>
<a href="Inventory Maintenance.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>

<h2><i class="fas fa-truck-moving text-primary"></i> Manage Suppliers 🏢</h2>
 <!-- Session-based Success Message -->
<c:if test="${not empty sessionScope.success}">
    <div class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.success}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="success" scope="session"/>
</c:if>

<!-- Session-based Error Message -->
<c:if test="${not empty sessionScope.error}">
    <div class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.error}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="error" scope="session"/>
</c:if>

<!-- Add Supplier Form -->
<form method="post" action="SupplierServlet" class="add-supplier-form row g-3 align-items-center">
    <input type="hidden" name="action" value="add" />
    <div class="col-md-3">
        <input type="text" name="name" class="form-control" placeholder="Supplier Name *" required />
    </div>
    <div class="col-md-3">
        <input type="email" name="email" class="form-control" placeholder="Email 📧" />
    </div>
    <div class="col-md-2">
        <input type="text" name="phone" class="form-control" placeholder="Phone 📞" />
    </div>
    <div class="col-md-3">
        <input type="text" name="address" class="form-control" placeholder="Address 🏠" />
    </div>
    <div class="col-md-1 d-grid">
        <button type="submit" class="btn btn-success" title="Add Supplier">
            <i class="fas fa-plus-circle"></i> Add
        </button>
    </div>
</form>

<!-- Supplier List Table -->
<form method="post" action="SupplierServlet">
<table class="table table-bordered table-hover align-middle text-center">
    <thead class="table-light">
        <tr>
            <th><i class="fas fa-building"></i> Name</th>
            <th><i class="fas fa-envelope"></i> Email</th>
            <th><i class="fas fa-phone"></i> Phone</th>
            <th><i class="fas fa-map-marker-alt"></i> Address</th>
            <th style="min-width:160px;">Actions</th>
        </tr>
    </thead>
    <tbody>
    <% for (Supplier s : list) { %>
        <tr>
            <td>
                <input type="text" name="name_<%= s.getSupplierId() %>" class="form-control form-control-sm" value="<%= s.getName() %>" required />
            </td>
            <td>
                <input type="email" name="email_<%= s.getSupplierId() %>" class="form-control form-control-sm" value="<%= s.getEmail() %>" />
            </td>
            <td>
                <input type="text" name="phone_<%= s.getSupplierId() %>" class="form-control form-control-sm" value="<%= s.getPhone() %>" />
            </td>
            <td>
                <input type="text" name="address_<%= s.getSupplierId() %>" class="form-control form-control-sm" value="<%= s.getAddress() %>" />
            </td>
            <td>
                <button type="submit" name="action" value="update_<%= s.getSupplierId() %>" class="btn btn-primary btn-sm" title="Update">
                    <i class="fas fa-edit"></i> Update
                </button>
                <button type="submit" name="action" value="delete_<%= s.getSupplierId() %>" class="btn btn-danger btn-sm" title="Delete"
                    onclick="return confirm('Are you sure you want to delete this supplier?');">
                    <i class="fas fa-trash-alt"></i> Delete
                </button>
            </td>
        </tr>
    <% } %>
    </tbody>
</table>
</form>
<script>
    // Auto-hide Success message after 5 seconds
    const successBox = document.getElementById("successBox");
    if (successBox) {
        setTimeout(() => {
            successBox.style.display = "none";
        }, 5000); // 5000 ms = 5 seconds
    }

    // Auto-hide Error message after 5 seconds
    const errorBox = document.getElementById("errorBox");
    if (errorBox) {
        setTimeout(() => {
            errorBox.style.display = "none";
        }, 5000); // 5000 ms = 5 seconds
    }
</script>
<!-- Bootstrap JS Bundle -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
