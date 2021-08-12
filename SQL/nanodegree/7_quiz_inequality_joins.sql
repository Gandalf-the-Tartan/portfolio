--show where name of primary poc
--comes before sales rep name
--in alphabet

SELECT a.name account, a.primary_poc, s.name
FROM accounts a
LEFT JOIN sales_reps s
ON s.id = a.sales_rep_id
AND a.primary_poc < s.name;
--correct

--experiment

--show the reverse to above
SELECT a.name account, a.primary_poc, s.name
FROM accounts a
LEFT JOIN sales_reps s
ON s.id = a.sales_rep_id
AND a.primary_poc > s.name
ORDER BY account;
