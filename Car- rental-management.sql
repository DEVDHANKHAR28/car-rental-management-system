CREATE DATABASE  car_rental;
USE car_rental;
SHOW DATABASES;
SELECT DATABASE();

CREATE TABLE customers (
    customer_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    driving_license VARCHAR(30) UNIQUE
);
SHOW TABLES;

CREATE TABLE cars (
    car_id INT AUTO_INCREMENT PRIMARY KEY,
    car_name VARCHAR(100) NOT NULL,
    brand VARCHAR(50),
    model VARCHAR(50),
    registration_number VARCHAR(20) UNIQUE,
    rent_per_day DECIMAL(10,2) NOT NULL,
    availability VARCHAR(20) DEFAULT 'Available'
);

CREATE TABLE rentals (
    rental_id INT AUTO_INCREMENT PRIMARY KEY,
    customer_id INT NOT NULL,
    car_id INT NOT NULL,
    rental_date DATE NOT NULL,
    return_date DATE,
    total_amount DECIMAL(10,2),
    rental_status VARCHAR(20) DEFAULT 'Active',
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id),
    FOREIGN KEY (car_id) REFERENCES cars(car_id)
);
CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
);

CREATE TABLE payments (
    payment_id INT AUTO_INCREMENT PRIMARY KEY,
    rental_id INT NOT NULL,
    payment_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    payment_method VARCHAR(30),
    payment_status VARCHAR(20) DEFAULT 'Pending',
    FOREIGN KEY (rental_id) REFERENCES rentals(rental_id)
);
CREATE TABLE employees (
    employee_id INT AUTO_INCREMENT PRIMARY KEY,
    employee_name VARCHAR(100) NOT NULL,
    phone VARCHAR(15) UNIQUE,
    email VARCHAR(100) UNIQUE,
    designation VARCHAR(50),
    salary DECIMAL(10,2)
);
INSERT INTO customers
(customer_name, phone, email, driving_license)
VALUES
('Rahul Sharma', '9876543210', 'rahul@gmail.com', 'DL1001'),
('Priya Verma', '9876543211', 'priya@gmail.com', 'DL1002'),
('Amit Kumar', '9876543212', 'amit@gmail.com', 'DL1003'),
('Neha Singh', '9876543213', 'neha@gmail.com', 'DL1004'),
('Rohit Mehta', '9876543214', 'rohit@gmail.com', 'DL1005');

SELECT * FROM customers;

INSERT INTO cars
(car_name, brand, model, registration_number, rent_per_day, availability)
VALUES
('Swift', 'Maruti Suzuki', '2023', 'HR01AB1234', 1500, 'Available'),
('Creta', 'Hyundai', '2024', 'HR01AB1235', 2500, 'Available'),
('Thar', 'Mahindra', '2023', 'HR01AB1236', 3500, 'Available'),
('Nexon', 'Tata', '2024', 'HR01AB1237', 2000, 'Available'),
('Fortuner', 'Toyota', '2023', 'HR01AB1238', 5000, 'Available');

SELECT * FROM cars;

INSERT INTO rentals
(customer_id, car_id, rental_date, return_date, total_amount, rental_status)
VALUES
(1, 1, '2026-11-01', '2026-11-03', 3000, 'Completed'),
(2, 2, '2026-11-02', '2026-11-04', 5000, 'Completed'),
(3, 3, '2026-11-05', '2026-11-07', 7000, 'Completed'),
(4, 4, '2026-11-08', '2026-11-10', 4000, 'Active'),
(5, 5, '2026-11-09', '2026-11-12', 15000, 'Active');

SELECT * FROM rentals;

INSERT INTO payments
(rental_id, payment_date, amount, payment_method, payment_status)
VALUES
(1, '2026-11-03', 3000, 'UPI', 'Paid'),
(2, '2026-11-04', 5000, 'Card', 'Paid'),
(3, '2026-11-07', 7000, 'Cash', 'Paid'),
(4, '2026-11-10', 4000, 'UPI', 'Pending'),
(5, '2026-11-09', 15000, 'Card', 'Paid');

SELECT * FROM payments;

INSERT INTO employees
(employee_name, phone, email, designation, salary)
VALUES
('Aman Gupta', '9876500001', 'aman@gmail.com', 'Manager', 45000),
('Karan Singh', '9876500002', 'karan@gmail.com', 'Receptionist', 25000),
('Simran Kaur', '9876500003', 'simran@gmail.com', 'Accountant', 30000),
('Vikas Sharma', '9876500004', 'vikas@gmail.com', 'Car Supervisor', 28000),
('Anjali Verma', '9876500005', 'anjali@gmail.com', 'Customer Support', 22000);

SELECT * FROM employees;

SELECT * FROM cars
WHERE rent_per_day > 2000;

SELECT * FROM cars
WHERE availability = 'Available';

SELECT * FROM cars
ORDER BY rent_per_day DESC;

SELECT COUNT(*) AS total_cars
FROM cars;

