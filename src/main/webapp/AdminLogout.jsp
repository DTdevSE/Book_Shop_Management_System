<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Logged Out</title>
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css" rel="stylesheet">
  <style>
    .typewriter h2 {
      overflow: hidden;
      border-right: .15em solid orange;
      white-space: nowrap;
      margin: 0 auto;
      letter-spacing: .10em;
      animation: typing 3s steps(30, end), blink-caret .75s step-end infinite;
    }

    @keyframes typing {
      from { width: 0 }
      to { width: 100% }
    }

    @keyframes blink-caret {
      from, to { border-color: transparent }
      50% { border-color: orange; }
    }

    body {
      background: linear-gradient(to right, #f8f9fa, #e9ecef);
    }
  </style>
</head>
<body class="text-center d-flex justify-content-center align-items-center" style="height: 100vh;">
  <div>
    <div class="typewriter">
      <h2>You have been logged out</h2>
    </div>
    <p class="mt-3">Thank you for visiting. Please <a href="login.jsp" class="text-primary fw-bold">login again</a> to continue.</p>
  </div>
</body>
</html>
