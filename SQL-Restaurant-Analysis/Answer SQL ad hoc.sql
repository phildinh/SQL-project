-- 1. View the menu_items table.
SELECT * FROM menu_items

-- 2. Find the number of items on the menu.
SELECT COUNT(*) as Total_Items FROM menu_items

-- 3. What are the least and most expensive items on the menu?
SELECT * FROM menu_items
ORDER BY price ASC;

SELECT * FROM menu_items
ORDER BY price DESC;
-- 4. How many Italian dishes are on the menu?
SELECT COUNT(*) as Italian_Dishes
FROM menu_items
WHERE category = 'Italian';

-- 5. What are the least and most expensive Italian dishes on the menu?
SELECT MIN(price) as Least_Expensive, MAX(price) as Most_Expensive
FROM menu_items
WHERE category = 'Italian';

-- 6. How many dishes are in each category?
SELECT category, COUNT(*) as Number_of_Dishes
FROM menu_items
GROUP BY category;

-- 7. What is the average dish price within each category?
SELECT category, AVG(price) as Average_Price
FROM menu_items
GROUP BY category;

-- 8 View the order_details table:
SELECT * FROM order_details2;

-- 9 Find the date range of the table:
SELECT MIN(order_date) as 'Start_Date', MAX(order_date) as End_date
FROM order_details2;

-- 10 Count how many orders were made within this date range:
SELECT COUNT(DISTINCT order_id) as Total_Orders
FROM order_details2;

-- 11 Count how many items were ordered within this date range:
SELECT COUNT(item_id) as Total_Items
FROM order_details2;

-- 12 dentify which orders had the most number of items:
SELECT order_id, COUNT(item_id) As Item_Count
FROM order_details2
GROUP BY order_id
ORDER BY Item_Count DESC

-- 13 Combine the menu_items and order_details tables into a single table using a JOIN:
SELECT * FROM order_details2
SELECT * FROM menu_items

SELECT * 
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id

-- 14 Find the least and most ordered items and their categories:
WITH hello AS(
SELECT m.category, COUNT(*) as ordered_items
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
GROUP BY m.category
) 
SELECT TOP 1* 
FROM hello
ORDER BY ordered_items DESC;

WITH hello AS(
SELECT m.category, COUNT(*) as ordered_items
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
GROUP BY m.category
) 
SELECT TOP 1* 
FROM hello
ORDER BY ordered_items ASC;


-- 15 Identify the top 5 orders that spent the most money:
WITH T AS 
(SELECT o.order_id, SUM(m.price) AS Total_Price
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
GROUP BY o.order_id
)
SELECT TOP 5* from T
ORDER BY Total_Price DESC;


-- 16 View the details of the highest spend order and extract insights:
WITH T AS 
(SELECT *
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
)
SELECT * FROM T
WHERE order_id ='440';

--17 View the details of the top 5 highest spend orders and extract insights:
WITH T AS 
(SELECT *
FROM order_details2 as o
LEFT JOIN menu_items as m ON o.item_id = m.menu_item_id
)
SELECT * FROM T
WHERE order_id IN (440, 2075, 1957,330,2675);