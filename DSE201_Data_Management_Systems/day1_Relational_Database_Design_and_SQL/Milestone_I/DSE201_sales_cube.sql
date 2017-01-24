-- Create the schema for DSE201 HW1: Sales Cube

CREATE TABLE states (
	id 				SERIAL PRIMARY KEY,
	name			TEXT NOT NULL
);

CREATE TABLE customer (
	id 				SERIAL PRIMARY KEY,
	name 			TEXT
);

CREATE TABLE products (
	id				SERIAL PRIMARY KEY,
	name 			TEXT,
	list_price		TEXT,
);

CREATE TABLE category (
	id				SERIAL PRIMARY KEY,
	name			TEXT,
	description		TEXT,
);

CREATE TABLE resides_in (
	state_residence	INTEGER REFERENCES states (id) NOT NULL,
	customer		INTEGER REFERENCES customer (id) NOT NULL
);

CREATE TABLE belongs_to (
	category		INTEGER REFERENCES category (id) NOT NULL,
	products		INTEGER REFERENCES products (id) NOT NULL
);

CREATE TABLE sales (
	sales_id 		SERIAL PRIMARY KEY,
	sales_datetime	TIME,
	discounted		BINARY_INTEGER,
	customer		INTEGER REFERENCES customer (id) NOT NULL,
	products		INTEGER REFERENCES products (id) NOT NULL,
	quantity		INTEGER,
	price_paid		DECIMAL
);