CREATE SCHEMA sockers;

-- Create necessary tables
CREATE TABLE sockers.teams
(
  name character primary key NOT NULL,
  coach character varying(50) NOT NULL
);

CREATE TABLE sockers.matches
(
  hteam character references sockers.teams(name) NOT NULL,
  vteam character references sockers.teams(name) NOT NULL,
  hscore integer NOT NULL,
  vscore integer NOT NULL,
  PRIMARY KEY(hteam, vteam)
);

COPY sockers.teams FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/Final/teams.csv' DELIMITER ',' CSV;
COPY sockers.matches FROM '/Users/Orysya/Desktop/DSE201_Database_Management_Systems/Final/matches.csv' DELIMITER ',' CSV;