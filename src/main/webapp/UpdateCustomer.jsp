<%@ page import="com.bookshop.dao.CustomerDAO" %>
<%@ page import="com.bookshop.model.Customer" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    int accountNumber = Integer.parseInt(request.getParameter("account_number"));
    CustomerDAO dao = new CustomerDAO();
    Customer customer = dao.getCustomerById(accountNumber);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Update Customer</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.2/dist/css/bootstrap.min.css">
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.5/font/bootstrap-icons.css">
    <style>
        body, html { height: 100%; }
        .card { max-width: 500px; margin: auto; }
        .profile-img-wrapper { position: relative; display: inline-block; cursor: pointer; }
        .profile-img {
            width: 120px; height: 120px; object-fit: cover;
            border-radius: 50%; border: 3px solid #fff;
            box-shadow: 0 2px 6px rgba(0,0,0,0.3);
        }
        .camera-icon {
            position: absolute; top: 50%; left: 50%;
            transform: translate(-50%, -50%);
            width: 30px; height: 30px;
            background-color: gray; border-radius: 50%;
            display: flex; align-items: center; justify-content: center;
            cursor: pointer;
        }
        .camera-icon i {
            color: white; font-size: 18px;
        }
    </style>
</head>
<body class="d-flex align-items-center justify-content-center bg-light" style="height: 100vh;">
<div class="container">
    <div class="card shadow-sm text-center">
        <div class="card-body">

            <div class="mb-3">
                <div class="profile-img-wrapper" onclick="document.getElementById('profileImageInput').click()">
                    <img id="profilePreview"
                         src="<%= (customer.getProfileImage() != null && !customer.getProfileImage().isEmpty()) ? customer.getProfileImage() : "https://via.placeholder.com/120x120.png?text=No+Image" %>"
                         alt="Profile Image" class="profile-img" />
                    <div class="camera-icon">
                        <i class="bi bi-camera"></i>
                    </div>
                </div>
            </div>

            <h4 class="card-title mb-4">Update Customer</h4>

            <form action="UpdateCustomer" method="post" enctype="multipart/form-data">

                <input type="hidden" name="account_number" value="<%= customer.getAccountNumber() %>">

                <!-- Hidden file input -->
                <input type="file" name="profile_image_file" id="profileImageInput" accept="image/*" style="display:none;" onchange="previewProfileImage(event)">

                <div class="mb-3 text-start">
                    <label class="form-label">Name</label>
                    <input type="text" name="name" value="<%= customer.getName() %>" class="form-control" required>
                </div>

                <div class="mb-3 text-start">
                    <label class="form-label">Address</label>
                    <input type="text" name="address" value="<%= customer.getAddress() %>" class="form-control">
                </div>

                <div class="mb-3 text-start">
                    <label class="form-label">Telephone</label>
                    <input type="text" name="telephone" value="<%= customer.getTelephone() %>" class="form-control" required>
                </div>

                <button type="submit" class="btn btn-primary w-100 mb-2">Update</button>
                <a href="AdminAddCustomer.jsp" class="btn btn-secondary w-100">Cancel</a>
            </form>

        </div>
    </div>
</div>

<script>
    function previewProfileImage(event) {
        const reader = new FileReader();
        reader.onload = function() {
            document.getElementById('profilePreview').src = reader.result;
        };
        reader.readAsDataURL(event.target.files[0]);
    }
</script>
</body>
</html>
