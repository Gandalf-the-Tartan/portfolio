--second from beginning attempt at project
--record answers and fill in the submission sheet
--syntax is probably better now, 
--so this attempt should focus more on NULL values
--also on correct table selections
--CASE statement for question 3(c)

/*
--N.B.

--NULL VALUES

--
Hey you will not include those values for calculating percentage whose forest land is NULL or total area is NULL.

You can simply add a where clause in your query to exclude these values.

Hope this helps!

--
Actually, yes you are right, there are some null values in the tables, however you should work on the database as it is without modifying null values, also you should ignore it.

--
You should not need to consider the null values. Either you may choose to drop them completely or while writing the queries, you can include them in the where clause like this:

WHERE forest_area_sqkm is not NULL

Hope this helps.

--


--QUARTILES

the code in the discussions uses case statements not NTILE

*/

/*
Steps to Complete

1.Create a View called “forestation” by joining all three tables - forest_area, land_area and regions in the workspace.
   
CREATE VIEW forestation 
AS
SELECT 	fa.country_code country_code,
	fa.country_name f_country_name,
	fa.year,
	fa.forest_area_sqkm,
	la.country_name l_country_name,
	la.total_area_sq_mi,
	(la.total_area_sq_mi * 2.59) total_area_sqkm,
	--the questions asks for all the original columns
	--can this be normalised or is there no point?
	(fa.forest_area_sqkm/(la.total_area_sq_mi*2.59)) * 100
		AS percentage_forest_area,
	r.country_name r_country_name,
	r.region,
	r.income_group
	
FROM forest_area fa
JOIN land_area la
ON fa.country_code = la.country_code
AND fa.year = la.year
JOIN regions r
ON r.country_code = fa.country_code;

SELECT *
FROM forestation

2.The forest_area and land_area tables join on both country_code AND year.
  
3.The regions table joins these based on only country_code.

--why not on country_name
--all three have the same information for country_name
--5886 results for each

--ACTUALLY they are not
--162 results for difference in name
--does region country name take precedence over the other tables
--given that it is the table specifically for regions?
--f and l country_name are identical

--ACTUALLY 
SELECT DISTINCT r_country_name, l_country_name
FROM forestation
WHERE r_country_name != l_country_name
--6 results are different not 162, that is with year presumably

--27 results for year on forest_area and land_area
--1990-2016


--218 results for country code for forest_area and land_area, 219 for regions


4. In the ‘forestation’ View, include the following:

	All of the columns of the origin tables
        
	A new column that provides the percent of the land area that is designated as forest.

5.Keep in mind that the column forest_area_sqkm in the forest_area table and the land_area_sqmi in the land_area table are in different units (square kilometers and square miles, respectively), so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km).


*/



