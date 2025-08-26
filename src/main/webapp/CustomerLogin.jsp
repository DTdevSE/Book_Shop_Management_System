<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Login</title>
    <link rel="icon" type="image/png" href="https://icon-library.com/images/icon-customer/icon-customer-15.jpg" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        * { box-sizing: border-box; }

        body {
            margin: 0;
            padding: 0;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
            background-size: cover;
            background-position: center;
            background-repeat: no-repeat;
            transition: background-image 1.5s ease-in-out;
        }

        .login-container {
            background: rgba(255, 255, 255, 0.15);
            backdrop-filter: blur(15px);
            border-radius: 15px;
            padding: 40px 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
            width: 100%;
            max-width: 400px;
            color: white;
            z-index: 1;
        }

        .login-container h2, .login-container p {
            text-align: center;
            margin-bottom: 20px;
        }

        .error-message {
            background-color: rgba(255, 0, 0, 0.2);
            border: 1px solid red;
            color: white;
            padding: 10px;
            border-radius: 8px;
            margin-bottom: 15px;
            text-align: center;
        }

        input[type="number"], input[type="password"] {
            width: 100%;
            padding: 12px 15px;
            margin: 10px 0;
            border: none;
            border-radius: 10px;
            font-size: 16px;
        }

        button[type="submit"] {
            background-color: #ff9900;
            color: white;
            border: none;
            padding: 12px;
            width: 100%;
            font-size: 16px;
            border-radius: 10px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button[type="submit"]:hover {
            background-color: #e68a00;
        }

        /* Loader overlay */
        .loader-overlay {
            position: fixed;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(32, 38, 40, 0.8);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 10;
            display: none;
        }

        .loader-circle-24 {
            width: 70px;
            height: 70px;
            display: inline-block;
            position: relative;
        }

        .loader-circle-24:before,
        .loader-circle-24:after {
            content: "";
            position: absolute;
            border-radius: 50%;
        }

        .loader-circle-24:before {
            border-top: 5px solid #bbb;
            top: 10%;
            left: 10%;
            width: 80%;
            height: 80%;
            animation: spin 2s linear infinite;
        }

        .loader-circle-24:after {
            border-bottom: 5px solid #bbb;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            animation: spinReverse 2s linear infinite;
        }

        @keyframes spin {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }

        @keyframes spinReverse {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(-360deg); }
        }

        @media (max-width: 480px) {
            .login-container {
                padding: 30px 20px;
            }
        }
    </style>
</head>
<body id="bg">

<!-- Loader Overlay -->
<div class="loader-overlay" id="loaderOverlay">
    <div class="loader-circle-24"></div>
</div>

<div class="login-container">
    <h2>Customer Login</h2>
    <p>PAHANA EDU</p>

    <c:if test="${not empty error}">
        <div class="error-message" id="errorBox">${error}</div>
    </c:if>

    <form action="CustomerLogin" method="post" onsubmit="showLoader()">
        <input type="number" name="account_number" placeholder="Account Number" required />
        <input type="password" name="password" placeholder="Password" required />
        <button type="submit">Login</button>
    </form>
</div>

<script>
    // Background image rotator
    const backgrounds = [
        'url("https://cdn.pixabay.com/photo/2017/08/06/22/01/books-2596809_1280.jpg")',
        'url("https://cdn.pixabay.com/photo/2016/11/18/16/49/books-1835753_1280.jpg")'
    ];
    let index = 0;
    const bg = document.getElementById('bg');

    function changeBackground() {
        index = (index + 1) % backgrounds.length;
        bg.style.backgroundImage = backgrounds[index];
    }

    bg.style.backgroundImage = backgrounds[0];
    setInterval(changeBackground, 10000);

    // Hide error after 10 seconds
    const errorBox = document.getElementById("errorBox");
    if (errorBox) {
        setTimeout(() => { errorBox.style.display = "none"; }, 10000);
    }

    // Show loader on form submit
    function showLoader() {
        document.getElementById("loaderOverlay").style.display = "flex";
    }
</script>

</body>
</html>
