--1
--Write a query to display for each order, the account ID, total amount of the order, and the level of the order - ‘Large’ or ’Small’ - depending on if the order is $3000 or more, or smaller than $3000.

SELECT o.account_id, o.total_amt_usd, 
CASE WHEN o.total_amt_usd >= 3000 THEN 'Large'
ELSE 'Small' END AS level
FROM orders o;

--2
--Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT 
	CASE 
	WHEN o.total >= 2000 THEN 'At least 2000'
	WHEN o.total >= 1000 AND o.total < 2000 THEN 'Between 1000 and 2000'
	ELSE 'Less than 1000' END AS number_items_ordered,
		COUNT(*) AS number_of_orders
FROM orders o
GROUP BY o.total;

--1359 results?
-- because GROUP BY refers to unchanged column, not the case in SELECT
-- number must be passed to GROUP BY

--solution


SELECT CASE WHEN total >= 2000 THEN 'At Least 2000'
   WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
	   ELSE 'Less than 1000' END AS order_category,
		COUNT(*) AS order_count
		FROM orders
		GROUP BY 1;

--NOTE reversing order in select also works
SELECT COUNT(*) AS order_count,
	CASE WHEN total >= 2000 THEN 'At Least 2000'
	WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
	ELSE 'Less than 1000' 
	END AS order_category
FROM orders
GROUP BY 2;


--3
--We would like to understand 3 different levels of customers based on the amount associated with their purchases. The top level includes anyone with a Lifetime Value (total sales of all orders) greater than 200,000 usd. The second level is between 200,000 and 100,000 usd. The lowest level is anyone under 100,000 usd. Provide a table that includes the level associated with each account. You should provide the account name, the total sales of all orders for the customer, and the level. Order with the top spending customers listed first.

SELECT a.name, o.total_amt_usd,
CASE
	WHEN o.total_amt_usd > 200000 THEN '$200,000+'
	WHEN o.total_amt_usd < 200000 AND o.total_amt_usd >= 100000
	       THEN '$100,000-$200,000'
	ELSE 'less than $100,000'
END AS level
FROM accounts a
JOIN orders o
ON o.account_id = a.id
ORDER BY o.total_amt_usd DESC;

--this is totally wrong
--there is no summation so there are 6912 rows instead of 350

--solution:
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
	     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
		     ELSE 'low' END AS customer_level
			FROM orders o
			JOIN accounts a
			ON o.account_id = a.id 
			GROUP BY a.name
			ORDER BY 2 DESC;


--4
--We would now like to perform a similar calculation to the first, but we want to obtain the total amount spent by customers only in 2016 and 2017. Keep the same levels as in the previous question. Order with the top spending customers listed first.

SELECT a.name, o.total_amt_usd "2016-2017 sales",
CASE
WHEN o.total_amt_usd > 200000
	THEN '$200,000'
WHEN o.total_amt_usd < 200000 AND o.total_amt_usd >= 100000
	THEN '$100,000-$200,000'
ELSE 'less than $100,000'
END AS level
FROM accounts a
JOIN orders o
ON o.account_id = a.id
WHERE o.occurred_at BETWEEN '2016-01-01' AND '2018-01-01'
ORDER BY o.total_amt_usd DESC;

--solution:
SELECT a.name, SUM(total_amt_usd) total_spent, 
     CASE WHEN SUM(total_amt_usd) > 200000 THEN 'top'
	     WHEN  SUM(total_amt_usd) > 100000 THEN 'middle'
		     ELSE 'low' END AS customer_level
			FROM orders o
			JOIN accounts a
			ON o.account_id = a.id
			WHERE occurred_at > '2015-12-31' 
			GROUP BY 1
			ORDER BY 2 DESC;

--5
--We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders. Create a table with the sales rep name, the total number of orders, and a column with top or not depending on if they have more than 200 orders. Place the top sales people first in your final table.

SELECT s.name rep, COUNT(o.id) total_orders,
CASE WHEN COUNT(o.id) > 200 THEN 'top'
ELSE 'not'
END AS performance
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
GROUP BY rep
ORDER BY total_orders DESC;

--solution:
SELECT s.name, COUNT(*) num_ords,
     CASE WHEN COUNT(*) > 200 THEN 'top'
	     ELSE 'not' END AS sales_rep_level
		FROM orders o
		JOIN accounts a
		ON o.account_id = a.id 
		JOIN sales_reps s
		ON s.id = a.sales_rep_id
		GROUP BY s.name
		ORDER BY 2 DESC;
--same but with number instead of alias in ORDER BY
--also COUNT(o.id) not necessary

--6
--The previous didn't account for the middle, nor the dollar amount associated with the sales. Management decides they want to see these characteristics represented as well. We would like to identify top performing sales reps, which are sales reps associated with more than 200 orders or more than 750000 in total sales. The middle group has any rep with more than 150 orders or 500000 in sales. Create a table with the sales rep name, the total number of orders, total sales across all orders, and a column with top, middle, or low depending on this criteria. Place the top sales people based on dollar amount of sales first in your final table.
SELECT s.name, COUNT(*) num_ords, SUM(o.total_amt_usd),
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 75000 THEN 'top'
	WHEN (COUNT(*) <= 200 AND COUNT(*) > 150) 
		OR (SUM(o.total_amt_usd) > 50000 
			AND SUM(o.total_amt_usd) <= 75000) THEN 'middle'
	ELSE 'low'
	END AS level
FROM accounts a
JOIN orders o
ON a.id = o.account_id
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.name
ORDER BY 3 DESC, 2 DESC;


--solution
SELECT s.name, COUNT(*), SUM(o.total_amt_usd) total_spent, 
     CASE WHEN COUNT(*) > 200 OR SUM(o.total_amt_usd) > 750000 THEN 'top'
	     WHEN COUNT(*) > 150 OR SUM(o.total_amt_usd) > 500000 THEN 'middle'
		     ELSE 'low' END AS sales_rep_level
			FROM orders o
			JOIN accounts a
			ON o.account_id = a.id 
			JOIN sales_reps s
			ON s.id = a.sales_rep_id
			GROUP BY s.name
			ORDER BY 3 DESC;

--advice in previous lesson was to assume each WHEN is executed?!
--but here it assumes that only one WHEN is executed