/*

1. GLOBAL SITUATION

Instructions:

    Answering these questions will help you add information into the template.
    Use these questions as guides to write SQL queries.
    Use the output from the query to answer these questions.

a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.

--answer: 41282694.9

SELECT forest_area_sqkm
FROM forestation
WHERE country_code = 'WLD' AND year = 1990;

b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”

--answer: 39958245.9

SELECT forest_area_sqkm
FROM forestation
WHERE country_code = 'WLD' AND year = 2016;

c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?

--LAG =>

SELECT forest_area_sqkm - lag AS difference_forest_area
FROM(
SELECT year, forest_area_sqkm,
	LAG(forest_area_sqkm) OVER (ORDER BY forest_area_sqkm) AS lag 
FROM (SELECT year, forest_area_sqkm
	FROM forestation
	WHERE country_code = 'WLD' AND (year = 2016 OR year = 1990)
) sub
ORDER BY lag
LIMIT 1) sub2

--answer: 1324449

--LEAD =>


SELECT forest_area_sqkm - lead AS difference_forest_area
FROM(
SELECT year, forest_area_sqkm,
        LEAD(forest_area_sqkm) OVER (ORDER BY forest_area_sqkm) AS lead 
FROM (SELECT year, forest_area_sqkm
        FROM forestation
        WHERE country_code = 'WLD' AND (year = 2016 OR year = 1990)
) sub
ORDER BY lead
LIMIT 1) sub2

--answer: -1324449
--N.B. using same logic as lag gets the negative 
--but the change is an absolute value

--NULL =>
--using IS NOT NULL instead of LIMIT 1

SELECT forest_area_sqkm - lag AS difference_forest_area
FROM(
SELECT year, forest_area_sqkm,
        LAG(forest_area_sqkm) OVER (ORDER BY forest_area_sqkm) AS lag 
FROM (SELECT year, forest_area_sqkm
        FROM forestation
        WHERE country_code = 'WLD' AND (year = 2016 OR year = 1990)
) sub
ORDER BY lag) sub2
WHERE forest_area_sqkm - lag IS NOT NULL

--answer: 1324449

EXPERIMENTS =>

--COALESCE

SELECT forest_area_sqkm - COALESCE(lag, forest_area_sqkm) AS difference_forest_area
FROM(
SELECT year, forest_area_sqkm,
        LAG(forest_area_sqkm) OVER (ORDER BY forest_area_sqkm) AS lag 
FROM (SELECT year, forest_area_sqkm
        FROM forestation
        WHERE country_code = 'WLD' AND (year = 2016 OR year = 1990)
) sub
ORDER BY lag) sub2

--this replaces the NULL value with a 0
--it doen't help with the problem, it is just interesting
--N.B. ISNULL() does not exist in postgres, use COALESCE 

d. What was the percent change in forest area of the world between 1990 and 2016?

SELECT forest_area_sqkm - LAG(forest_area_sqkm) OVER (ORDER BY forest_area_sqkm) AS change
FROM(
SELECT year, forest_area_sqkm
FROM forestation
WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD'
ORDER BY year DESC) sub

--N.B. this is the same as the query above at this point
--so I may as well create a variable WITH

WITH change AS (
	SELECT forest_area_sqkm - LAG(forest_area_sqkm) OVER (ORDER BY forest_area_sqkm) AS change
	FROM(
		SELECT year, forest_area_sqkm
		FROM forestation
		WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD'
		ORDER BY year DESC) sub
	ORDER BY change
	LIMIT 1)

SELECT *
FROM change

--why will this not work? syntax error?!?!?!?!
--because without a SELECT following, it will do nothing

--percentage of the original number!

WITH change AS (
        SELECT forest_area_sqkm - LAG(forest_area_sqkm) OVER (ORDER BY forest_area_sqkm) AS change,
  		year, forest_area_sqkm
        FROM(
                SELECT year, forest_area_sqkm
                FROM forestation
                WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD'
                ORDER BY year DESC) sub
        ORDER BY change
        LIMIT 1)

SELECT (change/forest_area_sqkm)*100 AS percentage_change
FROM change



--answer: 3.20824258980244

--this is correct, but could use the percent column
--MAX and MIN are being a pain in the following however


SELECT MAX(percentage_forest_area)-MIN(percentage_forest_area) AS percentage_difference
FROM(
SELECT *
FROM forestation
WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD'
ORDER BY year) sub



--d. What was the percent change in forest area of the world between 1990 and 2016?
--using WITH and then scalar of max-min for calculation 
--works
--fat trimmed

WITH table1 AS (
SELECT year, percentage_forest_area
FROM forestation
WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD'
)


SELECT ((SELECT MAX(percentage_forest_area)-MIN(percentage_forest_area)
FROM table1)/percentage_forest_area)*100 AS percentage_change
FROM table1
WHERE year = 1990

--answer:3.22813528513264

--verfication;
--calculator answer:3.228135285
--computer answer:3.2281352851326024


--combining a,b,c and d

a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.
b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”
c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?
d. What was the percent change in forest area of the world between 1990 and 2016?

WITH global_change AS (
SELECT year, forest_area_sqkm, percentage_forest_area
FROM forestation
WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD'
)

--a
SELECT forest_area_sqkm
FROM global_change
WHERE year = 1990
--answer:41282694.9

--b
SELECT forest_area_sqkm
FROM global_change
WHERE year = 2016
--answer:39958245.9

--c
SELECT MAX(forest_area_sqkm)-MIN(forest_area_sqkm) AS change_sqkm
FROM global_change
--answer:1324449


--d
SELECT ((SELECT MAX(percentage_forest_area)-MIN(percentage_forest_area)
FROM global_change)/percentage_forest_area)*100 AS percentage_change
FROM global_change
WHERE year = 1990



e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?

--this is a comparison of c to countries
--use c as a scalar

SELECT r_country_name, total_area_sqkm
FROM forestation
WHERE year = 2016 

--above is country name and total_area_sqkm
--normalisation occurs in view

--e
SELECT r_country_name, total_area_sqkm
FROM forestation
WHERE year = 2016 AND total_area_sqkm < (SELECT MAX(forest_area_sqkm)-MIN(forest_area_sqkm) AS change_sqkm
FROM global_change
)
ORDER BY 2 DESC
LIMIT 1
--answer; peru 1279999.9891 => 1324447 - 1279999.9891 = 44449.0109
--this shows the closest less than 

SELECT r_country_name, total_area_sqkm
FROM forestation
WHERE year = 2016 AND total_area_sqkm > (SELECT MAX(forest_area_sqkm)-MIN(forest_area_sqkm) AS change_sqkm
FROM global_change
)
ORDER BY 2
LIMIT 1
--answer; mongolia 1553560.0108 => 1553560.0108 - 1324447 = 229113.0108
this shows the closest more than


--connect these somehow
--perhaps as a case statement
SELECT r_country_name
FROM forestation
WHERE  ...



--HOW ABOUT SUBTRACT FROM EACH VALUE IN TABLE AND THEN LIMIT 1?
--perhaps overkill, but easily understandable
--using answer to c as a scalar

--WITH table creation section
...,

change_sqkm AS (SELECT MAX(forest_area_sqkm)-MIN(forest_area_sqkm) AS change_sqkm
FROM global_change)

--e2
SELECT r_country_name, ABS((total_area_sqkm - (SELECT * FROM change_sqkm))) AS difference
FROM forestation
WHERE year = 2016
ORDER BY difference
--this shows the difference lowest to highest


SELECT r_country_name, ABS((total_area_sqkm - (SELECT * FROM change_sqkm))) AS difference_sqkm
FROM forestation
WHERE year = 2016
ORDER BY difference
LIMIT 1



=>EXPERIMENT
--e2
--this gives the most precise answer to the question
SELECT r_country_name AS country 
FROM(
SELECT 	r_country_name, 
	total_area_sqkm,
	(SELECT * FROM change_sqkm) AS change_1990_2016,
	ABS((total_area_sqkm - (SELECT * FROM change_sqkm))) AS difference_sqkm
FROM forestation
WHERE year = 2016
ORDER BY difference_sqkm
LIMIT 1) diff







--possibly do a less than, a greater than
--both with LIMIT 1
--then compare this?


--could all these questions be queried from one subtable, instead of creating a new one each time?
--yes see above

--MENTOR QUESTIONS FOR SECTION 1
--is change required as an absolute value, or specifically as an increase or decrease?

 
*/



