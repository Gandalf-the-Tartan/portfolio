# LIKE, wild card matching
# '%google%', 'google%', '%google' (somewhere, starts, ends)
# used in WHERE instead of comparison operators
# presumably for searching character strings

SELECT name
FROM accounts
WHERE name LIKE 'C%';


