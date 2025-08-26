package com.bookshop.dao;

import com.bookshop.model.Book;
import com.bookshop.model.Supplier;
import com.bookshop.util.DBConnection;

import java.sql.*;
import java.time.LocalDate;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;


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
    public boolean updateBookStockAndDiscount(int bookId, int stock, double discount) {
        String sql = "UPDATE books SET stock_quantity = ?, discount = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, stock);
            stmt.setDouble(2, discount);
            stmt.setInt(3, bookId);
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public int getOutOfStockCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM books WHERE stock_quantity = 0";
        try (Connection conn = DBConnection.getConnection();  // Get connection first
             Statement st = conn.createStatement()) {
            ResultSet rs = st.executeQuery(sql);
            if (rs.next()) count = rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return count;
    }
 // BookDAO.java
    public List<Book> getOutOfStockBooks() {
        List<Book> outOfStockBooks = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE stock_quantity = 0 ORDER BY upload_date_time DESC";

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

                // Fetch all images for this book
                book.setImages(getBookImages(bookId));

                outOfStockBooks.add(book);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return outOfStockBooks;
    }

    public Map<Integer, List<Supplier>> getSuppliersForBooks(List<Integer> bookIds) {
        Map<Integer, List<Supplier>> map = new HashMap<>();
        if (bookIds == null || bookIds.isEmpty()) return map;

        StringBuilder sql = new StringBuilder(
            "SELECT bsm.book_id, s.supplier_id, s.name, s.email, s.phone, s.address " +
            "FROM book_supplier_map bsm " +
            "JOIN suppliers s ON bsm.supplier_id = s.supplier_id " +
            "WHERE bsm.book_id IN ("
        );

        for (int i = 0; i < bookIds.size(); i++) {
            sql.append("?");
            if (i < bookIds.size() - 1) sql.append(",");
        }
        sql.append(")");

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql.toString())) {

            for (int i = 0; i < bookIds.size(); i++) {
                ps.setInt(i + 1, bookIds.get(i));
            }

            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                int bookId = rs.getInt("book_id");
                Supplier s = new Supplier();
                s.setSupplierId(rs.getInt("supplier_id"));
                s.setName(rs.getString("name"));
                s.setEmail(rs.getString("email"));
                s.setPhone(rs.getString("phone"));
                s.setAddress(rs.getString("address"));

                map.computeIfAbsent(bookId, k -> new ArrayList<>()).add(s);
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
        return map;
    }
    public int getTotalStock() {
        int totalStock = 0;
        String sql = "SELECT SUM(stock_quantity) FROM books";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                totalStock = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return totalStock;
    }
    public List<Map<String, Object>> getStockBalancingReport() {
        List<Map<String, Object>> report = new ArrayList<>();
        String sql = "SELECT book_id, book_name, category, stock_quantity, min_stock, max_stock, " +
                     "(stock_quantity * price) AS stock_value FROM books ORDER BY book_name";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Map<String, Object> data = new HashMap<>();
                data.put("book_id", rs.getInt("book_id"));
                data.put("book_name", rs.getString("book_name"));
                data.put("category", rs.getString("category"));
                data.put("closing_stock", rs.getInt("stock_quantity"));
                data.put("min_stock", rs.getInt("min_stock"));
                data.put("max_stock", rs.getInt("max_stock"));
                data.put("stock_value", rs.getDouble("stock_value"));

                // Stock status
                String status = "OK";
                if (rs.getInt("stock_quantity") <= rs.getInt("min_stock")) {
                    status = "Low Stock";
                } else if (rs.getInt("stock_quantity") > rs.getInt("max_stock")) {
                    status = "Over Stock";
                }
                data.put("status", status);

                report.add(data);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return report;
    }
    public int getLowStockCount() {
        int count = 0;
        String sql = "SELECT COUNT(*) FROM books WHERE stock_quantity <= min_stock";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                count = rs.getInt(1);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return count;
    }
    public List<Map<String, Object>> getDailyStockBalancing() throws SQLException {
        String sql =
            "SELECT t.date, " +
            "SUM(t.stock_in) AS stock_in, " +
            "SUM(t.stock_out) AS stock_out " +
            "FROM ( " +
            "  SELECT DATE(supply_date) AS date, SUM(supply_qty) AS stock_in, 0 AS stock_out " +
            "  FROM book_supplier_map " +
            "  GROUP BY DATE(supply_date) " +
            "  UNION ALL " +
            "  SELECT DATE(b.billing_timestamp) AS date, 0 AS stock_in, SUM(bi.quantity) AS stock_out " +
            "  FROM bill_items bi " +
            "  JOIN bills b ON bi.bill_id = b.bill_id " +
            "  GROUP BY DATE(b.billing_timestamp) " +
            ") t " +
            "GROUP BY t.date " +
            "ORDER BY t.date ASC";

        List<Map<String, Object>> list = new ArrayList<>();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("date", rs.getDate("date"));
                row.put("stock_in", rs.getInt("stock_in"));
                row.put("stock_out", rs.getInt("stock_out"));
                list.add(row);
            }
        }
        return list;
    }
    public double getDailyProfitForDate(LocalDate date) throws SQLException {
        String sql = "SELECT SUM((bi.price - bi.discount) * bi.quantity) - " +
                     "SUM(latest_supply.supply_price * bi.quantity) AS daily_profit " +
                     "FROM bills b " +
                     "JOIN bill_items bi ON b.bill_id = bi.bill_id " +
                     "LEFT JOIN ( " +
                     "   SELECT book_id, MAX(supply_date) AS latest_date " +
                     "   FROM book_supplier_map GROUP BY book_id " +
                     ") last_supply ON bi.book_id = last_supply.book_id " +
                     "LEFT JOIN book_supplier_map latest_supply " +
                     "   ON bi.book_id = latest_supply.book_id " +
                     "   AND latest_supply.supply_date = last_supply.latest_date " +
                     "WHERE DATE(b.billing_timestamp) = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setDate(1, java.sql.Date.valueOf(date));
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getDouble("daily_profit");
                }
            }
        }
        return 0.0;
    }
    public double getTotalProfit() throws SQLException {
        String sql = "SELECT " +
                     "SUM((bi.price - bi.discount) * bi.quantity) - " +
                     "SUM(latest_supply.supply_price * bi.quantity) AS total_profit " +
                     "FROM bills b " +
                     "JOIN bill_items bi ON b.bill_id = bi.bill_id " +
                     "LEFT JOIN ( " +
                     "   SELECT book_id, MAX(supply_date) AS latest_date " +
                     "   FROM book_supplier_map " +
                     "   GROUP BY book_id " +
                     ") last_supply ON bi.book_id = last_supply.book_id " +
                     "LEFT JOIN book_supplier_map latest_supply " +
                     "   ON bi.book_id = latest_supply.book_id " +
                     "   AND latest_supply.supply_date = last_supply.latest_date";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getDouble("total_profit");
            }
        }
        return 0.0;
    }
    public List<Book> searchBooks(String keyword) {
        List<Book> books = new ArrayList<>();
        String sql = "SELECT * FROM books WHERE id LIKE ? OR name LIKE ? OR author LIKE ? OR category LIKE ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            String pattern = "%" + keyword + "%";
            ps.setString(1, pattern);
            ps.setString(2, pattern);
            ps.setString(3, pattern);
            ps.setString(4, pattern);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Book book = new Book();
                    int bookId = rs.getInt("id");

                    book.setId(bookId);
                    book.setName(rs.getString("name"));
                    book.setAuthor(rs.getString("author"));
                    book.setCategory(rs.getString("category"));
                    book.setDescription(rs.getString("description"));
                    book.setPrice(rs.getDouble("price"));
                    book.setDiscount(rs.getDouble("discount"));
                    book.setOffers(rs.getString("offers"));
                    book.setStockQuantity(rs.getInt("stock_quantity"));
                    book.setUploadDateTime(rs.getTimestamp("upload_date_time").toLocalDateTime());

                    // Load images
                    book.setImages(getBookImages(bookId));

                    books.add(book);
                }
            }

        } catch (Exception e) {
            e.printStackTrace();
        }

        return books;
    }


}


