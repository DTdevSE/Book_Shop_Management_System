<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0" />
  <title>BookVault – Explore. Read. Grow.</title>

  <!-- Bootstrap -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- AOS -->
  <link href="https://unpkg.com/aos@2.3.4/dist/aos.css" rel="stylesheet" />

  <!-- Font Awesome -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />

  <!-- Animate.css -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css" rel="stylesheet" />

  <!-- Google Fonts -->
  <link href="https://fonts.googleapis.com/css2?family=Roboto:wght@400;700&display=swap" rel="stylesheet" />

  <!-- Custom CSS -->
  <link rel="stylesheet" href="style.css" />

  <!-- Favicon & Icons -->
  <link rel="icon" href="favicon.ico" type="image/x-icon" />
  <link rel="apple-touch-icon" href="apple-touch-icon.png" />
  <link rel="manifest" href="manifest.json" />

  <!-- Meta Tags for SEO & Social -->
  <meta name="description" content="BookVault is your online home for the best books. Discover, explore, and grow." />
  <meta name="keywords" content="books, online bookstore, best books, reading, BookVault" />
  <meta name="author" content="BookVault Team" />

  <!-- Open Graph -->
  <meta property="og:title" content="BookVault – Explore. Read. Grow." />
  <meta property="og:description" content="Your online home for the best books." />
  <meta property="og:image" content="https://example.com/cover.jpg" />
  <meta property="og:url" content="https://example.com" />
  <meta property="og:type" content="website" />

  <!-- Twitter Card -->
  <meta name="twitter:card" content="summary_large_image" />
  <meta name="twitter:title" content="BookVault – Explore. Read. Grow." />
  <meta name="twitter:description" content="Your online home for the best books." />
  <meta name="twitter:image" content="https://example.com/cover.jpg" />
  <meta name="twitter:site" content="@BookVault" />

  <!-- Canonical -->
  <link rel="canonical" href="https://example.com" />

  <!-- Preconnect -->
  <link rel="preconnect" href="https://fonts.googleapis.com" />
  <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin />
</head>

<body data-bs-spy="scroll" data-bs-target="#navLinks">

<%@ page session="true" %>
<%
    String customerName = (String) session.getAttribute("customerName");
    String profileImage = (String) session.getAttribute("profileImage");

    if (profileImage == null || profileImage.isEmpty()) {
        profileImage = "https://i.pravatar.cc/40?img=5"; // fallback avatar
    } else {
        profileImage = profileImage; // keep relative if in /uploads/
    }
%>





<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-white fixed-top shadow-sm">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">
      📘 <span class="text-dark">BookVault</span>
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navLinks">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-end" id="navLinks">
      <ul class="navbar-nav me-3">
        <li class="nav-item"><a class="nav-link active" href="#home">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="#categories">Categories</a></li>
        <li class="nav-item"><a class="nav-link" href="#featured">Books</a></li>
        <li class="nav-item"><a class="nav-link" href="#reviews">Reviews</a></li>
        <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
      </ul>

      <!-- If user is NOT logged in -->
      <div class="d-flex align-items-center gap-2">
        <a href="/login" class="btn btn-outline-primary">
          <i class="fas fa-sign-in-alt me-1"></i> Login
        </a>
        <a href="AdminLogin.jsp" class="btn btn-dark">
          <i class="fas fa-user-shield me-1"></i> Admin Login
        </a>
      </div>

      <!-- If user IS logged in (replace block above via server-side logic) -->
      <!-- Example profile picture dropdown -->
      <div class="dropdown ms-3">
  <a class="d-flex align-items-center text-decoration-none dropdown-toggle" href="#" role="button" id="userDropdown" data-bs-toggle="dropdown" aria-expanded="false">
    <img src="<%= profileImage %>" alt="User Profile" class="rounded-circle me-2" width="40" height="40">
    <span class="fw-semibold text-dark"><%= customerName %></span>
  </a>
  <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
   <li><a class="dropdown-item" href="CustomerProfile.jsp"><i class="fas fa-user me-2"></i> My Profile</a></li>

    <li><a class="dropdown-item" href="cart.jsp"><i class="fas fa-book me-2"></i> My Orders</a></li>
    <li><hr class="dropdown-divider"></li>
    <li>
  <li>
  <a class="dropdown-item text-danger"
   href="<%= request.getContextPath() %>/CustomerLogout"
   onclick="return confirm('Are you sure you want to logout?');">
  <i class="fas fa-sign-out-alt me-2"></i> Logout
</a>

</li>

  </ul>
</div>

      
    </div>
  </div>
</nav>



