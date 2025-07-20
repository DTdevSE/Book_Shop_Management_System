package com.bookshop.Services.Admin;

import com.bookshop.dao.BookDAO;
import com.bookshop.model.Book;

import javax.servlet.*;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

@WebServlet("/AddBookServlet")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,        // 1 MB
    maxFileSize = 5 * 1024 * 1024,          // 5 MB per file
    maxRequestSize = 25 * 1024 * 1024       // 25 MB for whole request
)
public class AddBookServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;
    private static final int MAX_IMAGE_COUNT = 5;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Setup upload folder
        String uploadDir = getServletContext().getRealPath("/uploads");
        File fileUpload = new File(uploadDir);
        if (!fileUpload.exists()) fileUpload.mkdirs();

        List<String> imagePaths = new ArrayList<>();
        int imageCount = 0;

        try {
            // Get all uploaded image parts
            for (Part part : request.getParts()) {
                if (part.getName().equals("images") && part.getSize() > 0) {
                    if (imageCount >= MAX_IMAGE_COUNT) {
                        request.setAttribute("error", "Only up to 5 images are allowed.");
                        request.getRequestDispatcher("AddBooks.jsp").forward(request, response);
                        return;
                    }

                    String fileName = UUID.randomUUID() + "_" + part.getSubmittedFileName();
                    String fullPath = uploadDir + File.separator + fileName;
                    part.write(fullPath);

                    // Save relative path
                    imagePaths.add("uploads/" + fileName);
                    imageCount++;
                }
            }

            // Debug print
            System.out.println("Uploaded image count: " + imagePaths.size());
            for (String img : imagePaths) System.out.println("Saved image: " + img);

            // Create Book object from form
            Book book = new Book();
            book.setName(request.getParameter("name"));
            book.setCategory(request.getParameter("category"));
            book.setAuthor(request.getParameter("author"));
            book.setDescription(request.getParameter("description"));
            book.setPrice(Double.parseDouble(request.getParameter("price")));
            book.setDiscount(Double.parseDouble(request.getParameter("discount")));
            book.setOffers(request.getParameter("offers"));
            book.setStockQuantity(Integer.parseInt(request.getParameter("stockQuantity")));
            book.setUploadDateTime(LocalDateTime.now());
            book.setImages(imagePaths);

            // Save to database
            BookDAO dao = new BookDAO();
            int newBookId = dao.addBook(book);

            if (newBookId > 0) {
                System.out.println("Book inserted with ID: " + newBookId);
                response.sendRedirect("View_books.jsp?msg=success");
            } else {
                throw new Exception("Book insert failed (bookId=0)");
            }

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("error", "Book upload failed: " + e.getMessage());
            request.getRequestDispatcher("AddBooks.jsp").forward(request, response);
        }
    }
}
