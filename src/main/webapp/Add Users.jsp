<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Add User Account</title>
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f4f4f4;
            margin: 0;
            padding: 0;
        }

        .container {
            max-width: 500px;
            margin: 40px auto;
            padding: 25px 30px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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
            border-radius: 5px;
            font-size: 14px;
        }

        input[type="file"] {
            padding: 8px;
        }

        button {
            margin-top: 25px;
            width: 100%;
            padding: 12px;
            background-color: #f57c00;
            color: #fff;
            font-size: 16px;
            border: none;
            border-radius: 6px;
            cursor: pointer;
            transition: background-color 0.3s;
        }

        button:hover {
            background-color: #ef6c00;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Create New User</h2>
    <form action="AddAccountServlet" method="post" enctype="multipart/form-data">
        <label for="fullname">Full Name</label>
        <input type="text" name="fullname" id="fullname" required>

        <label for="id_number">ID Number</label>
        <input type="text" name="id_number" id="id_number" required>

        <label for="dob">Date of Birth</label>
        <input type="date" name="dob" id="dob">

        <label for="address">Address</label>
        <input type="text" name="address" id="address">

        <label for="password">Password</label>
        <input type="password" name="password" id="password" required>

        <label for="role">Role</label>
        <select name="role" id="role" required>
            <option value="" disabled selected>Select a role</option>
            <option value="admin">Admin</option>
            <option value="cashier">Cashier</option>
            <option value="store_keeper">StoreKeeper</option>
            <!-- Add more roles if needed -->
        </select>

        <label for="profile_image">Profile Image</label>
        <input type="file" name="profile_image" id="profile_image" accept="image/*" required>

        <button type="submit">Add User</button>
    </form>
</div>
</body>
</html>
