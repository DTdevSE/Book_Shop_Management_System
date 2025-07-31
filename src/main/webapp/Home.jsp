<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" session="true" %>
<%
    String customerName = (String) session.getAttribute("customerName");
    String profileImage = (String) session.getAttribute("profileImage");

    if (profileImage == null || profileImage.trim().isEmpty()) {
        profileImage = "https://i.pravatar.cc/40?img=5"; // fallback avatar
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1" />
  <title>BookVault – Explore. Read. Grow.</title>

  <!-- Google Fonts: Inter -->
  <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;600&display=swap" rel="stylesheet" />

  <!-- Bootstrap CSS -->
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />

  <!-- AOS -->
  <link href="https://unpkg.com/aos@2.3.4/dist/aos.css" rel="stylesheet" />

  <!-- Font Awesome -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css" rel="stylesheet" />

  <!-- Custom Styles for Neumorphism -->
  <style>
    body {
      font-family: 'Inter', sans-serif;
      background: #e0e5ec;
      color: #333;
    }

    /* Navbar */
    .navbar {
      background: #e0e5ec;
      box-shadow:
        8px 8px 15px #a3b1c6,
        -8px -8px 15px #ffffff;
      padding: 1rem 2rem;
      position: fixed;
      width: 100%;
      z-index: 1030;
    }

    .navbar-brand {
      font-weight: 700;
      font-size: 1.8rem;
      color: #3a405a;
    }

    .nav-link {
      color: #3a405a;
      font-weight: 600;
      transition: color 0.3s ease;
    }

    .nav-link:hover,
    .nav-link.active {
      color: #4e73df;
    }

    /* Profile dropdown */
    .dropdown-menu {
      border-radius: 15px;
      box-shadow:
        8px 8px 15px #a3b1c6,
        -8px -8px 15px #ffffff;
      background: #e0e5ec;
    }

    /* Buttons with neumorphic effect */
    .btn-outline-primary, .btn-outline-success, .btn-outline-warning, .btn-outline-danger, .btn-outline-info, .btn-outline-dark {
      border-radius: 30px;
      font-weight: 600;
      padding: 0.5rem 1.5rem;
      transition: all 0.3s ease;
      box-shadow:
        inset 4px 4px 6px #babecc,
        inset -4px -4px 6px #ffffff;
      color: #3a405a;
    }

    .btn-outline-primary:hover {
      background-color: #4e73df;
      color: white;
      box-shadow: 4px 4px 8px #babecc,
                  -4px -4px 8px #ffffff;
    }

    /* Hero section */
    header#home {
      height: 100vh;
      background: url('https://cdn.pixabay.com/photo/2016/06/01/06/26/open-book-1428428_1280.jpg') no-repeat center/cover;
      position: relative;
      display: flex;
      justify-content: center;
      align-items: center;
      text-align: center;
      color: white;
      overflow: hidden;
    }

    header#home::before {
      content: "";
      position: absolute;
      inset: 0;
      background: rgba(0,0,0,0.55);
      z-index: 0;
    }

    header#home .container {
      position: relative;
      z-index: 1;
      max-width: 720px;
    }

    header#home h1 {
      font-size: 3.5rem;
      font-weight: 700;
      text-shadow: 2px 2px 10px rgba(0,0,0,0.7);
      margin-bottom: 1rem;
    }

    header#home p.lead {
      font-size: 1.5rem;
      margin-bottom: 2rem;
      text-shadow: 1px 1px 8px rgba(0,0,0,0.6);
    }

    header#home .btn-warning {
      border-radius: 40px;
      font-size: 1.25rem;
      padding: 0.75rem 3rem;
      box-shadow:
        8px 8px 15px #c6b180,
        -8px -8px 15px #fff9c4;
      transition: box-shadow 0.3s ease;
    }

    header#home .btn-warning:hover {
      box-shadow:
        inset 4px 4px 6px #c6b180,
        inset -4px -4px 6px #fff9c4;
    }

    /* Categories section */
    #categories {
      padding: 4rem 0;
      text-align: center;
    }

    #categories h2 {
      font-weight: 700;
      margin-bottom: 2rem;
      color: #3a405a;
    }

    #categories .btn {
      border-radius: 40px;
      font-weight: 600;
      padding: 0.6rem 2rem;
      margin: 0.4rem;
      box-shadow:
        6px 6px 12px #bec8d2,
        -6px -6px 12px #ffffff;
      color: #3a405a !important;
      transition: all 0.3s ease;
    }

    #categories .btn:hover {
      box-shadow:
        inset 6px 6px 12px #bec8d2,
        inset -6px -6px 12px #ffffff;
      color: #fff !important;
    }

    /* Featured Books */
    #featured {
      padding: 4rem 0;
      background: #f0f3f7;
    }

    #featured h2 {
      font-weight: 700;
      color: #3a405a;
      margin-bottom: 3rem;
      text-align: center;
    }

    #featured .card {
      border-radius: 20px;
      background: #e0e5ec;
      box-shadow:
        8px 8px 15px #a3b1c6,
        -8px -8px 15px #ffffff;
      transition: box-shadow 0.3s ease;
    }

    #featured .card:hover {
      box-shadow:
        4px 4px 10px #a3b1c6,
        -4px -4px 10px #ffffff;
    }

    #featured .card-img-top {
      border-top-left-radius: 20px;
      border-top-right-radius: 20px;
      height: 280px;
      object-fit: cover;
      box-shadow: inset 0 0 8px rgba(0,0,0,0.1);
    }

    #featured .card-title {
      font-weight: 700;
      color: #3a405a;
    }

    #featured .card-text {
      color: #555;
      font-size: 0.95rem;
    }

    /* Reviews Section */
    #reviews {
      padding: 4rem 0;
      text-align: center;
    }

    #reviews h2 {
      font-weight: 700;
      margin-bottom: 2rem;
      color: #3a405a;
    }

    #reviews .p-4 {
      background: #e0e5ec;
      border-radius: 20px;
      box-shadow:
        8px 8px 15px #a3b1c6,
        -8px -8px 15px #ffffff;
      transition: box-shadow 0.3s ease;
      min-height: 220px;
    }

    #reviews .p-4:hover {
      box-shadow:
        4px 4px 10px #a3b1c6,
        -4px -4px 10px #ffffff;
    }

    #reviews i.fa-quote-left {
      color: #f4b400;
      margin-bottom: 1rem;
    }

    #reviews p {
      font-style: italic;
      font-size: 1.05rem;
      color: #555;
      min-height: 90px;
    }

    #reviews h6 {
      margin-top: 1rem;
      font-weight: 700;
      color: #3a405a;
    }

    /* Contact Section */
    #contact {
      padding: 4rem 0;
      background: #f9a825;
      color: white;
      text-align: center;
      box-shadow:
        inset 8px 8px 15px #c48800,
        inset -8px -8px 15px #ffde59;
    }

    #contact h2 {
      font-weight: 700;
      margin-bottom: 1rem;
    }

    #contact p {
      font-size: 1.2rem;
      margin-bottom: 2rem;
    }

    #contact .btn-outline-light {
      border-radius: 40px;
      font-weight: 600;
      padding: 0.75rem 3rem;
      color: white;
      box-shadow:
        inset 4px 4px 6px #c48800,
        inset -4px -4px 6px #ffde59;
      transition: box-shadow 0.3s ease;
    }

    #contact .btn-outline-light:hover {
      background-color: white;
      color: #f9a825;
      box-shadow:
        8px 8px 15px #c48800,
        -8px -8px 15px #ffde59;
    }

    /* Footer */
    footer {
      background: #e0e5ec;
      text-align: center;
      padding: 1.5rem 0;
      color: #7a7a7a;
      font-weight: 500;
      box-shadow:
        inset 8px 8px 15px #a3b1c6,
        inset -8px -8px 15px #ffffff;
    }

    /* Smooth scrolling offset for fixed navbar */
    html {
      scroll-padding-top: 80px;
    }

    /* Responsive tweaks */
    @media (max-width: 768px) {
      header#home h1 {
        font-size: 2.5rem;
      }
      header#home p.lead {
        font-size: 1.1rem;
      }
    }
  </style>
