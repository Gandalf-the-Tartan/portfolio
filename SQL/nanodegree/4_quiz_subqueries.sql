
--step 1 build subquery
--find number of events that occur for each day for each channel
--find number of ..for each .. for..each
--for each column, for each column, find number of rows
--column, column, COUNT(*)
--the primary key should be the *
SELECT
DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event
FROM web_events
GROUP BY 1, 2;

--subset of channels then separate days, everything left is the primary key
--which signifies an event
--no join so no dot notation
--NOTE AS is required for functions

--experimenting with ORDER BY to check I've pulled what I want.



--step 2
--pull all data from the subquery
SELECT *
FROM(SELECT 
DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event
FROM web_events
GROUP BY 1, 2) sub;


--step 3
--find average number of events for each channel (for each day)
SELECT sub.channel, AVG(sub.event)
FROM(SELECT
	DATE_TRUNC('day', occurred_at) AS day, channel, COUNT(*) AS event
	FROM web_events
	GROUP BY 1, 2) sub
GROUP BY 1;







--2nd quiz, nested subquery (WHERE)
--use DATE_TRUNC to pull month level info about first order ever placed in orders table

--step 1
SELECT DATE_TRUNC('month', MIN(occurred_At))
FROM orders;

--step 2
--use nested subquery to find only orders that took place in that particular month, pull average for each paper type quantity


SELECT AVG(standard_qty) AS avg_standard,
	AVG(gloss_qty) AS avg_gloss,
	AVG(poster_qty) AS avg_poster,
	SUM(total_amt_usd) AS total_spend --follow up question
FROM orders
WHERE DATE_TRUNC('month,' occurred_at) = (SELECT DATE_TRUNC('month', MIN(occurred_At))
	FROM orders);



--quiz 3
--1
--Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

--table of reps and their total sales
SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) AS total_sales
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
JOIN region r
ON r.id = s.region_id
GROUP BY 1, 2;

--id included for each table to ensure inclusion of possible shared names

--find max with inline (FROM) subquery
--check with *
SELECT * 
FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) AS total_sales
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
JOIN region r
ON r.id = s.region_id
GROUP BY 1, 2) AS T1;

--pull max total for each region
SELECT T1.region_name, MAX(total_sales) AS total_sales
FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) AS total_sales
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON a.id = o.account_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1, 2) AS T1
GROUP BY 1
ORDER BY 1;

--associate with sales rep
SELECT T3.rep_name, T3.region_name, T3.total_sales
FROM(
SELECT T1.region_name, MAX(total_sales) AS total_sales
FROM(SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) AS total_sales
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON a.id = o.account_id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY 1, 2) AS T1
GROUP BY 1
ORDER BY 1) AS T2
JOIN (
SELECT s.name rep_name, r.name region_name, SUM(o.total_amt_usd) AS total_sales
FROM sales_reps s
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON a.id = o.account_id
JOIN region r
ON r.id = s.region_id
GROUP BY 1, 2) AS T3
ON T3.region_name = T2.region_name AND T3.total_sales = T2.total_sales
ORDER BY 2;

--NOTE two conditions in ON clause, neither use primary keys, it seems like WHERE.

ON T3.region_name = T2.region_name
WHERE T3.total_sales = T2.total_sales; --also works and makes more sense

ON T3.total_sales = T2.total_sales; --also works, so previous two are redundant?

--I do not understand joins on subqueries!

--solution
--join the sales rep total table with a subquery of the same table
--join on derived columns of outer query



--2
--For the region with the largest (sum) of sales total_amt_usd, how many total (count) orders were placed? 

--step 1
--join region with orders, sum total_amt_usd
SELECT r.name region_name, SUM(o.total_amt_usd) total_amt_usd
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC;

--outerquery of MAX 
SELECT MAX(total_amt_usd) total_amt_usd
FROM(SELECT r.name region_name, SUM(o.total_amt_usd) total_amt_usd
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON a.sales_rep_id = s.id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
ORDER BY 2 DESC) AS t1;


--solution is to use this max as a having condition of an aggregate count
--make a second table with region and orders


--much simpler solution
SELECT total_orders
FROM(SELECT r.name, COUNT(o.total) total_orders, SUM(o.total_amt_usd)
	FROM sales_reps s
	JOIN accounts a
	ON a.sales_rep_id = s.id
	JOIN orders o
	ON o.account_id = a.id
	JOIN region r
	ON r.id = s.region_id
	GROUP BY r.name
	ORDER BY 3 DESC
	LIMIT 1) AS sub;





--3
--How many accounts had more total purchases than the account name which has bought the most standard_qty paper throughout their lifetime as a customer? 
--this is ambiguous is it total orders where an order and a purchase are synonyms, or is it the sum of total qty over all orders?
--the bold font on the website suggests the total column!!!!!!!

--step 1
--find account name which has bought most standard_qty paper

SELECT a.name account, SUM(o.standard_qty) total_standard_qty
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

