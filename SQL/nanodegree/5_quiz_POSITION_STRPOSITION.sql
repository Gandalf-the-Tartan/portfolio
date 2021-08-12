--1
--Use the accounts table to create first and last name columns that hold the first and last names for the primary_poc. 

SELECT SUBSTR(primary_poc, 1, POSITION(' ' IN primary_poc)) first_name, SUBSTR(primary_poc, POSITION(' ' IN primary_poc)+1) last_name
FROM accounts a;
--works




--solution
--uses totally different functions

SELECT LEFT(primary_poc, STRPOS(primary_poc, ' ') -1 ) first_name, 
RIGHT(primary_poc, LENGTH(primary_poc) - STRPOS(primary_poc, ' ')) last_name
FROM accounts;


--2
SELECT SUBSTR(name, 1, POSITION(' ' IN name)) first_name, SUBSTR(name, POSITION(' ' IN name)+1) last_name
FROM sales_reps;


--solution
--different functions, same answer
SELECT LEFT(name, STRPOS(name, ' ') -1 ) first_name, 
       RIGHT(name, LENGTH(name) - STRPOS(name, ' ')) last_name
FROM sales_reps;

