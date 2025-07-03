-- TIMESTAMPS
TIMESTAMP; -- we get current our timezone

SELECT NOW(); -- suan ki zamani verir

SELECT TIMEOFDAY(); -- aynisi sadece string bir sekilde okunmasi daha kolay

SELECT CURRENT_DATE;
--------------------------
-- EXTRACT function (allow us extract(cikarmak,elde etmek) or obtain(elde etmek) a sub component of a date value)
SELECT EXTRACT(YEAR FROM payment_date) AS myyear
FROM payment ;-- sadece yillari aliriz
-- ay icin month

SELECT EXTRACT(QUARTER FROM payment_date)
FROM payment; -- quarterlara boler vs vs

SELECT AGE(payment_date) 
FROM payment ;-- simdiki tarihten payment_date fonksiyondaki tarihlerin farkini alir

SELECT TO_CHAR(payment_date,'MONTH-YYYY')
FROM payment; -- aylari buyuk yazar ve yillari verir yaninda

SELECT TO_CHAR(payment_date,'mon/dd/YYYY')
FROM payment; -- aylar kucuk yaninda gunler ve yil

-- During which months did payments occur? Format your answer to return back the full month name
SELECT DISTINCT(TO_CHAR(payment_date,'MONTH'))
FROM payment;

-- How many payments occured on a monday
-- Sunday = 0 default value
SELECT COUNT(*)
FROM payment
WHERE EXTRACT(dow FROM payment_date) = 1;
-------------------------------------
-- math operations
SELECT ROUND(rental_rate / replacement_cost,2) FROM film; -- virgulden sonra 2 rakam

SELECT 0.1 * replacement_cost AS deposit
FROM film;
------------------------------------------
SELECT LENGTH(first_name) FROM customer;

SELECT first_name ||' '|| last_name AS full_name -- birlestirme , concat islemi (ben bi bosluk ekledim bilerek)
FROM customer;

SELECT upper(first_name) ||' '|| upper(last_name) AS full_name -- birlestirme , concat islemi (ben bi bosluk ekledim bilerek)
FROM customer;

-- left = returns first n characters in the string
SELECT left(first_name,1) || LOWER(last_name) || '@gmail.com' AS customer_email
FROM customer;
--------------------------------------------
-- SUBQUERY
-- ortalamanin ustunde olan filmler
SELECT title,rental_rate
FROM film
WHERE rental_rate >
(SELECT AVG(rental_rate) FROM film);

-- film id lerini ve titlelarini dondurecek verdigimiz araliklara uyan
SELECT film_id,title
FROM film
WHERE film_id IN
(SELECT inventory.film_id FROM rental
INNER JOIN inventory ON inventory.inventory_id = rental.inventory_id
WHERE return_date BETWEEN '2005-05-29' AND '2005-05-30')
ORDER BY title;

-- exist operator
-- tam tersini istersek exists onune NOT getirebiliriz
SELECT first_name , last_name
FROM customer as c
WHERE EXISTS
(SELECT * FROM payment as p
WHERE p.customer_id = c.customer_id
AND amount >11);
---------------------------------
-- SELF JOIN
SELECT f1.title,f2.title,f1.length
FROM film AS f1
INNER JOIN film AS f2 ON
f1.film_id != f2.film_id
AND f1.length = f2.length;



