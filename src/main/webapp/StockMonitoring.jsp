<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List, java.util.Map" %>
<%@ page import="com.bookshop.model.Book" %>
<%@ page import="com.bookshop.model.Supplier" %>
<%@ page import="com.bookshop.dao.BookDAO" %>

<%
    BookDAO dao = new BookDAO();
    List<Book> books = dao.getOutOfStockBooks();

    // Get book IDs for fetching suppliers
    List<Integer> bookIds = new java.util.ArrayList<>();
    for (Book b : books) {
        bookIds.add(b.getId());
    }
    Map<Integer, List<Supplier>> suppliersMap = dao.getSuppliersForBooks(bookIds);

    String contextPath = request.getContextPath();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>📦 Out of Stock Books</title>
    
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        .book-image {
            width: 80px;
            height: 80px;
            object-fit: cover;
            border-radius: 6px;
        }
        ul.supplier-list {
            list-style-type: none;
            padding-left: 0;
            margin: 0;
            text-align: left;
        }
        ul.supplier-list li {
            margin-bottom: 2px;
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
    margin-bottom: 20px;
}
.back-btn i {
    margin-right: 6px;
}
.back-btn:hover {
    background-color: #ddd;
    color: #000;
}
.supplier-item {
    display: flex;
    justify-content: center; /* centers horizontally */
    align-items: center;     /* centers vertically */
    gap: 15px;               /* space between name and phone */
    padding: 2px 0;
}
.publisher-name {
    font-weight: bold;
    color: #2a7ae2; /* blue */
    text-align: center;
}

.phone-number {
    color: #d9534f; /* red */
    font-weight: 600;
    text-align: center;
}

    </style>
</head>
<body class="container py-5">
<!-- Back Button -->
    <a href="Inventory Maintenance.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>

    <h2 class="mb-4 text-danger text-center">📦 Out of Stock Books</h2>

    <% if (books == null || books.isEmpty()) { %>
        <div class="alert alert-success text-center">🎉 All books are currently in stock!</div>
    <% } else { %>
        <div class="table-responsive">
            <table class="table table-bordered table-striped align-middle text-center">
                <thead class="table-dark">
                    <tr>
                        <th>📘 Image</th>
                        <th>📚 Name</th>
                        <th>👤 Author</th>
                        
                        <th>💰 Price (Rs.)</th>
                        <th>🔖 Discount (%)</th>
                        <th>📅 Uploaded Date</th>
                        <th>📦 Stock Status</th>
                        <th>📋 Suppliers</th>
                    </tr>
                </thead>
                <tbody>
                    <% for (Book book : books) {
                        List<String> images = book.getImages();
                        String imgPath = (images != null && !images.isEmpty()) ? images.get(0) : "images/no-image.png";
                        if (!imgPath.startsWith("http") && !imgPath.startsWith(contextPath)) {
                            imgPath = contextPath + "/" + imgPath;
                        }

                        List<Supplier> suppliers = suppliersMap != null ? suppliersMap.get(book.getId()) : null;
                    %>
                    <tr>
                        <td>
                            <img src="<%= imgPath %>" alt="Book Image" class="book-image" />
                        </td>
                        <td><%= book.getName() %></td>
                        <td><%= book.getAuthor() %></td>
                        
                        <td>Rs. <%= String.format("%.2f", book.getPrice()) %></td>
                        <td><%= String.format("%.1f", book.getDiscount()) %> %</td>
                        <td><%= book.getUploadDateTime() != null ? book.getUploadDateTime().toLocalDate() : "N/A" %></td>
                        <td class="text-danger fw-bold">
                            <i class="fas fa-exclamation-triangle"></i> Out of Stock
                        </td>
                       <td class="text-start">
						    <% if (suppliers == null || suppliers.isEmpty()) { %>
						        <i>No suppliers found</i>
						    <% } else { %>
						        <ul class="supplier-list">
						            <% for (Supplier s : suppliers) { %>
						                <li>
						                    <span class="publisher-name"><%= s.getName() %></span> 
						                    <span class="phone-number"><%= s.getPhone() %></span>
						                </li>
						            <% } %>
						        </ul>
						    <% } %>
						</td>
          
                    </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    <% } %>

</body>
</html>
