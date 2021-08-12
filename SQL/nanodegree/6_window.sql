--shows total for year plus previous years for all entries of current year
--shows annual running total
SELECT occurred_at, standard_amt_usd, 
	SUM(standard_amt_usd) 
	OVER(ORDER BY DATE_TRUNC('year',occurred_at)) AS running_total
FROM orders
ORDER BY occurred_at;

--shows total for year ignoring other years
--so not running total at all
SELECT occurred_at, standard_amt_usd, 
	SUM(standard_amt_usd) 
	OVER(PARTITION BY DATE_TRUNC('year', occurred_at) 
		ORDER BY DATE_TRUNC('year',occurred_at)) AS running_total
FROM orders
        
--N.B. ORDER BY and PARTITION BY can both stand alone in the clause

--solution
--shows running total throughout year
SELECT standard_amt_usd,
       DATE_TRUNC('year', occurred_at) as year,
       SUM(standard_amt_usd) 
	OVER (PARTITION BY DATE_TRUNC('year', occurred_at) 
		ORDER BY occurred_at) AS running_total
FROM orders                               
ORDER BY occurred_at;




SELECT id,
       account_id,
       standard_qty,
       DATE_TRUNC('month', occurred_at) AS month,
       DENSE_RANK() OVER (PARTITION BY account_id) AS dense_rank,
       SUM(standard_qty) OVER (PARTITION BY account_id) AS sum_std_qty,
       COUNT(standard_qty) OVER (PARTITION BY account_id) AS count_std_qty,
       AVG(standard_qty) OVER (PARTITION BY account_id) AS avg_std_qty,
       MIN(standard_qty) OVER (PARTITION BY account_id) AS min_std_qty,
       MAX(standard_qty) OVER (PARTITION BY account_id) AS max_std_qty
FROM orders








SELECT id,
       account_id,
       DATE_TRUNC('year',occurred_at) AS year,
       DENSE_RANK() OVER account_by_year AS dense_rank,
       total_amt_usd,
       SUM(total_amt_usd) OVER account_by_year AS sum_total_amt_usd,
       COUNT(total_amt_usd) OVER account_by_year AS count_total_amt_usd,
       AVG(total_amt_usd) OVER account_by_year AS avg_total_amt_usd,
       MIN(total_amt_usd) OVER account_by_year AS min_total_amt_usd,
       MAX(total_amt_usd) OVER account_by_year AS max_total_amt_usd
FROM orders
WINDOW account_by_year AS (PARTITION BY account_id ORDER BY DATE_TRUNC('year',occurred_at))







--wrong
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) AS lead,
       LEAD(total_amt_usd) - total_amt_usd AS lead_difference
FROM orders;


--solution
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
  FROM orders 
 GROUP BY 1
) sub
--why is total_amt_usd summed for every row?

N.B.
SELECT occurred_at,
       SUM(total_amt_usd) AS total_amt_usd
       , total_amt_usd AS original
  FROM orders 
 GROUP BY 1,3;
--this produced the same in both total_amt_usd columns
--so why is there a need for sum?

--removing sum produces 4 more results!!!
SELECT occurred_at,
       total_amt_usd,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) AS lead,
       LEAD(total_amt_usd) OVER (ORDER BY occurred_at) - total_amt_usd AS lead_difference
FROM (
SELECT occurred_at,
       total_amt_usd
  FROM orders 

) sub




























































