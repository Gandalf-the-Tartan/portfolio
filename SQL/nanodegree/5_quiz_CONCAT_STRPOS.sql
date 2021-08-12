--1
--Each company in the accounts table wants to create an email address for each primary_poc. The email address should be the first name of the primary_poc . last name primary_poc @ company name .com.

--using STRPOS and LEFT/RIGHT
SELECT CONCAT(LEFT(primary_poc, STRPOS(primary_poc, ' ')-1), RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')),'@', name, '.com')
FROM accounts;


--2
--You may have noticed that in the previous solution some of the company names include spaces, which will certainly not work in an email address. See if you can create an email address that will work by removing all of the spaces in the account name, but otherwise your solution should be just as in question 1. Some helpful documentation is here.

--substitution
OVERLAY(name PLACING '_' FROM POSITION(' ' IN name))

OVERLAY(name PLACING '_' FROM POSITION(' ' IN name))

SELECT CONCAT(LEFT(primary_poc, STRPOS(primary_poc, ' ')-1), RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')),'@', OVERLAY(name PLACING '_' FROM POSITION(' ' IN name)), '.com')
FROM accounts;
--negative substring not allowed
--possibly cases without space are causing error


--using overlay
SELECT 
CASE WHEN name LIKE '% %' THEN OVERLAY(name PLACING '_' FROM POSITION(' ' IN name)) 
END AS underscore
FROM accounts;
--this only does the first blank space

--using replace
SELECT REPLACE(name, ' ', '_')
FROM accounts;
--this works

--working answer
SELECT CONCAT(LEFT(primary_poc, STRPOS(primary_poc, ' ')-1), RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')),'@', REPLACE(name, ' ', '_'), '.com')
FROM accounts;



--3
--We would also like to create an initial password, which they will change after their first log in. The first password will be the first letter of the primary_poc's first name (lowercase), then the last letter of their first name (lowercase), the first letter of their last name (lowercase), the last letter of their last name (lowercase), the number of letters in their first name, the number of letters in their last name, and then the name of the company they are working with, all capitalized with no spaces.
SELECT primary_poc, CONCAT( LEFT(LOWER(primary_poc), 1), RIGHT(LOWER(primary_poc), STRPOS(' '), 1), LEFT(LOWER(primary_poc), STRPOS(' ')+1), RIGHT(LOWER(primary_poc), 1)) initial_password
FROM accounts;
--wrong order of LOWER and LEFT/RIGHT

--working answer
SELECT primary_poc, CONCAT(LOWER(LEFT(primary_poc, 1)), LOWER(SUBSTR(primary_poc,STRPOS(primary_poc, ' ')-1, 1)), LOWER(SUBSTR(primary_poc, STRPOS(primary_poc, ' ')+1, 1)), LOWER(RIGHT(primary_poc, 1)), STRPOS(primary_poc, ' ')-1, LENGTH(primary_poc)-STRPOS(primary_poc, ' '), REPLACE(UPPER(name), ' ', '')) initial_password
FROM accounts
ORDER BY 1;





--solution
--much less parentheses with ||
WITH t1 AS (
	 SELECT LEFT(primary_poc,     STRPOS(primary_poc, ' ') -1 ) first_name,  RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name, name
	 FROM accounts)
SELECT first_name, last_name, CONCAT(first_name, '.', last_name, '@', name, '.com'), LEFT(LOWER(first_name), 1) || RIGHT(LOWER(first_name), 1) || LEFT(LOWER(last_name), 1) || RIGHT(LOWER(last_name), 1) || LENGTH(first_name) || LENGTH(last_name) || REPLACE(UPPER(name), ' ', '')
FROM t1;

--all three questions together
--I did separate
--subselect table for formatting is probably better for reuse
--aliases used from t1 so first and last name clear in code
