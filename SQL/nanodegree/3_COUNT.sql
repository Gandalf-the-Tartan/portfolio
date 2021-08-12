-- COUNT requires AS alias, function notation COUNT(parameter)

-- count all rows in (primary key column?) in accounts
SELECT COUNT(*)
FROM accounts;

-- count specific column in accounts
SELECT COUNT(accounts.id)
FROM accounts;

-- N.B. function only accepts one argument
-- N.B. COUNT ignores rows with NULL values