</head>
<body data-bs-spy="scroll" data-bs-target="#navLinks" data-bs-offset="80">


<nav class="navbar navbar-expand-lg shadow-sm bg-light">
  <div class="container">
    <a class="navbar-brand fw-bold" href="#">
      📘 <span>Pahana Edu</span>
    </a>

    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navLinks" aria-controls="navLinks" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>

    <div class="collapse navbar-collapse justify-content-end" id="navLinks">
      <ul class="navbar-nav me-3 mb-2 mb-lg-0">
        <li class="nav-item"><a class="nav-link active" href="#home">Home</a></li>
        <li class="nav-item"><a class="nav-link" href="#categories">Categories</a></li>
        <li class="nav-item"><a class="nav-link" href="#featured">Books</a></li>
        <li class="nav-item"><a class="nav-link" href="#reviews">Reviews</a></li>
        <li class="nav-item"><a class="nav-link" href="#contact">Contact</a></li>
      </ul>

      <% if (customerName == null || customerName.trim().isEmpty()) { %>
        <!-- Show login button if NOT logged in -->
        <div class="d-flex align-items-center gap-2">
          <a href="/login" class="btn btn-outline-primary">
            <i class="fas fa-sign-in-alt me-1"></i> Login Out
          </a>
        </div>
      <% } else { %>
        <!-- Profile dropdown if logged in -->
        <div class="dropdown ms-3">
          <a class="d-flex align-items-center text-decoration-none dropdown-toggle" href="#" id="userDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">
            <img src="<%= profileImage %>" alt="User Profile" class="rounded-circle me-2" width="40" height="40" />
            <span class="fw-semibold text-dark"><%= customerName %></span>
          </a>
          <ul class="dropdown-menu dropdown-menu-end" aria-labelledby="userDropdown">
            <li><a class="dropdown-item" href="CustomerProfile.jsp"><i class="fas fa-user me-2"></i> My Profile</a></li>
            <li>
  <a class="dropdown-item" href="SearchBillsServlet">
    <i class="fas fa-book me-2"></i> My Orders
  </a>
</li>

            <li><hr class="dropdown-divider" /></li>
            <li>
              <a class="dropdown-item text-danger" 
   href="<%= request.getContextPath() %>/CustomerLogout" 
   onclick="return confirm('Are you sure you want to logout?');">
   <i class="fas fa-sign-out-alt me-2"></i> Logout
</a>

            </li>
          </ul>
        </div>
      <% } %>
    </div>
  </div>
