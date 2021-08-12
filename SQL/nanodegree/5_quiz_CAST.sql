--1
--write a query to look at the top 10 rows to understand the columns and the raw data in the dataset called sf_crime_data

--currently all string type
--large table 30400 results

SELECT CONCAT(SUBSTR(date, 7, 4), '-', SUBSTR(date, 1, 2), '-', SUBSTR(date, 4,2))
FROM sf_crime_data
LIMIT 10;



SELECT CAST((SUBSTR(date, 7, 4), '-', SUBSTR(date, 1, 2), '-', SUBSTR(date, 4,2)) AS DATE)
FROM sf_crime_data
LIMIT 10;
--cannot cast type record to date
--this is because there is no concat operation so the commas mean something else
--|| is concatention


SELECT CAST(CONCAT(SUBSTR(date, 7, 4), '-', SUBSTR(date, 1, 2), '-', SUBSTR(date, 4,2)) AS DATE)
FROM sf_crime_data
LIMIT 10;
--now it works


SELECT date orig, (SUBSTR(date, 7, 4) || '-'|| SUBSTR(date, 1, 2) || '-'|| SUBSTR(date, 4,2))::DATE new_date
FROM sf_crime_data
LIMIT 10;
--wtf are the pipes for?

SELECT (SUBSTR(date, 7, 4) || '-'|| SUBSTR(date, 1, 2) || '-'|| SUBSTR(date, 4,2))::DATE new_date
FROM sf_crime_data
LIMIT 10;
--also now works

SELECT CAST((SUBSTR(date, 7, 4) || '-'|| SUBSTR(date, 1, 2) || '-'|| SUBSTR(date, 4,2)) AS DATE) new_date
FROM sf_crime_data
LIMIT 10;
--also now works

SELECT CAST((SUBSTR(date, 7, 4) || '-'|| SUBSTR(date, 1, 2) || '-'|| SUBSTR(date, 4,2)) AS DATE)
FROM sf_crime_data
LIMIT 10;
--also now works




--solution
SELECT date orig_date, (SUBSTR(date, 7, 4) || '-' || LEFT(date, 2) || '-' || SUBSTR(date, 4, 2))::DATE new_date
FROM sf_crime_data;
