# WHERE

# antepenultimate position, comparison operator to filter data
# >, <, >=, <=, =, !=

SELECT *
FROM orders
WHERE gloss_amt_usd >= 1000
LIMIT 5;

#N.B. no ORDER BY clause so antepenultimate is penultimate

# comparing non-numeric data
SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

