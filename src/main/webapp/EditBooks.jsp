<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Book, com.bookshop.dao.BookDAO" %>

<%
    String idParam = request.getParameter("id");
    Book book = null;

    if (idParam != null) {
        try {
            int bookId = Integer.parseInt(idParam);
            BookDAO dao = new BookDAO();
            book = dao.getBookById(bookId);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
%>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>✏️ Edit Book</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f9f9fb;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        }
        .card {
            border: none;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.05);
            background-color: #ffffff;
        }
        .form-label {
            font-weight: 500;
        }
        .form-control:focus {
            border-color: #a3c4f3;
            box-shadow: 0 0 0 0.15rem rgba(163, 196, 243, 0.25);
        }
        .btn-primary {
            background-color: #5b8df7;
            border: none;
        }
        .btn-primary:hover {
            background-color: #467fe0;
        }
        .btn-secondary {
            background-color: #ced4da;
            border: none;
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

<div class="container py-5 d-flex justify-content-center">
    <div class="w-100" style="max-width: 720px;">

        <% if (book == null) { %>
            <div class="alert alert-danger shadow-sm">
                ⚠️ Error: Book not found or not loaded properly.
            </div>
            <a href="ViewBooks.jsp" class="btn btn-secondary">← Back to Book List</a>
        <% } else { %>

       
            <h3 class="mb-4 text-primary">📘 Edit Book Details</h3>
            

            <form action="UpdateBookServlet" method="post" enctype="multipart/form-data" class="row g-4">
                <input type="hidden" name="id" value="<%= book.getId() %>" />

                <div class="col-md-6">
                    <label class="form-label">📕 Book Name</label>
                    <input type="text" name="name" value="<%= book.getName() %>" class="form-control" required />
                </div>

                <div class="col-md-6">
                    <label class="form-label">📚 Category</label>
                    <input type="text" name="category" value="<%= book.getCategory() %>" class="form-control" required />
                </div>

                <div class="col-md-6">
                    <label class="form-label">✍️ Author</label>
                    <input type="text" name="author" value="<%= book.getAuthor() %>" class="form-control" required />
                </div>

                <div class="col-md-12">
                    <label class="form-label">📝 Description</label>
                    <textarea name="description" class="form-control" rows="4" required><%= book.getDescription() %></textarea>
                </div>

                <div class="col-md-4">
                    <label class="form-label">💰 Price ($)</label>
                    <input type="number" name="price" value="<%= book.getPrice() %>" step="0.01" class="form-control" required />
                </div>

                <div class="col-md-4">
                    <label class="form-label">🔻 Discount (%)</label>
                    <input type="number" name="discount" value="<%= book.getDiscount() %>" step="0.01" class="form-control" required />
                </div>

                <div class="col-md-4">
                    <label class="form-label">🎁 Offers</label>
                    <input type="text" name="offers" value="<%= book.getOffers() != null ? book.getOffers() : "" %>" class="form-control" />
                </div>

                <div class="col-md-4">
                    <label class="form-label">📦 Stock Quantity</label>
                    <input type="number" name="stock_quantity" value="<%= book.getStockQuantity() %>" class="form-control" required />
                </div>

                <div class="col-12 mt-3 d-flex justify-content-between">
                    <button type="submit" class="btn btn-primary px-4">💾 Update Book</button>
                    <a href="ViewBooks.jsp" class="btn btn-secondary px-4">↩️ Cancel</a>
                </div>
            </form>
        </div>
        <% } %>

    </div>
</div>

</body>
</html>
