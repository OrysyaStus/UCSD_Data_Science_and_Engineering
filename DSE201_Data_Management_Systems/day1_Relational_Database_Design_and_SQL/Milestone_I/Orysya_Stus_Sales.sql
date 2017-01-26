-- Create the schema for DSE201 HW1: Sales Cube

CREATE TABLE states (
	state_id 		SERIAL PRIMARY KEY,
	name			TEXT NOT NULL
);

CREATE TABLE customer (
	customer_id 	SERIAL PRIMARY KEY,
	name 			TEXT
);

CREATE TABLE products (
	product_id		SERIAL PRIMARY KEY,
	name 			TEXT,
	list_price		TEXT,
);

CREATE TABLE category (
	category_id		SERIAL PRIMARY KEY,
	name			TEXT,
	description		TEXT,
);

CREATE TABLE resides_in (
	state_residence	INTEGER REFERENCES states (state_id) NOT NULL,
	customer		INTEGER REFERENCES customer (customer_id) NOT NULL
);

CREATE TABLE belongs_to (
	category		INTEGER REFERENCES category (category_id) NOT NULL,
	products		INTEGER REFERENCES products (product_id) NOT NULL
);

CREATE TABLE sales (
	sales_id 		SERIAL PRIMARY KEY,
	sales_datetime	TIME,
	discounted		BINARY_INTEGER,
	customer		INTEGER REFERENCES customer (customer_id) NOT NULL,
	products		INTEGER REFERENCES products (product_id) NOT NULL,
	quantity		INTEGER,
	price_paid		DECIMAL
);