<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" session="true" %>
<%@ page import="java.sql.*" %>
<%@ page import="com.bookshop.util.DBConnection" %>

<%
    HttpSession currentSession = request.getSession(false);
    if (currentSession == null || currentSession.getAttribute("account_number") == null) {
        response.sendRedirect("CustomerLogin.jsp");
        return;
    }

    int accNum = (Integer) currentSession.getAttribute("account_number");

    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    String name = "", address = "", telephone = "", profileImage = "";

    try {
        conn = DBConnection.getConnection();
        stmt = conn.prepareStatement("SELECT * FROM customers WHERE account_number = ?");
        stmt.setInt(1, accNum);
        rs = stmt.executeQuery();
        if (rs.next()) {
            name = rs.getString("name");
            address = rs.getString("address");
            telephone = rs.getString("telephone");
            profileImage = rs.getString("profile_image");
        }
    } catch (Exception e) {
        out.println("Error fetching profile: " + e.getMessage());
    } finally {
        if (rs != null) rs.close();
        if (stmt != null) stmt.close();
        if (conn != null) conn.close();
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>My Profile</title>
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">

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
      color: #fff;
    }

    .profile-box {
      background: rgba(255, 255, 255, 0.1);
      border-radius: 10px;
      padding: 40px;
      width: 500px;
      box-shadow: 0 8px 16px rgba(0,0,0,0.25);
    }

    .header-bar {
      display: flex;
      align-items: center;
      margin-bottom: 20px;
    }

    .btn-back {
      background: none;
      border: none;
      color: #f1c40f;
      font-size: 22px;
      cursor: pointer;
      margin-right: 10px;
    }

    .header-bar h2 {
      margin: 0;
      font-weight: 400;
      text-align: center;
      flex: 1;
    }

    label {
      display: block;
      margin-top: 15px;
      color: #f1c40f;
    }

    input[type="text"],
    input[type="file"] {
      width: 100%;
      padding: 12px 20px;
      margin-top: 6px;
      border: none;
      border-radius: 5px;
      box-sizing: border-box;
      color: #000;
    }

    .btn-submit {
      width: 100%;
      padding: 12px;
      background-color: #2c3e50;
      border: none;
      color: white;
      margin-top: 20px;
      border-radius: 5px;
      cursor: pointer;
    }

    .img-preview {
      margin-top: 10px;
      border-radius: 8px;
      box-shadow: 0 0 5px #000;
    }
  </style>
</head>
<body>

  <div class="profile-box">
    <div class="header-bar">
      <button onclick="history.back()" class="btn-back" title="Go back">
        <i class="fas fa-arrow-left"></i>
      </button>
      <h2><i class="fas fa-user-edit"></i> Update Profile</h2>
    </div>

    <form action="CustomerProfile" method="post" enctype="multipart/form-data">
      <input type="hidden" name="account_number" value="<%= accNum %>">

      <label><i class="fas fa-user"></i> Name</label>
      <input type="text" name="name" value="<%= name %>" required>

      <label><i class="fas fa-map-marker-alt"></i> Address</label>
      <input type="text" name="address" value="<%= address %>">

      <label><i class="fas fa-phone"></i> Telephone</label>
      <input type="text" name="telephone" value="<%= telephone %>" required>

      <label><i class="fas fa-image"></i> Current Profile Image</label><br>
      <img src="<%= profileImage %>" width="100" class="img-preview"><br>
      <input type="file" name="image">

      <button type="submit" class="btn-submit">
        <i class="fas fa-save"></i> Save Changes
      </button>
    </form>
  </div>

</body>
</html>
