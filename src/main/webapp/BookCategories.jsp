<%@ page import="java.util.*, com.bookshop.model.Book, com.bookshop.dao.BookDAO" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8" />
    <title>Books by Category</title>
    <link rel="icon" type="image/png" href="https://static.vecteezy.com/system/resources/previews/024/043/963/original/book-icon-clipart-transparent-background-free-png.png" />
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        .book-img { height: 250px; object-fit: cover; }
        .badge-category { background-color: #0d6efd; color: white; }
        .text-truncate { overflow: hidden; text-overflow: ellipsis; white-space: nowrap; }
    </style>
</head>
<body>

<%
    BookDAO dao = new BookDAO();
    String selectedCategory = request.getParameter("category");

    List<Book> filteredBooks = (selectedCategory != null && !selectedCategory.trim().isEmpty())
        ? dao.getBooksByCategory(selectedCategory.trim())
        : dao.getAllBooks();
%>

<div class="container py-5">
    <h2 class="text-center fw-bold mb-4">
        <%= (selectedCategory != null && !selectedCategory.trim().isEmpty())
            ? "📚 " + selectedCategory + " Books"
            : "📚 All Books" %>
    </h2>

    <% if (filteredBooks != null && !filteredBooks.isEmpty()) { %>
        <div class="row g-4">
            <% for (Book b : filteredBooks) { 
                List<String> imgs = b.getImages();
                if (imgs == null || imgs.isEmpty()) {
                    imgs = new ArrayList<>();
                    imgs.add("images/default-image.jpg");
                }
                String bookImg = imgs.get(0).startsWith("http") 
                    ? imgs.get(0) 
                    : (request.getContextPath() + "/" + imgs.get(0));

                int stockQty = b.getStockQuantity();
                boolean isLowStock = stockQty > 0 && stockQty < 5;
                boolean isOutOfStock = stockQty == 0;
            %>
            <div class="col-md-3">
                <div class="card card-book p-3 text-center 
                    <%= isOutOfStock ? "border-danger border-3" : (isLowStock ? "border-warning border-2" : "") %>">
                    
                    <img src="<%= bookImg %>" alt="Book" class="book-img mb-3 mx-auto" />

                    <div class="card-body d-flex flex-column">
                        <h5 class="card-title text-truncate" title="<%= b.getName() %>">
                            <i class="fa-solid fa-book me-2 text-primary"></i><%= b.getName() %>
                        </h5>
                        <span class="badge badge-category mb-2"><%= b.getCategory() %></span>
                        <p class="mb-1"><strong>Author:</strong> <%= b.getAuthor() %></p>
                        <p class="mb-1">
                            <strong>Price:</strong> Rs:<%= b.getPrice() %>
                            <span class="text-success">(<%= b.getDiscount() %>% off)</span>
                        </p>
                        <p class="mb-1"><strong>Offers:</strong> 
                            <%= (b.getOffers() != null && !b.getOffers().isEmpty()) ? b.getOffers() : "None" %>
                        </p>
                        <p class="mb-1"><strong>Stock:</strong>
                            <span class="<%= b.getStockQuantity() > 0 ? "text-success" : "text-danger" %>">
                                <%= b.getStockQuantity() > 0 
                                    ? b.getStockQuantity() + " available" 
                                    : "Out of Stock" %>
                            </span>
                        </p>
                        <p class="mb-1 text-muted small"><strong>Uploaded:</strong> <%= b.getUploadDateTime() %></p>
                        <p class="mt-auto small"><%= b.getDescription() != null ? b.getDescription() : "" %></p>

                        <!-- Buy Form -->
                        <% if (b.getStockQuantity() > 0) { %>
                            <form action="<%= request.getContextPath() %>/BuyBook" method="post">
                                <input type="hidden" name="bookId" value="<%= b.getId() %>" />
                                <div class="input-group mb-2">
                                    <input type="number" name="quantity" min="1" max="<%= b.getStockQuantity() %>" 
                                           value="1" class="form-control" required />
                                    <button type="submit" class="btn btn-success">
                                        <i class="fa-solid fa-cart-shopping"></i> Buy
                                    </button>
                                </div>
                            </form>
                        <% } else { %>
                            <button class="btn btn-secondary mt-2" disabled>Out of Stock</button>
                        <% } %>

                        <!-- Action Buttons -->
                        <div class="d-flex justify-content-between align-items-center mt-2">
                            <!-- Cancel -->
                            <form action="CancelPurchase" method="post">
                                <input type="hidden" name="bookId" value="<%= b.getId() %>" />
                                <button type="submit" class="btn btn-outline-danger btn-sm">
                                    <i class="fa-solid fa-xmark"></i> Cancel
                                </button>
                            </form>

                            <!-- Like -->
                            <form action="LikeBook" method="post" class="d-inline">
                                <input type="hidden" name="bookId" value="<%= b.getId() %>" />
                                <button type="submit" class="btn btn-outline-primary btn-sm">
                                    <i class="fa-solid fa-heart"></i> Like
                                </button>
                            </form>

                            <!-- React Dropdown -->
                            <div class="dropdown d-inline">
                                <button class="btn btn-outline-secondary btn-sm dropdown-toggle" 
                                        type="button" data-bs-toggle="dropdown">
                                    <i class="fa-regular fa-face-smile"></i> React
                                </button>
                                <ul class="dropdown-menu">
                                    <% String[] reactions = {"happy", "sad", "angry", "love"}; 
                                       String[] emojis = {"😃 Happy", "😢 Sad", "😡 Angry", "😍 Love"}; 
                                       for (int i = 0; i < reactions.length; i++) { %>
                                        <li>
                                            <form action="ReactBook" method="post" class="px-3">
                                                <input type="hidden" name="bookId" value="<%= b.getId() %>" />
                                                <input type="hidden" name="reaction" value="<%= reactions[i] %>" />
                                                <button class="dropdown-item" type="submit"><%= emojis[i] %></button>
                                            </form>
                                        </li>
                                    <% } %>
                                </ul>
                            </div>
                        </div>

                        <!-- Comment Section -->
                        <form action="CommentBook" method="post" class="mt-2">
                            <input type="hidden" name="bookId" value="<%= b.getId() %>" />
                            <div class="input-group">
                                <input type="text" name="comment" class="form-control" 
                                       placeholder="Add a comment..." required />
                                <button type="submit" class="btn btn-outline-secondary">Post</button>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        <% } %>
        </div>
    <% } else { %>
        <div class="alert alert-warning text-center">No books found.</div>
    <% } %>
</div>

<!-- Bootstrap JS -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/js/bootstrap.bundle.min.js"></script>

</body>
</html>
