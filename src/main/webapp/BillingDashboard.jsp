<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.*, com.bookshop.model.Book, com.bookshop.dao.BookDAO ,com.bookshop.model.CartItem" %>
<%@ page import="com.bookshop.model.Customer, com.bookshop.dao.CustomerDAO,com.bookshop.dao.CartDAO" %>

<%
    BookDAO dao = new BookDAO();
    List<Book> books = dao.getAvailableBooks();

    CustomerDAO customerDao = new CustomerDAO();
    List<Customer> customers = customerDao.getAllCustomers();
%>
<%
    // Get selected customer from session
    Integer customerId = (Integer) session.getAttribute("selectedCustomerId");

    List<CartItem> cartItems = new ArrayList<>();
    if (customerId != null) {
        CartDAO cartDAO = new CartDAO();
        cartItems = cartDAO.getCartItemsByCustomer(customerId);
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>📚 Book Preview Card View</title>

    <!-- Bootstrap & FontAwesome -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />

    <style>
        /* Fade-in animation */
        @keyframes fadeInUp {
            0% {
                opacity: 0;
                transform: translateY(10px);
            }
            100% {
                opacity: 1;
                transform: translateY(0);
            }
        }

        body {
            background: #f8f9fa;
            font-family: "Segoe UI", Tahoma, Geneva, Verdana, sans-serif;
        }

        h2 {
            font-weight: 700;
            color: #2c3e50;
        }

        .card-book {
            border-radius: 12px;
            box-shadow: 0 4px 12px rgba(0,0,0,0.12);
            transition: transform 0.3s ease, box-shadow 0.3s ease;
            height: 100%;
            position: relative;
            animation: fadeInUp 0.6s ease forwards;
            background: #fff;
        }
        .card-book:hover {
            transform: translateY(-6px) scale(1.03);
            box-shadow: 0 8px 20px rgba(0,0,0,0.15);
        }

        .book-img {
            display: block;
            margin: 1rem auto;
            max-height: 160px;
            width: auto;
            object-fit: cover;
            border-radius: 10px;
            user-select: none;
        }

        .icon-bar {
            display: flex;
            justify-content: center;
            gap: 1.2rem;
            margin-top: 1rem;
        }

        .icon-bar button {
            border: none;
            background: none;
            font-size: 1.4rem;
            color: #555;
            cursor: pointer;
            transition: color 0.25s ease;
        }

        .icon-bar button:hover {
            color: #007bff;
        }

        .wishlist.active {
            color: #e74c3c !important;
            text-shadow: 0 0 8px #e74c3c80;
        }

        /* Customer dropdown scroll */
        .dropdown-menu {
            max-height: 300px;
            overflow-y: auto;
            scrollbar-width: thin;
            scrollbar-color: #888 #f1f1f1;
        }
        .dropdown-menu::-webkit-scrollbar {
            width: 7px;
        }
        .dropdown-menu::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        .dropdown-menu::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }

        /* Customer search input spacing */
        .dropdown-menu > div {
            padding-bottom: 0.75rem;
        }

        /* Customer item hover */
        .customer-item:hover {
            background-color: #e9ecef;
            cursor: pointer;
            border-radius: 6px;
        }

        /* Selected customer box */
        #selectedCustomerBox {
            background: white;
            padding: 0.6rem 1rem;
            border-radius: 12px;
            box-shadow: 0 2px 10px rgba(0,0,0,0.08);
            user-select: none;
        }

        /* Modal tweaks */
        #bookPreviewModal .modal-content {
            border-radius: 12px;
            animation: fadeInUp 0.4s ease;
        }

        #bookPreviewModal img {
            max-width: 200px;
            border-radius: 10px;
            user-select: none;
        }
        #cartIcon {
            position: fixed;
            top: 20px;
            right: 20px;
            font-size: 1.8rem;
            color: #007bff;
            background: #fff;
            padding: 8px 12px;
            border-radius: 8px;
            box-shadow: 0 2px 8px rgba(0,0,0,0.15);
            z-index: 1050;
            display: flex;
            align-items: center;
            gap: 6px;
            text-decoration: none;
            user-select: none;
            transition: background-color 0.3s, color 0.3s;
        }
        #cartIcon:hover {
            background-color: #007bff;
            color: #fff;
        }
        #cartCount {
            font-size: 0.75rem;
            min-width: 18px;
            height: 18px;
            line-height: 18px;
            padding: 0 5px;
            border-radius: 9px;
            font-weight: 600;
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
<a href="Cashierdashboard.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>

    <h2 class="mb-4">📚 Browse Books</h2>

    <!-- Fixed Cart Icon Top Right -->
    <a href="cart.jsp" id="cartIcon" title="View Cart" aria-label="View Cart">
      <i class="fas fa-shopping-cart"></i>
      <span id="cartCount" class="badge bg-danger">0</span>
    </a>
    
    <!-- Customer Dropdown -->
    <div class="dropdown mb-4">
        <button class="btn btn-dark dropdown-toggle" type="button" data-bs-toggle="dropdown" aria-expanded="false" id="customerDropdownBtn">
            👤 Select a Customer
        </button>
        
        <!-- Search input hidden -->