</nav>

<!-- Hero Section -->
<header id="home" class="vh-100 d-flex justify-content-center align-items-center">
  <div class="container">
    <h1 class="animate__animated animate__fadeInDown">📚 Explore. Read. Grow.</h1>
    <p class="lead animate__animated animate__fadeInUp">Discover a world of books at your fingertips</p>
    <a href="#featured" class="btn btn-warning btn-lg shadow animate__animated animate__bounceIn animate__delay-1s">
      <i class="fas fa-book-open me-2"></i> Shop Now
    </a>
  </div>
</header>

<!-- Categories -->
<section id="categories" data-aos="fade-up">
  <div class="container">
    <h2>📖 Book Categories</h2>
    <div class="d-flex flex-wrap justify-content-center">
      <a href="BookCategories.jsp?category=Fiction" class="btn btn-outline-primary">Fiction</a>
      <a href="BookCategories.jsp?category=Business" class="btn btn-outline-success">Business</a>
      <a href="BookCategories.jsp?category=History" class="btn btn-outline-warning">History</a>
      <a href="BookCategories.jsp?category=Self-Help" class="btn btn-outline-danger">Self-Help</a>
      <a href="BookCategories.jsp?category=Children" class="btn btn-outline-info">Children</a>
      <a href="BookCategories.jsp?category=Novels" class="btn btn-outline-success">Novels</a>
    </div>
  </div>
</section>

<!-- Featured Books -->
<section id="featured" data-aos="fade-up">
  <div class="container">
    <h2>📚 Featured Books</h2>
    <div class="row g-4">
      <div class="col-md-4">
        <div class="card h-100 shadow-sm" data-aos="zoom-in">
          <img src="https://cdn.pixabay.com/photo/2017/08/07/03/30/people-2599319_1280.jpg" class="card-img-top" alt="Deep Work book cover" />
          <div class="card-body">
            <h5 class="card-title">Deep Work</h5>
            <p class="card-text">Master the ability to focus without distraction.</p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card h-100 shadow-sm" data-aos="zoom-in" data-aos-delay="150">
          <img src="https://images.unsplash.com/photo-1524995997946-a1c2e315a42f?auto=format&fit=crop&w=600&q=80" class="card-img-top" alt="The Alchemist book cover" />
          <div class="card-body">
            <h5 class="card-title">The Alchemist</h5>
            <p class="card-text">A fable about following your dreams.</p>
          </div>
        </div>
      </div>
      <div class="col-md-4">
        <div class="card h-100 shadow-sm" data-aos="zoom-in" data-aos-delay="300">
          <img src="https://images.unsplash.com/photo-1516979187457-637abb4f9353?auto=format&fit=crop&w=600&q=80" class="card-img-top" alt="Atomic Habits book cover" />
          <div class="card-body">
            <h5 class="card-title">Atomic Habits</h5>
            <p class="card-text">An easy way to build good habits  break bad ones.</p>
          </div>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Reviews -->
<section id="reviews" data-aos="fade-up">
  <div class="container">
    <h2>💬 What Readers Say</h2>
    <div class="row g-4">
      <div class="col-md-4">
        <div class="p-4">
          <i class="fas fa-quote-left fa-2x mb-3"></i>
          <p>"An incredible online bookstore! Fast delivery  top-notch titles."</p>
          <h6>Emma Wilson</h6>
        </div>
      </div>
      <div class="col-md-4">
        <div class="p-4">
          <i class="fas fa-quote-left fa-2x mb-3"></i>
          <p>"A stunning design and smooth shopping experience."</p>
          <h6>Liam Smith</h6>
        </div>
      </div>
      <div class="col-md-4">
        <div class="p-4">
          <i class="fas fa-quote-left fa-2x mb-3"></i>
          <p>"I love how easy it is to find my favorite authors here!"</p>
          <h6>Olivia Brown</h6>
        </div>
      </div>
    </div>
  </div>
</section>

<!-- Contact -->
<section id="contact" data-aos="fade-up">
  <div class="container text-center">
    <h2>Get In Touch</h2>
    <p>Need help choosing a book? Contact us anytime.</p>
    <a href="#home" class="btn btn-outline-light btn-lg">Contact Now</a>
  </div>
</section>

<!-- Footer -->
<footer class="bg-light py-3 text-center text-muted" style="font-size:14px;">
  <div class="container">
    <p class="mb-1">© 2025 PahanaEdu. All rights reserved.</p>
    <p class="mb-0">Developed by <strong>Dinitha Thewmika</strong>, Undergraduate, <em>ICBT Campus</em></p>
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
