--Microsoft SQL Server--

--Question 1: Pulling standard_qty, gloss_qty, and poster_qty from the orders table, and the website and the primary_poc from the accounts table.

SELECT orders.standard_qty,
       orders.gloss_qty,
	   orders.poster_qty,
	   accounts.website,
	   accounts.primary_poc
FROM orders
JOIN accounts
ON orders.account_id = accounts.id;

--Question 2: Pulling the channel from web_event, name from accounts and total from orders.

SELECT web_events.channel,
       accounts.name,
	   orders.total
FROM web_events
JOIN accounts
ON web_events.account_id = accounts.id
JOIN orders
ON accounts.id = orders.account_id;

--Question 3:  Find the time of events, channels, and primary_poc of accounts with the name 'Walmart'."

SELECT w.occurred_at,
       w.channel,
	   a.primary_poc,
	   a.name
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE a.name = 'Walmart';

--Question 4: Provide a table with region name, account name and sales_reps name and sort accounts name from A-Z.

SELECT r.name,
       a.name,
	   s.name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
ORDER BY a.name;

--Question 5: Provide the name for each region for every order, as well as the account name and the unit price they paid (total_amt_usd/total) for the order. 
--Your final table should have 3 columns: region name, account name, and unit price. A few accounts have 0 for total, so I divided by (total + 0.01) to assure not dividing by zero.

SELECT r.name,
       a.name,
	   o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id;

--Question 6: Find all orders with sales_rep_id is 321500. 

SELECT a.*,
       o.* 
FROM accounts a
LEFT JOIN orders o
ON a.id = o.account_id
WHERE a.sales_rep_id = 321500;

--Quesion 7: Provide the region for each sales_rep along with their associated accounts in the Midwest region.

SELECT r.name AS region_name,
       s.name AS sales_rep_name,
	   a.name AS accounts_name
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
WHERE r.name = 'Midwest' 
ORDER BY a.name; 

