-- JOIN, division of labour
-- SF[JO]WOL

-- dot notation: table.column
-- FROM table1
-- JOIN table2 ON table1.shared_column = table2.shared_column
-- notation: many to one (crow's foot), 

-- order of presentation is shared column, first table, second table
SELECT accounts.*, orders.*
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

-- displaying specific columns
-- N.B. ON clause can have any order of equality: a = b , b = a
SELECT orders.standard_qty, orders.gloss_qty, orders.poster_qty, accounts.website, accounts.primary_poc
FROM accounts
JOIN orders
ON accounts.id = orders.account_id;

-- joining more than two
SELECT *
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id
-- now that accounts is joined to web_ events, orders is joined to accounts
-- is there a best practice here?
-- N.B. order of joins is arbitrary

-- aliases for shorter code, NOT for naming columns
-- FROM tablename AS t1
-- JOIN tablename2 AS t2

-- aliases for shorter code AND for naming columns
--Select t1.column1 aliasname, t2.column2 aliasname2
--FROM tablename AS t1
--JOIN tablename2 AS t2

--N.B. always provide a SELECT alias when same column name in different tables
