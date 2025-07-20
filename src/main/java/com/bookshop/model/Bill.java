package com.bookshop.model;

import java.util.Date;

public class Bill {
    private int billId;
    private int customerId;
    private double totalAmount;
    private Date billingTimestamp;

    // Getters and Setters
    public int getBillId() {
        return billId;
    }

    public void setBillId(int billId) {
        this.billId = billId;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int customerId) {
        this.customerId = customerId;
    }

    public double getTotalAmount() {
        return totalAmount;
    }

    public void setTotalAmount(double totalAmount) {
        this.totalAmount = totalAmount;
    }

    public Date getBillingTimestamp() {
        return billingTimestamp;
    }

    public void setBillingTimestamp(Date billingTimestamp) {
        this.billingTimestamp = billingTimestamp;
    }
}
