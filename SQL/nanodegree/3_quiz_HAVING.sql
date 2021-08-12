--1
--How many of the sales reps have more than 5 accounts that they manage?

SELECT s.id, s.name rep, COUNT(*) num_accounts
FROM accounts a
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
HAVING COUNT(*) > 5
ORDER BY num_accounts;

--the inner join creates a subset of sales reps and any associated information
--any sales reps without a sales_rep_id in the accounts table are dropped
--in this table s.id and s.name are unique, but this wont always be the case
--s.id is the primary key
--GROUP BY needs the non-aggregates s.id and s.name as this informs the
--following COUNT aggregation.
--COUNT(*) will count all the primary keys in accounts table with a matching
--sales_rep_id, so a.id is unnecessary
--the alias num_accounts cannot go in the HAVING condition
--however ORDER BY must come later as the aggregate can be used to order the
--data
--it is probably a good idea to include one of the primary keys in the SELECT
--HAVING COUNT(*) <= 5 has 16 so query is correct (34/50 for > 5)


--2
--How many accounts have more than 20 orders?

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING COUNT(*) > 20
ORDER BY num_orders;

--120
--230 <= 
--6912 orders => without HAVING 350 results so correct

--3
--Which account has the most orders?

SELECT a.id, a.name, COUNT(*) num_orders
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY num_orders DESC
LIMIT 1;

--can aggregations go inside aggregations?
--no need for having clause here
--COUNT is needed to create a new column so MAX cannot be used?

--4
--Which accounts spent more than 30,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) as total_orders_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_orders_usd DESC;

--204
-- <= results 146 => 350 so correct
-- the values in the total_amt_usd column are summed for each company


--5
--Which accounts spent less than 1,000 usd total across all orders?
SELECT a.id, a.name, SUM(o.total_amt_usd) as total_orders_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_orders_usd DESC;

--only 3 companies, 347 >=


--6
--Which account has spent the most with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) as total_orders_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_orders_usd DESC
LIMT 1;

--superlatives have no HAVING condition, but order by descent and limit to 1
--totals require summing first then sifting
--max only good for single order
--answer: EOG Resources

--7
--Which account has spent the least with us?
SELECT a.id, a.name, SUM(o.total_amt_usd) as total_orders_usd
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_orders_usd
LIMIT 1;

--superlative total
--answer:nike

--8
--Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.id, a.name, COUNT(*) facebook_contact
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE channel = 'facebook'
GROUP BY a.id, a.name
HAVING COUNT(*) > 6
ORDER BY facebook_contact  DESC;

--WHERE conditions required to narrow down the subset before aggregation
--don't forget dot notation for all columns! w.channel is safer to use

--solution given:
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY use_of_channel;

--N.B. WHERE condition can be placed in HAVING clause

--9
--Which account used facebook most as a channel? 
SELECT a.id, a.name, COUNT(*) facebook_contact
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE channel = 'facebook'
GROUP BY a.id, a.name
ORDER BY facebook_contact  DESC
LIMIT 1;

--superlative tally
--answer: Gilead Sciences

--10
--Which channel was most frequently used by most accounts?

--this is an ambiguous question

--apparantly
SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 10;

--COUNT on string types counts matching strings



--subselects
--1
SELECT COUNT(*) num_reps_above5
FROM(SELECT s.id, s.name, COUNT(*) num_accounts
	     FROM accounts a
	     JOIN sales_reps s
	     ON s.id = a.sales_rep_id
	     GROUP BY s.id, s.name
	     HAVING COUNT(*) > 5
	     ORDER BY num_accounts) AS Table1;
--this will return only one column instead of three 
--this is like a nested query

--2
SELECT COUNT(*) num_accounts_above20orders -- "num accounts above etc."
FROM(SELECT a.id, a.name, COUNT(*) num_orders
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.id, a.name
	HAVING COUNT(*) > 20
	ORDER BY num_orders) AS Table1;
--what does AS Table1 do?

--3
SELECT Table1.name "account with most orders"
FROM(SELECT a.id, a.name, COUNT(*) num_orders
	FROM accounts a
	JOIN orders o
	ON a.id = o.account_id
	GROUP BY a.id, a.name
	ORDER BY num_orders DESC
	LIMIT 1) AS Table1;
--Table1 is just an alias to refer to column names with dot notation

--4
SELECT COUNT (*) "number of accounts spending over $30,000"
FROM(SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) > 30000
ORDER BY total_spent) AS Table1;

--omitting table alias resulted in error

--5
SELECT COUNT(*) accounts_lt_1000
FROM(SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
HAVING SUM(o.total_amt_usd) < 1000
ORDER BY total_spent) AS Table1;

--6
SELECT Table1.name "most lucrative account"
FROM(SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent DESC
LIMIT 1) AS Table1;

--which queries require superlative name column

--7
SELECT Table1.name worst_account
FROM(SELECT a.id, a.name, SUM(o.total_amt_usd) total_spent
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.id, a.name
ORDER BY total_spent
LIMIT 1) As Table1;

--8
SELECT Table1.name "accounts using facebook 6+ times"
FROM(SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY a.id, a.name, w.channel
HAVING COUNT(*) > 6 AND w.channel = 'facebook'
ORDER BY a.name) AS Table1;

--which plural queries require Table1.name column
--alphabetical order probably best here

--9
SELECT Table1.name "most avid facebook user"
FROM(SELECT a.id, a.name, w.channel, COUNT(*) use_of_channel
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name, w.channel
ORDER BY use_of_channel DESC
LIMIT 1) AS Table1;


