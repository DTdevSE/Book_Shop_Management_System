-- Create a new database
CREATE DATABASE sample_crud;

-- Use the newly created database
USE sample_crud;

-- Create a table named 'user' with 3 columns
CREATE TABLE user (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(100) NOT NULL,
    email VARCHAR(255) NOT NULL
);

-- Insert sample data into the 'user' table
INSERT INTO user (username, email) VALUES
('john_doe', 'john@example.com'),
('jane_doe', 'jane@example.com'),
('alice_smith', 'alice@example.com');

-- Retrieve all data from the 'user' table
SELECT * FROM user;
