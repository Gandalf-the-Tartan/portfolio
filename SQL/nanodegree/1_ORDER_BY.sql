# ORDER BY
# N.B. the column does not have to be selected to be used to order the result

SELECT id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at
LIMIT 10;

#penultimate position, default ASC (low-high), override with DESC
#default order may be primary key column
#ORDER BY column1, column2 #(column 1 then column 2 (both ascending))

SELECT id, account_id, total_amt_usd
FROM orders
ORDER BY account_id, total_amt_usd DESC;