--Question 8: Provide the region name, account name, and unit price for each order where the standard order quantity exceeds 100 and the poster order quantity exceeds 50.
--In order to avoid a division by zero error, adding .01 to the denominator here is helpful (total_amt_usd/(total+0.01).

SELECT r.name AS region_name,
       a.name AS accounts_name,
	   o.total_amt_usd/(o.total + 0.01) AS unit_price
FROM region r
JOIN sales_reps s
ON r.id = s.region_id
JOIN accounts a
ON s.id = a.sales_rep_id
JOIN orders o
ON a.id = o.account_id
WHERE o.poster_qty > 100 AND o.poster_qty > 50
ORDER BY unit_price DESC;

--Question 9: List the unique channels used by account id 1001, along with the account name

SELECT DISTINCT a.name, w.channel 
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
WHERE a.id = 1001;

--Question 10: Find all the orders that occurred in 2015.

SELECT o.*, a.name
FROM orders o
JOIN accounts a
ON o.account_id = a.id
WHERE occurred_at BETWEEN '2015-01-01' AND '2016-01-01'
ORDER BY o.occurred_at;

--Question 11: Find the standard_amt_usd per unit of standard_qty paper.

SELECT SUM (standard_amt_usd)/SUM (standard_qty) standard_price_per_unit
FROM orders;

--Question 12: Which account (by name) placed the earliest order?

SELECT TOP 1 a.name, o.occurred_at 
FROM accounts a
JOIN orders o
ON a.id = o.account_id
ORDER BY o.occurred_at;

--Question 13: Find the total sales in usd for each account.

SELECT a.name, SUM (total_amt_usd) total_sales
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name;

--Question 14: Via what channel did the most recent (latest) web_event occur, which account was associated with this web_event?

SELECT TOP 1 a.name, 
       w.channel, 
	   w.occurred_at
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
ORDER BY w.occurred_at DESC;

--Question 15: Find the total number of times each type of channel from the web_events was used.

SELECT channel, COUNT (channel) Frequency
FROM web_events
GROUP BY channel;

--Question 16: Who was the primary contact associated with the earliest web_event?

SELECT TOP 1 a.primary_poc, w.occurred_at
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
ORDER BY w.occurred_at;

--Question 17: What was the smallest order placed by each account in terms of total usd.

SELECT a.name, MIN (o.total_amt_usd) smallest_total
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY smallest_total;

--Question 18: Find the number of sales reps in each region

SELECT r.name, COUNT (*) number_sales_reps 
FROM region r
JOIN sales_reps s
ON r.id = s.region_id 
GROUP BY r.name;

--Question 19: For each account, determine the average amount of each type of paper they purchased across their orders. 

SELECT a.name,
       AVG (poster_qty) avg_poster_qty,
	   AVG (gloss_qty) avg_gloss_qty,
	   AVG (standard_qty) avg_standard_qty 
FROM accounts a
JOIN orders o
ON a.id = o.account_id
GROUP BY a.name
ORDER BY a.name; 

--Question 20: Determine the number of times a particular channel was used in the web_events table for each sales rep

SELECT s.name,
       w.channel,
	   COUNT (w.channel) number_of_time 
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY w.channel, s.name
ORDER BY number_of_time DESC;

--Question 21: Have any sales reps worked on more than one account?

--Query 1
SELECT s.id, s.name,
       COUNT (*) nummber_of_account
FROM accounts a
JOIN sales_reps s
ON s.id = a.sales_rep_id
GROUP BY s.id, s.name
ORDER BY s.id;

--Query 2:
SELECT DISTINCT id, name
FROM sales_reps;
--> In query 1, there are no sales reps working under 1 account, at least 3 accounts. Comparing the number of results of the 2 queries shows no difference 

--Question 22: Which channel was most frequently used by most accounts?

SELECT TOP 1 w.channel,
             COUNT (*) num_accounts
FROM accounts a
JOIN web_events w
ON a.id = w.account_id
GROUP BY w.channel
ORDER BY COUNT (*) DESC;

--Question 23: How many accounts have more than 20 orders?

SELECT COUNT (*) acc_more_than_20
FROM  (SELECT a.id, a.name,
              COUNT (*) num_orders
       FROM orders o
	   JOIN accounts a
	   ON o.account_id = a.id
	   GROUP BY a.id, a.name
	   HAVING COUNT (*) > 20) AS orders;
	   
--Question 23: Which accounts used facebook as a channel to contact customers more than 6 times?

SELECT a.id, a.name,
       COUNT (*) time_use
FROM web_events w
JOIN accounts a
ON w.account_id = a.id
WHERE w.channel = 'facebook'
GROUP BY a.id, a.name
HAVING COUNT (*) > 6 
ORDER BY time_use DESC;

--Question 24: Display for each order, the level of the order - eLargef or fSmallf - depending on if the order is $3000 or more, or smaller than $3000.

SELECT account_id, total_amt_usd,
CASE 
    WHEN total_amt_usd >= 3000 THEN 'Large' 
	ELSE 'Small' 
END AS order_level
FROM orders;

--Questio 25: Write a query to display the number of orders in each of three categories, based on the total number of items in each order. The three categories are: 'At Least 2000', 'Between 1000 and 2000' and 'Less than 1000'.

SELECT 
    type_of_categories,
    COUNT(*) AS count_categories
FROM (
    SELECT 
        CASE 
            WHEN total >= 2000 THEN 'At Least 2000'
            WHEN total >= 1000 AND total < 2000 THEN 'Between 1000 and 2000'
            ELSE 'Less than 1000' 
        END AS type_of_categories
    FROM orders
) AS categorized
GROUP BY type_of_categories;

--Question 26:  Provide a table that includes the level associated with each account.

SELECT a.name, SUM (o.total_amt_usd) total_amt,
CASE 
    WHEN SUM (o.total_amt_usd) >= 2000 THEN 'top'
	WHEN SUM (o.total_amt_usd) > 1000 AND SUM (o.total_amt_usd) < 200 THEN 'middle'
	ELSE 'low'
END AS level_total
FROM orders o
JOIN accounts a 
ON a.id = o.account_id
GROUP BY a.name
ORDER BY  total_amt DESC;

--Question 27: Identify top performing sales reps, which are sales reps associated with more than 200 orders

SELECT s.id, s.name, COUNT (*) num_orders,
CASE 
    WHEN COUNT (*) > 200 THEN 'top'
	ELSE 'not'
END AS top_perform 
FROM orders o
JOIN accounts a
ON o.account_id = a.id
JOIN sales_reps s
ON a.sales_rep_id = s.id
GROUP BY s.id, s.name
ORDER BY num_orders DESC;

--Question 28: Calculate the average order quantity for each type of paper by month.

SELECT DATEADD (month, DATEDIFF (month, 0, occurred_at), 0) AS month,
       AVG (gloss_qty) avg_gloss_qty,
       AVG (standard_qty) avg_standard_qty,
	   AVG (poster_qty) avg_standard_qty	   
FROM orders
GROUP BY DATEADD (month, DATEDIFF (month, 0, occurred_at), 0);

--Question 29: Provide the name of the sales_rep in each region with the largest amount of total_amt_usd sales.

SELECT t3.region_name, t3.sale_reps_name, t3.total_amt_usd
FROM (SELECT region_name, 
             MAX (total_amt_usd) max_total
      FROM  (SELECT s.name sale_reps_name, 
                    r.name region_name,
					SUM (o.total_amt_usd) total_amt_usd
             FROM orders o
			 JOIN accounts a
			 ON o.account_id = a.id
			 JOIN sales_reps s
			 ON a.sales_rep_id = s.id
			 JOIN region r
			 ON s.region_id = r.id
	         GROUP BY s.name, r.name) AS t1 
     GROUP BY region_name) AS t2
JOIN (SELECT s.name sale_reps_name, 
             r.name region_name,
			 SUM (o.total_amt_usd) total_amt_usd
      FROM orders o
	  JOIN accounts a
	  ON o.account_id = a.id
	  JOIN sales_reps s
	  ON a.sales_rep_id = s.id
	  JOIN region r
	  ON s.region_id = r.id
	  GROUP BY s.name, r.name) AS t3
ON t3.region_name = t2.region_name AND t3.total_amt_usd = t2.max_total;

--Question 30: For the customer that spent the most (in total over their lifetime as a customer) total_amt_usd, how many web_events did they have for each channel?

WITH top_total_spent AS (
                SELECT TOP 1 a.id, a.name, SUM (o.total_amt_usd) total_spent
				FROM accounts a
				JOIN orders o
				ON a.id = o.account_id
				GROUP BY a.id, a.name
				ORDER BY total_spent DESC)
SELECT t.id, t.name, w.channel, COUNT (*)
FROM web_events w
JOIN top_total_spent t
ON w.account_id = t.id
GROUP BY t.id, t.name, w.channel;