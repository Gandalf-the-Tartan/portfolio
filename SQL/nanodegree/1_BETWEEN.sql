# BETWEEN AND, shorthand for >= AND <=

SELECT occurred_at, gloss_qty 
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

#N.B. includes end and start points
#saves writing: column  >= 24 AND column <= 29

#timestamp data type

SELECT *
FROM web_events
WHERE channel IN ('organic', 'adwords') AND occurred_at BETWEEN '2016-01-01' AND '2017-01-01'
ORDER BY occurred_at DESC;
