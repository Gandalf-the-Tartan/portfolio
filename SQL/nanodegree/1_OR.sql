# OR, inclusive or



SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);
# first condition applies to each of the parenthesized conditions
# it has been 'factored out'


