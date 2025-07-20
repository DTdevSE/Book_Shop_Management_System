package com.bookshop.Services.Admin;

import com.bookshop.dao.BookDAO;
import com.bookshop.model.Book;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.nio.file.Paths;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/UpdateBookServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2,  // 2MB
    maxFileSize = 1024 * 1024 * 10,       // 10MB
    maxRequestSize = 1024 * 1024 * 50     // 50MB
)
public class UpdateBookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final String UPLOAD_DIR = "book_images";

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String idStr = request.getParameter("id");
        String name = request.getParameter("name");
        String category = request.getParameter("category");
        String author = request.getParameter("author");
        String description = request.getParameter("description");
        String priceStr = request.getParameter("price");
        String discountStr = request.getParameter("discount");
        String offers = request.getParameter("offers");
        String stockStr = request.getParameter("stock_quantity");

        List<String> imagePaths = new ArrayList<>();

        try {
            int id = Integer.parseInt(idStr);
            double price = Double.parseDouble(priceStr);
            double discount = Double.parseDouble(discountStr);
            int stock = Integer.parseInt(stockStr);

            // Handle multiple image uploads
            for (Part part : request.getParts()) {
                if ("bookImages".equals(part.getName()) && part.getSize() > 0) {
                    String fileName = Paths.get(part.getSubmittedFileName()).getFileName().toString();

                    String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
                    File uploadDir = new File(uploadPath);
                    if (!uploadDir.exists()) uploadDir.mkdirs();

                    String filePath = uploadPath + File.separator + fileName;
                    part.write(filePath);

                    imagePaths.add(UPLOAD_DIR + "/" + fileName);
                }
            }

            BookDAO dao = new BookDAO();
            Book existing = dao.getBookById(id);
            if (existing == null) {
                request.setAttribute("error", "Book not found.");
                request.getRequestDispatcher("EditBook.jsp?id=" + id).forward(request, response);
                return;
            }

            Book updatedBook = new Book();
            updatedBook.setId(id);
            updatedBook.setName(name);
            updatedBook.setCategory(category);
            updatedBook.setAuthor(author);
            updatedBook.setDescription(description);
            updatedBook.setPrice(price);
            updatedBook.setDiscount(discount);
            updatedBook.setOffers(offers);
            updatedBook.setStockQuantity(stock);
            updatedBook.setUploadDateTime(LocalDateTime.now());
            updatedBook.setImages(imagePaths.isEmpty() ? existing.getImages() : imagePaths);

            boolean success = dao.updateBook(updatedBook);
            if (success) {
                response.sendRedirect("View_books.jsp?message=Book updated successfully");
            } else {
                request.setAttribute("error", "Failed to update book.");
                request.getRequestDispatcher("EditBook.jsp?id=" + id).forward(request, response);
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Error: " + e.getMessage());
            request.getRequestDispatcher("EditBook.jsp?id=" + idStr).forward(request, response);
        }
    }
}