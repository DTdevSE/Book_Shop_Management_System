package com.bookshop.model;

import java.sql.Date;
import java.sql.Timestamp;  // Import for timestamp

public class Customer {
    private int accountNumber;
    private String name;
    private String email;
    private String address;
    private String telephone;
    private String password;
    private String profileImage;
    private String gender;
    private Date dob;
    private String membershipType;
    private String loginStatus;
    private Timestamp registeredTime;  // New field

    // Constructors
    public Customer() {}

    public Customer(int accountNumber, String name, String email, String address, String telephone, String password,
                    String profileImage, String gender, Date dob, String membershipType, String loginStatus,
                    Timestamp registeredTime) {  // Add new param
        this.accountNumber = accountNumber;
        this.name = name;
        this.email = email;
        this.address = address;
        this.telephone = telephone;
        this.password = password;
        this.profileImage = profileImage;
        this.gender = gender;
        this.dob = dob;
        this.membershipType = membershipType;
        this.loginStatus = loginStatus;
        this.registeredTime = registeredTime;
    }

    // Getters and Setters
    public int getAccountNumber() {
        return accountNumber;
    }
    public void setAccountNumber(int accountNumber) {
        this.accountNumber = accountNumber;
    }
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
    public String getEmail() {
        return email;
    }
    public void setEmail(String email) {
        this.email = email;
    }
    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }
    public String getTelephone() {
        return telephone;
    }
    public void setTelephone(String telephone) {
        this.telephone = telephone;
    }
    public String getPassword() {
        return password;
    }
    public void setPassword(String password) {
        this.password = password;
    }
    public String getProfileImage() {
        return profileImage;
    }
    public void setProfileImage(String profileImage) {
        this.profileImage = profileImage;
    }
    public String getGender() {
        return gender;
    }
    public void setGender(String gender) {
        this.gender = gender;
    }
    public Date getDob() {
        return dob;
    }
    public void setDob(Date dob) {
        this.dob = dob;
    }
    public String getMembershipType() {
        return membershipType;
    }
    public void setMembershipType(String membershipType) {
        this.membershipType = membershipType;
    }
    public String getLoginStatus() {
        return loginStatus;
    }
    public void setLoginStatus(String loginStatus) {
        this.loginStatus = loginStatus;
    }

    public Timestamp getRegisteredTime() {
        return registeredTime;
    }
    public void setRegisteredTime(Timestamp registeredTime) {
        this.registeredTime = registeredTime;
    }
}
