# Creating global_electronics database

create database global_electronics;

# using database
USE global_electronics;

# Imported all cleaned and Structured DataFrames from pandas 

# I used these SQL Querries in ODBC connector to extract data from the database and insert into PowerBI
# to Optimized Data Loading and have control over the data 

# Customer Table
SELECT*FROM global_electronics.customers;

# 1. Gender Distribution
SELECT gender, COUNT(*) AS Count_gender
FROM customers
GROUP BY gender;

# 2. Country wise customers
SELECT country, count(*) AS Country_count
FROM customers
group by country;

# 3. Age bucketing
SELECT
    age_bucket,
    COUNT(*) AS count
FROM (
    SELECT
        c.CustomerKey,
        s.`Order Date`,
        CASE 
            WHEN YEAR(s.`Order Date`) - YEAR(c.Birthday) <= 18 THEN '<=18'
            WHEN YEAR(s.`Order Date`) - YEAR(c.Birthday) BETWEEN 18 AND 25 THEN '18-25'
            WHEN YEAR(s.`Order Date`) - YEAR(c.Birthday) BETWEEN 25 AND 35 THEN '25-35'
            WHEN YEAR(s.`Order Date`) - YEAR(c.Birthday) BETWEEN 35 AND 45 THEN '35-45'
            WHEN YEAR(s.`Order Date`) - YEAR(c.Birthday) BETWEEN 45 AND 55 THEN '45-55'
            WHEN YEAR(s.`Order Date`) - YEAR(c.Birthday) BETWEEN 55 AND 65 THEN '55-65'
            ELSE '>65'
        END AS age_bucket
    FROM Customers c
    JOIN Sales s ON c.CustomerKey = s.CustomerKey
) AS age_groups
GROUP BY age_bucket;

# 4. Average Order Quantity per Customer
SELECT c.Name, AVG(s.Quantity) AS AvgQuantity
FROM sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.Name
ORDER BY AvgQuantity DESC
LIMIT 10;

# 5. Top 10 Customers by Purchase Volume
SELECT c.Name, SUM(s.Quantity) AS TotalPurchased
FROM sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.Name
ORDER BY TotalPurchased DESC
LIMIT 10;

# 6.Number of Orders by Gender
SELECT c.Gender, COUNT(DISTINCT s.`Order Number`) AS Orders
FROM sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
GROUP BY c.Gender;

# 7. Revenue by Continent
SELECT c.Continent, SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM sales s
JOIN customers c ON s.CustomerKey = c.CustomerKey
JOIN products p ON s.ProductKey = p.ProductKey
GROUP BY c.Continent
ORDER BY Revenue DESC;


# Products table
SELECT*FROM global_electronics.products;

# 8. Top-selling Products by Quantity
SELECT Productkey, SUM(Quantity) AS TotalQuantity
FROM sales
GROUP BY Productkey
ORDER BY TotalQuantity DESC
LIMIT 10;

# 9. Revenue by Product
SELECT p.`Product Name`, SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM sales s
JOIN products p ON s.ProductKey = p.ProductKey
GROUP BY p.`Product Name`
ORDER BY Revenue DESC;

# 10. Most Profitable Products
SELECT p.`Product Name`, SUM((p.`Unit Price USD` - p.`Unit Cost USD`) * s.Quantity) AS Profit
FROM sales s
JOIN products p ON s.ProductKey = p.ProductKey
GROUP BY p.`Product Name`
ORDER BY Profit DESC;

# 11. Product Sales by Category
SELECT p.Category, SUM(s.Quantity) AS TotalSales
FROM sales s
JOIN products p ON s.ProductKey = p.ProductKey
GROUP BY p.Category
ORDER BY TotalSales DESC;

# 12. Average Profit Margin by Subcategory
SELECT Subcategory, AVG((`Unit Price USD` - `Unit Cost USD`) / `Unit Price USD`) AS AvgProfitMargin
FROM products
GROUP BY Subcategory
ORDER BY AvgProfitMargin DESC;

# Stores Table 
SELECT*FROM global_electronics.stores;

# 13.Total Revenue Per Store
SELECT st.StoreKey, st.State, SUM(s.Quantity * p.`Unit Price USD`) AS Revenue
FROM sales s
JOIN products p ON s.ProductKey = p.ProductKey
JOIN stores st ON s.StoreKey = st.StoreKey
GROUP BY st.StoreKey, st.State
ORDER BY Revenue DESC;

# 14.Top Stores by Total Sales
SELECT st.StoreKey, st.State, SUM(s.Quantity) AS TotalSales
FROM sales s
JOIN stores st ON s.StoreKey = st.StoreKey
GROUP BY st.StoreKey, st.State
ORDER BY TotalSales DESC;

# 15. Stores with the Largest Square Meters
SELECT StoreKey, Country, State, `Square Meters`
FROM stores
ORDER BY `Square Meters` DESC
LIMIT 10;


SELECT*FROM global_electronics.sales;

SELECT*FROM global_electronics.exchangerates;