<div class="p-3" style="width: 100%; display: none;">
    <input type="text" id="customerSearchInput" placeholder="Search customer..." />
</div>

        <ul class="dropdown-menu p-3" style="width: 100%;">
            <% if (customers != null && !customers.isEmpty()) {
                   for (Customer c : customers) { 
                       String imgPath = c.getProfileImage();
                       if (imgPath == null || imgPath.trim().isEmpty()) {
                           imgPath = "https://cdn-icons-png.flaticon.com/512/847/847969.png";
                       }
            %>
                <li class="dropdown-item customer-item d-flex align-items-center gap-3" 
                    data-image="<%= imgPath %>" 
                    data-name="<%= c.getName() %>"
                    data-account="<%= c.getAccountNumber() %>">
                    <img src="<%= imgPath %>" alt="Customer" 
                         style="width:40px; height:40px; border-radius:50%; object-fit:cover;" />
                    <div>
                        <strong>Account No:</strong> <%= c.getAccountNumber() %><br/>
                        <strong><%= c.getName() %></strong>
                    </div>
                </li>
            <%   }
               } else { %>
                <li class="dropdown-item text-muted">No customers found.</li>
            <% } %>
        </ul>
    </div>

    <!-- Selected Customer Display -->
    <div id="selectedCustomerBox" class="d-flex align-items-center gap-3 mb-4" style="display: none;">
        <img id="selectedCustomerImage" src="https://cdn-icons-png.flaticon.com/512/847/847969.png" alt="Customer" class="rounded-circle" 
             style="width: 60px; height: 60px; object-fit: cover; border: 2px solid #333;" />
        <h5 id="selectedCustomerName" class="mb-0"></h5>
    </div>

    <!-- Hidden input to store selected customer ID -->
    <input type="hidden" id="selectedCustomerId" value="" />

    <!-- Book Cards -->
    <% if (books != null && !books.isEmpty()) { %>
        <div class="row g-4">
            <% 
            int delayIndex = 0; // for staggered animation delay
            for (Book book : books) {
                List<String> imgs = book.getImages();
                if (imgs == null || imgs.isEmpty()) {
                    imgs = new ArrayList<>();
                    imgs.add("images/default-image.jpg");
                }
                String bookImg = imgs.get(0).startsWith("http") ? imgs.get(0) : (request.getContextPath() + "/" + imgs.get(0));
            %>
            <div class="col-md-3" style="animation-delay: <%= (delayIndex++ * 0.12) %>s; animation-fill-mode: both; animation-name: fadeInUp; animation-duration: 0.6s;">
                <div class="card card-book p-3 text-center">
                    <img src="<%= bookImg %>" alt="Book" class="book-img" />
                    <h5 class="card-title mt-2"><%= book.getName() %></h5>

                    <div class="icon-bar">
                        <!-- Preview -->
                        <button class="preview-btn" title="Preview"
                                data-bs-toggle="modal"
                                data-bs-target="#bookPreviewModal"
                                data-name="<%= book.getName() %>"
                                data-author="<%= book.getAuthor() %>"
                                data-category="<%= book.getCategory() %>"
                                data-price="Rs. <%= book.getPrice() %>"
                                data-stock="<%= book.getStockQuantity() %>"
                                data-discount="<%= book.getDiscount() %>%"
                                data-image="<%= bookImg %>">
                            <i class="fas fa-eye"></i>
                        </button>

                        <!-- Add to Cart -->
                        <button class="add-to-cart-btn" title="Add to Cart"
                                data-bookid="<%= book.getId() %>"
                                data-name="<%= book.getName() %>"
                                data-price="<%= book.getPrice() %>"
                                data-discount="<%= book.getDiscount() %>">
                            <i class="fas fa-cart-plus"></i>
                        </button>
                        
                        <!-- Add to Wishlist -->
                        <button class="wishlist-btn" title="Add to Wishlist" aria-label="Add to Wishlist">
                            <i class="fas fa-heart wishlist"></i>
                        </button>
                    </div>
                </div>
            </div>
            <% } %>
        </div>
    <% } else { %>
        <div class="alert alert-warning text-center mt-5">⚠️ No books available to show.</div>
    <% } %>

    <!-- Modal for Book Preview -->
    <div class="modal fade" id="bookPreviewModal" tabindex="-1" aria-labelledby="bookPreviewModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-dialog-centered modal-lg">
            <div class="modal-content">
                <div class="modal-header">
                    <h5 class="modal-title" id="bookPreviewModalLabel">📖 Book Details</h5>
                    <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body d-md-flex align-items-start gap-4">
                    <img id="previewImage" src="" alt="Book Image" class="img-fluid rounded" />
                    <div>
                        <h4 id="previewName" class="mb-2"></h4>
                        <p><strong>Author:</strong> <span id="previewAuthor"></span></p>
                        <p><strong>Category:</strong> <span id="previewCategory"></span></p>
                        <p><strong>Price:</strong> <span id="previewPrice"></span></p>
                        <p><strong>Stock:</strong> <span id="previewStock"></span></p>
                        <p><strong>Discount:</strong> <span id="previewDiscount"></span></p>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
