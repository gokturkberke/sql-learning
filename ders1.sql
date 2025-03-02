SELECT first_name,last_name FROM actor; 
-- lastname ilk siraya yazariz onu ilk gormek istersek

-- Distinct keyword (birden fazla degerleri elemek icin)
--SELECT * FROM film;
SELECT DISTINCT rental_rate FROM film;

--Count () ile birlikte kullanilir
SELECT COUNT(amount) FROM payment; --14596
SELECT COUNT(DISTINCT amount) FROM payment; --19

--WHERE
SELECT * FROM customer
where first_name = 'Jared';

SELECT * FROM film
WHERE rental_rate > 4 AND replacement_cost >= 19.99;

SELECT email FROM customer
WHERE first_name = 'Nancy' and last_name = 'Thomas';

SELECT description FROM film
WHERE title = 'Outlaw Hanky'; -- "" tirnak koymamaya dikat et error olur
-- "" sql standartlarinda column veya tablo isimleri icin kullanilir

--ORDER BY
SELECT * FROM customer
ORDER BY first_name;  --burda ASC veya DESC diyebilirz (desc yukaridan asagi)

SELECT store_id, first_name, last_name FROM customer
ORDER BY store_id DESC ,first_name ASC;

--LIMIT
SELECT * FROM payment
WHERE amount != 0.00
ORDER BY payment_date DESC
LIMIT 5; --5 tane gosterir sadece(5 tane en buyuk yani yakin tarih)


SELECT customer_id FROM payment
ORDER BY payment_date ASC
LIMIT 10;

--What are the titles of the 5 shorest movies? answer is this
SELECT title FROM film
ORDER BY length ASC
LIMIT 5;

--If the previous customer can watch any movie that 50 minutes
-- or less in run time how many options does she have
SELECT COUNT(*) FROM film
WHERE length <= 50;





