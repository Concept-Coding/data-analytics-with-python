-- ============================================================
-- ASSIGNMENT 01 — Querying, Sorting & Filtering
-- Database: BikeStores
-- ============================================================


-- ============================================================
-- Question 1 — SELECT & WHERE
-- Customers in California (CA) who have a phone number.
-- ============================================================

SELECT first_name, last_name, city, phone
FROM sales.customers
WHERE state = 'CA'
  AND phone IS NOT NULL;


-- ============================================================
-- Question 2 — ORDER BY (Multiple Columns)
-- Newest model year first; within each year, cheapest first.
-- ============================================================

SELECT product_id, product_name, model_year, list_price
FROM production.products
ORDER BY model_year DESC, list_price ASC;


-- ============================================================
-- Question 3 — TOP N & TOP PERCENT
-- ============================================================

-- Part a: The 5 most expensive products.

SELECT TOP (5) product_name, list_price
FROM production.products
ORDER BY list_price DESC;


-- Part b: The cheapest 5% of products (all columns).
-- In the standard BikeStores database, there are 321 products.
-- TOP (5) PERCENT returns 17 rows because 5% of 321 is 16.05,
-- which SQL Server rounds up to the next whole row.

SELECT TOP (5) PERCENT *
FROM production.products
ORDER BY list_price ASC;


-- ============================================================
-- Question 4 — OFFSET & FETCH (Pagination)
-- 10 products per page, most expensive first.
-- ============================================================

-- Page 1: rows 1–10

SELECT *
FROM production.products
ORDER BY list_price DESC
OFFSET 0 ROWS FETCH NEXT 10 ROWS ONLY;


-- Page 2: rows 11–20

SELECT *
FROM production.products
ORDER BY list_price DESC
OFFSET 10 ROWS FETCH NEXT 10 ROWS ONLY;


-- Page 3: rows 21–30

SELECT *
FROM production.products
ORDER BY list_price DESC
OFFSET 20 ROWS FETCH NEXT 10 ROWS ONLY;


-- ============================================================
-- Question 5 — DISTINCT
-- ============================================================

-- Part a: Unique customer states, alphabetically.

SELECT DISTINCT state
FROM sales.customers
ORDER BY state ASC;


-- Part b: Unique state-and-city combinations.

SELECT DISTINCT state, city
FROM sales.customers
ORDER BY state ASC, city ASC;


-- Part c: Distinct model years.
-- Run this query and count the returned rows.
-- The standard BikeStores dataset has 6 distinct model years.

SELECT DISTINCT model_year
FROM production.products
ORDER BY model_year ASC;


-- ============================================================
-- Question 6 — Logical Operators (AND / OR)
-- Price from $500 to $1500 inclusive, and model year 2019 or 2020.
-- ============================================================

SELECT product_id, product_name, brand_id, category_id, list_price
FROM production.products
WHERE list_price BETWEEN 500 AND 1500
  AND (model_year = 2019 OR model_year = 2020)
ORDER BY list_price ASC;
