--Microsoft SQL Server-- Parch_and_Posey

SELECT id, account_id, occurred_at FROM orders;

--Question 1: Displays all the data in the occurred_at, account_id, and channel columns of the web_events table, 
--and limits the output to only the first 20 rows.

SELECT TOP 15 occurred_at, account_id, channel
FROM web_events;

--Question 2: Feturn the 20 earliest orders in the orders table. Include the id, occurred_at, and total_amt_usd.

SELECT TOP 20 id, occurred_at, total_amt_usd
FROM orders
ORDER BY occurred_at;

--Question 3: Find the top 10 orders in terms of largest total_amt_usd. Include the id, account_id, and total_amt_usd.

SELECT TOP 10 id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd DESC;

--Question 4: Find the lowest 20 orders in terms of smallest total_amt_usd. Include the id, account_id, and total_amt_usd.

SELECT TOP 20 id, account_id, total_amt_usd
FROM orders
ORDER BY total_amt_usd;

--Question 5: Sorted first by the account ID (in ascending order), and then by the total dollar amount (in descending order).

SELECT *
FROM orders
ORDER BY account_id, total_amt_usd DESC;

--Question 6: Find the highest 5 rows from the orders table that have a dollar amount of gloss_amt_usd greater than or equal to 1000.

SELECT TOP 5 *
FROM orders
WHERE gloss_amt_usd >= 1000
ORDER BY gloss_amt_usd DESC; 

--Question 7: The first 10 rows and all columns from the orders table that have a total_amt_usd less than 500.

SELECT TOP 10 *
FROM orders
WHERE total_amt_usd < 500;

--Question 8: Filter the accounts table to include the company name, website, 
--and the primary point of contact (primary_poc) just for the Exxon Mobil company in the accounts table.

SELECT name, website, primary_poc
FROM accounts
WHERE name = 'Exxon Mobil';

--Question 9: Create a column that divides the standard_amt_usd by the standard_qty to find the unit price for standard paper for each order. 
--Limit the results to the first 10 orders, and include the id and account_id fields.

SELECT TOP 10 id, account_id, standard_amt_usd, standard_qty, standard_amt_usd/standard_qty AS standard_unit_price
FROM orders;

--Question 10: Write a query that finds the fist 10 orders that the percentage of revenue that comes from poster paper for each order. 
--You will need to use only the columns that end with _usd. (Try to do this without using the total column.) Display the id and account_id fields also.

SELECT TOP 10 id, account_id, (poster_amt_usd/(poster_amt_usd+gloss_amt_usd+standard_amt_usd))*100 AS poster_per_rev
FROM orders;

--Question 11: All the companies whose names start with 'C'.

SELECT *
FROM accounts
WHERE name LIKE 'C%';

--Question 12: All companies whose names do not contain the string 'one' somewhere in the name.

SELECT *
FROM accounts
WHERE name NOT LIKE '%one%';

--Question 13: All companies whose names end with 's'.

SELECT *
FROM accounts
WHERE name LIKE '%s';

--Question 14: Find the account name, primary_poc, and sales_rep_id for Walmart, Target, and Nordstrom.

SELECT name, primary_poc, sales_rep_id
FROM accounts
WHERE name IN ('Walmart', 'Target', 'Nordstrom');

--Question 15: Find all information regarding individuals who were contacted via the channel except organic or adwords.

SELECT *
FROM web_events
WHERE channel NOT IN ('organic', 'adwords');

--Question 16: Find all the orders where the standard_qty is over 1000, the poster_qty is 0, and the gloss_qty is 0

SELECT *
FROM orders
WHERE standard_qty > 1000 AND poster_qty = 0 and gloss_qty = 0;

--Question 17: Find all the companies whose names do not start with 'C' and end with 's'.

SELECT *
FROM accounts
WHERE name NOT LIKE 'C%' AND name NOT LIKE '%s';

--Question 18: Displays the order date and gloss_qty data for all orders where gloss_qty is between 24 and 29. rder

SELECT occurred_at, gloss_qty
FROM orders
WHERE gloss_qty BETWEEN 24 AND 29;

--Question 19: Find all information regarding individuals who were contacted via the organic or adwords channels, 
--and started their account at any point in 2016, sorted from newest to oldest.

SELECT *
FROM web_events
WHERE occurred_at BETWEEN '2016-01-01' AND '2017-01-01' AND channel IN ('organic', 'adwords')
ORDER BY occurred_at DESC;

--Question 20: Find list of orders ids where either gloss_qty or poster_qty is greater than 4000. Only include the id field in the resulting table.

SELECT id
FROM orders
WHERE gloss_qty > 4000 or poster_qty > 4000;

--Question 21: Find a list of orders where the standard_qty is zero and either the gloss_qty or poster_qty is over 1000.

SELECT *
FROM orders
WHERE standard_qty = 0 AND (gloss_qty > 1000 OR poster_qty > 1000);

--Question 22: Find all the company names that start with a 'C' or 'W', and the primary contact contains 'ana' or 'Ana', but it doesn't contain 'eana'.

SELECT *
FROM accounts
WHERE (name LIKE 'C%' or name LIKE 'W')
      AND (primary_poc LIKE '%ana%' OR primary_poc LIKE '%Ana%')
	  AND primary_poc NOT LIKE '%eana%';