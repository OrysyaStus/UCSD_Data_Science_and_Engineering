-- Create the schema for DSE201 HW1: 201Cats

CREATE TABLE users (
	fb_login		TEXT PRIMARY KEY,
	name			TEXT NOT NULL
);

CREATE TABLE video (
	id				SERIAL PRIMARY KEY,
	name			TEXT
);

CREATE TABLE cat_users_connections (
	friend			INTEGER REFERENCES users (fb_login) NOT NULL,
	isfriends		INTEGER REFERENCES users (fb_login) NOT NULL
);

CREATE TABLE watch_activity (
	watched_time	TIME,
	video_id		INTEGER REFERENCES video (id) NOT NULL
);

CREATE TABLE visit (
	login_time		TIME,
	fb_login		INTEGER REFERENCES users (fb_login) NOT NULL,
	suggested_video	INTEGER REFERENCES video (id) NOT NULL
);

CREATE TABLE like_activity (
	liked_time		TIME,
	fb_login		INTEGER REFERENCES users (fb_login) NOT NULL,
	video_id		INTEGER REFERENCES video (id) NOT NULL
);