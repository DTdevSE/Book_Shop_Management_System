<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Book, com.bookshop.dao.BookDAO" %>

<%
    BookDAO dao = new BookDAO();
    List<Book> books = dao.getAllBooks(); // Fetch all books including out of stock
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>📦 Storekeeper Book View</title>

    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        body {
            background: #f8f9fa;
        }
        .card-book {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.1);
            transition: transform 0.3s ease;
        }
        .card-book:hover {
            transform: scale(1.03);
        }
        .book-img {
            height: 160px;
            object-fit: cover;
            border-radius: 10px;
        }
        .modal-content {
            border-radius: 1rem;
        }
        .modal-header {
            background-color: #343a40;
            color: #fff;
            border-top-left-radius: 1rem;
            border-top-right-radius: 1rem;
        }
        .highlight-stock {
            color: #dc3545;
            font-weight: bold;
            font-size: 1.2rem;
        }
        .highlight-discount {
            color: #198754;
            font-weight: bold;
            font-size: 1.2rem;
        }
        .preview-btn {
            border: none;
            background: none;
            font-size: 1.4rem;
            color: #007bff;
            cursor: pointer;
        }
        .preview-btn[disabled] {
            color: #6c757d;
            cursor: not-allowed;
            pointer-events: none;
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
    </style>
</head>
<body class="container py-5">

    <!-- Back Button -->
    <a href="Inventory Maintenance.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>

    <h2 class="mb-4 text-center text-primary">📦 Storekeeper View - Books</h2>

    <% if (books != null && !books.isEmpty()) { %>
        <div class="row g-4">
            <% for (Book book : books) {
                List<String> imgs = book.getImages();
                if (imgs == null || imgs.isEmpty()) {
                    imgs = new ArrayList<>();
                    imgs.add("images/default-image.jpg");
                }
                String bookImg = imgs.get(0).startsWith("http") ? imgs.get(0) : (request.getContextPath() + "/" + imgs.get(0));
                int stockQty = book.getStockQuantity();
                boolean isLowStock = stockQty > 0 && stockQty < 5;
                boolean isOutOfStock = stockQty == 0;
            %>
            <div class="col-md-3">
                <div class="card card-book p-3 text-center 
                    <%= isOutOfStock ? "border-danger border-3" : (isLowStock ? "border-warning border-2" : "") %>">
                    <img src="<%= bookImg %>" alt="Book" class="book-img mb-3 mx-auto" />
                    <h5 class="card-title"><%= book.getName() %></h5>

                    <% if (isOutOfStock) { %>
                        <p class="text-danger fw-semibold">
                            <i class="fas fa-exclamation-circle me-1"></i> Out of Stock
                        </p>
                    <% } else if (isLowStock) { %>
                        <p class="text-warning fw-semibold">
                            <i class="fas fa-exclamation-triangle me-1"></i> Low Stock!
                        </p>
                    <% } %>

                    <button class="preview-btn mt-2 btn btn-link"
                        data-bs-toggle="modal"
                        data-bs-target="#bookPreviewModal"
                        data-bookid="<%= book.getId() %>"
                        data-name="<%= book.getName() %>"
                        data-author="<%= book.getAuthor() %>"
                        data-category="<%= book.getCategory() %>"
                        data-price="Rs. <%= book.getPrice() %>"
                        data-stock="<%= book.getStockQuantity() %>"
                        data-discount="<%= book.getDiscount() %>%"
                        data-uploaded="<%= book.getUploadDateTime() != null ? book.getUploadDateTime().toString() : "N/A" %>"
                        data-image="<%= bookImg %>"
                        <%= isOutOfStock ? "disabled title='Out of Stock'" : "" %>>
                        <i class="fas fa-eye"></i> Preview
                    </button>
                </div>
            </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="alert alert-warning text-center mt-5">⚠️ No books available to show.</div>
    <% } %>

    <!-- Book Preview Modal -->
    <div class="modal fade" id="bookPreviewModal" tabindex="-1" aria-labelledby="bookPreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg modal-dialog-scrollable">
            <div class="modal-content shadow-lg">
                <div class="modal-header">
                    <h5 class="modal-title" id="bookPreviewModalLabel">
                        <i class="fas fa-book me-2"></i> Book Information
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body d-md-flex gap-4 align-items-start p-4">
                    <!-- Book Image -->
                    <img id="previewImage" src="" alt="Book Image" class="img-fluid rounded border" style="max-width: 200px;" />
                    <!-- Book Info -->
                    <div>
                        <h4 id="previewName" class="mb-3 text-primary fw-bold"></h4>
                        <p><strong>📘 Book ID:</strong> <span id="previewId"></span></p>
                        <p><strong>✍️ Author:</strong> <span id="previewAuthor"></span></p>
                        <p><strong>🏷️ Category:</strong> <span id="previewCategory"></span></p>
                        <p><strong>💰 Price:</strong> <span id="previewPrice"></span></p>
                        <p><strong>📦 Stock:</strong> <span id="previewStock" class="highlight-stock"></span></p>
                        <p><strong>🎯 Discount:</strong> <span id="previewDiscount" class="highlight-discount"></span></p>
                        <p><strong>📅 Uploaded:</strong> <span id="previewDate"></span></p>
                    </div>
                </div>
                <div class="modal-footer justify-content-end">
                    <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                        Close
                    </button>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS Bundle (includes Popper) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

    <script>
        document.addEventListener("DOMContentLoaded", function () {
            document.querySelectorAll('.preview-btn').forEach(btn => {
                btn.addEventListener('click', () => {
                    document.getElementById('previewName').textContent = btn.getAttribute('data-name');
                    document.getElementById('previewId').textContent = btn.getAttribute('data-bookid');
                    document.getElementById('previewAuthor').textContent = btn.getAttribute('data-author');
                    document.getElementById('previewCategory').textContent = btn.getAttribute('data-category');
                    document.getElementById('previewPrice').textContent = btn.getAttribute('data-price');
                    document.getElementById('previewStock').textContent = btn.getAttribute('data-stock');
                    document.getElementById('previewDiscount').textContent = btn.getAttribute('data-discount');
                    document.getElementById('previewDate').textContent = btn.getAttribute('data-uploaded');
                    document.getElementById('previewImage').src = btn.getAttribute('data-image');
                });
            });
        });
    </script>

</body>
</html>
