<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add User Account</title>
     <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 520px;
            margin: 40px auto;
            padding: 25px 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 4px 12px rgba(0, 0, 0, 0.12);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: bold;
            color: #555;
        }

        input[type="text"],
        input[type="date"],
        input[type="password"],
        select,
        input[type="file"] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 6px;
            font-size: 14px;
        }

        input[type="file"] {
            padding: 8px;
        }

        button {
            margin-top: 25px;
            width: 100%;
            padding: 12px;
            background-color: #28a745;
            color: #fff;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #218838;
        }

        .alert {
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 6px;
            font-weight: bold;
        }

        .error-message {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }

        .success-message {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }

        .emoji {
            font-size: 20px;
            margin-right: 5px;
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

<div class="container">
    <h2>👤 Create New User</h2>
     <a href="View_users.jsp" class="back-btn" title="Go Back">
                <i class="fas fa-arrow-left"></i> Back
            </a>

    <!-- ✅ Display error message -->
    <c:if test="${not empty param.error}">
        <div class="alert error-message">
            <span class="emoji">❌</span>
            <c:choose>
                <c:when test="${param.error == 'failedToAdd'}">
                    Failed to add user. Please try again.
                </c:when>
                <c:when test="${param.error == 'exception'}">
                    ⚠️ Unexpected error occurred. Contact admin.
                </c:when>
                <c:otherwise>
                    ⚠️ Something went wrong.
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <!-- ✅ Display success message -->
    <c:if test="${not empty param.msg}">
        <div class="alert success-message">
            <span class="emoji">✅</span>
            <c:choose>
                <c:when test="${param.msg == 'AccountAdded'}">
                    User account successfully added! 🎉
                </c:when>
                <c:otherwise>
                    Operation completed successfully.
                </c:otherwise>
            </c:choose>
        </div>
    </c:if>

    <!-- 📝 Add User Form -->
    <form action="AddAccountServlet" method="post" enctype="multipart/form-data">
        <label for="fullname">🧑 Full Name</label>
        <input type="text" name="fullname" id="fullname" required>

        <label for="id_number">🆔 ID Number</label>
        <input type="text" name="id_number" id="id_number" required>

        <label for="dob">🎂 Date of Birth</label>
        <input type="date" name="dob" id="dob">

        <label for="address">🏠 Address</label>
        <input type="text" name="address" id="address">

        <label for="password">🔐 Password</label>
        <input type="password" name="password" id="password" required>

        <label for="role">🧩 Role</label>
        <select name="role" id="role" required>
            <option value="" disabled selected>🔽 Select a role</option>
            <option value="admin">👑 Admin</option>
            <option value="cashier">💰 Cashier</option>
            <option value="store_keeper">📦 StoreKeeper</option>
        </select>

        <label for="profile_image">📷 Profile Image</label>
        <input type="file" name="profile_image" id="profile_image" accept="image/*" required>

        <button type="submit">➕ Add User</button>
    </form>
</div>

</body>
</html>
