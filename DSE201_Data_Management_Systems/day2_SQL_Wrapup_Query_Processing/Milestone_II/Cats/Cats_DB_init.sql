CREATE SCHEMA cats;

-- Create necessary tables
CREATE TABLE cats."user"
(
  user_id serial primary key NOT NULL,
  user_name character varying(50) NOT NULL,
  facebook_id character varying(50) NOT NULL
);

CREATE TABLE cats.video
(
  video_id serial primary key NOT NULL,
  video_name character varying(50) NOT NULL
);

CREATE TABLE cats.login
(
  login_id serial primary key NOT NULL,
  user_id integer references cats."user" (user_id) NOT NULL,
  "time" timestamp without time zone NOT NULL
);

CREATE TABLE cats.watch
(
  watch_id serial primary key NOT NULL,
  video_id integer references cats.video (video_id) NOT NULL,
  user_id integer references cats."user" (user_id) NOT NULL,
  "time" timestamp without time zone NOT NULL
);

CREATE TABLE cats.friend
(
  user_id integer references cats."user" (user_id) NOT NULL,
  friend_id integer references cats."user" (user_id) NOT NULL
);

CREATE TABLE cats."likes"
(
  like_id serial primary key NOT NULL,
  user_id integer references cats."user" (user_id) NOT NULL,
  video_id integer references cats.video (video_id) NOT NULL,
  "time" timestamp without time zone NOT NULL
);

CREATE TABLE cats.suggestion
(
  suggestion_id serial primary key NOT NULL,
  login_id integer references cats.login(login_id) NOT NULL,
  video_id integer references cats.video (video_id) NOT NULL
);

-- Loading sample data into sales
-- COPY <table_name> FROM <location in your computer> DELIMITER ',' CSV;
-- ie. COPY video FROM '/Users/swethakrishnakumar/Desktop/DSE201/video.txt' DELIMITER ',' CSV;
COPY cats."user" FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Cats/user.csv' DELIMITER ',' CSV;
COPY cats.video FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Cats/video.csv' DELIMITER ',' CSV;
COPY cats.friend FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Cats/friend.csv' DELIMITER ',' CSV;
COPY cats.likes FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/day2_SQL_Wrapup_Query_Processing/Milestone_II/Cats/likes.csv' DELIMITER ',' CSV;