2. REGIONAL OUTLOOK

Instructions:

    Answering these questions will help you add information into the template.
    Use these questions as guides to write SQL queries.

    Use the output from the query to answer these questions.

    Create a table that shows the Regions and their percent forest area (sum of forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
    Based on the table you created, ....

a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?


SELECT ROUND(percentage_forest_area::numeric, 2) AS percentage_forest_area
FROM forestation
WHERE year = 2016 AND country_code = 'WLD'

--answer: wld - 31.3755709643095


--checking against calculation
SELECT region, forest_area_sqkm, total_area_sqkm, (forest_area_sqkm/total_area_sqkm)*100
FROM forestation
WHERE year = 2016 AND country_code = 'WLD'

--answer: wld - 31.3755709643095


--checking against miles calculation
SELECT region, forest_area_sqkm, total_area_sq_mi, (forest_area_sqkm/(total_area_sq_mi*2.59))*100
FROM forestation
WHERE year = 2016 AND country_code = 'WLD'

--answer: wld - 31.3755709643095


--HIGHEST
--partition?

SELECT DISTINCT region,
	SUM(percentage_forest_area) OVER (PARTITION BY region) AS sum
FROM forestation
WHERE year = 2016

--something else
--counts countries in each region
SELECT region, COUNT(country_code) AS num_countries
FROM forestation
WHERE year = 2016
GROUP BY 1
ORDER BY 2 DESC

--make the actual table requested
--this is a basic version of just summing total area by region 
SELECT region, year, SUM(forest_area_sqkm)
FROM forestation
WHERE (year = 1990 OR year = 2016) AND region != 'World'
GROUP BY 1,2
ORDER BY 1,2


SELECT 	region,
	year, 
	SUM(forest_area_sqkm) AS total_forest,
       	SUM(total_area_sq_mi)*2.59 AS total_land,
	SUM(total_area_sq_mi*2.59) AS pre_calc,
	SUM(total_area_sqkm) AS normalised,
	SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59)*100 AS given
