--model for self join

SELECT o1.id AS o1_id,
       o1.account_id AS o1_account_id,
       o1.occurred_at AS o1_occurred_at,
       o2.id AS o2_id,
       o2.account_id AS o2_account_id,
       o2.occurred_at AS o2_occurred_at
  FROM orders o1
 LEFT JOIN orders o2
   ON o1.account_id = o2.account_id
  AND o2.occurred_at > o1.occurred_at
  AND o2.occurred_at <= o1.occurred_at + INTERVAL '28 days'
ORDER BY o1.account_id, o1.occurred_at


--modify to web events at up to one day after other web events
--N.B. <esc>/o1<enter><esc> --create regex
--	cgnfoo<esc>	--set replacement word to foo
--	 n		--next instance
--	.		--repeat replacement command
SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
	w1.channel AS w1_channel,
       w2.id AS w2_id,
       w2.account_id AS w2_account_id,
       w2.occurred_at AS w2_occurred_at,
	w2.channel AS w2_channel
  FROM web_events w1
 LEFT JOIN web_events w2
   ON w1.account_id = w2.account_id
  AND w2.occurred_at > w1.occurred_at
  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
ORDER BY w1.account_id, w2.occurred_at
--correct
--we get to see web events where nothing happens for a day after
--and web events where something happens within a day after

--experiments

SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
        w1.channel AS w1_channel,
	       w2.id AS w2_id,
	       w2.account_id AS w2_account_id,
	       w2.occurred_at AS w2_occurred_at,
	        w2.channel AS w2_channel
		  FROM web_events w1
		 JOIN web_events w2
		   ON w1.account_id = w2.account_id
		  AND w2.occurred_at > w1.occurred_at
		  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
		ORDER BY w1.account_id, w1.occurred_at
--inner join to show only where subsequent events happened
--1046 results

--experiment 2
SELECT w1.id AS w1_id,
       w1.account_id AS w1_account_id,
       w1.occurred_at AS w1_occurred_at,
        w1.channel AS w1_channel,
	       w2.id AS w2_id,
	       w2.account_id AS w2_account_id,
	       w2.occurred_at AS w2_occurred_at,
	        w2.channel AS w2_channel
		  FROM web_events w1
		 RIGHT JOIN web_events w2
		   ON w1.account_id = w2.account_id
		  AND w2.occurred_at > w1.occurred_at
		  AND w2.occurred_at <= w1.occurred_at + INTERVAL '1 days'
		ORDER BY w1.account_id, w1.occurred_at
--shows matches then shows where all w2 with null for w1


