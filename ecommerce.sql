-- Create the Database

CREATE DATABASE ecommerce;
USE ecommerce;

-- Create Customers Table
CREATE TABLE customers (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    address VARCHAR(255) NOT NULL
);

-- Create Orders Table
CREATE TABLE orders (
    id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    total_amount DECIMAL(10, 2),
    FOREIGN KEY (customer_id) REFERENCES customers(id)
);

-- Create Products Table
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    description TEXT
);

-- Insert into Customers

INSERT INTO customers (name, email, address)
VALUES ('John Doe', 'john@example.com', '123 Main St'),
       ('Jane Smith', 'jane@example.com', '456 Oak St');

-- Insert into Products

INSERT INTO products (name, price, description)
VALUES ('Product A', 50.00, 'Description for Product A'),
       ('Product B', 75.00, 'Description for Product B'),
       ('Product C', 100.00, 'Description for Product C');

-- Insert into Orders

INSERT INTO orders (customer_id, order_date, total_amount)
VALUES (1, '2024-09-01', 200.00),
       (2, '2024-09-10', 150.00);


-- Retrieve customers who placed an order in the last 30 days

SELECT DISTINCT c.name 
FROM customers c
JOIN orders o ON c.id = o.customer_id
WHERE o.order_date >= NOW() - INTERVAL 30 DAY;


-- Get total amount of all orders placed by each customer

SELECT c.name, SUM(o.total_amount) AS total_spent
FROM customers c
JOIN orders o ON c.id = o.customer_id
GROUP BY c.name;


-- Update price of Product C

UPDATE products
SET price = 45.00
WHERE name = 'Product C';


-- Add a new column discount to products table

ALTER TABLE products
ADD COLUMN discount DECIMAL(5, 2) DEFAULT 0.00;


-- Retrieve top 3 products with the highest price

SELECT name, price
FROM products
ORDER BY price DESC
LIMIT 3;


-- Get names of customers who ordered Product A

SELECT DISTINCT c.name 
FROM customers c
JOIN orders o ON c.id = o.customer_id
JOIN order_items oi ON o.id = oi.order_id
JOIN products p ON oi.product_id = p.id
WHERE p.name = 'Product A';


-- Join orders and customers to retrieve customer name and order date

SELECT c.name, o.order_date
FROM customers c
JOIN orders o ON c.id = o.customer_id;


-- Retrieve orders with a total amount greater than 150.00

SELECT * 
FROM orders
WHERE total_amount > 150.00;


-- Normalize database with an order_items table

CREATE TABLE order_items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT,
    product_id INT,
    quantity INT,
    price DECIMAL(10, 2),
    FOREIGN KEY (order_id) REFERENCES orders(id),
    FOREIGN KEY (product_id) REFERENCES products(id)
);


-- Retrieve average total of all orders

SELECT AVG(total_amount) AS average_total
FROM orders;
