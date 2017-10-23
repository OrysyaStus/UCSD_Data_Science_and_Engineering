/* Basic SQL for Data Analysis */
/* DSE203 10.13.2017 */

/* 
Sampling 
*/
/* 1.1 Random Sample */
-- Generate a random sample consisting of 1000 rows from the customers table
SELECT c.*
FROM customers AS c
ORDER BY random()
LIMIT 1000

/* 1.2 Repeatable Random Sample */
-- Generate a 10% random sample of the customers table, such that it can be reproduced at a later point of time
SELECT setseed(0.5);
SELECT *
FROM customers 
WHERE random() < 0.1

-- Without repetition
SELECT setseed(0.5);
-- Common Tablular Expression(CTE)
WITH shuffled_data AS (
    -- Assign a sequential value, starting with 1 to each row
    SELECT *, ROW_NUMBER() OVER (ORDER BY random()) AS rownum
	FROM customers
	)
SELECT * 
FROM shuffled_data
WHERE rownum <= 100

/* 1.3 Proportional Stratified Sample */
-- Obtain a 1% sample of customers that maintains the same gender ratio as the original table. Original Gender Ratio
SELECT SUM(CASE WHEN cust.gender = 'F' THEN 1 ELSE 0 END) * 100 / COUNT(*) AS percent_f,
	SUM(CASE WHEN cust.gender = 'M' THEN 1 ELSE 0 END) * 100 / COUNT(*) AS percent_m,
	COUNT(*) AS total_count
FROM customers cust

-- Sample Gender Ratio
WITH cust AS (
    	SELECT c.*, ROW_NUMBER() OVER (ORDER BY c.gender) AS rownum
	FROM customers c
	)
SELECT 
SUM(CASE WHEN cust.gender = 'F' THEN 1 ELSE 0 END) * 100 / COUNT(*) AS percent_f,
SUM(CASE WHEN cust.gender = 'M' THEN 1 ELSE 0 END) * 100 / COUNT(*) AS percent_m,
COUNT(*) AS total_count
FROM cust
WHERE cust.rownum  % 100 = 1

/* 1.4 Balanced Sample */
-- Generate a random sample consisting of 1000 customers that has equal number of male and female customers i.e., with 1:1 gender ratio
WITH cust AS (
	SELECT c.*,
    	-- Assign the same row number for all rows with the same value of isF
		ROW_NUMBER() OVER (PARTITION BY isF) AS seqnum
    FROM (SELECT c.*,
         	(CASE WHEN c.gender = 'F' THEN 1 ELSE 0 END) AS isF
         FROM customers c
         WHERE c.gender <> ''
         ) c
    )
SELECT 
	SUM(CASE WHEN cust.isF = 1 THEN 1 ELSE 0 END) * 100 / COUNT(*) AS percent_f,
	SUM(CASE WHEN cust.isF = 0 THEN 1 ELSE 0 END) * 100 / COUNT(*) AS percent_m,
    COUNT(*) AS total_count
FROM cust
WHERE seqnum <= 500

/* 
Table Sample 
*/
/* 2.1 System & Bernoulli */
-- Generate a 10% random sample of the customers table, such that it can be reproduced at a later point of time.
-- SYSTEM - which does block level sampling. It groups a set of tuples and randomly selects these groups.
SELECT * 
FROM customers
TABLESAMPLE SYSTEM(10) REPEATABLE(200);
-- BERNOULLI - which does tuple level sampling. Each row has equal probability of being selected.
SELECT * 
FROM customers
TABLESAMPLE BERNOULLI(10) REPEATABLE(200);

/* 2.2 Systen Rows and Comparind Efficiency */
-- Generate a random sample consisting of 1000 rows from the customers table and compare the query execution times
EXPLAIN ANALYSE
SELECT * 
FROM customers
ORDER BY random()
LIMIT 1000
-- vs. tablesample:
CREATE EXTENSION IF NOT EXISTS "tsm_system_rows";
EXPLAIN ANALYZE
SELECT * 
FROM customers 
TABLESAMPLE SYSTEM_ROWS(1000)
-- this is much more efficient than using just random (~100 ms) vs. system (~14 ms)

/* 
Histogram 
*/
-- What is the distribution of orders by state and how is this related to the state’s population?
-- (4) Display the state along with number of orders and population of that state.
SELECT State, SUM(numorders) as numorders, SUM(pop) as pop
FROM (
    -- (1) For each state in orders table, we find the number of orders.
    (SELECT o.State, COUNT(*) as numorders, 0 as pop
    FROM Orders o
    GROUP BY o.state
	) 
    -- (3) UNION ALL combines all rows in two tables.
    UNION ALL
    -- (2) For each state in zipcensus table, we find the total population.
    (SELECT zc.stab, 0 as numorders, SUM(totpop) as pop
     FROM ZipCensus zc
     GROUP BY zc.stab
    )
) summary
GROUP BY State
-- (5) Arrange the rows in descending order of number of orders
ORDER BY numorders DESC




