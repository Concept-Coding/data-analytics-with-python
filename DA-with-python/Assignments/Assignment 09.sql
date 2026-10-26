-- ASSIGNMENT 09 — Joins & Group By
-- Database: BikeStores

-- Question 1 — INNER JOIN
SELECT p.product_name, b.brand_name, p.list_price
FROM production.products AS p
INNER JOIN production.brands AS b ON p.brand_id = b.brand_id
ORDER BY b.brand_name ASC, p.list_price DESC;


-- Question 2 — Joining Three Tables
SELECT p.product_name, b.brand_name, c.category_name, p.model_year
FROM production.products AS p
INNER JOIN production.brands AS b ON p.brand_id = b.brand_id
INNER JOIN production.categories AS c ON p.category_id = c.category_id
WHERE p.list_price > 1000;


-- Question 3 — LEFT JOIN
-- Part a
SELECT c.first_name, c.last_name, c.city, o.order_id, o.order_date
FROM sales.customers AS c
LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id;

-- Part b
SELECT c.first_name, c.last_name, c.city
FROM sales.customers AS c
LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;


-- Question 4 — RIGHT JOIN & FULL OUTER JOIN
-- Part a
SELECT s.store_name, st.first_name, st.last_name
FROM sales.staffs AS st
RIGHT JOIN sales.stores AS s ON st.store_id = s.store_id;

-- Part b: Products without any stock record
SELECT p.product_name, stock.quantity
FROM production.products AS p
FULL OUTER JOIN production.stocks AS stock ON p.product_id = stock.product_id
WHERE stock.product_id IS NULL;


-- Question 5 — Multi-Table Join (Order Details)
SELECT
    o.order_id,
    o.order_date,
    c.first_name + ' ' + c.last_name AS customer_full_name,
    p.product_name,
    oi.quantity,
    oi.quantity * oi.list_price * (1 - oi.discount) AS line_total
FROM sales.orders AS o
INNER JOIN sales.customers AS c ON o.customer_id = c.customer_id
INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
INNER JOIN production.products AS p ON oi.product_id = p.product_id
ORDER BY o.order_id ASC, p.product_name ASC;


-- Question 6 — Aggregate Functions
SELECT
    COUNT(*) AS total_products,
    MIN(list_price) AS lowest_list_price,
    MAX(list_price) AS highest_list_price,
    ROUND(AVG(list_price), 2) AS average_list_price
FROM production.products;


-- Question 7 — GROUP BY
-- Part a
SELECT c.category_name, COUNT(p.product_id) AS product_count
FROM production.categories AS c
INNER JOIN production.products AS p ON c.category_id = p.category_id
GROUP BY c.category_name
ORDER BY product_count DESC;

-- Part b
SELECT b.brand_name, p.model_year, AVG(p.list_price) AS average_list_price
FROM production.products AS p
INNER JOIN production.brands AS b ON p.brand_id = b.brand_id
GROUP BY b.brand_name, p.model_year
ORDER BY b.brand_name ASC, p.model_year ASC;


-- Question 8 — GROUP BY with Joins
-- Part a
SELECT
    c.customer_id,
    c.first_name + ' ' + c.last_name AS customer_full_name,
    COUNT(o.order_id) AS total_orders
FROM sales.customers AS c
LEFT JOIN sales.orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
ORDER BY total_orders DESC;

-- Part b
SELECT
    s.store_name,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.stores AS s
INNER JOIN sales.orders AS o ON s.store_id = o.store_id
INNER JOIN sales.order_items AS oi ON o.order_id = oi.order_id
GROUP BY s.store_name
ORDER BY total_revenue DESC;


-- Question 9 — HAVING
-- Part a
SELECT b.brand_name
FROM production.brands AS b
INNER JOIN production.products AS p ON b.brand_id = p.brand_id
GROUP BY b.brand_name
HAVING COUNT(p.product_id) > 20;

-- Part b
SELECT c.first_name + ' ' + c.last_name AS customer_full_name
FROM sales.customers AS c
INNER JOIN sales.orders AS o ON c.customer_id = o.customer_id
GROUP BY c.customer_id, c.first_name, c.last_name
HAVING COUNT(o.order_id) >= 3;

-- Part c:
-- WHERE filters individual rows before grouping.
-- HAVING filters groups after GROUP BY.


-- Question 10 — Combined Challenge
SELECT TOP (5)
    p.product_name,
    c.category_name,
    SUM(oi.quantity) AS total_quantity_sold,
    SUM(oi.quantity * oi.list_price * (1 - oi.discount)) AS total_revenue
FROM sales.order_items AS oi
INNER JOIN sales.orders AS o ON oi.order_id = o.order_id
INNER JOIN production.products AS p ON oi.product_id = p.product_id
INNER JOIN production.categories AS c ON p.category_id = c.category_id
WHERE o.order_status = 4
GROUP BY p.product_name, c.category_name
ORDER BY total_quantity_sold DESC;
