package com.bookshop.model;

import java.time.LocalDateTime;
import java.sql.Date;

public class Account {
    private int id;
    private String fullname;
    private String idNumber;
    private String password;
    private String role;
    private Date dob;
    private String address;
    private String profileImage;
    private LocalDateTime createdAt;
    private LocalDateTime lastUpdated;

    public Account() {}

    public Account(int id, String fullname, String idNumber, String password, String role,
                   Date dob, String address, String profileImage,
                   LocalDateTime createdAt, LocalDateTime lastUpdated) {
        this.id = id;
        this.fullname = fullname;
        this.idNumber = idNumber;
        this.password = password;
        this.role = role;
        this.dob = dob;
        this.address = address;
        this.profileImage = profileImage;
        this.createdAt = createdAt;
        this.lastUpdated = lastUpdated;
    }

    // Getters and Setters

    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public String getFullname() { return fullname; }
    public void setFullname(String fullname) { this.fullname = fullname; }

    public String getIdNumber() { return idNumber; }
    public void setIdNumber(String idNumber) { this.idNumber = idNumber; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }

    public Date getDob() { return dob; }
    public void setDob(Date dob) { this.dob = dob; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getProfileImage() { return profileImage; }
    public void setProfileImage(String profileImage) { this.profileImage = profileImage; }

    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }

    public LocalDateTime getLastUpdated() { return lastUpdated; }
    public void setLastUpdated(LocalDateTime lastUpdated) { this.lastUpdated = lastUpdated; }
}
