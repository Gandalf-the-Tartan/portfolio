--each account with sales rep and
--each sales rep with account

SELECT a.id account, s.id rep
FROM accounts a
FULL OUTER JOIN sales_reps s
ON s.id = a.sales_rep_id;
--correct 

--solution

SELECT *
FROM accounts
FULL JOIN sales_reps 
ON accounts.sales_rep_id = sales_reps.id



--each account without sales rep and
--each sales rep without account

SELECT a.id account, s.id rep
FROM accounts a
FULL OUTER JOIN sales_reps s
ON s.id = a.sales_rep_id
WHERE a.id IS NULL OR s.id is NULL;
--incorrect
--this shows where there would be no account at all?!
--WHERE a.sales_rep_id IS NULL...=each account without sales rep

--solution
SELECT *
FROM accounts
FULL JOIN sales_reps 
ON accounts.sales_rep_id = sales_reps.id
WHERE accounts.sales_rep_id IS NULL OR sales_reps.id IS NULL;
