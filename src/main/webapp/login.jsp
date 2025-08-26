<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login Page</title>
    <link rel="icon" type="image/png" href="https://e7.pngegg.com/pngimages/9/763/png-clipart-computer-icons-login-user-system-administrator-admin-desktop-wallpaper-megaphone-thumbnail.png" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        * {
            box-sizing: border-box;
        }

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
            -webkit-backdrop-filter: blur(15px);
            border-radius: 15px;
            padding: 40px 30px;
            box-shadow: 0 8px 32px rgba(0, 0, 0, 0.25);
            width: 100%;
            max-width: 400px;
            color: white;
            position: relative;
            z-index: 2;
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

        input[type="text"],
        input[type="password"] {
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

        /* Loader Styling */
        .loader-overlay {
            position: fixed;
            top: 0; left: 0;
            width: 100%;
            height: 100%;
            background: rgba(32, 38, 40, 0.9);
            display: flex;
            justify-content: center;
            align-items: center;
            z-index: 999;
            display: none; /* Hidden by default */
        }

        .loader-circle-24 {
            width: 70px;
            height: 70px;
            position: relative;
        }
        .loader-circle-24:before {
            border-radius: 50%;
            border-top: 5px solid #bbb;
            content: " ";
            display: block;
            position: absolute;
            top: 10%;
            left: 10%;
            height: 80%;
            width: 80%;
            animation: loader-circle-24_rotation 2s linear infinite;
        }
        .loader-circle-24:after {
            border-radius: 50%;
            border-bottom: 5px solid #bbb;
            content: " ";
            display: block;
            height: 100%;
            width: 100%;
            animation: loader-circle-24_rotation-reverse 2s linear infinite;
            position: absolute;
            top: 0;
        }
        @keyframes loader-circle-24_rotation {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(360deg); }
        }
        @keyframes loader-circle-24_rotation-reverse {
            0% { transform: rotate(0deg); }
            100% { transform: rotate(-360deg); }
        }
    </style>
</head>
<body id="bg">

<!-- Loader -->
<div class="loader-overlay" id="loader">
    <div class="loader-circle-24"></div>
</div>

<div class="login-container">
    <h2>Login</h2>
    <p>PAHANA EDU</p>

    <!-- Session-based error handling -->
    <c:if test="${not empty sessionScope.error}">
        <div class="error-message" id="errorBox">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <form action="LoginServlet" method="post" onsubmit="showLoader()">
        <input type="text" name="id_number" placeholder="UserID" required />
        <input type="password" name="password" placeholder="Password" required />
        <button type="submit">Login</button>
    </form>
</div>

<script>
    // Background slideshow
    const backgrounds = [
        'url("https://cdn.pixabay.com/photo/2020/12/29/10/38/bookshop-5870155_960_720.jpg")',
        'url("https://cdn.pixabay.com/photo/2017/08/01/17/31/books-2566812_1280.jpg")'
    ];
    let index = 0;
    const bg = document.getElementById('bg');
    function changeBackground() {
        index = (index + 1) % backgrounds.length;
        bg.style.backgroundImage = backgrounds[index];
    }
    bg.style.backgroundImage = backgrounds[0];
    setInterval(changeBackground, 10000);

    // Loader handling
    function showLoader() {
        document.getElementById("loader").style.display = "flex";
    }

    // Auto-hide error message
    const errorBox = document.getElementById("errorBox");
    if (errorBox) {
        setTimeout(() => {
            errorBox.style.display = "none";
        }, 10000); // 10 seconds
    }
</script>

</body>
</html>
