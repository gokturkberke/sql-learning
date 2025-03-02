--JOINS(inner-outer-full-union) combine multiple tables

--AS -> isim degistirmek icin kullanilir
SELECT SUM(amount) AS net_revenue
FROM payment;

SELECT customer_id,SUM(amount) AS total_spent
FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100 ; --BURAYA total_spent yazamayiz error aliriz

SELECT customer_id , amount AS new_name
FROM payment
WHERE amount > 2; --Ayni sekilde buraya da amount yazmamiz lazim
--new_name yazarsak yine error verir yukaridaki gibi

--INNER JOIN--
--will result with the set of records that match in both tables
SELECT payment_id,payment.customer_id,first_name FROM payment
INNER JOIN customer --buraya payment yazip fromdan sonra da customer yazabiliriz bir sey farketmez
ON payment.customer_id = customer.customer_id;
--first name customer tablosuna ozel payment_id payment tablosuna
--ama customer id ikisinde de oldugu icin onu belirtmemiz lazim select yaparken


--FULL OUTER JOIN --her seyi alir iki tablodan ortak olmasi onemli degil
SELECT * FROM customer
FULL OUTER JOIN payment
ON customer.customer_id = payment.customer_id
WHERE customer.customer_id IS null OR
payment.payment_id IS null;
--bu ortaklari kaldirir ve iki tablo icin de farkli olanlari bastirir ekrana

--left outer join !! ORDER MATTER
SELECT film.film_id,title,inventory_id
FROM film 
LEFT OUTER JOIN inventory ON --filme tablosunda olan her bilgiyi aldik
inventory.film_id = film.film_id
--eger alttakinleri  de yazarsak sadece filmi aliriz ortaklari da cikaririz
WHERE inventory.film_id is null;

--aynisinin right outer joini var o da tam tersi leftin
--UNION
-- SELECT column_name FROM table1 UNION SELECT column_name 2 FROM table2 ORDER BY name

--QUESTIONS
--What are the emails of the customers who live in California?
SELECT district,email FROM address
INNER JOIN customer
ON address.address_id = customer.address_id
WHERE district = 'California';

--Get a list of all the movies "Nick Wahlberg" has been in
--3 tablo kullanmamiz lazim
SELECT title,first_name,last_name 
FROM film
INNER JOIN film_actor ON film.film_id = film_actor.film_id
INNER JOIN actor ON film_actor.actor_id = actor.actor_id
WHERE first_name = 'Nick' AND last_name = 'Wahlberg'


