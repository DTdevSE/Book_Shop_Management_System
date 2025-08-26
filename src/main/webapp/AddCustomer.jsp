<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<!DOCTYPE html>
<html>
<head>
    <title>🧾 Register Customer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet" />
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet" />
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f5f7fa;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 600px;
            margin: 50px auto;
            padding: 30px;
            background-color: #ffffff;
            border-radius: 10px;
            box-shadow: 0 6px 12px rgba(0, 0, 0, 0.1);
        }

        h2 {
            text-align: center;
            margin-bottom: 25px;
            color: #333;
        }

        label {
            display: block;
            margin-top: 15px;
            font-weight: 600;
            color: #555;
        }

        input[type="text"],
        input[type="email"],
        input[type="tel"],
        input[type="password"],
        input[type="date"],
        textarea,
        select,
        input[type="file"] {
            width: 100%;
            padding: 10px;
            margin-top: 6px;
            border: 1px solid #ccc;
            border-radius: 5px;
            font-size: 14px;
        }

        button {
            margin-top: 25px;
            width: 100%;
            padding: 12px;
            background-color: #007bff;
            color: #fff;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #0056b3;
        }

        /* Corrected back button style */
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
            margin-bottom: 15px;
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
    <!-- Back Button -->
    <a href="View_customers.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>

    <h2>🧾 Register New Customer</h2>
    <form action="AddCustomer" method="post" enctype="multipart/form-data">
        <label for="name">👤 Full Name *</label>
        <input type="text" name="name" id="name" required maxlength="100">

        <label for="email">📧 Email (unique)</label>
        <input type="email" name="email" id="email" maxlength="150">

        <label for="address">🏠 Address</label>
        <textarea name="address" id="address" rows="2" maxlength="255"></textarea>

        <label for="telephone">📞 Telephone *</label>
        <input type="tel" name="telephone" id="telephone" required maxlength="15">

        <label for="password">🔒 Password *</label>
        <input type="password" name="password" id="password" required maxlength="255">

        <label for="profileImage">🖼️ Profile Image</label>
        <input type="file" name="profileImage" id="profileImage" accept="image/*">

        <label for="gender">⚧️ Gender</label>
        <select name="gender" id="gender">
            <option value="" selected disabled>-- Select Gender --</option>
            <option value="male">♂️ Male</option>
            <option value="female">♀️ Female</option>
            <option value="other">⚧️ Other</option>
        </select>

        <label for="dob">🎂 Date of Birth</label>
        <input type="date" name="dob" id="dob">

        <label for="membershipType">💳 Membership Type</label>
        <select name="membershipType" id="membershipType">
            <option value="regular" selected>🟢 Regular</option>
            <option value="premium">🌟 Premium</option>
            <option value="vip">👑 VIP</option>
        </select>

        <button type="submit">✅ Register Customer</button>
    </form>
</div>
</body>
</html>
