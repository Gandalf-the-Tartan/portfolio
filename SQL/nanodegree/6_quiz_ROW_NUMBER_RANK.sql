--shows ordinal ranking system for total qty ordered, for each order in the whole database. This is partitioned into accounts so the lowest to highest account ids go down the column. for each of these account partitions, the total goes from highes to lowest. For each account partition, the ordinal count starts again at 1 and goes higher for snd, 3rd place etc.
SELECT id, account_id, total,
RANK() OVER(PARTITION BY account_id ORDER BY total DESC)
FROM orders;

--experiments
SELECT id, account_id, total,
RANK() OVER(PARTITION BY account_id ORDER BY total)
FROM orders;

--Shows rank for total column from lowest to highest. partioned by account.order id is random, but exists behind the scenes as it is the primary key.




SELECT id, account_id, total,
RANK() OVER(PARTITION BY account_id)
FROM orders;

--doesn't seem to do anything in particular. rank of 1 assigned to everything, account order ascending from partition, but otherwise pretty random.
