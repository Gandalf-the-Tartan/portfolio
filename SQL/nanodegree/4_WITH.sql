--convert this inline to with
SELECT channel, AVG(events) AS average_events
FROM (SELECT DATE_TRUNC('day',occurred_at) AS day,
	             channel, COUNT(*) as events
		      FROM web_events 
		      GROUP BY 1,2) sub
	GROUP BY channel
	ORDER BY 2 DESC;

=>
WITH events AS (
	SELECT DATE_TRUNC('day',occurred_at) AS day, 
			channel, COUNT(*) as events
	FROM web_events 
	GROUP BY 1,2)

SELECT channel, AVG(events) AS average_events
FROM events
GROUP BY channel
ORDER BY 2 DESC;

--multiple tables can be defined at once

WITH table1 AS (
	SELECT *
	FROM web_events),

     table2 AS (
	SELECT *
	FROM account)


--basically creating bespoke tables as 'constants'