=>
--having subquery
--this gives the amount
SELECT MAX(total_standard_qty) total_standard_qty
FROM(SELECT a.name account, SUM(o.standard_qty) total_standard_qty
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC) sub;

--alternatively
--this gives the actual name, which is asked for
SELECT account
FROM(SELECT a.name account, SUM(o.standard_qty) total_standard_qty
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1) sub;


--however we want to compare other queries against sum of total column
--this gives the sum of total for the account that has bought most std._qty
SELECT total
FROM(SELECT a.name account, SUM(o.standard_qty) total_standard_qty,
	SUM(o.total) total
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	ORDER BY 2 DESC
	LIMIT 1) sub;

=>
--WRONG NOT COUNT
--how many accounts have had more total purchases than this account
--table of total purchases for each account
SELECT a.name account, COUNT(*) total_purchases
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


--table of accounts with summed total column
SELECT a.name account, SUM(o.total) total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;


=>
--create subset where accounts and purchases exceeds given account
--solution includes total in first subquery

SELECT a.name account, SUM(o.total) total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > 3000

ORDER BY 2 DESC;
--above is just checking condition works
--NOTE HAVING cannot take alias total


--replace condition with subquery

SELECT a.name account, SUM(o.total) total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING SUM(o.total) > (SELECT total
			FROM(SELECT a.name account, SUM(o.standard_qty) total_standard_qty,
					SUM(o.total) total
				FROM accounts a
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY 1
				ORDER BY 2 DESC
				LIMIT 1) sub)
ORDER BY 2 DESC;

--this now shows all accounts that meet the criteria


=>

--create an outer select with a count aggregation

SELECT COUNT(*)
FROM(SELECT a.name account, SUM(o.total) total
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY 1
	HAVING SUM(o.total) > (SELECT total
			FROM(SELECT a.name account, SUM(o.standard_qty) total_standard_qty,
					SUM(o.total) total
				FROM accounts a
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY 1
				ORDER BY 2 DESC
				LIMIT 1) sub)
	ORDER BY 2 DESC) AS sub2;




--4
--For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

--step 1
--which customer spent the most as having (return total_amt_usd)
--show channel, count(web_events)

--shows channel and counts events
SELECT w.channel, COUNT(*) num_events
FROM web_events w
GROUP BY 1;

--shows account, channel, web_events
SELECT a.name account, w.channel, COUNT(*) num_events
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY 1,2
ORDER BY 1;
--1509 results (*) and (w.id) 
--therefore the GROUP BY ensures immediate left is the table whos primary
--id is counted

--with condition

SELECT w.channel, COUNT(*) num_events
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
JOIN orders o
ON o.account_id = a.id
GROUP BY 1
HAVING AVG(o.total);
--come back to this

--second table, account with largest total_amt_usd
--return 2 to outer as may change
SELECT a.name account, SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1;


--having name

--finished query
SELECT a.name account, w.channel, COUNT(*) num_events
FROM web_events w
JOIN accounts a
ON a.id = w.account_id
GROUP BY 1,2
HAVING a.name = (
SELECT account
FROM(SELECT a.name account, SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) sub)
ORDER BY 3 DESC;

--answer same as solution given but different approach
--mine makes more sense

--second table as subquery
SELECT account
FROM(SELECT a.name account, SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 1) sub



--5
--What is the lifetime average amount spent in terms of total_amt_usd for the top 10 total spending accounts?

--step one top ten accounts for total_amt_usd
SELECT a.name account, SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10;

--step 2 show avg
SELECT AVG(total_amt_usd) top_ten_average
FROM(SELECT a.name account, SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10) sub;

--same as solution more or less
--304846.969000000000 same answer



--6
--What is the lifetime average amount spent in terms of total_amt_usd, including only the companies that spent more per order, on average, than the average of all orders.

--find avg of all orders and use as having >
--WRONG this shows avg order per account
SELECT AVG(total_amt_usd) average_all_orders
FROM(SELECT a.name account, SUM(o.total_amt_usd) total_amt_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC) sub;



--avg of all orders (scalar) use as having 
SELECT AVG(total_amt_usd)
FROM orders;

--find account and average order size in total amt usd
SELECT a.name account, AVG(o.total_amt_usd)
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
ORDER BY 2 DESC;

--table of companies who beat order average with lifetime averageSELECT a.name account, AVG(o.total_amt_usd)
SELECT a.name account, AVG(o.total_amt_usd) average_spend
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(total_amt_usd)
				FROM orders)
ORDER BY 2 DESC;

--169 results

--find average of these 169 companies


SELECT AVG(average_spend) final_average
FROM(SELECT a.name account, AVG(o.total_amt_usd) average_spend
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY 1
HAVING AVG(o.total_amt_usd) > (SELECT AVG(total_amt_usd)
				FROM orders)
ORDER BY 2 DESC) sub;

--no need to use account table as name not required
--same approach having clause
--4721.1397439971747168 same answer
