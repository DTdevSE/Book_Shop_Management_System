package com.bookshop.model;


import java.util.Date;

public class BookSupplierMap {
    private int id;
    private int bookId;
    private int supplierId;
    private double supplyPrice;
    private int supplyQty;
    private Date supplyDate;

    public BookSupplierMap() {}

    public BookSupplierMap(int id, int bookId, int supplierId, double supplyPrice, int supplyQty, Date supplyDate) {
        this.id = id;
        this.bookId = bookId;
        this.supplierId = supplierId;
        this.supplyPrice = supplyPrice;
        this.supplyQty = supplyQty;
        this.supplyDate = supplyDate;
    }

    // Getters and setters for all fields

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getBookId() { return bookId; }
    public void setBookId(int bookId) { this.bookId = bookId; }

    public int getSupplierId() { return supplierId; }
    public void setSupplierId(int supplierId) { this.supplierId = supplierId; }

    public double getSupplyPrice() { return supplyPrice; }
    public void setSupplyPrice(double supplyPrice) { this.supplyPrice = supplyPrice; }

    public int getSupplyQty() { return supplyQty; }
    public void setSupplyQty(int supplyQty) { this.supplyQty = supplyQty; }

    public Date getSupplyDate() { return supplyDate; }
    public void setSupplyDate(Date supplyDate) { this.supplyDate = supplyDate; }
}
