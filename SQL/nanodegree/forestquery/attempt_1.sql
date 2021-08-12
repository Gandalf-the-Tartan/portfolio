With forestation AS (
	SELECT *, (fa.forest_area_sqkm/(la.total_area_sq_mi)*2.59)*100 AS percentage_forest_sqkm
	--normalise units
	FROM forest_area fa
	JOIN land_area la
	ON fa.country_code = la.country_code
	AND fa.year = la.year
	JOIN regions r
	ON r.country_code = fa.country_code
)

SELECT *
FROM forestation;
--this seems to work and answers all the following criteria
--all my column references are 'ambiguous'


--apparantly this is not a view
CREATE VIEW forestation
AS
SELECT *, (fa.forest_area_sqkm/(la.total_area_sq_mi)*2.59)*100 AS percentage_forest_sqkm
--normalise units
FROM forest_area fa
JOIN land_area la
ON fa.country_code = la.country_code
AND fa.year = la.year
JOIN regions r
ON r.country_code = fa.country_code;
--column "country_code" specified more than once

--approach
--create view for just forest_area and land_area

CREATE VIEW forestation
AS
SELECT fa.country_code AS country_code,
fa.country_name AS country_name,
fa.year AS year,
fa.forest_area_sqkm AS forest_area_sqkm,
la.total_area_sq_mi AS total_area_sq_mi,
(fa.forest_area_sqkm/(la.total_area_sq_mi * 2.59))*100 AS percentage_forest_sqkm,
r.region AS region,
r.income_group AS income_group
FROM forest_area fa
JOIN land_area la
ON fa.country_code = la.country_code
AND fa.year = la.year
JOIN regions r
ON r.country_code = fa.country_code;
--removing select * has prevented some problems
--assigning aliases to every row
--works (but is it what I need?)
--DROP VIEW forestation; --this will remove a view
--percentage column now correct

/*
1.    Create a View called “forestation” by joining all three tables - forest_area, land_area and regions in the workspace.
   
2.The forest_area and land_area tables join on both country_code AND year.

3.The regions table joins these based on only country_code.


4.In the ‘forestation’ View, include the following:

	All of the columns of the origin tables
        A new column that provides the percent of the land area that is designated as forest.

--SELECT * does not work as it states there are ambiguous columns!

5.	Keep in mind that the column forest_area_sqkm in the forest_area table and the land_area_sqmi in the land_area table are in different units (square kilometers and square miles, respectively), so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km).

*/




--part 1

/*1. GLOBAL SITUATION

Instructions:

    Answering these questions will help you add information into the template.
    Use these questions as guides to write SQL queries.
    Use the output from the query to answer these questions.

a. What was the total forest area (in sq km) of the world in 1990?

SELECT forest_area_sqkm
FROM forestation
WHERE country_code = 'WLD' AND year = 1990;

--answer: 41 282 694.9


SELECT SUM(forest_area_sqkm)
FROM forestation
WHERE year = 1990;

82 016 472.036028
--is this summing and then added the WLD
--it is roughly twice as much but not quite?!

Please keep in mind that you can use the country record denoted as “World" in the region table.
=>
SELECT *
FROM regions
WHERE region = 'World';

b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”

SELECT forest_area_sqkm
FROM forestation
WHERE year = 2016 AND country_code = 'WLD';

--answer: 39 958 245.9

c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?

SELECT (MAX(*)-MIN(*)) AS difference
FROM(
SELECT forest_area_sqkm
FROM forestation
WHERE (year = 2016 OR year = 1990) AND country_code = 'WLD'
)sub;
--doesnt work

--attempt 2
SELECT MAX(forest_area_sqkm)-MIN(forest_area_sqkm) AS difference
FROM forestation
WHERE (year = 2016 OR year = 1990) AND country_code = 'WLD'

--answer:1 324 449


d. What was the percent change in forest area of the world between 1990 and 2016?

SELECT year, forest_area_sqkm, percentage_forest_sqkm
FROM forestation
WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD';

=>
SELECT MAX(percentage_forest_sqkm)-MIN(percentage_forest_sqkm) AS percent_changeFROM forestation
WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD';

--answer:1.04663259325941
--this is incorrect
--this does what 
--answer on attempt_2.sql is correct

SELECT MAX(percentage_forest_sqkm)-MIN(percentage_forest_sqkm) AS percent_difference
FROM forestation
WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD'
ORDER BY year;



e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?

--use lag ?
SELECT year,
	forest_area_sqkm,
	LEAD(forest_area_sqkm) OVER (ORDER BY year) AS lead,
	LEAD(forest_area_sqkm) OVER (ORDER BY year) - forest_area_sqkm 
		AS difference
FROM(
SELECT year,
	forest_area_sqkm
FROM forestation
WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD') sub
ORDER BY year DESC;
--this ...actually works!
--answer: -1 324 449
--this is nonsense, do this section of the course again

--now comparing to countries total area
SELECT country_code, total_area_sq_mi
FROM forestation
WHERE year = 2016;

probably India, but how should this be calculated in SQL
 
 */


