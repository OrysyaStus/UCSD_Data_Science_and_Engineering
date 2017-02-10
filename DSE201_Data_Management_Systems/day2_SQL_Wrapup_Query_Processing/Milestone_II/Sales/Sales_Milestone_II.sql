-- Sales Cube: Milestone II
-- Orysya Stus

-- 1. Show the total sales (quantity sold and dollar value) for each customer
SELECT c.customer_id, c.customer_name, SUM(quantity) AS quantity_sold, SUM(price) AS dollar_value, SUM(quantity*price) AS total_sales 
FROM sales.customer AS c, sales.sale AS s 
WHERE c.customer_id = s.customer_id
GROUP BY c.customer_id
ORDER BY c.customer_id;

-- 2. Show the total sales for each state
SELECT st.state_name, SUM(quantity) AS quantity_sold, SUM(price) AS dollar_value, SUM(quantity*price) AS total_sales
FROM sales.state AS st, sales.customer AS c, sales.sale AS s
WHERE st.state_id = c.state_id AND c.customer_id = s.customer_id
GROUP BY st.state_id
ORDER BY st.state_name;

-- 3. Show the total sales for each product, for a given customer. Only products that were actually bought by the given customer are listed. Order by dollar value.
SELECT 
	cpTot.customer_id, cpTot.product_id, stotal, dollar_value, total_sales, p.product_name, c.customer_name
FROM     
(
	SELECT c.customer_id,p.product_id,SUM(s.quantity) sTotal,SUM(s.price) dollar_value,  SUM(quantity*price) AS total_sales
	FROM sales.customer AS c JOIN sales.sale AS s ON  s.customer_id = c.customer_id
	JOIN sales.product AS p ON  s.product_id = p.product_id
    -- The next line can vary depending on the id(s) given
	WHERE c.customer_id IN (18)
	GROUP BY c.customer_id, p.product_id
) cpTot
JOIN sales.customer AS c ON  cpTot.customer_id = c.customer_id
JOIN sales.product AS p ON  p.product_id = cpTot.product_id
ORDER BY total_sales DESC;

-- 4. Show the total sales for each product and customer. Order by dollar value.
SELECT c.customer_id, c.customer_name, p.product_id, p.product_name, SUM(quantity) AS quantity_sold, SUM(price) AS dollar_value, SUM(quantity*price) AS total_sales
FROM sales.sale AS s, sales.customer AS c, sales.product AS p
WHERE s.customer_id = c.customer_id AND p.product_id = s.product_id
GROUP BY c.customer_id, c.customer_name, p.product_id, p.product_name
ORDER by total_sales DESC;

-- 5. Show the total sales for each product category and state.
SELECT c.category_id, c.category_name, st.state_id, st.state_name, SUM(quantity) AS quantity_sold, SUM(price) AS dollar_value, SUM(quantity*price) AS total_sales    
FROM sales.sale AS s JOIN sales.product AS p ON s.product_id = p.product_id
JOIN sales.category AS c ON p.category_id = c.category_id
JOIN sales.customer AS cus on s.customer_id = cus.customer_id
JOIN sales.state AS st on cus.state_id = st.state_id
GROUP BY c.category_id, c.category_name, st.state_id, st.state_name
ORDER BY st.state_id, total_sales DESC;

-- 6. For each one of the top 20 product categories and top 20 customer, return a tuple (top product, top customer, quantity sold, dollar value)
SELECT alltop.category_name,
alltop.customer,
alltop.category_id,
alltop.customer_id,
COALESCE(alls.category_spending,0)
FROM
(	SELECT tcat.category_id, tcat.category_name, tcus.customer_id, tcus.customer
	FROM ( SELECT cat.category_id, cat.category_name, SUM(s.quantity * s.price) AS grand_total -- top 20 product categories
			FROM sales.sale AS s, sales.product AS p, sales.category AS cat
			WHERE s.product_id = p.product_id
			AND p.category_id = cat.category_id
			GROUP BY cat.category_name, cat.category_id
			ORDER BY grand_total DESC
			LIMIT 20) tcat
	CROSS JOIN ( SELECT c.customer_id, c.customer_name AS customer, SUM(s.quantity * s.price) AS grand_total -- top 20 customers
  			FROM sales.sale AS s, sales.customer AS c
   			WHERE s.customer_id = c.customer_id
   			GROUP BY c.customer_id, c.customer_name
   			ORDER BY grand_total DESC
   			LIMIT 20) tcus
	ORDER BY tcat.category_id, tcus.customer_id) alltop
LEFT JOIN ( SELECT c.customer_id, c.customer_name, p.category_id, SUM(s.quantity * s.price) AS category_spending -- total money spent by each customer per category
	FROM sales.sale AS s, sales.customer AS c, sales.product AS p
	WHERE c.customer_id = s.customer_id
	AND s.product_id = p.product_id
	GROUP BY p.category_id, c.customer_id) alls
ON (alltop.customer_id = alls.customer_id)
AND (alltop.category_id = alls.category_id)
GROUP BY alltop.category_name, alltop.customer,
alltop.category_id, alltop.customer_id,
alls.category_spending
ORDER BY alltop.customer_id, alltop.category_id;
-- 400 rows are returned

/*
WITH top_20_cats AS
(
	SELECT c.category_id, c.category_name, SUM(s.quantity) AS quantity_sold, SUM(s.price) dollar_value
	FROM sale AS s
	JOIN product AS p ON s.product_id = p.product_id
	JOIN category AS c ON p.category_id = c.category_id
	GROUP BY c.category_id, c.category_name
	ORDER BY dollar_value DESC
	LIMIT 20
),
top_20_cust AS 
(
	SELECT CUS.customer_id, CUS.customer_name, SUM(s.quantity) AS quantity_sold, SUM(s.price) dollar_value
	FROM sale AS s
	JOIN customer AS CUS ON s.customer_id=CUS.customer_id
	GROUP BY CUS.customer_id, CUS.customer_name
	ORDER BY dollar_value DESC
	LIMIT 20
)
-- SELECT tcat.category_name AS top_category, tcus.customer_name AS top_customer, SUM(s.quantity) quantity_sold, SUM(s.price) dollar_value
-- FROM sale s
-- CROSS JOIN product AS p -- ON s.product_id=p.product_id
-- CROSS JOIN top_20_cats AS tcat -- ON p.category_id=tcat.category_id
-- CROSS JOIN top_20_cust AS tcus -- ON s.customer_id=tcus.customer_id
-- GROUP BY tcat.category_name, tcus.customer_name
-- ORDER BY dollar_value DESC;
SELECT tcat.category_name AS top_category, tcus.customer_name AS top_customer, SUM(s.quantity) quantity_sold, SUM(s.price) dollar_value
FROM sale s
JOIN product AS p ON s.product_id=p.product_id
JOIN top_20_cats AS tcat ON p.category_id=tcat.category_id
JOIN top_20_cust AS tcus ON s.customer_id=tcus.customer_id
GROUP BY tcat.category_name, tcus.customer_name
ORDER BY dollar_value DESC;
*/