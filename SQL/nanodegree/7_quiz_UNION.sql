SELECT *
FROM accounts

UNION ALL

SELECT *
FROM accounts



--2
SELECT *
FROM accounts
WHERE accounts.name = 'Walmart'

UNION ALL

SELECT *
FROM accounts
WHERE accounts.name = 'Disney'


--3
WITH double_accounts AS (SELECT *
	FROM accounts

	UNION ALL

	SELECT *
	FROM accounts)

SELECT COUNT(name)
FROM double_accounts;
--wrong
--this just counts every row

--solution
WITH double_accounts AS (
	    SELECT *
	      FROM accounts

	    UNION ALL

	    SELECT *
	      FROM accounts
)

SELECT name,
       COUNT(*) AS name_count
 FROM double_accounts 
GROUP BY 1
ORDER BY 2 DESC

