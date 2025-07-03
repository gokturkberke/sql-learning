CREATE SCHEMA learning;


CREATE TABLE CUSTOMERS(CustomerID int,
 CustomerFirstName char,  -- null olmamasini istiyorsak NOT NULL diye de ekleyebiliriz
 CustomerLastName char NOT NULL , -- default value ekleyebiliriz
 age INT NOT NULL DEFAULT 99
 );

-- soldan tabledan alter table diyip varchar(50) yaptim charlari kendim 
-- DROP TABLE CUSTOMERS;

select * from customers;

-- insert part 
INSERT INTO customers
VALUES
(1, 'Berke','Korkut');

-- DROP TABLE CUSTOMERS
-- DROP SCHEMA LEARNING

-- -------------------------------------------------------------------------------
SELECT *
FROM classicmodels.CUSTOMERS
WHERE contactLastName <> 'Young'; -- is not

-- lower upper
select * from employees
WHERE lower(email) = 'DMURPHY@CLASSICMODELCARS.COM'; -- hepsini buyuk yazmis olsak bile lower ile kisaca onu bulabiliriz bastan yazmak yerine

select * from
employees
where lower(email) in ('DMURPHY@CLASSICMODELCARS.COM',
'MPATTERSO@CLASSICMODELCARS.COM'); -- not in de bu ikisi olamyan her seyi gosterir

-- DISTINCT = PROVIDE UNIQUE NAME
SELECT DISTINCT COUNTRY
FROM CUSTOMERS;

SELECT * FROM CUSTOMERS -- veya SELECT DISTINCT CITY FROM CUSTOMERS
WHERE CITY LIKE '%New%';

-- ORDER BY
SELECT * FROM employees
ORDER BY lastname; -- DESC derse azalan alfabetik zden a ya

SELECT * FROM employees
ORDER BY lastname desc , firstname desc;

SELECT DISTINCT orderdate
FROM orders
order by orderdate;

-- WHERE KEYWORD

SELECT * FROM orders
WHERE lower(comments) LIKE '%negotiate%';

DESC customers; -- tabloda neler var gormek icin desc kullanabiliriz