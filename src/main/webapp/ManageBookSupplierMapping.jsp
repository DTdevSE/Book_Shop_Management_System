<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.*, com.bookshop.model.BookSupplierMap, com.bookshop.model.Book, com.bookshop.model.Supplier" %>
<%@ page import="com.bookshop.dao.BookDAO, com.bookshop.dao.SupplierDAO, com.bookshop.dao.BookSupplierMapDAO" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    BookSupplierMapDAO dao = new BookSupplierMapDAO();
    List<BookSupplierMap> mappings = dao.getAllMappings();

    BookDAO bookDAO = new BookDAO();
    List<Book> books = bookDAO.getAllBooks();

    SupplierDAO supplierDAO = new SupplierDAO();
    List<Supplier> suppliers = supplierDAO.getAllSuppliers();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Manage Book-Supplier Mappings</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
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
            margin-bottom: 20px;
        }
        .back-btn i { margin-right: 6px; }
        .back-btn:hover { background-color: #ddd; color: #000; }
    </style>
</head>
<body class="container py-4">

<!-- Back Button -->
<a href="Inventory Maintenance.jsp" class="back-btn" title="Go Back">
    <i class="fas fa-arrow-left"></i> Back
</a>

<h2>Manage Book-Supplier Mappings</h2>

<!-- Success & Error Messages -->
<c:if test="${not empty sessionScope.successMsg}">
    <div id="successBox" class="alert alert-success alert-dismissible fade show" role="alert">
        ${sessionScope.successMsg}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="successMsg" scope="session"/>
</c:if>

<c:if test="${not empty sessionScope.errorMsg}">
    <div id="errorBox" class="alert alert-danger alert-dismissible fade show" role="alert">
        ${sessionScope.errorMsg}
        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
    </div>
    <c:remove var="errorMsg" scope="session"/>
</c:if>

<!-- Add new mapping -->
<form method="post" action="BookSupplierMapServlet" class="row g-3 align-items-end mb-4">
    <input type="hidden" name="action" value="add" />
    <div class="col-md-3">
        <label for="bookId" class="form-label">Book</label>
        <select name="bookId" id="bookId" class="form-select" required>
            <option value="">Select Book</option>
            <% for (Book b : books) { %>
                <option value="<%= b.getId() %>"><%= b.getName() %></option>
            <% } %>
        </select>
    </div>
    <div class="col-md-3">
        <label for="supplierId" class="form-label">Supplier</label>
        <select name="supplierId" id="supplierId" class="form-select" required>
            <option value="">Select Supplier</option>
            <% for (Supplier s : suppliers) { %>
                <option value="<%= s.getSupplierId() %>"><%= s.getName() %></option>
            <% } %>
        </select>
    </div>
    <div class="col-md-2">
        <label for="supplyPrice" class="form-label">Supply Price</label>
        <input type="number" name="supplyPrice" id="supplyPrice" class="form-control" step="0.01" min="0" required />
    </div>
    <div class="col-md-2">
        <label for="supplyQty" class="form-label">Supply Quantity</label>
        <input type="number" name="supplyQty" id="supplyQty" class="form-control" min="0" required />
    </div>
    <div class="col-md-2">
        <button type="submit" class="btn btn-success">Add Mapping</button>
    </div>
</form>

<!-- List all mappings -->
<table class="table table-bordered table-striped align-middle text-center">
    <thead class="table-light">
        <tr>
            <th>ID</th>
            <th>Book</th>
            <th>Book Price</th>
            <th>Supplier</th>
            <th>Supply Price</th>
            <th>Supply Quantity</th>
            <th>Supply Date</th>
            <th>Actions</th>
        </tr>
    </thead>
    <tbody>
    <% for (BookSupplierMap map : mappings) { 
        String bookName = "";
        double bookPrice = 0.0;
        String supplierName = "";

        for (Book b : books) {
            if (b.getId() == map.getBookId()) {
                bookName = b.getName();
                bookPrice = b.getPrice();
                break;
            }
        }

        for (Supplier s : suppliers) {
            if (s.getSupplierId() == map.getSupplierId()) {
                supplierName = s.getName();
                break;
            }
        }
    %>
        <tr>
            <form method="post" action="BookSupplierMapServlet" class="row g-2 align-items-center">
                <input type="hidden" name="action" value="update" />
                <input type="hidden" name="id" value="<%= map.getId() %>" />

                <td><%= map.getId() %></td>
                <td><%= bookName %></td>
                <td>Rs. <%= String.format("%.2f", bookPrice) %></td>
                <td>
                    <select name="supplierId" class="form-select form-select-sm" required>
                        <% for (Supplier s : suppliers) { %>
                            <option value="<%= s.getSupplierId() %>" <%= s.getSupplierId() == map.getSupplierId() ? "selected" : "" %>><%= s.getName() %></option>
                        <% } %>
                    </select>
                </td>
                <td>
				    <input type="number" name="supplyPrice" 
				        class="form-control form-control-sm <%= map.getSupplyPrice() > bookPrice ? "border border-danger bg-light text-danger" : "" %>" 
				        step="0.01" min="0" value="<%= map.getSupplyPrice() %>" required />
				    <% if(map.getSupplyPrice() > bookPrice) { %>
				        <small class="text-danger fw-bold">Supply price is higher than book price! Verify with Admin.</small>
				    <% } %>
				</td>


                <td><input type="number" name="supplyQty" class="form-control form-control-sm" min="0" value="<%= map.getSupplyQty() %>" required /></td>
                <td><%= map.getSupplyDate() %></td>
                <td class="d-flex gap-1 justify-content-center">
                    <button type="submit" class="btn btn-primary btn-sm" title="Update">
                        <i class="fas fa-edit"></i>
                    </button>
            </form>
            <form method="post" action="BookSupplierMapServlet" onsubmit="return confirm('Delete this mapping?');">
                <input type="hidden" name="action" value="delete" />
                <input type="hidden" name="id" value="<%= map.getId() %>" />
                <button type="submit" class="btn btn-danger btn-sm" title="Delete">
                    <i class="fas fa-trash-alt"></i>
                </button>
            </form>
                </td>
        </tr>
    <% } %>
    </tbody>
</table>

<script>
    function autoHideMessage(id, timeout = 5000) {
        const box = document.getElementById(id);
        if (box) {
            setTimeout(() => { box.style.display = "none"; }, timeout);
        }
    }
    autoHideMessage("successBox", 5000);
    autoHideMessage("errorBox", 5000);
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
