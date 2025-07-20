package com.bookshop.model;

import java.math.BigDecimal;
import java.sql.Timestamp;

public class Payment {

    private int id;
    private int requestId;
    private String buyerName;
    private int quantity;
    private BigDecimal pricePerUnit;
    private BigDecimal discount;
    private BigDecimal totalAmount;
    private Timestamp paymentTime;
    private String status;
    private String slipPath;

    // No-arg constructor
    public Payment() {
    }

    // Full constructor
    public Payment(int id, int requestId, String buyerName, int quantity, BigDecimal pricePerUnit,
                   BigDecimal discount, BigDecimal totalAmount, Timestamp paymentTime,
                   String status, String slipPath) {
        this.id = id;
        this.requestId = requestId;
        this.buyerName = buyerName;
        this.quantity = quantity;
        this.pricePerUnit = pricePerUnit;
        this.discount = discount;
        this.totalAmount = totalAmount;
        this.paymentTime = paymentTime;
        this.status = status;
        this.slipPath = slipPath;
    }

    // Getters and Setters for all fields

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getRequestId() {
        return requestId;
    }

    public void setRequestId(int requestId) {
        this.requestId = requestId;
    }

    public String getBuyerName() {
        return buyerName;
    }

    public void setBuyerName(String buyerName) {
        this.buyerName = buyerName;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public BigDecimal getPricePerUnit() {
        return pricePerUnit;
    }

    public void setPricePerUnit(BigDecimal pricePerUnit) {
        this.pricePerUnit = pricePerUnit;
    }

    public BigDecimal getDiscount() {
        return discount;
    }

    public void setDiscount(BigDecimal discount) {
        this.discount = discount;
    }

    public BigDecimal getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(BigDecimal totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Timestamp getPaymentTime() {
        return paymentTime;
    }

    public void setPaymentTime(Timestamp paymentTime) {
        this.paymentTime = paymentTime;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public String getSlipPath() {
        return slipPath;
    }

    public void setSlipPath(String slipPath) {
        this.slipPath = slipPath;
    }
}
