# IN, check against multiple values in a list
# used in WHERE clause instead of comparison operator

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');


