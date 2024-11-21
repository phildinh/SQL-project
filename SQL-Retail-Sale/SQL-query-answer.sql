-- CREATE DATABASE 
CREATE DATABASE retail_db;

-- CREATE TABLE IN retail_db (database)
CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);

-- Import file CSV to our table in retail_db (database)
-- Check our dataset
SELECT *
FROM retail_sales;

-- PART1: Data Exploration & Cleaning
SELECT COUNT(*)
FROM retail_sales;
-- WE HAVE 1987 TRANSACTIONS
SELECT COUNT(DISTINCT transactions_id)
FROM retail_sales;
-- WE HAVE 1987 TRANSACTIONS from count distinct, so we don't have same transactions
SELECT DISTINCT category FROM retail_sales;
-- We have 3 categories
-- Check null values
SELECT * 
FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
-- delete null values
DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

-- PART 2: Questions:
-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05':
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT *
FROM retail_sales
WHERE 
category = 'Clothing' AND
quantity >=4 AND
sale_date BETWEEN '2022-11-01' AND '2022-11-30';
-- 3.Write a SQL query to calculate the total sales (total_sale) for each category
SELECT category, SUM(total_sale) AS total_sale_category
FROM retail_sales
GROUP BY category;
-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT ROUND(AVG(age),0) AS avg_age, category
FROM retail_sales
WHERE category ='Beauty'
GROUP BY category;
-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000.:
SELECT *
FROM retail_sales
WHERE total_sale >1000;
-- 6.Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT category, gender, COUNT(transactions_id) AS number_transactions
FROM retail_sales
GROUP BY category, gender;
-- 7.Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
WITH T1 AS (
SELECT 
	AVG(total_sale) AS AVG_sale_month,
	EXTRACT(YEAR FROM sale_date) as Year,
    EXTRACT(MONTH FROM sale_date) as Month,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) AS rank_sale
FROM retail_sales
GROUP BY
	Year, Month
)
SELECT 
	AVG_sale_month,
	Year,
	Month,
    rank_sale
FROM T1
WHERE
	rank_sale = 1;
-- 8.Write a SQL query to find the top 5 customers based on the highest total sales **:
SELECT customer_id, SUM(total_sale) AS sum_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY sum_sale DESC
LIMIT 5;
-- 9.Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT COUNT(DISTINCT customer_id) as Total_customers, category
FROM retail_sales
GROUP BY category;
-- 10.Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH T2 AS 
(
SELECT *,
CASE
	WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
    WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
    ELSE 'Evening'
END AS shift
FROM retail_sales
)
SELECT 
shift,
COUNT(transactions_id) AS number_orders
FROM T2
GROUP BY shift;