-- CREATE TABLE students(
-- 	student_id SERIAL PRIMARY KEY,
-- 	first_name VARCHAR(50) NOT NULL,
-- 	last_name VARCHAR(50) NOT NULL,
-- 	homeroom_number INTEGER NOT NULL UNIQUE,
-- 	phone VARCHAR NOT NULL UNIQUE,
-- 	email VARCHAR(50) NOT NULL UNIQUE,
-- 	gradition_year INTEGER NOT NULL
-- )

-- CREATE TABLE teachers(
-- 	teacher_id SERIAL PRIMARY KEY,
-- 	first_name VARCHAR(50) NOT NULL,
-- 	last_name VARCHAR(50) NOT NULL,
-- 	homeroom_number INTEGER NOT NULL,
-- 	department VARCHAR(100) NOT NULL,
-- 	email VARCHAR(100) NOT NULL UNIQUE,
-- 	phone VARCHAR NOT NULL UNIQUE
-- )

INSERT INTO students(
first_name,last_name,phone,email,gradition_year,homeroom_number
)
VALUES
('Mark','Watney','777-555-1234','markWatney@gmail.com',2035,5);

INSERT INTO teachers(
first_name,last_name,homeroom_number,department,email,phone
)
VALUES
('Jonas','Salk',5,'Biology','jsalk@school.org','777-555-321')


SELECT * FROM teachers