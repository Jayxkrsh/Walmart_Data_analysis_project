CREATE database walmart_db;
use walmart_db;
-- EDA
SELECT * FROM walmart;
SELECT COUNT(*) FROM walmart;

SELECT payment_method , COUNT(*) 
FROM walmart
GROUP BY payment_method;

describe walmart;

-- changed column names to lowercase
ALTER TABLE walmart
CHANGE Branch branch text ;
ALTER TABLE walmart
CHANGE City city text ;

SELECT MAX(quantity) FROM walmart;

-- Solve Business problems
-- Q.1 Find different payment method and number of transactions, number of qty sold  
SELECT 
payment_method,
COUNT(*) as no_payments,
SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;

-- Identify the highest-rated category in each branch, displaying the branch, category
-- AVG RATING
SELECT branch, category, avg_rating
FROM (
    SELECT 
        branch,
        category,
        AVG(rating) AS avg_rating
    FROM walmart
    GROUP BY branch, category
) AS avg_table
WHERE (branch, avg_rating) IN (
    SELECT branch, MAX(avg_rating)
    FROM (
        SELECT branch, category, AVG(rating) AS avg_rating
        FROM walmart
        GROUP BY branch, category
    ) AS subquery
    GROUP BY branch
);

--  Q.3 Identify the busiest day for each branch based on the number of transactions
SELECT branch, 
       DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name, 
       COUNT(*) AS no_transactions
FROM walmart w1
GROUP BY branch, day_name
HAVING COUNT(*) = (
    SELECT MAX(sub.no_transactions)
    FROM (
        SELECT branch, 
               DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name, 
               COUNT(*) AS no_transactions
        FROM walmart
        GROUP BY branch, day_name
    ) sub
    WHERE sub.branch = w1.branch
);

-- Calculate the total quantity of items sold per payment method. List payment_method and total_quantity.
SELECT 
payment_method,
SUM(quantity) as no_qty_sold
FROM walmart
GROUP BY payment_method;

-- Q.5
-- Determine the average, minimum, and maximum rating of category for each city. 
-- List the city, average_rating, min_rating, and max_rating.
SELECT 
city,
category,
MIN(rating) as min_rating,
MAX(rating) as max_rating,
AVG(rating) as avg_rating
FROM walmart
GROUP BY city, category;

-- Q.6
-- Calculate the total profit for each category by considering total_profit as
-- (unit_price * quantity * profit_margin). 
-- List category and total_profit, ordered from highest to lowest profit.
SELECT 
category,
SUM(total) as total_revenue,
SUM(total * profit_margin) as profit
FROM walmart
GROUP BY category;

-- Q.7
-- Categorize sales into 3 group MORNING, AFTERNOON, EVENING 
-- Find out each of the shift and number of invoices
SELECT 
branch,
    CASE 
        WHEN HOUR(TIME(time)) < 12 THEN 'Morning'
        WHEN HOUR(TIME(time)) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS day_time,
    COUNT(*) AS transaction_count
FROM walmart
GROUP BY branch, day_time
ORDER BY branch, transaction_count DESC;