<script></script>
   <script>
  
        // Book preview modal
        document.querySelectorAll('.preview-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                document.getElementById('previewName').textContent = btn.getAttribute('data-name');
                document.getElementById('previewAuthor').textContent = btn.getAttribute('data-author');
                document.getElementById('previewCategory').textContent = btn.getAttribute('data-category');
                document.getElementById('previewPrice').textContent = btn.getAttribute('data-price');
                document.getElementById('previewStock').textContent = btn.getAttribute('data-stock');
                document.getElementById('previewDiscount').textContent = btn.getAttribute('data-discount');
                document.getElementById('previewImage').src = btn.getAttribute('data-image');
            });
        });

        // Wishlist toggle effect
        document.querySelectorAll('.wishlist-btn').forEach(btn => {
            btn.addEventListener('click', () => {
                const icon = btn.querySelector('.wishlist');
                icon.classList.toggle('active');
            });
        });

        // Customer search filter
        document.getElementById('customerSearchInput').addEventListener('input', function() {
            const filter = this.value.toLowerCase();
            document.querySelectorAll('.customer-item').forEach(item => {
                const text = item.textContent.toLowerCase();
                item.style.display = text.includes(filter) ? '' : 'none';
            });
        });

        // Customer selection - show image and name in selectedCustomerBox, set hidden input
        document.querySelectorAll('.customer-item').forEach(item => {
            item.addEventListener('click', () => {
                const name = item.getAttribute('data-name');
                const image = item.getAttribute('data-image');
                const customerId = item.getAttribute('data-account');

                const selectedCustomerBox = document.getElementById('selectedCustomerBox');
                const selectedCustomerName = document.getElementById('selectedCustomerName');
                const selectedCustomerImage = document.getElementById('selectedCustomerImage');
                const selectedCustomerIdInput = document.getElementById('selectedCustomerId');

                selectedCustomerName.textContent = name;
                selectedCustomerImage.src = image && image.trim() !== "" 
                    ? image 
                    : "https://cdn-icons-png.flaticon.com/512/847/847969.png";

                selectedCustomerBox.style.display = "flex";

                selectedCustomerIdInput.value = customerId; // save selected customer id

                // Close dropdown
                const dropdownBtn = document.getElementById('customerDropdownBtn');
                const dropdownMenu = dropdownBtn.nextElementSibling;

                if (dropdownMenu.classList.contains('show')) {
                    dropdownBtn.click();
                }
            });
        });

        // Add to Cart button AJAX functionality
    document.querySelectorAll('.customer-item').forEach(item => {
  item.addEventListener('click', () => {
    const customerId = item.getAttribute('data-account');

    // Call servlet to set session and get cart count
    fetch('SetSelectedCustomerServlet', {
      method: 'POST',
      body: new URLSearchParams({ customerId }),
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' }
    })
    .then(response => response.json())
    .then(data => {
      if (data.success) {
        // Update selected customer UI (name, image etc) as you already do
        const selectedCustomerName = document.getElementById('selectedCustomerName');
        const selectedCustomerImage = document.getElementById('selectedCustomerImage');
        selectedCustomerName.textContent = item.getAttribute('data-name');
        const imgSrc = item.getAttribute('data-image') || "https://cdn-icons-png.flaticon.com/512/847/847969.png";
        selectedCustomerImage.src = imgSrc;

        document.getElementById('selectedCustomerBox').style.display = "flex";
        document.getElementById('selectedCustomerId').value = customerId;

        // Update cart count badge
        const cartCountElem = document.getElementById('cartCount');
        cartCountElem.textContent = data.cartCount;

        // Close the dropdown (optional)
        const dropdownBtn = document.getElementById('customerDropdownBtn');
        if (dropdownBtn.nextElementSibling.classList.contains('show')) {
          dropdownBtn.click();
        }
      } else {
        alert("Failed to set customer: " + data.message);
      }
    })
    .catch(err => {
      console.error("Error setting selected customer:", err);
      alert("Error selecting customer.");
    });
  });
});

        //add cart value

  

