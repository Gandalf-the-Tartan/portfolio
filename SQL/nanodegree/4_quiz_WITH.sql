--1
--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

--sales rep amount of total sales

--table of sales reps and their total sales
WITH table1 AS (SELECT s.name sales_rep, SUM(o.total_amt_usd) total_sales
	FROM sales_reps s
	JOIN accounts a
	ON s.id = a.sales_rep_id
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC)

     table2 AS ()






--mistakes
SELECT r.name region, table1.sales_rep, MAX(table1.total_sales)
FROM region r
JOIN table1
ON r.id = table1.s.region_id --can't be done
GROUP BY 1,2;

--this shows all 50 reps
SELECT r.name region, table1.sales_rep, MAX(table1.total_sales)
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN table1
ON s.name = table1.sales_rep
GROUP BY 1,2;


--solution defines second table as filter of first table


WITH t1 AS (
	SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) total_amt
	FROM sales_reps s
	JOIN accounts a
	ON s.id = a.sales_rep_id
	JOIN orders o
	ON a.id = o.account_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1,2
	ORDER BY 3 DESC),
t2 AS (
	SELECT region_name, MAX(total_amt) total_amt
	FROM t1
	GROUP BY 1)
SELECT t1.rep_name, t1.region_name, t1.total_amt
FROM t1
JOIN t2
ON t1.region_name = t2.region_name AND t1.total_amt = t2.total_amt;




--2
--For the region with the largest sales total_amt_usd, how many total orders were placed?


--table for; region, sum(o.total_amt_usd)
	     region, count(o.id)


--as subquery

--region, total_orders, total sales
SELECT r.name, COUNT(o.id) total_orders, SUM(o.total_amt_usd) total_sales
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC;



--inline
SELECT total_orders
FROM(SELECT r.name, COUNT(o.id) total_orders, SUM(o.total_amt_usd) total_sales
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1) sub;




--with
WITH t1 AS(SELECT r.name, COUNT(o.id) total_orders, SUM(o.total_amt_usd) total_sales
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 3 DESC
LIMIT 1)

SELECT t1.total_orders
FROM t1;


--nested

??



--solution
--answer 2357 same
--solution is unnecessarily complicated
--solution has no formatting for joins
--only do this if limit is not allowed
WITH t1 AS (
	SELECT r.name region_name, SUM(o.total_amt_usd) total_amt
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON o.account_id = a.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY r.name),
--t1 is table of region and sum(o.total_amt_usd)
t2 AS (
	SELECT MAX(total_amt)
	FROM t1)
--t2 is a scalar for use in having
--if limit is not available then this is a possibility
SELECT r.name, COUNT(o.total) total_orders
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
JOIN region r
ON r.id = s.region_id
GROUP BY r.name
HAVING SUM(o.total_amt_usd) = (SELECT * FROM t2);
--this has the main select as region and total_orders
--then filters with SUM(o.total_amt_usd) of region with t2
--lots of code replication





--3
--How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer? 

--this requires having clause, as greater than operator required

--all accounts
WITH t1 AS (
	SELECT o.account_id account_id, SUM(o.standard_qty) total_standard, SUM(o.total) total
	FROM orders o
	GROUP BY 1
	ORDER BY 2 DESC),
t2 AS (
	SELECT *
	FROM t1
	LIMIT 1),
--max account of t1
t3 AS (
	SELECT total
	FROM t2)
--t3 is scalar for total of t2 for comparison

SELECT COUNT(t1.account_id)
FROM t1
WHERE (t1.total) > (SELECT *
			FROM t3)
ORDER BY 1 DESC;

--3 results
--solution totally different but same answer
--filtering with more tables allows for WHERE clause
--using less tables requires filtering inside tables

--solution
WITH t1 AS (
	SELECT a.name account_name, SUM(o.standard_qty) total_std,
		SUM(o.total) total
	FROM accounts a
	JOIN orders o
	ON o.account_id = a.id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1),
--solution also uses limit
--no need to join accounts as account id also in orders table
t2 AS (
	SELECT a.name
	FROM orders o
	JOIN accounts a
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > (SELECT total FROM t1))
--NOTE my WHERE clause is the same as this but with one extra step
SELECT COUNT(*)
FROM t2;