SELECT AVG(rent_per_day) AS average_rent,
       MAX(rent_per_day) AS highest_rent,
       MIN(rent_per_day) AS lowest_rent
FROM cars;

SELECT customer_id, COUNT(*) AS total_rentals
FROM rentals
GROUP BY customer_id;

SELECT customer_id, COUNT(*) AS total_rentals
FROM rentals
GROUP BY customer_id
HAVING COUNT(*) >= 1;

SELECT
    customers.customer_name,
    cars.car_name,
    rentals.rental_date,
    rentals.return_date,
    rentals.total_amount
FROM rentals
INNER JOIN customers
ON rentals.customer_id = customers.customer_id
INNER JOIN cars
ON rentals.car_id = cars.car_id;

SELECT
    customers.customer_id,
    customers.customer_name,
    rentals.rental_id,
    rentals.total_amount
FROM customers
LEFT JOIN rentals
ON customers.customer_id = rentals.customer_id;

SELECT car_name, rent_per_day
FROM cars
WHERE rent_per_day > (
    SELECT AVG(rent_per_day)
    FROM cars
);

CREATE VIEW rental_details AS
SELECT
    customers.customer_name,
    cars.car_name,
    rentals.rental_date,
    rentals.return_date,
    rentals.total_amount,
    rentals.rental_status
FROM rentals
JOIN customers
ON rentals.customer_id = customers.customer_id
JOIN cars
ON rentals.car_id = cars.car_id;

SELECT * FROM rental_details;

UPDATE cars
SET rent_per_day = 1800
WHERE car_id = 1;

SELECT * FROM cars
WHERE car_id = 1;

DELETE FROM employees
WHERE employee_id = 5;

SELECT * FROM employees;

DELIMITER //

CREATE PROCEDURE GetAvailableCars()
BEGIN
    SELECT *
    FROM cars
    WHERE availability = 'Available';
END //

DELIMITER ;

CALL GetAvailableCars();

DELIMITER //

CREATE PROCEDURE CustomerRentalHistory(IN p_customer_id INT)
BEGIN
    SELECT
        customers.customer_name,
        cars.car_name,
        rentals.rental_date,
        rentals.return_date,
        rentals.total_amount,
        rentals.rental_status
    FROM rentals
    JOIN customers
    ON rentals.customer_id = customers.customer_id
    JOIN cars
    ON rentals.car_id = cars.car_id
    WHERE customers.customer_id = p_customer_id;
END //

DELIMITER ;

CALL CustomerRentalHistory(1);

DELIMITER //

CREATE TRIGGER UpdateCarAvailability
AFTER INSERT ON rentals
FOR EACH ROW
BEGIN
    UPDATE cars
    SET availability = 'Rented'
    WHERE car_id = NEW.car_id;
END //

DELIMITER ;

SELECT * FROM cars WHERE car_id = 1;

SELECT car_id, availability FROM cars;

INSERT INTO rentals
(customer_id, car_id, rental_date, return_date, total_amount, rental_status)
VALUES
(1, 1, '2026-11-10', '2026-11-12', 3000, 'Active');

SELECT car_id, car_name, availability
FROM cars
WHERE car_id = 1;

DELIMITER //

CREATE TRIGGER UpdateCarOnReturn
AFTER UPDATE ON rentals
FOR EACH ROW
BEGIN
    IF NEW.rental_status = 'Completed'
       AND OLD.rental_status <> 'Completed' THEN

        UPDATE cars
        SET availability = 'Available'
        WHERE car_id = NEW.car_id;

    END IF;
END //

DELIMITER ;

UPDATE rentals
SET rental_status = 'Completed'
WHERE rental_id = 4;

SELECT car_id, car_name, availability
FROM cars
WHERE car_id = 4;

START TRANSACTION;

UPDATE cars
SET rent_per_day = 2200
WHERE car_id = 2;

COMMIT;

SELECT * FROM cars
WHERE car_id = 2;

START TRANSACTION;

UPDATE cars
SET rent_per_day = 9999
WHERE car_id = 2;

ROLLBACK;

SELECT car_id, car_name, rent_per_day
FROM cars
WHERE car_id = 2;

ALTER TABLE cars
ADD CONSTRAINT chk_rent
CHECK (rent_per_day > 0);

SHOW CREATE TABLE cars;

SHOW TABLES;

SELECT 'Customers' AS Table_Name, COUNT(*) AS Total FROM customers
UNION ALL
SELECT 'Cars', COUNT(*) FROM cars
UNION ALL
SELECT 'Rentals', COUNT(*) FROM rentals
UNION ALL
SELECT 'Payments', COUNT(*) FROM payments
UNION ALL
SELECT 'Employees', COUNT(*) FROM employees;

SELECT
    c.customer_name,
    ca.car_name,
    r.rental_date,
    r.return_date,
    r.total_amount,
    r.rental_status,
    p.payment_method,
    p.payment_status
FROM rentals r
JOIN customers c ON r.customer_id = c.customer_id
JOIN cars ca ON r.car_id = ca.car_id
LEFT JOIN payments p ON r.rental_id = p.rental_id;