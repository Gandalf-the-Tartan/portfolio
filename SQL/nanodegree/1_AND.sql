# AND, for multiple conditions in the WHERE clause

# using comparison operators
SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 AND gloss_qty = 0;

# using wildcard operators
SELECT name
FROM accounts
WHERE name NOT LIKE 'C%' AND name LIKE '%s';