</script>
<script>
document.addEventListener("DOMContentLoaded", function () {
    // Add-to-cart button logic
    document.querySelectorAll(".add-to-cart-btn").forEach(button => {
        button.addEventListener("click", function () {
            const customerId = document.getElementById("selectedCustomerId").value;

            if (!customerId) {
                alert("Please select a customer first.");
                return;
            }

            const bookId = this.getAttribute("data-bookid");
            const name = this.getAttribute("data-name");
            const price = parseFloat(this.getAttribute("data-price"));
            const discount = parseFloat(this.getAttribute("data-discount"));
            const quantity = 1;
            const total = price - discount;

            fetch("AddToCartServlet", {
                method: "POST",
                headers: {
                    "Content-Type": "application/x-www-form-urlencoded"
                },
                body: new URLSearchParams({
                    customerId,
                    bookId,
                    bookName: name,
                    price,
                    discount,
                    quantity,
                    total
                })
            })
            .then(res => res.json())
            .then(data => {
                if (data.success) {
                    alert("✅ Added to cart successfully!");

                    // ✅ Update cart count badge
                    const cartCountSpan = document.getElementById("cartCount");
                    if (cartCountSpan) {
                        cartCountSpan.innerText = data.cartCount;
                    }

                    // ✅ Update per-book quantity badge
                    const qtySpan = document.getElementById("qty-book-" + data.bookId);
                    if (qtySpan) {
                        qtySpan.innerText = data.qtyInCart;
                    }

                } else {
                    alert("❌ Error: " + data.message);
                }
            })
            .catch(error => {
                console.error("Error:", error);
                alert("Something went wrong while adding to cart.");
            });
        });
    });
});
</script>

 
</html>
