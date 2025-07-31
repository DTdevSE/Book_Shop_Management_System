package com.bookshop.model;

import java.util.Date;

public class Bill {
    private int billId;
    private int customerId;
    private double totalAmount;
    private String paymentMethod;
    private double amountGiven;
    private double changeDue;
    private String shippingAddress;
    private Date billingTimestamp;

    // Getters and Setters
    public int getBillId() { return billId; }
    public void setBillId(int billId) { this.billId = billId; }

    public int getCustomerId() { return customerId; }
    public void setCustomerId(int customerId) { this.customerId = customerId; }

    public double getTotalAmount() { return totalAmount; }
    public void setTotalAmount(double totalAmount) { this.totalAmount = totalAmount; }

    public String getPaymentMethod() { return paymentMethod; }
    public void setPaymentMethod(String paymentMethod) { this.paymentMethod = paymentMethod; }

    public double getAmountGiven() { return amountGiven; }
    public void setAmountGiven(double amountGiven) { this.amountGiven = amountGiven; }

    public double getChangeDue() { return changeDue; }
    public void setChangeDue(double changeDue) { this.changeDue = changeDue; }

    public String getShippingAddress() { return shippingAddress; }
    public void setShippingAddress(String shippingAddress) { this.shippingAddress = shippingAddress; }

    public Date getBillingTimestamp() { return billingTimestamp; }
    public void setBillingTimestamp(Date billingTimestamp) { this.billingTimestamp = billingTimestamp; }
}
