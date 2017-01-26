-- Create the schema for DSE201 HW1: 201Cats

CREATE TABLE users (
	user_id			SERIAL PRIMARY KEY,
	fb_login		TEXT NOT NULL,
	name			TEXT NOT NULL
);

CREATE TABLE video (
	video_id		SERIAL PRIMARY KEY,
	name			TEXT
);

CREATE TABLE cat_users_connections (
	connections_id	SERIAL PRIMARY KEY,
	follows			INTEGER REFERENCES users (user_id) NOT NULL,
	isfollowing		INTEGER REFERENCES users (user_id) NOT NULL
);

CREATE TABLE watch_activity (
	wa_id			SERIAL PRIMARY KEY,
	watched_time	TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	video			INTEGER REFERENCES video (video_id) NOT NULL
);

CREATE TABLE visit (
	visit_id		SERIAL PRIMARY KEY, 
	login_time		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	users			INTEGER REFERENCES users (user_id) NOT NULL,
	suggested_video	INTEGER REFERENCES video (video_id) NOT NULL UNIQUE
);

CREATE TABLE like_activity (
	la_id			SERIAL PRIMARY KEY,
	liked_time		TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
	users			INTEGER REFERENCES users (user_id) NOT NULL,
	liked_video		INTEGER REFERENCES video (video_id) NOT NULL
);