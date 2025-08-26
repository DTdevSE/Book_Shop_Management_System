<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.bookshop.dao.CustomerDAO" %>
<%@ page import="com.bookshop.model.Customer" %>
<%@ page import="java.sql.Date" %>

<%
    String accountNumberParam = request.getParameter("id");
    Customer customer = null;
    if (accountNumberParam != null) {
        try {
            int accountNumber = Integer.parseInt(accountNumberParam);
            CustomerDAO dao = new CustomerDAO();
            customer = dao.getCustomerById(accountNumber);
        } catch (NumberFormatException e) {
            out.println("<div class='alert alert-danger'>⚠️ Invalid customer ID</div>");
        }
    }
    if (customer == null) {
        out.println("<div class='alert alert-danger'>❌ Customer not found.</div>");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>✏️ Edit Customer</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
    <style>
        body {
            font-family: 'Segoe UI', sans-serif;
            background-color: #f0f2f5;
            padding: 40px;
        }
        .form-container {
            max-width: 650px;
            margin: auto;
            background: #fff;
            padding: 35px;
            border-radius: 12px;
            box-shadow: 0 6px 20px rgba(0,0,0,0.1);
            position: relative;
        }
        h2 {
            margin-bottom: 25px;
            color: #1a1a1a;
            border-bottom: 2px solid #444;
            padding-bottom: 10px;
            text-align: center;
        }
        label {
            font-weight: 600;
            color: #333;
        }
        input, select, textarea {
            border-radius: 8px;
            border: 1px solid #ccc;
            padding: 10px 12px;
            font-size: 14px;
            background-color: #fefefe;
            transition: border-color 0.3s ease;
        }
        input:focus, select:focus, textarea:focus {
            border-color: #007bff;
            outline: none;
        }
        button {
            margin-top: 25px;
            background-color: #007bff;
            color: white;
            border: none;
            padding: 12px 24px;
            border-radius: 8px;
            font-size: 16px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        button:hover {
            background-color: #0056b3;
        }
        .profile-img {
            max-width: 150px;
            max-height: 150px;
            margin-bottom: 10px;
            border-radius: 50%;
            box-shadow: 0 0 8px rgba(0,0,0,0.1);
            object-fit: cover;
        }
        .back-btn {
            display: inline-flex;
            align-items: center;
            background-color: #eee;
            border: 1px solid #ccc;
            padding: 6px 12px;
            cursor: pointer;
            font-size: 16px;
            border-radius: 6px;
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

<div class="form-container">
    <!-- Back Button -->
    <a href="AdminHome.jsp" class="back-btn" title="Go Back">
        <i class="fas fa-arrow-left"></i> Back
    </a>

    <h2>✏️ Edit Customer - ID: <%= customer.getAccountNumber() %> 🧑‍💼</h2>

    <% if (request.getAttribute("error") != null) { %>
        <div class="alert alert-danger">⚠️ <%= request.getAttribute("error") %></div>
    <% } %>

    <form action="UpdateCustomerServlet" method="post" enctype="multipart/form-data" class="mt-4">

        <input type="hidden" name="accountNumber" value="<%= customer.getAccountNumber() %>" />

        <div class="mb-3">
            <label for="name">👤 Full Name</label>
            <input type="text" id="name" name="name" class="form-control" required value="<%= customer.getName() %>" />
        </div>

        <div class="mb-3">
            <label for="email">📧 Email Address</label>
            <input type="email" id="email" name="email" class="form-control" value="<%= customer.getEmail() != null ? customer.getEmail() : "" %>" />
        </div>

        <div class="mb-3">
            <label for="telephone">📞 Telephone</label>
            <input type="text" id="telephone" name="telephone" class="form-control" required value="<%= customer.getTelephone() %>" />
        </div>

        <div class="mb-3">
            <label for="address">🏠 Address</label>
            <textarea id="address" name="address" class="form-control" rows="3"><%= customer.getAddress() != null ? customer.getAddress() : "" %></textarea>
        </div>

        <div class="mb-3">
            <label for="password">🔒 Password (Leave blank to keep current)</label>
            <input type="password" id="password" name="password" class="form-control" autocomplete="new-password" />
        </div>

        <div class="mb-3">
            <label for="gender">⚧️ Gender</label>
            <select id="gender" name="gender" class="form-select">
                <option value="male" <%= "male".equals(customer.getGender()) ? "selected" : "" %>>♂️ Male</option>
                <option value="female" <%= "female".equals(customer.getGender()) ? "selected" : "" %>>♀️ Female</option>
                <option value="other" <%= "other".equals(customer.getGender()) ? "selected" : "" %>>⚧️ Other</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="dob">🎂 Date of Birth</label>
            <input type="date" id="dob" name="dob" class="form-control" value="<%= customer.getDob() != null ? customer.getDob().toString() : "" %>" />
        </div>

        <div class="mb-3">
            <label for="membership_type">💳 Membership Type</label>
            <select id="membership_type" name="membership_type" class="form-select">
                <option value="regular" <%= "regular".equals(customer.getMembershipType()) ? "selected" : "" %>>🟢 Regular</option>
                <option value="premium" <%= "premium".equals(customer.getMembershipType()) ? "selected" : "" %>>🌟 Premium</option>
                <option value="vip" <%= "vip".equals(customer.getMembershipType()) ? "selected" : "" %>>👑 VIP</option>
            </select>
        </div>

        <div class="mb-3">
            <label for="profileImage">🖼️ Profile Image</label><br/>
            <%
                String imgSrc = (customer.getProfileImage() != null && !customer.getProfileImage().isEmpty())
                    ? customer.getProfileImage()
                    : "https://via.placeholder.com/150?text=No+Image";
            %>
            <img src="<%= imgSrc %>" alt="Profile Image" class="profile-img" /><br/>
            <input type="file" id="profileImage" name="profileImage" accept="image/*" />
            <small class="text-muted">Upload new image to replace existing one</small>
        </div>

        <button type="submit">✅ Update Customer</button>
        <a href="view_customers.jsp" class="btn btn-secondary ms-2">❌ Cancel</a>
    </form>
</div>

</body>
</html>
