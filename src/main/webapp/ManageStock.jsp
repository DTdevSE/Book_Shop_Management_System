<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Book, com.bookshop.dao.BookDAO" %>

<%
    // Initialize DAO and get all books
    BookDAO bookDAO = new BookDAO();
    List<Book> bookList = bookDAO.getAllBooks(); // this line defines bookList
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Stock</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
</head>
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
<body>
<div class="container mt-4">
<a href="Inventory Maintenance.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>

    <h2>📦 Manage Stock and Discount</h2>

    <!-- Optional success message -->
    <%
        String status = request.getParameter("status");
        if ("success".equals(status)) {
    %>
    <div class="alert alert-success">Stock and discounts updated successfully!</div>
    <%
        }
    %>

    <form action="UpdateStockServlet" method="post">
        <table class="table table-bordered">
            <thead>
                <tr>
                    <th>Book ID</th>
                    <th>Book Name</th>
                    <th>Current Stock</th>
                    <th>Update Stock</th>
                    <th>Current Discount (%)</th>
                    <th>Update Discount</th>
                </tr>
            </thead>
            <tbody>
                <% for (Book book : bookList) { %>
                    <tr>
                        <td><%= book.getId() %></td>
                        <td><%= book.getName() %></td>
                        <td><%= book.getStockQuantity() %></td>
                        <td>
                            <input type="number" class="form-control" name="stock_<%= book.getId() %>" value="<%= book.getStockQuantity() %>" required>
                        </td>
                        <td><%= book.getDiscount() %>%</td>
                        <td>
                            <input type="number" step="0.01" class="form-control" name="discount_<%= book.getId() %>" value="<%= book.getDiscount() %>">
                        </td>
                    </tr>
                <% } %>
            </tbody>
        </table>

        <button type="submit" class="btn btn-primary">Update All</button>
    </form>
</div>
</body>
</html>
