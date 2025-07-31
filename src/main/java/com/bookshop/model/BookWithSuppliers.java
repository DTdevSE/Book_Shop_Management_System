package com.bookshop.model;




import java.util.List;

public class BookWithSuppliers {
    private Book book;
    private List<Supplier> suppliers;

    public BookWithSuppliers(Book book, List<Supplier> suppliers) {
        this.book = book;
        this.suppliers = suppliers;
    }

    public Book getBook() { return book; }
    public void setBook(Book book) { this.book = book; }

    public List<Supplier> getSuppliers() { return suppliers; }
    public void setSuppliers(List<Supplier> suppliers) { this.suppliers = suppliers; }
}