FROM forestation
WHERE (year = 1990 OR year = 2016) AND region != 'World'
GROUP BY 1,2
ORDER BY 1,2

--N.B. normalised and calculated are the same, which is good
--N.B. pre_calc and total_land are the same also

SELECT  region,
        year, 
        SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59)*100 AS percent
FROM forestation
WHERE year = 2016 AND region != 'World'
GROUP BY 1,2
ORDER BY percent DESC

--answer: Latin America & Caribbean	2016	46.1620721996047
--answer: Middle East & North Africa	2016	2.06826486871501

--with one query
SELECT  region,
        year, 
        ROUND((SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59)*100)::numeric, 2) AS percent
FROM forestation
WHERE year = 2016
GROUP BY 1,2
ORDER BY percent DESC

--answer: World				2016	31.3755709643095
--answer: Latin America & Caribbean     2016    46.1620721996047
--answer: Middle East & North Africa    2016    2.06826486871501


b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?

SELECT  region,
        year, 
        ROUND((SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59)*100)::numeric, 2) AS percent
FROM forestation
WHERE year = 1990
GROUP BY 1,2
ORDER BY percent DESC

--answer: World	1990	32.4222035575689
--answer: Latin America & Caribbean	1990	51.0299798667514
--answer: Middle East & North Africa	1990	1.77524062469353



c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?


--NOW AS A SINGLE WITH TABLE QUERIED

WITH regional_outlook AS
(SELECT  region,
        year, 
        ROUND((SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59)*100)::numeric, 2) AS percent
FROM forestation
WHERE year = 2016 OR year = 1990
GROUP BY 1,2
ORDER BY 1,2)

SELECT * 
FROM regional_outlook



--a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?

--a
SELECT *
FROM regional_outlook 
WHERE year = 2016
ORDER BY percent DESC

--answer: World				2016	31.3755709643095
--answer: Latin America & Caribbean	2016	46.1620721996047
--answer: Middle East & North Africa	2016	2.06826486871501

SELECT region, year, percent, ROUND(percent)
FROM regional_outlook 
WHERE year = 2016
ORDER BY percent DESC
--this rounds but does not work with ROUND(percent, 2)

SELECT region, year, ROUND(percent::numeric, 2) AS percent
FROM regional_outlook 
WHERE year = 2016
ORDER BY percent DESC
--this works
--it converts percent to a numeric type which can be modified with numeric function

--b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?

--b
SELECT *
FROM regional_outlook 
WHERE year = 1990
ORDER BY percent DESC

--now round 2 d.p. in the above query

--this answers all three questions
--is the priority the fewest queries, or the most specific queries
--is the context required or just a scalar as the answer

SELECT region, year, ROUND(percent::numeric, 2) AS percent
FROM regional_outlook 
WHERE year = 1990
ORDER BY percent DESC


--c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?

--c
SELECT *
FROM regional_outlook  
ORDER BY percent DESC

--try MAX on partition by region where 1990 is MAX
--try subtracting 2016 from 1990 percent by partition of region

SELECT region, year, MAX(percent) OVER (PARTITION BY region)
FROM regional_outlook
GROUP BY region, year


SELECT region, year, percent, MAX(percent) OVER (PARTITION BY region)
FROM regional_outlook

--this shows the MAX of the two years for each region

SELECT 	region,
	year,
       	percent,
       	MAX(percent) OVER (PARTITION BY region) AS max
FROM regional_outlook

--use this as a subquery

SELECT * 
FROM(SELECT  region,
        year,
        percent,
        MAX(percent) OVER (PARTITION BY region) AS max
    FROM regional_outlook) sub
