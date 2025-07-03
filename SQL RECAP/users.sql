-- create trigger trigger_name
-- trigger_time trigger_event on table_name for each row
-- begin ...
-- end;
CREATE DATABASE trigger_demo;
use trigger_demo;

CREATE TABLE users (
	username VARCHAR(100),
    age INT
);

INSERT INTO users(username,age)
VALUES('bobby',23);

