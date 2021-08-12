--1
--In the accounts table, there is a column holding the website for each company. The last three digits specify what type of web address they are using. A list of extensions (and pricing) is provided here. Pull these extensions and provide how many of each website type exist in the accounts table.

--list of website extensions

WITH extensions AS (SELECT RIGHT(a.website, 3)
			FROM accounts a)

--just counts 351
SELECT COUNT(*)
FROM extensions;

--correct query
SELECT *, COUNT(*)
FROM extensions
GROUP BY 1;


--shows three types
SELECT DISTINCT *
FROM extensions;


--solution
--list domain name THEN count them
SELECT RIGHT(website, 3) AS domain, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

--c.f.////////////////
SELECT channel
FROM web_events;

SELECT channel, COUNT(*)
FROM web_events
GROUP BY 1;
--where the first one lists all event channels
--and the second one counts how many of each type
--///////////////////



--2
--There is much debate about how much the name (or even the first letter of a company name) matters. Use the accounts table to pull the first letter of each company name to see the distribution of company names that begin with each letter (or number). 


SELECT LEFT(name,1) initial_alfanumeric, COUNT(*) num_companies
FROM accounts
GROUP BY 1
ORDER BY 2 DESC;

--solution
--same but LEFT(UPPER(name), 1) so f and F etc. not separate
--26 rather than 27 result due to this


--3
--Use the accounts table and a CASE statement to create two groups: one group of company names that start with a number and a second group of those company names that start with a letter. What proportion of company names start with a letter?

--create one column and enter 2 possible values, then count
SELECT 
CASE WHEN LEFT(name, 1) IN ('0','1','2','3','4','5','6','7','8','9') THEN 'number'
	ELSE 'letter' 
END AS alpanumeric,
COUNT (*)
FROM accounts
GROUP BY 1;

--solution
--assigns boolean values over two columns
--aggregates subquery
--1 or 0 allows for SUM instead of COUNT
--this has two columns instead of mine which has two rows
SELECT SUM(num) nums, SUM(letter) letters
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9')
			THEN 1 ELSE 0 END AS num,
		CASE WHEN LEFT(UPPER(name), 1) IN ('0','1','2','3','4','5','6','7','8','9')
			THEN 0 ELSE 1 END AS letter
	FROM accounts) t1;

--4
--Consider vowels as a, e, i, o, and u. What proportion of company names start with a vowel, and what percent start with anything else?


SELECT 
CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U') 
	THEN 'vowel'
	ELSE 'other' 
END AS vowel,
COUNT (*) 
FROM accounts
GROUP BY 1;

--again mine is in rows and solution is in columns

--solution
SELECT SUM(vowels) vowels, SUM(other) other
FROM (SELECT name, CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
			THEN 1 ELSE 0 END AS vowels,
		CASE WHEN LEFT(UPPER(name), 1) IN ('A','E','I','O','U')
			THEN 0 ELSE 1 END AS other
	FROM accounts) t1;