WHERE (percent = max) AND year = 1990

--this shows only those regions where there has been a decrease

--answer:
Latin America & Caribbean	1990	51.0299798667514	51.0299798667514
Sub-Saharan Africa		1990	30.6741454610006	30.6741454610006
World				1990	32.4222035575689	32.4222035575689

--show 1990 and 2016 for these
SELECT 	region,
				year,
				percent
WHERE year = 2016 AND year = 1990

*/



 
3. COUNTRY-LEVEL DETAIL

Instructions:

    Answering these questions will help you add information into the template.
    Use these questions as guides to write SQL queries.
    Use the output from the query to answer these questions.

a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?

SELECT 	r_country_name,
	year, 
	forest_area_sqkm,
	SUM(forest_area_sqkm) OVER (PARTITION BY r_country_name) AS combined
FROM forestation  
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3
ORDER BY 1,2
--the above partitions into regions and performs an aggregate
--now create a lag


SELECT  r_country_name,
        year, 
        forest_area_sqkm,
        LAG(forest_area_sqkm)
       		OVER (PARTITION BY r_country_name) -forest_area_sqkm
	       		AS decrease
FROM forestation  
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3
ORDER BY 1,2
--subselect of decrease from 1990 to 2016 where decrease > 0

SELECT r_country_name, region, decrease_sqkm
FROM
(SELECT  r_country_name,
 		region,
        year, 
        forest_area_sqkm,
        LAG(forest_area_sqkm)
                OVER (PARTITION BY r_country_name) -forest_area_sqkm
                        AS decrease_sqkm
FROM forestation  
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3,4
ORDER BY 1,2,3
) sub
WHERE year = 2016 AND decrease_sqkm IS NOT NULL AND r_country_name != 'World'
ORDER BY decrease_sqkm DESC
LIMIT 5
--filters out world, as not a country
--shows only top 5
--format; use names for outer selects

--answer:
r_country_name	year		forest_area_sqkm	decrease
Brazil		2016		4925540			541510
Indonesia	2016		903256.0156		282193.9844
Myanmar		2016		284945.9961		107234.0039
Nigeria		2016		65833.99902		106506.00098
Tanzania	2016		456880			102320

--increase instead

SELECT * 
FROM(SELECT  r_country_name,
        year, 
        forest_area_sqkm,
        LAG(forest_area_sqkm)
                OVER (PARTITION BY r_country_name) -forest_area_sqkm
                        AS increase_sqkm
FROM forestation  
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3
ORDER BY 1,2 DESC) sub
WHERE increase_sqkm IS NOT NULL
ORDER BY increase_sqkm DESC

b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?

--percentage decrease = ((starting value - final value)/starting value)*100
=>
SELECT 	r_country_name,
	year,
	forest_area_sqkm,
	ROUND((((forest_area_sqkm - LEAD(forest_area_sqkm)
		OVER (PARTITION BY r_country_name))/forest_area_sqkm)*100)::numeric, 2)
			AS percentage_decrease	
FROM forestation
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3
ORDER BY 1,2,
--subquery with casting to 2 dp

SELECT *
FROM(
SELECT  r_country_name,
		region,
        year,
        forest_area_sqkm,
        ROUND((((forest_area_sqkm - LEAD(forest_area_sqkm)
                OVER (PARTITION BY r_country_name))/forest_area_sqkm)*100)::numeric, 2)
                        AS percentage_decrease  
FROM forestation
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3,4
ORDER BY 1,2,3
) sub
WHERE year = 1990 AND r_country_name != 'World' AND  percentage_decrease IS NOT NULL
ORDER BY percentage_decrease DESC
LIMIT 5

--answer:
r_country_name	year	forest_area_sqkm	percentage_decrease
Togo		1990	6850			75.45
Nigeria		1990	172340			61.80
Uganda		1990	47510			59.13
Mauritania	1990	4150			46.75
Honduras	1990	81360			45.03

