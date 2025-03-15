# Restaurant Ad-Hoc SQL Analysis Project

## Overview
This project is designed to perform ad-hoc analysis on restaurant data using SQL queries based on two key datasets: `menu_items` and `order_details2`. The aim is to gain actionable insights into menu popularity, order patterns, and sales performance through comprehensive SQL data manipulation.

## Introduction
The goal of this project is to utilize SQL for in-depth analysis of complex restaurant datasets. By executing structured queries, we uncover critical data points about customer preferences and operational efficiency. This analysis helps in optimizing menu offerings and improving overall business strategies focused on data-driven decisions.

## Data Preparation
### Initializing the Database
Begin by importing the `menu_items` and `order_details2` CSV files into your SQL database to create a robust data foundation ready for querying.

### Understanding the Schema
Post-initialization, the database will feature interconnected tables that mirror real-world restaurant operations, including menu items offered and details of customer orders.

### Data Integrity and Relationships
Primary and foreign keys are established to ensure data integrity and maintain accurate relationships across the restaurant's operational datasets. This structural integrity supports the execution of complex SQL queries.

## SQL Queries for Analysis
# Restaurant Ad-Hoc SQL Analysis Project

### Question 1: View the menu_items table.
```sql
SELECT * FROM menu_items;
```
### Question 2: Find the number of items on the menu.
```sql
SELECT COUNT(*) as Total_Items FROM menu_items;
```
### Question 3: What are the least and most expensive items on the menu?
```sql
-- Least expensive
SELECT * FROM menu_items ORDER BY price ASC;
-- Most expensive
SELECT * FROM menu_items ORDER BY price DESC;
```
### Question 4: How many Italian dishes are on the menu?
```sql
SELECT COUNT(*) as Italian_Dishes FROM menu_items WHERE category = 'Italian';
```
### Question 5: What are the least and most expensive Italian dishes on the menu?
```sql
SELECT MIN(price) as Least_Expensive, MAX(price) as Most_Expensive FROM menu_items WHERE category = 'Italian';
```
### Question 6: How many dishes are in each category?
```sql
SELECT category, COUNT(*) as Number_of_Dishes FROM menu_items GROUP BY category;
```
### Question 7: What is the average dish price within each category?
```sql
SELECT category, AVG(price) as Average_Price FROM menu_items GROUP BY category;
```
### Question 8: View the order_details table.
```sql
SELECT * FROM order_details2;
```
### Question 9: Find the date range of the table.
```sql
SELECT MIN(order_date) as 'Start_Date', MAX(order_date) as 'End_Date' FROM order_details2;
```
### Question 10: Count how many orders were made within this date range.
```sql
SELECT COUNT(DISTINCT order_id) as Total_Orders FROM order_details2;
```
### Question 11: Count how many items were ordered within this date range.
```sql
SELECT COUNT(item_id) as Total_Items FROM order_details2;
```
### Question 12: Identify which orders had the most number of items.
```sql
SELECT order_id, COUNT(item_id) As Item_Count FROM order_details2 GROUP BY order_id ORDER BY Item_Count DESC;
```
### Question 13: Combine the menu_items and order_details tables into a single table using a JOIN.
```sql
SELECT * FROM order_details2 as o LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id;
```
### Question 14: Find the least and most ordered items and their categories.
```sql
-- Least ordered
WITH hello AS (
    SELECT m.category, COUNT(*) as ordered_items
    FROM order_details2 as o
    LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
    GROUP BY m.category
) 
SELECT TOP 1 * FROM hello ORDER BY ordered_items ASC;

-- Most ordered
WITH hello AS (
    SELECT m.category, COUNT(*) as ordered_items
    FROM order_details2 as o
    LEFT JOIN menu_items as
```
### Question 15 Identify the top 5 orders that spent the most money:
```sql
WITH T AS 
(SELECT o.order_id, SUM(m.price) AS Total_Price
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
GROUP BY o.order_id
)
SELECT TOP 5* from T
ORDER BY Total_Price DESC;
```
### Question 16 View the details of the highest spend order and extract insights:
```sql
WITH T AS 
(SELECT *
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
)
SELECT * FROM T
WHERE order_id ='440';
```
### Question 17 View the details of the top 5 highest spend orders and extract insights:
```sql
WITH T AS 
(SELECT *
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
)
SELECT * FROM T
WHERE order_id IN (440, 2075, 1957,330,2675);
```
## Contact Information

For further information, collaboration, or inquiries, feel free to contact [Phil Dinh](mailto:dinhthanhtrung2011@gmail.com).