--problem 1
SELECT *
FROM forestation
WHERE year = 2016;
--column reference "year" is ambiguous
--yet SELECT * shows year column



--part 2
/*2. REGIONAL OUTLOOK

Instructions:

    Answering these questions will help you add information into the template.
    Use these questions as guides to write SQL queries.

    Use the output from the query to answer these questions.

    Create a table that shows the Regions and their percent forest area (sum of forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
    Based on the table you created, ....

SELECT region, country_code, year, percentage_forest_sqkm
FROM forestation
WHERE year = 1990 OR year = 2016
ORDER BY 1, 2, 3;
--N.B. many countries in each region
--sum percentages already calculated?

SELECT region, 
country_code,
year, 
(SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59))*100 AS region_percentage_forest_area
FROM forestation
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3
ORDER BY 1, 2, 3;
--seems to work
--why are there NULL rows?
--436 results (why not 438?)

SELECT region
FROM regions;
--there are 219 country_name in regions
--there are 8 distinct regions

--should I partition to sum?

SELECT region, 
country_code,
year, 
(SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59))*100 
	OVER (PARTITION BY region) AS region_percentage_forest_area
FROM forestation
WHERE year = 1990 OR year = 2016
GROUP BY 1,2,3
ORDER BY 1, 2, 3;
???

--possibly this
SELECT region, year,
(SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59))*100 AS region_percentage_forest
FROM forestation
WHERE year = 1990 OR year = 2016
GROUP BY 1, 2
ORDER BY 1, 2 DESC;
--16 results, 2 for each of 8 regions 
--N.B. 7 continents and the world

a. What was the percent forest of the entire world in 2016? Which region had the HIGHEST percent forest in 2016, and which had the LOWEST, to 2 decimal places?

--answers:
	world - 31.38% (2 d.p.)
	region highest- Latin America & Caribbean 46.16% (2 d.p.)
	region lowest- South Asia 17.51% (2 d.p.)


b. What was the percent forest of the entire world in 1990? Which region had the HIGHEST percent forest in 1990, and which had the LOWEST, to 2 decimal places?

--answers:
	world - 32.42% (2 d.p.)
	region highest - Latin America & Caribbean 51.03 (2 d.p.)
	region lowest - South Asia 16.51 (2 d.p.)

c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?

--answers:
	Latin America & Caribbean
	Sub-Saharan Africa
	World
 
 */


--part 3