<!-- Hero Section -->
<header id="home" class="vh-100 d-flex justify-content-center align-items-center text-center position-relative" style="background: url('https://images.unsplash.com/photo-1512820790803-83ca734da794') no-repeat center/cover;" data-aos="fade-in">
  <!-- Overlay -->
  <div class="position-absolute top-0 start-0 w-100 h-100" style="background: rgba(0, 0, 0, 0.6); z-index: 1;"></div>

  <!-- Content -->
  <div class="container position-relative text-white" style="z-index: 2;">
    <h1 class="display-2 fw-bold animate__animated animate__fadeInDown mb-4">📚 Explore. Read. Grow.</h1>
    <p class="lead fs-4 animate__animated animate__fadeInUp">Discover a world of books at your fingertips</p>
    <a href="#featured" class="btn btn-warning btn-lg mt-4 px-5 py-3 shadow-lg animate__animated animate__bounceIn animate__delay-1s">
      <i class="fas fa-book-open me-2"></i> Shop Now
    </a>
  </div>
</header>

<!-- Categories -->
<section id="categories" class="py-5 text-center" data-aos="fade-up">
  <div class="container">
    <h2 class="fw-bold mb-4">📖 Book Categories</h2>
    <div class="d-flex flex-wrap justify-content-center gap-3">
      <a href="BookCategories.jsp?category=Fiction" class="btn btn-outline-primary rounded-pill">Fiction</a>
      <a href="BookCategories.jsp?category=Business" class="btn btn-outline-success rounded-pill">Business</a>
      <a href="BookCategories.jsp?category=History" class="btn btn-outline-warning rounded-pill">History</a>
      <a href="BookCategories.jsp?category=Self-Help" class="btn btn-outline-danger rounded-pill">Self-Help</a>
      <a href="BookCategories.jsp?category=Children" class="btn btn-outline-info rounded-pill">Children</a>
      <a href="BookCategories.jsp?category=NOVELS" class="btn btn-outline-success rounded-pill">Novels</a>

    </div>
  </div>
</section>


<!-- Featured Books -->
<section id="featured" class="py-5 bg-light" data-aos="fade-up">
  <div class="container">
    <h2 class="fw-bold text-center mb-5">📚 Featured Books</h2>
    <div class="row g-4">
      <!-- Repeatable Book Cards -->
      <div class="col-md-4">
        <div class="card h-100 shadow-sm" data-aos="zoom-in">
          <img src="https://images.unsplash.com/photo-1606107557195-c6cb7a713bf0" class="card-img-top" alt="Deep Work book cover">
          <div class="card-body">
            <h5 class="card-title">Deep Work</h5>
            <p class="card-text">Master the ability to focus without distraction.</p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card h-100 shadow-sm" data-aos="zoom-in" data-aos-delay="150">
          <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f" class="card-img-top" alt="The Alchemist book cover">
          <div class="card-body">
            <h5 class="card-title">The Alchemist</h5>
            <p class="card-text">A fable about following your dreams.</p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card h-100 shadow-sm" data-aos="zoom-in" data-aos-delay="300">
          <img src="https://images.unsplash.com/photo-1516979187457-637abb4f9353" class="card-img-top" alt="Atomic Habits book cover">
          <div class="card-body">
            <h5 class="card-title">Atomic Habits</h5>
            <p class="card-text">An easy way to build good habits & break bad ones.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Reviews -->
<section id="reviews" class="py-5 text-center" data-aos="fade-up">
  <div class="container">
    <h2 class="fw-bold mb-4">💬 What Readers Say</h2>
    <div class="row g-4">
      <div class="col-md-4">
        <div class="p-4 border rounded shadow-sm">
          <i class="fas fa-quote-left fa-2x text-warning mb-3"></i>
          <p>"An incredible online bookstore! Fast delivery & top-notch titles."</p>
          <h6 class="fw-bold">Emma Wilson</h6>
        </div>
      </div>
      <div class="col-md-4">
        <div class="p-4 border rounded shadow-sm">
          <i class="fas fa-quote-left fa-2x text-warning mb-3"></i>
          <p>"A stunning design and smooth shopping experience."</p>
          <h6 class="fw-bold">Liam Smith</h6>
        </div>
      </div>
      <div class="col-md-4">
        <div class="p-4 border rounded shadow-sm">
          <i class="fas fa-quote-left fa-2x text-warning mb-3"></i>
          <p>"I love how easy it is to find my favorite authors here!"</p>
          <h6 class="fw-bold">Olivia Brown</h6>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Contact -->
<section id="contact" class="py-5 bg-warning text-white text-center" data-aos="fade-up">
  <div class="container">
    <h2 class="fw-bold">Get In Touch</h2>
    <p>Need help choosing a book? Contact us anytime.</p>
    <a href="#home" class="btn btn-outline-light btn-lg">Contact Now</a>
  </div>
</section>

<!-- Footer -->
<footer class="py-3 bg-light text-center border-top">
  <div class="container">
    <p class="mb-0 text-muted">© 2025 BookVault. All rights reserved.</p>
  </div>
</footer>

<!-- Scripts -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="https://unpkg.com/aos@2.3.4/dist/aos.js"></script>
<script>
  AOS.init({ duration: 1200, once: true });

  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault();
      document.querySelector(this.getAttribute("href")).scrollIntoView({
        behavior: "smooth",
        block: "start"
      });
    });
  });
</script>
</body>
</html>
