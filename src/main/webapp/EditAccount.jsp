<%@ page import="com.bookshop.dao.AccountDAO, com.bookshop.model.Account" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<%
    String idNumber = request.getParameter("idNumber");
    AccountDAO dao = new AccountDAO();
    Account account = null;

    if (idNumber != null) {
        account = dao.getAccountByIdNumber(idNumber); 
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>✏️ Edit Account</title>
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0f2f5;
            margin: 0;
            padding: 40px;
        }

        .form-container {
            max-width: 600px;
            margin: auto;
            background-color: #ffffff;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 4px 20px rgba(0, 0, 0, 0.1);
        }

        h2 {
            margin-bottom: 25px;
            color: #1e1e1e;
            border-bottom: 2px solid #444;
            padding-bottom: 10px;
        }

        label {
            display: block;
            margin-top: 18px;
            font-weight: 600;
            color: #333;
        }

        input[type="text"],
        input[type="password"],
        input[type="date"],
        input[type="file"] {
            width: 100%;
            padding: 10px 12px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
            background-color: #fefefe;
            transition: border-color 0.3s ease;
        }

        input:focus {
            border-color: #444;
            outline: none;
        }

        button {
            margin-top: 30px;
            background-color: #28a745;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 6px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }

        button:hover {
            background-color: #218838;
        }

        .error-message {
            text-align: center;
            color: red;
            font-size: 18px;
            padding: 15px;
            background-color: #fff0f0;
            border: 1px solid #ffc4c4;
            border-radius: 6px;
            margin-top: 40px;
        }

        .emoji-label {
            margin-right: 6px;
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
    <h2>✏️ Edit User Account</h2>
     <!-- Back Button -->
            <a href="AdminHome.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>

    <% if (account != null) { %>
        <form action="UpdateAccountServlet" method="post" enctype="multipart/form-data">
            <input type="hidden" name="idNumber" value="<%= account.getIdNumber() %>" />

            <label><span class="emoji-label">👤</span>Full Name:</label>
            <input type="text" name="fullname" value="<%= account.getFullname() %>" required />

            <label><span class="emoji-label">🎂</span>Date of Birth:</label>
            <input type="date" name="dob" value="<%= account.getDob() %>" required />

            <label><span class="emoji-label">🏠</span>Address:</label>
            <input type="text" name="address" value="<%= account.getAddress() %>" required />

            <label><span class="emoji-label">🔐</span>Password:</label>
            <input type="password" name="password" value="<%= account.getPassword() %>" required />

            <label><span class="emoji-label">🧑‍💼</span>Role:</label>
            <input type="text" name="role" value="<%= account.getRole() %>" required />

            <label><span class="emoji-label">🖼️</span>Profile Image:</label>
            <input type="file" name="profileImage" class="form-control"/>

            <button type="submit">✅ Update Account</button>
        </form>
    <% } else { %>
        <div class="error-message">
            ⚠️ Account not found for ID: <strong><%= idNumber %></strong>
        </div>
    <% } %>
</div>

</body>
</html>
