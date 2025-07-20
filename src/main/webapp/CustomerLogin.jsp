<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Login Page</title>
    <!-- Make sure to include Font Awesome CDN in your <head> -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  
  <style>
    body {
      margin: 0;
      padding: 0;
      font-family: 'Segoe UI', sans-serif;
      background: linear-gradient(to bottom, #2c3e50, #bdc3c7);
      height: 100vh;
      display: flex;
      justify-content: center;
      align-items: center;
    }

    .login-box {
      background: rgba(255, 255, 255, 0.1);
      border-radius: 10px;
      padding: 40px;
      width: 350px;
      box-shadow: 0 8px 16px rgba(0,0,0,0.25);
      color: #fff;
      text-align: center;
    }

    .login-box h2 {
      margin-bottom: 20px;
      font-weight: 400;
    }

    input[type="number"],
    input[type="password"] {
      width: 100%;
      padding: 12px 20px;
      margin: 8px 0;
      border: none;
      border-radius: 5px;
      box-sizing: border-box;
    }

    .login-box button {
      width: 100%;
      padding: 12px;
      background-color: #2c3e50;
      border: none;
      color: white;
      margin-top: 10px;
      border-radius: 5px;
      cursor: pointer;
    }

    .options {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-top: 10px;
      font-size: 14px;
    }

    .social-buttons {
      margin-top: 15px;
    }

    .social-buttons button {
      margin: 5px;
      padding: 10px 15px;
      border: none;
      color: white;
      border-radius: 4px;
      cursor: pointer;
    }

    .social-blue { background: #3498db; }
    .social-cyan { background: #00cec9; }
    .social-pink { background: #e84393; }

    .signup-link {
      margin-top: 15px;
      font-size: 14px;
    }

    .signup-link a {
      color: #f1c40f;
      text-decoration: none;
    }

    .signup-link a:hover {
      text-decoration: underline;
    }
  </style>
</head>
<body>

  <div class="login-box">
    <h2>Member Login</h2>
    <form action="CustomerLogin" method="post">
  <input type="number" name="account_number" placeholder="Account Number" required>
  <input type="password" name="password" placeholder="Password" required>
  <button type="submit">Login</button>
</form>


      <div class="options">
        <label><input type="checkbox"> Remember me</label>
        <a href="#" style="color:#ccc;">Forgot Password?</a>
      </div>
    </form>

  
<div class="social-buttons" style="display: flex; justify-content: space-between;">
  <button class="social-blue">
    <i class="fab fa-facebook-f"></i> Facebook
  </button>
  <button class="social-cyan">
    <i class="fab fa-google"></i> Google
  </button>
  <button class="social-pink">
    <i class="fab fa-github"></i> GitHub
  </button>
</div>

    <div class="signup-link">
      Don't have an account? <a href="CustomerSingup.jsp">Sign up</a>
    </div>
  </div>

</body>
</html>
