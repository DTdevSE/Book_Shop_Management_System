<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="com.bookshop.model.Customer" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%
    Customer customer = (Customer) session.getAttribute("loggedCustomer");
    if (customer == null) {
        response.sendRedirect("Login.jsp");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>My Profile</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            background: linear-gradient(to right, #2c3e50, #4ca1af);
            font-family: 'Segoe UI', sans-serif;
            padding: 2rem;
            color: #fff;
        }

        .profile-container {
            background: rgba(0, 0, 0, 0.6);
            padding: 2rem;
            max-width: 450px;
            margin: auto;
            border-radius: 12px;
            box-shadow: 0 0 10px #000;
        }

        .header-bar {
            display: flex;
            align-items: center;
            justify-content: space-between;
            margin-bottom: 1.5rem;
        }

        .back-btn {
            padding: 5px 10px;
            background-color: #f1c40f;
            color: #2c3e50;
            font-weight: bold;
            border: none;
            border-radius: 50px;
            text-decoration: none;
            box-shadow: 2px 2px 8px #111;
            transition: all 0.3s ease;
        }

        .back-btn:hover {
            background-color: #fff;
            color: #000;
        }

        h2 {
            margin: 0;
            font-size: 1.50rem;
            display: flex;
            align-items: center;
            gap: 0.5rem;
        }

        label {
            color: #f1c40f;
            margin-top: 1rem;
        }

        input[type="text"],
        input[type="file"] {
            width: 100%;
            padding: 0.5rem;
            margin-top: 0.3rem;
            border-radius: 6px;
            border: none;
            color: #000;
        }

        .btn-submit {
            margin-top: 1.5rem;
            width: 100%;
        }

        .img-preview {
            margin-top: 1rem;
            max-width: 70px;
            border-radius: 50px;
            box-shadow: 0 0 5px #000;
        }

        .alert {
            max-width: 600px;
            margin: 20px auto;
            text-align: center;
            font-weight: 600;
            transition: all 0.3s ease-in-out;
        }

        .alert-success {
            background-color: #e0f7ec;
            color: #1abc9c;
            border-left: 6px solid #1abc9c;
        }

        .alert-danger {
            background-color: #fdecea;
            color: #e74c3c;
            border-left: 6px solid #e74c3c;
        }
        .header-bar {
    display: flex;
    align-items: center;
    justify-content: space-between;
  
    
    
}
.flex-fill {
    flex: 1;
}
        
footer {
    border-top: 1px solid rgba(60, 141, 155, 0.5); /* Light teal with semi-transparency */
    margin-top: 40px;
}


    </style>
</head>
<body>

<div class="profile-container">
    <!-- Header -->
    <div class="header-bar">
    <a href="Home.jsp" class="back-btn" title="Go Back">
        🔙 Back
    </a>
    <div class="flex-fill text-center">
        <h2 class="mb-0">  ✏️ Update Profile</h2>
    </div>
</div>


    <!-- Show messages -->
    <c:if test="${not empty sessionScope.error}">
        <div class="alert alert-danger" id="error-msg">${sessionScope.error}</div>
        <c:remove var="error" scope="session"/>
    </c:if>

    <c:if test="${not empty sessionScope.success}">
        <div class="alert alert-success" id="success-msg">${sessionScope.success}</div>
        <c:remove var="success" scope="session"/>
    </c:if>

    <form action="CustomerProfile" method="post" enctype="multipart/form-data">
        <input type="hidden" name="account_number" value="<%= customer.getAccountNumber() %>" />

        <label for="name">👤 Name</label>
        <input type="text" id="name" name="name" value="<%= customer.getName() %>" required />

        <label for="address">🏠 Address</label>
        <input type="text" id="address" name="address" value="<%= customer.getAddress() %>" />

        <label for="telephone">📞 Telephone</label>
        <input type="text" id="telephone" name="telephone" value="<%= customer.getTelephone() %>" required />

        <label>🖼️ Current Profile Image</label><br/>
        <img src="<%= customer.getProfileImage() != null && !customer.getProfileImage().trim().isEmpty() ? customer.getProfileImage() : "default-profile.png" %>" alt="Profile Image" class="img-preview" /><br/>

        <label for="image">📂 Upload New Image</label>
        <input type="file" id="image" name="image" accept="image/*" />

        <button type="submit" class="btn btn-primary btn-submit">
            💾 Save Changes
        </button>
    </form>
    
</div>


<script>
    // Fade out success or error messages after 10 seconds
    setTimeout(() => {
        const success = document.getElementById("success-msg");
        const error = document.getElementById("error-msg");

        if (success) success.style.display = "none";
        if (error) error.style.display = "none";
    }, 10000);
</script>

<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
