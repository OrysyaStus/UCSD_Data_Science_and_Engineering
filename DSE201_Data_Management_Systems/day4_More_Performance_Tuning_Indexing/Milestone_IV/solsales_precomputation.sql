set search_path to sales;
	
/***
* 6: For each one of the top 20 product categories and top 20 customers, 
*    return a tuple (top product category, top customer, quantity sold, dollar value)
***/

CREATE VIEW q1 AS
SELECT   c.customer_id, 
	 coalesce (sum (s.quantity), 0) AS quantity_sold, 
	 coalesce (sum (s.quantity*s.price), 0.0) AS dollar_value
FROM     sales.customer c LEFT  JOIN sales.sale s ON c.customer_id = s.customer_id
GROUP BY c.customer_id;

CREATE VIEW q4 AS
SELECT	  c.customer_id, c.customer_name, p.product_id, 
	  coalesce (SUM (s.quantity), 0) AS quantity_sold, 
	  coalesce (SUM (s.quantity*s.price), 0.0) AS dollar_value,
	  c.state_id, p.category_id
FROM      (sales.customer c CROSS JOIN sales.product p) LEFT  JOIN sales.sale s 
	  ON c.customer_id = s.customer_id AND p.product_id = s.product_id
GROUP BY  c.customer_id, p.product_id
ORDER BY  c.customer_id, dollar_value DESC;

CREATE VIEW q5 AS
SELECT    s.state_id, c.category_id, 
	  coalesce (SUM (q.quantity_sold), 0) AS quantity_sold,
	  coalesce (SUM (q.dollar_value), 0.0) AS dollar_value
FROM      (sales.state s CROSS JOIN sales.category c)
	  LEFT  JOIN q4 q ON s.state_id = q.state_id AND c.category_id = q.category_id
GROUP BY  s.state_id, c.category_id;

CREATE VIEW top_customer_values AS
SELECT    DISTINCT dollar_value 
FROM      q1
ORDER BY  dollar_value DESC
LIMIT 	  20;

CREATE VIEW all_top_customers AS
SELECT customer_id
FROM   q1
WHERE  dollar_value IN (SELECT dollar_value FROM top_customer_values);

CREATE VIEW top_category_values AS
SELECT    DISTINCT SUM (dollar_value) AS dollar_value
FROM	  q5
GROUP BY  category_id
ORDER BY  dollar_value DESC
LIMIT 	  20;

CREATE VIEW all_top_categories AS
SELECT    category_id
FROM	  q5
GROUP BY  category_id
HAVING	  SUM (dollar_value) IN (SELECT dollar_value FROM top_category_values);

DISCARD ALL;
CREATE MATERIALIZED VIEW q6_all_mat AS
SELECT	  ca.category_id, cu.customer_id, 
	  coalesce (SUM (q.quantity_sold), 0) AS quantity_sold,
	  coalesce (SUM (q.dollar_value), 0.0) AS dollar_value
FROM      (all_top_customers cu CROSS JOIN all_top_categories ca) LEFT JOIN q4 q 
	  ON q.customer_id = cu.customer_id AND q.category_id = ca.category_id
GROUP BY  ca.category_id, cu.customer_id;
	  
SELECT *
FROM q6_all_mat;