   
CREATE VIEW forestation 
AS
SELECT  fa.country_code country_code,
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


--1 GLOBAL SITUATION

WITH global_change AS (
	SELECT 	year, 
		forest_area_sqkm,
	       	ROUND(percentage_forest_area::numeric, 2) AS percentage_forest_area
	FROM forestation
	WHERE (year = 1990 OR year = 2016) AND country_code = 'WLD'
			),

--scalar of change in sqkm from 1990 to 2016
--for question e
change_sqkm AS (
	SELECT 	MAX(forest_area_sqkm)-MIN(forest_area_sqkm) 
			AS change_sqkm
	FROM global_change
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

SELECT ROUND(((SELECT MAX(percentage_forest_area)-MIN(percentage_forest_area)
		FROM global_change)/percentage_forest_area)*100::numeric, 2) 
			AS percentage_change
FROM global_change
WHERE year = 1990


--e
--subtracting change_sqkm scalar from total area of each country
SELECT r_country_name, total_area_sqkm, (total_area_sqkm - (SELECT * FROM change_sqkm)) AS difference, total_area_sqkm, ABS((total_area_sqkm - (SELECT * FROM change_sqkm))) AS abs
FROM forestation
WHERE year = 2016
ORDER BY abs
LIMIT 1

--2 REGIONAL

WITH regional_outlook AS
(SELECT  region,
        year, 
        ROUND((SUM(forest_area_sqkm)/SUM(total_area_sq_mi*2.59)*100)::numeric, 2) AS percent
FROM forestation
WHERE year = 2016 OR year = 1990
GROUP BY 1,2
ORDER BY 1,2)

--a
SELECT *
FROM regional_outlook 
WHERE year = 2016
ORDER BY percent DESC

--b
SELECT *
FROM regional_outlook 
WHERE year = 1990
ORDER BY percent DESC

--c
SELECT * 
FROM(SELECT  region,
        year,
        percent,
        MAX(percent) OVER (PARTITION BY region) AS max
    FROM regional_outlook) sub
WHERE (percent = max) AND year = 1990
--come back to this






3

--a
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

--b
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
--c
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

-d
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

--e
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

--f

SELECT 	r_country_name, 
				region, 
				ROUND(percentage_forest_area::numeric, 2) 
					AS percentage_forest_area, 
				percentage_quartile
FROM(
SELECT  r_country_name,
				region,
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
