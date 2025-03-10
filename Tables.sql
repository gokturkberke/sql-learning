-- CREATE TABLE account(
--    user_id SERIAL PRIMARY KEY,
--    username VARCHAR(50) UNIQUE NOT NULL,
--    password VARCHAR(50) NOT NULL,
--    email VARCHAR(250) UNIQUE NOT NULL,
--    created_on TIMESTAMP NOT NULL,
--    last_login TIMESTAMP --hesap olustursak bile login yapmayabiliriz ondan not null yapmadik
-- )
--Serial veri tipi auto increment yani her kayit eklendiginde bu ornekte
--user id alani otomatik olarak 1 artarak benzersersiz bir kimlik olur kisacasi otomatik her kullanicinin user idsinin 1 artmasini saglar
----------------------------------------------
-- CREATE TABLE job(
-- 	job_id SERIAL PRIMARY KEY,
-- 	job_name VARCHAR(200) UNIQUE NOT NULL
-- )

-- CREATE TABLE account_job(
-- 	user_id INTEGER REFERENCES account (user_id), --hangi tablo ve hangi column referans ediyo onu yazyirouz
-- 	job_id INTEGER REFERENCES job (job_id),
-- 	hire_date TIMESTAMP
-- )
---------------------------------------------
--INSERT VALUES
-- INSERT INTO account(username,password,email,created_on)
-- VALUES
-- ('Jose','password','jose@mail.com',CURRENT_TIMESTAMP)

-- INSERT INTO job(job_name)
-- VALUES
-- ('Astronaut')

-- INSERT INTO job(job_name)
-- VALUES
-- ('President')

-- INSERT INTO account_job(user_id,job_id,hire_date)
-- VALUES
-- (1,1,CURRENT_TIMESTAMP)
-----------------------------------------------------
-- UPDATE account
-- SET last_login = CURRENT_TIMESTAMP

SELECT * FROM account_job;

-- UPDATE account
-- SET last_login = created_on diyip created on daki degere de esitleyebiliriz

UPDATE account_job
SET hire_date = account.created_on
FROM account
WHERE account_job.user_id = account.user_id;

UPDATE account
SET last_login = CURRENT_TIMESTAMP
RETURNING email,created_on,last_login;
------------------------------------------
--DELETE
-- INSERT INTO job(job_name)
-- VALUES
-- ('Cowboy')

DELETE FROM job -- yazarsak sadece her seyi siler
WHERE job_name = 'Cowboy'
RETURNING job_id,job_name; -- sildigimiz rowlari dondurur
---------------------------------------------
--ALTER
-- CREATE TABLE information(
--   info_id SERIAL PRIMARY KEY,
--   title VARCHAR(500) NOT NULL,
--   person VARCHAR(500) NOT NULL UNIQUE
-- )

ALTER TABLE information
RENAME TO new_info;-- ismini degistirdik

ALTER TABLE new_info
RENAME COLUMN person TO people; -- column ismi degistirdik

ALTER TABLE new_info
ALTER COLUMN people DROP NOT NULL; -- droplayabiliriz ozelligi eklemek istersek de SET kelimesiyle ekleriz

INSERT INTO new_info(title)
VALUES
('Some new title')
------------------------------------------
--DROP TABLE
ALTER TABLE new_info
DROP COLUMN people ;

--error almamak icin sunu yazmak daha mantikli olmamasi durumunda
ALTER TABLE new_info
DROP COLUMN IF EXISTS people; -- error vermez olmadigi durumda mesaj verir
--------------------------------------
--CHECK Constraint
CREATE TABLE employees(
	emp_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	birthdate DATE CHECK (birthdate > '1915-01-01'),
	hire_date DATE CHECK(hire_date > birthdate),
	salary INTEGER CHECK(salary > 0)
)

INSERT INTO employees(
first_name , last_name , birthdate,hire_date,salary
)
VALUES
(
'Sammy','Smith','2001-07-02','2024-2-1','8900'
)

SELECT * FROM employees

