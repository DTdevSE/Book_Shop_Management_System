<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Book, com.bookshop.dao.BookDAO" %>

<%
    BookDAO dao = new BookDAO();
    List<Book> books = dao.getAvailableBooks();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    
    <title>📚 Available Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        .card-book {
            border-radius: 12px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s;
            height: 100%;
        }
        .card-book:hover {
            transform: scale(1.02);
        }
        .book-img {
            display: block;
            margin: 10px auto;
            max-height: 160px;
            object-fit: cover;
            border-radius: 10px;
        }.back-btn {
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
<div class="d-flex align-items-center gap-3">
            <!-- Back Button -->
            <a href="Cashierdashboard.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>

            <!-- Page Title -->
             <h2 class="mb-4">📚 Available Books for Billing</h2>
            
        </div>
    <% if (books != null && !books.isEmpty()) { %>
    <form action="${pageContext.request.contextPath}/AddMultipleToBillServlet" method="post">

        <!-- Customer ID input -->
        <div class="mb-4">
            <label for="customerId" class="form-label">Enter Customer ID:</label>
            <input type="number" class="form-control" name="customerId" id="customerId" required min="1" placeholder="Customer ID" />
        </div>

        <div class="row g-4">
            <% for (Book book : books) {
                List<String> imgs = book.getImages();
                if (imgs == null || imgs.isEmpty()) {
                    imgs = new ArrayList<>();
                    imgs.add("default-image.jpg");
                }
            %>
            <div class="col-md-4">
                <div class="card card-book p-3">
                    <img src="<%= request.getContextPath() + "/" + imgs.get(0) %>" alt="Book" class="book-img" />
                    <h5 class="card-title text-center"><%= book.getName() %></h5>
                    <p class="text-muted mb-1"><strong>Author:</strong> <%= book.getAuthor() %></p>
                    <p class="text-muted mb-1"><strong>Category:</strong> <%= book.getCategory() %></p>
                    <ul class="list-unstyled mt-2">
                        <li><strong>Price:</strong> Rs. <%= book.getPrice() %></li>
                        <li><strong>Stock:</strong> <%= book.getStockQuantity() %></li>
                        <li><strong>Discount:</strong> <%= book.getDiscount() %> %</li>
                    </ul>

                    <div class="form-check">
                        <input type="checkbox" class="form-check-input" name="selectedBooks" value="<%= book.getId() %>" id="select_<%= book.getId() %>">
                        <label class="form-check-label" for="select_<%= book.getId() %>">Select</label>
                    </div>

                    <label for="quantity_<%= book.getId() %>" class="mt-2">Quantity:</label>
                    <input type="number" class="form-control mb-2" name="quantity_<%= book.getId() %>" id="quantity_<%= book.getId() %>" value="1" min="1" max="<%= book.getStockQuantity() %>" />
                </div>
            </div>
            <% } %>
        </div>

        <div class="mt-4">
            <button type="submit" class="btn btn-primary">Add Selected Books to Bill 🧾</button>
        </div>
    </form>
    <% } else { %>
        <div class="alert alert-warning text-center">
            ⚠️ No available books found.
        </div>
    <% } %>

</body>
</html>
