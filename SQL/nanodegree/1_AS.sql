# AS, used for derived columns created with arithmetic operators
# *,+,-,/
# parenthesis to override order or operations

SELECT id, account_id, 
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per
FROM orders
LIMIT 10;


#column, operations AS derived_column, column
SELECT account_id, 
   poster_amt_usd/(standard_amt_usd + gloss_amt_usd + poster_amt_usd) AS post_per, id
FROM orders
LIMIT 10;

