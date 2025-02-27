-- Create Database
CREATE DATABASE UnoxMultiplexDB;
USE UnoxMultiplexDB;

-- Users Table
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    phone VARCHAR(15) UNIQUE NOT NULL,
    membership_status ENUM('Regular', 'Member') DEFAULT 'Regular',
    points_earned INT DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Movies Table
CREATE TABLE Movies (
    movie_id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    genre VARCHAR(100) NOT NULL,
    rating DECIMAL(2,1),
    status ENUM('Now Showing', 'Upcoming') NOT NULL,
    poster_image VARCHAR(255),
    star_cast TEXT,
    release_date DATE
);

-- Screens Table
CREATE TABLE Screens (
    screen_id INT AUTO_INCREMENT PRIMARY KEY,
    screen_name ENUM('A', 'B', 'C', 'D') NOT NULL,
    class ENUM('Gold', 'Silver', 'Iron') NOT NULL,
    capacity INT NOT NULL
);

-- Shows Table
CREATE TABLE Shows (
    show_id INT AUTO_INCREMENT PRIMARY KEY,
    movie_id INT,
    screen_id INT,
    show_time ENUM('10:00 AM', '1:30 PM', '5:00 PM', '8:30 PM') NOT NULL,
    show_date DATE NOT NULL,
    FOREIGN KEY (movie_id) REFERENCES Movies(movie_id) ON DELETE CASCADE,
    FOREIGN KEY (screen_id) REFERENCES Screens(screen_id) ON DELETE CASCADE
);

-- Bookings Table
CREATE TABLE Bookings (
    booking_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT,
    show_id INT,
    num_seats INT NOT NULL,
    total_cost DECIMAL(10,2) NOT NULL,
    payment_status ENUM('Pending', 'Completed', 'Failed') DEFAULT 'Pending',
    booking_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (show_id) REFERENCES Shows(show_id) ON DELETE CASCADE
);

-- Payments Table
CREATE TABLE Payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    payment_method ENUM('PayPal', 'BillDesk', 'Verizon') NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status ENUM('Success', 'Failed') NOT NULL,
    transaction_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE
);

-- QR Codes Table
CREATE TABLE QRCodes (
    qr_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    generated_time DATETIME DEFAULT CURRENT_TIMESTAMP,
    scanned_status ENUM('Not Scanned', 'Scanned') DEFAULT 'Not Scanned',
    download_source ENUM('App', 'WhatsApp') DEFAULT NULL,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE
);

-- Food Orders Table
CREATE TABLE FoodOrders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    booking_id INT,
    item_details TEXT NOT NULL,
    quantity INT NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    delivery_option ENUM('Collect at Counter', 'Deliver to Seat') NOT NULL,
    order_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id) ON DELETE CASCADE
);

-- Membership Table
CREATE TABLE Memberships (
    user_id INT PRIMARY KEY,
    points_earned INT DEFAULT 0,
    points_redeemed INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Indexing for Performance
CREATE INDEX idx_show_time ON Shows(show_time);
CREATE INDEX idx_show_date ON Shows(show_date);
CREATE INDEX idx_booking_date ON Bookings(booking_date);
CREATE INDEX idx_payment_status ON Payments(status);
CREATE INDEX idx_qr_scanned ON QRCodes(scanned_status);
CREATE INDEX idx_order_time ON FoodOrders(order_time);
