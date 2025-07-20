package com.bookshop.model;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class Book {
    private int id;
    private List<String> images = new ArrayList<>(); // ✅ Support for multiple images
    private String name;
    private String category;
    private String author;
    private String description;
    private double price;
    private double discount;
    private String offers;
    private int stockQuantity;
    private LocalDateTime uploadDateTime;

    public Book() {}

    public Book(int id, List<String> images, String name, String category, String author, String description,
                double price, double discount, String offers, int stockQuantity, LocalDateTime uploadDateTime) {
        this.id = id;
        this.images = images;
        this.name = name;
        this.category = category;
        this.author = author;
        this.description = description;
        this.price = price;
        this.discount = discount;
        this.offers = offers;
        this.stockQuantity = stockQuantity;
        this.uploadDateTime = uploadDateTime;
    }

    // Getters and setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public List<String> getImages() { return images; }
    public void setImages(List<String> images) { this.images = images; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    public String getAuthor() { return author; }
    public void setAuthor(String author) { this.author = author; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public double getDiscount() { return discount; }
    public void setDiscount(double discount) { this.discount = discount; }

    public String getOffers() { return offers; }
    public void setOffers(String offers) { this.offers = offers; }

    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }

    public LocalDateTime getUploadDateTime() { return uploadDateTime; }
    public void setUploadDateTime(LocalDateTime uploadDateTime) { this.uploadDateTime = uploadDateTime; }

    @Override
    public String toString() {
        return "Book{" +
                "id=" + id +
                ", images=" + images +
                ", name='" + name + '\'' +
                ", category='" + category + '\'' +
                ", author='" + author + '\'' +
                ", description='" + description + '\'' +
                ", price=" + price +
                ", discount=" + discount +
                ", offers='" + offers + '\'' +
                ", stockQuantity=" + stockQuantity +
                ", uploadDateTime=" + uploadDateTime +
                '}';
    }
}
