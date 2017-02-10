CREATE SCHEMA sales;

-- Create necessary tables
CREATE TABLE sales.state
(
  state_id serial primary key NOT NULL,
  state_name character varying(50) NOT NULL
);

CREATE TABLE sales.category
(
  category_id serial primary key NOT NULL,
  category_name character varying(50) NOT NULL,
  category_desc text
);

CREATE TABLE sales.product
(
  product_id serial primary key NOT NULL,
  product_name character varying(50) NOT NULL,
  category_id integer references sales.category(category_id) NOT NULL,
  list_price numeric NOT NULL
);

CREATE TABLE sales.customer
(
  customer_id serial primary key NOT NULL,
  customer_name character varying(50) NOT NULL,
  state_id integer references sales.state(state_id) NOT NULL
);

CREATE TABLE sales.sale
(
  sale_id serial primary key NOT NULL,
  customer_id integer references sales.customer(customer_id) NOT NULL,
  product_id integer references sales.product(product_id) NOT NULL,
  quantity integer NOT NULL,
  price numeric NOT NULL
);

-- Loading sample data into sales
-- COPY <table_name> FROM <location in your computer> DELIMITER ',' CSV;
-- ie. COPY video FROM '/Users/swethakrishnakumar/Desktop/DSE201/video.txt' DELIMITER ',' CSV;
COPY sales.category FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Sales/category.csv' DELIMITER ',' CSV
COPY sales.state FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Sales/States.csv' DELIMITER ',' CSV;
COPY sales.customer FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Sales/Customers.csv' DELIMITER ',' CSV;
COPY sales.product FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Sales/product.csv' DELIMITER ',' CSV;
COPY sales.sale FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Sales/sale.csv' DELIMITER ',' CSV;