--just do percent change
SELECT *
FROM(SELECT  r_country_name,
        year,
        forest_area_sqkm,
        ROUND((((forest_area_sqkm - LEAD(forest_area_sqkm)
                OVER (PARTITION BY r_country_name))/forest_area_sqkm)*100)::numeric, 2)
                        AS percentage_change  
FROM forestation
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3
ORDER BY 1,2 DESC) sub
WHERE percentage_change IS NOT NULL
ORDER BY percentage_change DESC

c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?

SELECT 	r_country_name,
	percentage_forest_area,
	NTILE (4) OVER (ORDER BY percentage_forest_area)
		AS quartile
FROM forestation
WHERE year = 2016 AND r_country_name != 'World'
	AND percentage_forest_area IS NOT NULL

--creates quartiles of countries by percent forestation
--except it doesnt!! quartile 4 from 49 percent
-- do I need to eliminate nulls first?

SELECT 	r_country_name,
	percentage_forest_area,
	NTILE (4) OVER (ORDER BY percentage_forest_area)
		AS quartile
FROM(
SELECT  r_country_name,
        percentage_forest_area
FROM forestation
WHERE year = 2016 AND r_country_name != 'World'
        AND percentage_forest_area IS NOT NULL
) sub

--this makes no difference to the result
--maybe it is correct, perhaps 49 percent is more than 75 percent 
--of the other countries

--other students have used case statements instead
--so what is the point of NTILE?


--USING CASE STATEMENT INSTEAD

SELECT	r_country_name,
	percentage_forest_area,
CASE 
WHEN percentage_forest_area BETWEEN 0 AND 25 
	THEN 1
WHEN percentage_forest_area BETWEEN 25 AND 50
	THEN 2
WHEN percentage_forest_area BETWEEN 50 AND 75
	THEN 3
ELSE 4
END AS quartile
FROM forestation
WHERE year = 2016 AND r_country_name != 'World'
	AND percentage_forest_area IS NOT NULL	

--this works and does the 'quartiles'
--the definition of quartiles given is incorrect, as pointed out by
--another student

--now as subquery

SELECT quartile, COUNT(r_country_name)
FROM(
SELECT  r_country_name,
        percentage_forest_area,
CASE 
WHEN percentage_forest_area BETWEEN 0 AND 25 
        THEN 1
WHEN percentage_forest_area BETWEEN 25 AND 50
        THEN 2
WHEN percentage_forest_area BETWEEN 50 AND 75
        THEN 3
ELSE 4
END AS quartile
FROM forestation
WHERE year = 2016 AND r_country_name != 'World'
        AND percentage_forest_area IS NOT NULL  ) sub
GROUP BY quartile
ORDER BY quartile


c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?

=>

SELECT percentage_quartile, COUNT(r_country_name)
FROM(
SELECT  r_country_name,
        percentage_forest_area,
CASE 
WHEN percentage_forest_area BETWEEN 0 AND 25 
        THEN '0-25'
WHEN percentage_forest_area BETWEEN 25 AND 50
        THEN '25-50'
WHEN percentage_forest_area BETWEEN 50 AND 75
        THEN '50-75'
ELSE '75-100'
END AS percentage_quartile
FROM forestation
WHERE year = 2016 AND r_country_name != 'World'
        AND percentage_forest_area IS NOT NULL  ) sub
GROUP BY percentage_quartile
ORDER BY percentage_quartile


d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.


SELECT r_country_name, percentage_quartile
FROM(
SELECT  r_country_name,
        percentage_forest_area,
CASE 
WHEN percentage_forest_area BETWEEN 0 AND 25 
        THEN '0-25'
WHEN percentage_forest_area BETWEEN 25 AND 50
        THEN '25-50'
WHEN percentage_forest_area BETWEEN 50 AND 75
        THEN '50-75'
ELSE '75-100'
END AS percentage_quartile
FROM forestation
WHERE year = 2016 AND r_country_name != 'World'
        AND percentage_forest_area IS NOT NULL  ) sub
WHERE percentage_quartile = '75-100'

--answer:
 Download CSV
r_country_name		percentage_quartile
American Samoa		75-100
Micronesia, Fed. Sts.	75-100
Gabon			75-100
Guyana			75-100
Lao PDR			75-100
Palau			75-100
Solomon Islands		75-100
Suriname		75-100
Seychelles		75-100


e. How many countries had a percent forestation higher than the United States in 2016?


*/