/*3. COUNTRY-LEVEL DETAIL

Instructions:

    Answering these questions will help you add information into the template.
    Use these questions as guides to write SQL queries.
    Use the output from the query to answer these questions.

a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?

SELECT country_code, country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 1990 OR year = 2016
ORDER BY 1,3;
--this subquery can now be aggregated and then ordered with limit 5
--1990 figure - 2016 figure is the decrease 


SELECT	country_code, 
	country_name,
       	year,
	LEAD(forest_area_sqkm) OVER (ORDER BY year) AS lead
	LEAD(forest_area_sqkm) OVER (ORDER BY year) - forest_area_sqkm
		AS decrease
FROM(
SELECT country_code, country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 1990 OR year = 2016
ORDER BY 1,3)
GROUP BY 1,2,3;

--this doesn't calculate what it is meant to
--countries are calculating by other countries
--some kind of partition is needed


--step 1 just sum the two entries
SELECT  country_code, 
        country_name,
        year,
        LEAD(forest_area_sqkm) 
	OVER (PARTITION BY country_code ORDER BY year) - forest_area_sqkm
                AS decrease
FROM(
SELECT country_code, country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 1990 OR year = 2016
ORDER BY 1,3) sub
ORDER BY decrease DESC;
--this works, but half of the entries (2016) have NULL
--outer select may be necessary as whereing only one year messes it up

WITH test AS (SELECT  country_code, 
        country_name,
        year,
        LEAD(forest_area_sqkm) 
        OVER (PARTITION BY country_code ORDER BY year) - forest_area_sqkm
                AS decrease
FROM(
SELECT country_code, country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 1990 OR year = 2016
ORDER BY 1,3) sub
ORDER BY decrease DESC)

SELECT country_name, decrease
FROM test
WHERE year = 1990 AND decrease IS NOT NULL
LIMIT 5;
--this seems to work
--although I still need to figure out why NULL values are appearing



b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?

--same as above but with percentage equation for lead

WITH test AS (SELECT  country_code, 
        country_name,
        year,
        ((LEAD(forest_area_sqkm) 
        OVER (PARTITION BY country_code ORDER BY year))/forest_area_sqkm)*100
                AS decrease
FROM(
SELECT country_code, country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 1990 OR year = 2016
ORDER BY 1,3) sub
ORDER BY decrease DESC)

SELECT country_name, decrease
FROM test
WHERE year = 1990 AND decrease IS NOT NULL
LIMIT 5;
--this makes no sense, over 100%


SELECT  country_code, 
        country_name,
        year,
        forest_area_sqkm,
        100-(((LEAD(forest_area_sqkm) 
        OVER (PARTITION BY country_code ORDER BY year))/forest_area_sqkm)*100)
                AS decrease
FROM(
SELECT country_code, country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 1990 OR year = 2016
ORDER BY 1,3) sub
--this now has the percentage correct



=>
WITH test AS (SELECT  country_code, 
        country_name,
        year,
	forest_area_sqkm,
        100-(((LEAD(forest_area_sqkm) 
        OVER (PARTITION BY country_code ORDER BY year))/forest_area_sqkm)*100)
                AS decrease
FROM(
SELECT country_code, country_name, year, forest_area_sqkm
FROM forestation
WHERE year = 1990 OR year = 2016
ORDER BY 1,3) sub
ORDER BY decrease DESC)

SELECT country_name, decrease
FROM test
WHERE year = 1990 AND decrease IS NOT NULL
LIMIT 5;
--this seems to work

c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?

SELECT 	country_code,
	country_name,
       	year,
       	forest_area_sqkm
	NTILE(4) OVER (PARTITION BY country_code ORDER BY forest_area_sqkm)
		AS quartile
FROM forestation
WHERE year = 2016
ORDER BY quartile DESC

--this does area not percent

SELECT 	country_code,
	country_name, 
	year,
	(forest_area_sqkm/(total_area_sq_mi*2.59))*100
		AS percentage_forest
FROM forestation
WHERE year = 2016
ORDER BY percentage_forest DESC

-- this is a subselect for percentages

SELECT  country_code,
        country_name, 
        year,
        (forest_area_sqkm/(total_area_sq_mi*2.59))*100
                AS percentage_forest,
	NTILE(4) OVER (ORDER BY percentage_forest)
		AS quartile
FROM forestation
WHERE year = 2016
ORDER BY quartile DESC
--doesn't work, needs to be subquery

SELECT 	country_name,
	percentage_forest,
       	NTILE(4) OVER (ORDER BY percentage_forest) AS quartile
FROM(SELECT  country_code,
        country_name, 
        year,
        (forest_area_sqkm/(total_area_sq_mi*2.59))*100
                AS percentage_forest
FROM forestation
WHERE year = 2016
ORDER BY percentage_forest DESC) sub
ORDER BY quartile

--now add count
SELECT quartile, COUNT(*)
FROM(SELECT  country_name,
        percentage_forest,
        NTILE(4) OVER (ORDER BY percentage_forest) AS quartile
FROM(SELECT  country_code,
        country_name, 
        year,
        (forest_area_sqkm/(total_area_sq_mi*2.59))*100
                AS percentage_forest
FROM forestation
WHERE year = 2016
ORDER BY percentage_forest DESC) sub
ORDER BY quartile) sub2
GROUP BY 1

--answer: seems to be evenly distributed
--probably incorrect, still NULL data everywhere


d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.

SELECT country_name, percentage_forest, quartile
FROM(SELECT  country_name,
        percentage_forest,
        NTILE(4) OVER (ORDER BY percentage_forest) AS quartile
FROM(SELECT  country_code,
        country_name, 
        year,
        (forest_area_sqkm/(total_area_sq_mi*2.59))*100
                AS percentage_forest
FROM forestation
WHERE year = 2016
ORDER BY percentage_forest DESC) sub
ORDER BY quartile) sub2
ORDER BY quartile DESC

--my quartiles are totally wrong, they go down to 52%!!??


e. How many countries had a percent forestation higher than the United States in 2016?

--subselect
SELECT 	country_name, 
	forest_area_sqkm,
       	total_area_sq_mi,
	(forest_area_sqkm/(total_area_sq_mi*2.59))
		AS percentage_forestation

FROM forestation
WHERE year = 2016
ORDER BY percentage_forestation DESC

--scalar usa forestation
SELECT percentage_forestation
FROM(SELECT  country_code,
	country_name, 
        forest_area_sqkm,
        total_area_sq_mi,
        (forest_area_sqkm/(total_area_sq_mi*2.59))
                AS percentage_forestation
FROM forestation
WHERE year = 2016 AND country_code = 'USA') sub


=>

SELECT  country_name, 
        forest_area_sqkm,
        total_area_sq_mi,
        (forest_area_sqkm/(total_area_sq_mi*2.59))
                AS percentage_forestation

FROM forestation
WHERE year = 2016 AND percentage_forestation > (
SELECT percentage_forestation
FROM(SELECT  country_code,
        country_name, 
        forest_area_sqkm,
        total_area_sq_mi,
        (forest_area_sqkm/(total_area_sq_mi*2.59))
                AS percentage_forestation
FROM forestation
WHERE year = 2016 AND country_code = 'USA') sub)
ORDER BY percentage_forestation

--doesn't work because of WHERE clause and alias

--trying WITH

WITH usa_percentage AS (
	SELECT  country_code,
        	country_name, 
        	forest_area_sqkm,
        	total_area_sq_mi,
        	(forest_area_sqkm/(total_area_sq_mi*2.59))
                	AS percentage_forestation
	FROM forestation
	WHERE country_code = 'USA' AND year = 2016)

SELECT * FROM usa_percentage



=>

WITH usa_percentage AS (
	SELECT percentage_forestation
	FROM(SELECT  country_code,
               	 country_name, 
                forest_area_sqkm,
                total_area_sq_mi,
                (forest_area_sqkm/(total_area_sq_mi*2.59))
                        AS percentage_forestation
        	FROM forestation
        	WHERE country_code = 'USA' AND year = 2016) sub)

SELECT * FROM usa_percentage

=>

--use usa_percentage in WHERE clause 

SELECT 	country_code,
	country_name, 
	forest_area_sqkm,
	total_area_sq_mi,
	(forest_area_sqkm/(total_area_sq_mi*2.59))
		AS percentage_forestation
FROM forestation
WHERE year = 2016 
AND (forest_area_sqkm/(total_area_sq_mi*2.59)) > (SELECT * FROM usa_percentage)
ORDER BY percentage_forestation DESC


--answer:94 results



*/
