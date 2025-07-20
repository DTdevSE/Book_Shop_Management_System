<%@ page import="java.util.*, com.bookshop.dao.BookDAO, com.bookshop.model.Book" %>
<%
    BookDAO dao = new BookDAO();
    List<Book> books = dao.getAllBooks();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Book Manager</title>
</head>
<body>
<h2>Add Book</h2>
<form action="AddBookServlet" method="post" enctype="multipart/form-data">
    Name: <input type="text" name="name"><br>
    Category: <input type="text" name="category"><br>
    Author: <input type="text" name="author"><br>
    Description: <textarea name="description"></textarea><br>
    Price: <input type="number" step="0.01" name="price"><br>
    Discount: <input type="number" step="0.01" name="discount"><br>
    Offers: <input type="text" name="offers"><br>
    Stock Quantity: <input type="number" name="stockQuantity"><br>
    Upload Images: <input type="file" name="images" multiple><br>
    <button type="submit">Add</button>
</form>


</body>
</html>
