<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Admin Login</title>
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

    input[type="text"],
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
    <h2>Admin Login</h2>
    <form action="AdminLogin" method="post">
      <input type="text" name="username" placeholder="Username" required>

      <input type="password" name="password" placeholder="Password" required>
      <button type="submit">Login</button>

      <div class="options">
        <label><input type="checkbox"> Remember me</label>
        <a href="#" style="color:#ccc;">Forgot Password?</a>
      </div>
    </form>
  </div>

</body>
</html>
