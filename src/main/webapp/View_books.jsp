<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Book, com.bookshop.dao.BookDAO" %>
<%@ page import="com.google.gson.Gson" %>

<%
    BookDAO dao = new BookDAO();
    List<Book> books = dao.getAllBooks();

    // Gson instance to convert Java list to JSON string
    Gson gson = new Gson();
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>📚 All Books</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        .card-book {
            border-radius: 15px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.1);
            transition: transform 0.2s ease-in-out;
            height: 100%;
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .card-book:hover {
            transform: translateY(-5px);
        }
        .book-img {
            display: block;
            margin-left: auto;
            margin-right: auto;
            max-height: 180px;
            max-width: 100%;
            object-fit: cover;
            border-radius: 12px;
            box-shadow: 0 2px 6px rgba(0,0,0,0.2);
        }
        .image-carousel {
            position: relative;
            height: 180px;
        }
        .image-carousel button {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            z-index: 10;
            background-color: rgba(255,255,255,0.8);
            border: 1px solid #0d6efd;
            color: #0d6efd;
            width: 32px;
            height: 32px;
            border-radius: 50%;
            font-size: 18px;
            line-height: 1;
            cursor: pointer;
            user-select: none;
        }
        .image-carousel button:focus {
            outline: none;
            box-shadow: 0 0 0 0.25rem rgba(13,110,253,.5);
        }
        .image-carousel button.start {
            left: 5px;
        }
        .image-carousel button.end {
            right: 5px;
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
       <!-- Back Button -->
            <a href="AdminHome.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>
        <h2>📚 All Books</h2>
        <a href="AddBooks.jsp" class="btn btn-success">➕ Add New Book</a>
    </div>

    <div class="row g-4">
        <% if (books != null && !books.isEmpty()) {
            for (Book book : books) {
                List<String> imgs = book.getImages();
                if (imgs == null || imgs.isEmpty()) {
                    imgs = new ArrayList<>();
                    imgs.add("default-image.jpg"); // fallback image path relative to context root
                }
        %>
        <div class="col-md-4 d-flex">
            <div class="card card-book p-3 w-100">

                <div class="image-carousel mb-3">

                    <button class="start" 
                            onclick="changeImage('<%= book.getId() %>', -1)" 
                            type="button">&#9664;</button>

                    <img id="main-img-<%= book.getId() %>" 
                         src="<%= request.getContextPath() + "/" + imgs.get(0) %>" 
                         alt="Book Image" class="book-img" />

                    <button class="end" 
                            onclick="changeImage('<%= book.getId() %>', 1)" 
                            type="button">&#9654;</button>

                    <script>
                        window.bookImages = window.bookImages || {};
                        window.bookImages['<%= book.getId() %>'] = <%= gson.toJson(imgs) %>;
                        window.bookCurrentIndex = window.bookCurrentIndex || {};
                        window.bookCurrentIndex['<%= book.getId() %>'] = 0;
                    </script>

                </div>

                <h5 class="card-title"><%= book.getName() %></h5>
                <p class="text-muted mb-1"><strong>Author:</strong> <%= book.getAuthor() %></p>
                <p class="text-muted mb-1"><strong>Category:</strong> <%= book.getCategory() %></p>
                <p class="card-text mb-2" style="max-height: 60px; overflow: hidden;">
                    <%= (book.getDescription() != null && book.getDescription().length() > 120) 
                            ? book.getDescription().substring(0, 120) + "..." 
                            : book.getDescription() %>
                </p>
                <ul class="list-unstyled mb-3">
                    <li><strong>Price:</strong> Rs:<%= book.getPrice() %></li>
                    <li><strong>Discount:</strong> <%= book.getDiscount() %> %</li>
                    <li><strong>Stock:</strong> <%= book.getStockQuantity() %></li>
                    <li><strong>Uploaded:</strong> <%= book.getUploadDateTime() != null ? book.getUploadDateTime().toString() : "N/A" %></li>
                </ul>
                <div class="d-flex justify-content-end gap-2">
                    <a href="EditBooks.jsp?id=<%= book.getId() %>" class="btn btn-warning btn-sm">✏️ Edit</a>
                    <a href="DeleteBookServlet?id=<%= book.getId() %>" onclick="return confirm('Are you sure you want to delete this book?');" class="btn btn-danger btn-sm">🗑️ Delete</a>
                </div>
            </div>
        </div>
        <%  }
        } else { %>
        <div class="col-12">
            <div class="alert alert-warning text-center">
                ⚠️ No books found or database error.
            </div>
        </div>
        <% } %>
    </div>

    <script>
        function changeImage(bookId, direction) {
            let imgs = window.bookImages[bookId];
            if (!imgs || imgs.length === 0) return;

            let currentIndex = window.bookCurrentIndex[bookId] || 0;
            currentIndex += direction;

            if (currentIndex < 0) currentIndex = imgs.length - 1;
            if (currentIndex >= imgs.length) currentIndex = 0;

            window.bookCurrentIndex[bookId] = currentIndex;

            let imgElem = document.getElementById('main-img-' + bookId);
            if (imgElem) {
                imgElem.src = '<%= request.getContextPath() + "/" %>' + imgs[currentIndex];
            }
        }
    </script>

</body>
</html>
