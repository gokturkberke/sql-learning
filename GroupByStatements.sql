--Aggregation Functions max-min-count-sum-avg
SELECT MIN(replacement_cost) FROM film;

SELECT 	ROUND(AVG(replacement_cost)) FROM film; --avg aliriz ve onu yuvarlariz

SELECT SUM(replacement_cost) FROM film;


--GROUP BY must appear right after a FROM or WHERE statement
SELECT customer_id FROM payment
GROUP BY customer_id
ORDER BY customer_id; --distinct customer_id gorevini gorur aslinda burda ve siralar 1 den kaca kadar gidiyosa idleri

SELECT customer_id , SUM(amount) FROM payment
GROUP BY customer_id
ORDER BY SUM(amount) DESC;

SELECT customer_id, staff_id , SUM(amount) FROM payment
GROUP BY staff_id , customer_id
ORDER BY customer_id; 

SELECT DATE(payment_date),SUM(amount) FROM payment
GROUP BY DATE(payment_date)
ORDER BY SUM(amount) DESC;


SELECT  staff_id, COUNT(amount) FROM payment
GROUP BY staff_id ;

--what is the relationship between mpaa rating and a movie
SELECT rating,AVG(replacement_cost) FROM film
GROUP BY rating;

--what are the customer ids of the top 5 customer by total spend
SELECT customer_id,SUM(amount) FROM payment
GROUP BY customer_id 
ORDER BY SUM(amount) DESC
LIMIT 5;



--HAVING
SELECT customer_id , SUM(amount) FROM payment
GROUP BY customer_id
HAVING SUM(amount) > 100;

SELECT store_id , COUNT(*) FROM customer --* yerine customer_id de yazabiliriz bir sey degismez
GROUP BY store_id
HAVING COUNT(*) > 300; --Where koyamayiz buraya
--group byden sonra geliyo cunku ama having koyabiliriz o yuzden kullaniyoruz


--Customers that have had 40 or more transaction payments
SELECT customer_id,COUNT(amount) FROM payment
GROUP BY customer_id
HAVING COUNT(amount) >= 40;

--what are customer ids of customers who have spent more than 100 dolar in payment transaction wit hour staff_id member 2
SELECT customer_id,SUM(amount) FROM payment
WHERE staff_id = '2'
GROUP BY  customer_id
HAVING SUM(amount) >100;


