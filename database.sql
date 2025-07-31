CREATE DATABASE book_shop_db;
USE book_shop_db;

CREATE TABLE customers (
    account_number INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(150) UNIQUE,
    address VARCHAR(255),
    telephone VARCHAR(15) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    profile_image VARCHAR(255),
    gender ENUM('male', 'female', 'other'),
    dob DATE,
    membership_type ENUM('regular', 'premium', 'vip') DEFAULT 'regular',
    login_status VARCHAR(10) DEFAULT 'offline',
    registered_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);



USE book_shop_db;
CREATE TABLE books (
    id INT PRIMARY KEY AUTO_INCREMENT,
    image VARCHAR(255),
    name VARCHAR(150) NOT NULL,
    category VARCHAR(50),
    author VARCHAR(100),
    description TEXT,
    price DOUBLE,
    discount DOUBLE,
    offers VARCHAR(100),
    stock_quantity INT,
    upload_date_time DATETIME
);

USE book_shop_db;
CREATE TABLE book_images (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    image_path VARCHAR(255) NOT NULL,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);

CREATE TABLE books (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100),
    author VARCHAR(100),
    description TEXT,
    price DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) DEFAULT 0.00,
    offers VARCHAR(255),
    stock_quantity INT DEFAULT 0,
    upload_datetime DATETIME DEFAULT CURRENT_TIMESTAMP
);


USE book_shop_db;

CREATE TABLE buy_requests (
    id INT AUTO_INCREMENT PRIMARY KEY,
    book_id INT NOT NULL,
    account_number INT NOT NULL, -- refers to customer
    quantity INT DEFAULT 1,
    request_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status VARCHAR(20) DEFAULT 'Pending', -- Pending, Approved, Rejected

    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE,
    FOREIGN KEY (account_number) REFERENCES customers(account_number) ON DELETE CASCADE
);

USE book_shop_db;
CREATE TABLE accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    fullname VARCHAR(100),
    id_number VARCHAR(50) UNIQUE,
    dob DATE,
    address TEXT,
    password VARCHAR(255),
    role ENUM('admin', 'user', 'store_keeper', 'cashier') NOT NULL
);

USE book_shop_db;
CREATE TABLE bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DOUBLE NOT NULL,
    billing_timestamp DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(account_number)
);

CREATE TABLE bill_items (
    item_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    book_id INT NOT NULL,
    book_name VARCHAR(255),
    price DOUBLE,
    discount DOUBLE,
    quantity INT,
    total DOUBLE,
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id)
);
USE book_shop_db;
ALTER TABLE bills
ADD COLUMN payment_method VARCHAR(50),
ADD COLUMN amount_given DECIMAL(10,2),
ADD COLUMN change_due DECIMAL(10,2);
USE book_shop_db;
USE book_shop_db;

CREATE TABLE cart_items (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    book_id INT NOT NULL,
    book_name VARCHAR(255),
    price DECIMAL(10, 2),
    discount DECIMAL(10, 2) DEFAULT 0.00,
    quantity INT NOT NULL,
    total DECIMAL(10, 2),
    added_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    
    FOREIGN KEY (customer_id) REFERENCES customers(account_number) ON DELETE CASCADE,
    FOREIGN KEY (book_id) REFERENCES books(id) ON DELETE CASCADE
);bills

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    customer_id INT NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    payment_method ENUM('Cash', 'Card', 'Online') NOT NULL,
    amount_given DECIMAL(10,2),
    change_due DECIMAL(10,2),
    payment_status VARCHAR(20) DEFAULT 'Paid',
    payment_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id),
    FOREIGN KEY (customer_id) REFERENCES customers(account_number)
);
USE book_shop_db;
CREATE TABLE bills (
    bill_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    total_amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(50) NOT NULL,
    amount_given DECIMAL(10,2) NOT NULL,
    change_due DECIMAL(10,2) NOT NULL,
    shipping_address TEXT,
    billing_timestamp TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(account_number)
);
CREATE TABLE bill_items (
    bill_item_id INT AUTO_INCREMENT PRIMARY KEY,
    bill_id INT NOT NULL,
    book_id INT NOT NULL,
    book_name VARCHAR(255),
    price DECIMAL(10,2),
    quantity INT,
    discount DECIMAL(10,2) DEFAULT 0,
    FOREIGN KEY (bill_id) REFERENCES bills(bill_id)
);





