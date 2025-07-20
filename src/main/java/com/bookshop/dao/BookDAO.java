package com.bookshop.dao;

import com.bookshop.model.Book;
import com.bookshop.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookDAO {

    // Add a new book and insert its images
    public int addBook(Book book) {
        String sql = "INSERT INTO books (name, category, author, description, price, discount, offers, stock_quantity, upload_date_time) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int bookId = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {

            ps.setString(1, book.getName());
            ps.setString(2, book.getCategory());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getDescription());
            ps.setDouble(5, book.getPrice());
            ps.setDouble(6, book.getDiscount());
            ps.setString(7, book.getOffers());
            ps.setInt(8, book.getStockQuantity());
            ps.setTimestamp(9, Timestamp.valueOf(book.getUploadDateTime()));

            int rows = ps.executeUpdate();

            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        bookId = rs.getInt(1);
                        insertBookImages(bookId, book.getImages());
                    }
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return bookId;
    }

    public void insertBookImages(int bookId, List<String> imagePaths) {
        if (imagePaths == null || imagePaths.isEmpty()) return;

        String sql = "INSERT INTO book_images (book_id, image_path) VALUES (?, ?)";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (String path : imagePaths) {
                ps.setInt(1, bookId);
                ps.setString(2, path);
                ps.addBatch();
            }
            ps.executeBatch();

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void deleteBookImages(int bookId) {
        String sql = "DELETE FROM book_images WHERE book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookId);
            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public boolean updateBookInfo(Book book) {
        String sql = "UPDATE books SET name=?, category=?, author=?, description=?, price=?, discount=?, offers=?, stock_quantity=?, upload_date_time=? WHERE id=?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, book.getName());
            ps.setString(2, book.getCategory());
            ps.setString(3, book.getAuthor());
            ps.setString(4, book.getDescription());
            ps.setDouble(5, book.getPrice());
            ps.setDouble(6, book.getDiscount());
            ps.setString(7, book.getOffers());
            ps.setInt(8, book.getStockQuantity());
            ps.setTimestamp(9, Timestamp.valueOf(book.getUploadDateTime()));
            ps.setInt(10, book.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBookImages(int bookId, List<String> newImages) {
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            deleteBookImages(bookId);
            insertBookImages(bookId, newImages);
            conn.commit();
            return true;
        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBook(Book book) {
        boolean infoUpdated = updateBookInfo(book);
        boolean imagesUpdated = updateBookImages(book.getId(), book.getImages());
        return infoUpdated && imagesUpdated;
    }

    public Book getBookById(int id) {
        Book book = null;
        String sql = "SELECT * FROM books WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    book = new Book();
                    book.setId(rs.getInt("id"));
                    book.setName(rs.getString("name"));
                    book.setCategory(rs.getString("category"));
                    book.setAuthor(rs.getString("author"));
                    book.setDescription(rs.getString("description"));
                    book.setPrice(rs.getDouble("price"));
                    book.setDiscount(rs.getDouble("discount"));
                    book.setOffers(rs.getString("offers"));
                    book.setStockQuantity(rs.getInt("stock_quantity"));
                    book.setUploadDateTime(rs.getTimestamp("upload_date_time").toLocalDateTime());
                    book.setImages(getBookImages(id));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return book;
    }

    public List<Book> getAllBooks() {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books ORDER BY upload_date_time DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Book book = new Book();
                int bookId = rs.getInt("id");

                book.setId(bookId);
                book.setName(rs.getString("name"));
                book.setCategory(rs.getString("category"));
                book.setAuthor(rs.getString("author"));
                book.setDescription(rs.getString("description"));
                book.setPrice(rs.getDouble("price"));
                book.setDiscount(rs.getDouble("discount"));
                book.setOffers(rs.getString("offers"));
                book.setStockQuantity(rs.getInt("stock_quantity"));
                book.setUploadDateTime(rs.getTimestamp("upload_date_time").toLocalDateTime());
                book.setImages(getBookImages(bookId));

                books.add(book);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }

    public List<String> getBookImages(int bookId) {
        List<String> images = new ArrayList<>();
        String sql = "SELECT image_path FROM book_images WHERE book_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, bookId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    images.add(rs.getString("image_path"));
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return images;
    }

    public boolean deleteBook(int bookId) {
        boolean deleted = false;

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try {
                deleteBookImages(bookId);

                String sql = "DELETE FROM books WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(sql)) {
                    ps.setInt(1, bookId);
                    int rows = ps.executeUpdate();
                    deleted = rows > 0;
                }

                conn.commit();
            } catch (Exception e) {
                conn.rollback();
                e.printStackTrace();
            } finally {
                conn.setAutoCommit(true);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return deleted;
    }

    public List<Book> getBooksByCategory(String category) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE category = ? ORDER BY upload_date_time DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, category);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book book = new Book();
                    int bookId = rs.getInt("id");

                    book.setId(bookId);
                    book.setName(rs.getString("name"));
                    book.setCategory(rs.getString("category"));
                    book.setAuthor(rs.getString("author"));
                    book.setDescription(rs.getString("description"));
                    book.setPrice(rs.getDouble("price"));
                    book.setDiscount(rs.getDouble("discount"));
                    book.setOffers(rs.getString("offers"));
                    book.setStockQuantity(rs.getInt("stock_quantity"));
                    book.setUploadDateTime(rs.getTimestamp("upload_date_time").toLocalDateTime());
                    book.setImages(getBookImages(bookId));

                    books.add(book);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }
    public List<Book> getAvailableBooks() {
        List<Book> books = new ArrayList<>();
        final String sql = "SELECT * FROM books WHERE stock_quantity > 0 ORDER BY upload_date_time DESC";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Book book = new Book();
                int bookId = rs.getInt("id");

                book.setId(bookId);
                book.setName(rs.getString("name"));
                book.setCategory(rs.getString("category"));
                book.setAuthor(rs.getString("author"));
                book.setDescription(rs.getString("description"));
                book.setPrice(rs.getDouble("price"));
                book.setDiscount(rs.getDouble("discount"));
                book.setOffers(rs.getString("offers"));
                book.setStockQuantity(rs.getInt("stock_quantity"));
                book.setUploadDateTime(rs.getTimestamp("upload_date_time").toLocalDateTime());

                // Load associated images
                List<String> images = getBookImages(bookId);
                book.setImages(images);

                books.add(book);
            }

        } catch (Exception e) {
            System.err.println("Error fetching available books: " + e.getMessage());
            e.printStackTrace();
        }

        return books;
    }

    public boolean reduceStock(int bookId, int quantity) {
        String sql = "UPDATE books SET stock_quantity = stock_quantity - ? WHERE id = ? AND stock_quantity >= ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, quantity);
            ps.setInt(2, bookId);
            ps.setInt(3, quantity);

            int rowsAffected = ps.executeUpdate();
            return rowsAffected > 0; // True = stock updated

        } catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }
    
}
