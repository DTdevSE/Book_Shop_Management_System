<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Inventory Manager Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    
    <style>
        * {
            box-sizing: border-box;
            font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
            margin: 0;
            padding: 0;
        }

        body {
            background-color: #f4f6f8;
            color: #333;
        }

        .header {
            background-color: #ff9800;
            color: white;
            padding: 20px;
            text-align: center;
            font-size: 24px;
            font-weight: bold;
        }

        .sidebar {
            width: 220px;
            background-color: #fff;
            height: 100vh;
            position: fixed;
            top: 70px;
            left: 0;
            padding: 20px;
            border-right: 1px solid #ddd;
        }

        .sidebar a {
            display: block;
            color: #333;
            padding: 12px 0;
            text-decoration: none;
            font-weight: 500;
            transition: all 0.2s;
        }

        .sidebar a:hover {
            color: #ff9800;
        }

        .main {
            margin-left: 240px;
            padding: 30px;
        }

        .cards {
            display: flex;
            flex-wrap: wrap;
            gap: 20px;
        }

        .card {
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            flex: 1 1 200px;
            box-shadow: 0 4px 10px rgba(0,0,0,0.05);
        }

        .card h3 {
            font-size: 18px;
            margin-bottom: 10px;
            color: #ff9800;
        }

        .card p {
            font-size: 16px;
        }

        .table-section {
            margin-top: 40px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            background-color: #fff;
            border-radius: 10px;
            overflow: hidden;
        }

        table th, table td {
            padding: 12px 15px;
            text-align: left;
        }

        table th {
            background-color: #f9a825;
            color: white;
        }

        table tr:nth-child(even) {
            background-color: #f5f5f5;
        }

        @media (max-width: 768px) {
            .sidebar {
                display: none;
            }

            .main {
                margin-left: 0;
                padding: 20px;
            }

            .cards {
                flex-direction: column;
            }
        }
    </style>
</head>
<body>

    <div class="header">Inventory Manager Dashboard</div>

    <div class="sidebar">
        <a href="#">Dashboard</a>
        <a href="View_books.jsp">Manage Products</a>
        <a href="#">Add New Item</a>
        <a href="#">Suppliers</a>
        <a href="#">Stock Alerts</a>
        <a href="#">Reports</a>
        <a href="#">Logout</a>
    </div>

    <div class="main">
        <div class="cards">
            <div class="card">
                <h3>Total Products</h3>
                <p>1,254</p>
            </div>
            <div class="card">
                <h3>Low Stock</h3>
                <p>18 Items</p>
            </div>
            <div class="card">
                <h3>Pending Orders</h3>
                <p>6 Orders</p>
            </div>
            <div class="card">
                <h3>Suppliers</h3>
                <p>12 Partners</p>
            </div>
        </div>

        <div class="table-section">
            <h2>Recent Inventory Activity</h2>
            <table>
                <thead>
                    <tr>
                        <th>Item Name</th>
                        <th>Category</th>
                        <th>Quantity</th>
                        <th>Last Updated</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td>HP Laser Printer</td>
                        <td>Electronics</td>
                        <td>25</td>
                        <td>2025-07-13</td>
                    </tr>
                    <tr>
                        <td>Office Chair</td>
                        <td>Furniture</td>
                        <td>45</td>
                        <td>2025-07-10</td>
                    </tr>
                    <tr>
                        <td>USB Flash Drive</td>
                        <td>Accessories</td>
                        <td>130</td>
                        <td>2025-07-09</td>
                    </tr>
                </tbody>
            </table>
        </div>
    </div>

</body>
</html>
