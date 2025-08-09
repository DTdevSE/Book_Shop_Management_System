<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.*, com.bookshop.dao.BookDAO, com.bookshop.model.Book" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>➕ Add New Book</title>
    <!-- Bootstrap CSS CDN -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background-color: #f8f9fa;
        }
        .form-container {
            max-width: 700px;
            margin: 50px auto;
            background: white;
            padding: 30px;
            border-radius: 15px;
            box-shadow: 0 4px 15px rgba(0,0,0,0.1);
        }
        .form-title {
            margin-bottom: 30px;
            font-weight: 700;
            color: #343a40;
            text-align: center;
        }
        .form-label {
            font-weight: 600;
        }
        button[type="submit"] {
            width: 100%;
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

<div class="form-container">
    <h2 class="form-title">📘 Add New Book</h2>
    <a href="View_books.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>

    <form action="AddBookServlet" method="post" enctype="multipart/form-data" class="needs-validation" novalidate>

        <div class="mb-3">
            <label for="name" class="form-label">📕 Book Name</label>
            <input type="text" class="form-control" id="name" name="name" placeholder="📕 Enter book name" required />
            <div class="invalid-feedback">Please enter the book name.</div>
        </div>

        <div class="mb-3">
            <label for="category" class="form-label">📚 Category</label>
            <select class="form-select" id="category" name="category" required>
                <option value="" disabled selected>📂 Select a category</option>
                <option value="Fiction">Fiction</option>
                <option value="Non-fiction">Non-fiction</option>
                <option value="Children">Children</option>
                <option value="Education">Education</option>
                <option value="Science">Science</option>
                <option value="Technology">Technology</option>
                <option value="Biography">Biography</option>
                <option value="History">History</option>
                <option value="Romance">Romance</option>
                <option value="Fantasy">Fantasy</option>
                <option value="Mystery">Mystery</option>
                <option value="Comics">Comics</option>
                <option value="Self-help">Self-help</option>
                <option value="Health">Health</option>
                <option value="Travel">Travel</option>
            </select>
            <div class="invalid-feedback">Please select a category.</div>
        </div>

        <div class="mb-3">
            <label for="author" class="form-label">✍️ Author</label>
            <input type="text" class="form-control" id="author" name="author" placeholder="✍️ Author name" required />
            <div class="invalid-feedback">Please enter the author name.</div>
        </div>

        <div class="mb-3">
            <label for="description" class="form-label">📝 Description</label>
            <textarea class="form-control" id="description" name="description" rows="4" placeholder="📝 Brief description" required></textarea>
            <div class="invalid-feedback">Please enter a description.</div>
        </div>

        <div class="row">
            <div class="col-md-6 mb-3">
                <label for="price" class="form-label">💰 Price ($)</label>
                <input type="number" step="0.01" class="form-control" id="price" name="price" placeholder="💰 Price" required />
                <div class="invalid-feedback">Please enter a valid price.</div>
            </div>
            <div class="col-md-6 mb-3">
                <label for="discount" class="form-label">🔻 Discount (%)</label>
                <input type="number" step="0.01" class="form-control" id="discount" name="discount" placeholder="🔻 Discount" />
            </div>
        </div>

        <div class="mb-3">
            <label for="offers" class="form-label">🎁 Offers</label>
            <input type="text" class="form-control" id="offers" name="offers" placeholder="🎁 Any special offers" />
        </div>

        <div class="mb-3">
            <label for="stockQuantity" class="form-label">📦 Stock Quantity</label>
            <input type="number" class="form-control" id="stockQuantity" name="stockQuantity" placeholder="📦 Available stock" required />
            <div class="invalid-feedback">Please enter the stock quantity.</div>
        </div>

        <div class="mb-4">
            <label for="images" class="form-label">🖼️ Upload Images</label>
            <input type="file" class="form-control" id="images" name="images" multiple accept="image/*" />
        </div>

        <button type="submit" class="btn btn-primary btn-lg">➕ Add Book</button>
    </form>
</div>

<!-- Bootstrap JS Bundle for validation -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>

<script>
    // Bootstrap validation
    (() => {
      'use strict'
      const forms = document.querySelectorAll('.needs-validation')
      Array.from(forms).forEach(form => {
        form.addEventListener('submit', event => {
          if (!form.checkValidity()) {
            event.preventDefault()
            event.stopPropagation()
          }
          form.classList.add('was-validated')
        }, false)
      })
    })()
</script>

</body>
</html>
