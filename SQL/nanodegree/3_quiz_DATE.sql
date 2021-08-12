--issue: general or particular, ask for clarification
--in which month does... implies continuity so general
--in which month did.. implies completion so particular


--1
-- Find the sales in terms of total dollars for all orders in each year, ordered from greatest to least. Do you notice any trends in the yearly sales totals?

SELECT DATE_TRUNC('year', o.occurred_at) AS year, SUM(o.total_amt_usd) annual_total
FROM orders o
GROUP BY DATE_TRUNC('year', o.occurred_at)
ORDER BY annual_total DESC;

-- there seems to be an increase each year, except 2017

--GROUP BY 1 means GROUP BY column 1 in SELECT
SELECT DATE_TRUNC('year', o.occurred_at) AS year, SUM(o.total_amt_usd) annual_total
FROM orders o
GROUP BY 1
ORDER BY 2 DESC;
--DATE_PART('dow', occurred_at) returns 0-6 for monday to sunday


--solution:
 SELECT DATE_PART('year', occurred_at) ord_year,  SUM(total_amt_usd) total_spent
 FROM orders
 GROUP BY 1
 ORDER BY 2 DESC;

--DATE_PART used instead but exactly the same result!


--2
--Which month did Parch & Posey have the greatest sales in terms of total dollars? Are all months evenly represented by the dataset?

SELECT DATE_TRUNC('month', o.occurred_at) AS month,
SUM(o.total_amt_usd) monthly_total
FROM orders o
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--as subselect
SELECT Table1.month
FROM(SELECT DATE_TRUNC('month', o.occurred_at) AS month,
SUM(o.total_amt_usd) monthly_total
FROM orders o
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) AS Table1;
-- N.B. first and last month are probably incomplete


--solution:
SELECT DATE_PART('month', occurred_at) ord_month, SUM(total_amt_usd) total_spent
FROM orders
WHERE occurred_at BETWEEN '2014-01-01' AND '2017-01-01'
GROUP BY 1
ORDER BY 2 DESC; 

--this solution answers a different question
--this answers which month sums to the highest total over all years
--ambiguous question

--3
--Which year did Parch & Posey have the greatest sales in terms of total number of orders? Are all years evenly represented by the dataset?

SELECT DATE_TRUNC('year', o.occurred_at) AS year, COUNT(*) AS annual_num_orders
FROM orders o
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--2016
--probably first and last years are not complete

--as subselect

SELECT Table1.year
FROM(SELECT DATE_TRUNC('year', o.occurred_at) AS year, COUNT(*) AS annual_num_orders
FROM orders o
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) AS Table1;


--solution:
SELECT DATE_PART('year', occurred_at) ord_year,  COUNT(*) total_sales
FROM orders
GROUP BY 1
ORDER BY 2 DESC;

--same answer, different approach
--truncate gives indivual months and days
--part gives running total of all mondays, all februaries etc.

--4
--Which month did Parch & Posey have the greatest sales in terms of total number of orders? Are all months evenly represented by the dataset?
SELECT DATE_TRUNC('month', o.occurred_at) AS month, COUNT(*) AS monthly_num_orders
FROM orders o
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--December 2016

--as subselect
SELECT Table1.month
FROM(SELECT DATE_TRUNC('month', o.occurred_at) AS month, COUNT(*) AS monthly_num_orders
FROM orders o
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) AS Table1;

--5
--In which month of which year did Walmart spend the most on gloss paper in terms of dollars?

SELECT DATE_TRUNC('month', o.occurred_at) AS month, 
SUM(o.gloss_amt_usd) AS gloss_total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart' 
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;

--May 2016

--as subselect
SELECT Table1.month
FROM(SELECT DATE_TRUNC('month', o.occurred_at) AS month, 
SUM(o.gloss_amt_usd) AS gloss_total_usd
FROM orders o
JOIN accounts a
ON a.id = o.account_id
WHERE a.name = 'Walmart'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) AS Table1;



