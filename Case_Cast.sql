SELECT customer_id,
CASE 
	WHEN (customer_id <= 100) THEN 'Premium'
	WHEN (customer_id BETWEEN 100 and 200) THEN 'Plus'
	ELSE 'Normal'
END AS customer_class --boyle de isim degistirebiliyoruz
FROM customer;

SELECT customer_id,
CASE customer_id
	WHEN 2 THEN 'Winner'
	WHEN 5 THEN 'Second Place'
	ELSE 'Normal'
END AS raffle_results
FROM customer;

SELECT rental_rate,
CASE rental_rate 
	WHEN 0.99 THEN 1
	ELSE 0
END
FROM film;

--Kac tane oldugunu count ile ogrenme
SELECT
SUM(CASE rental_rate 
	WHEN 0.99 THEN 1
	ELSE 0
END) AS bargains,
SUM(CASE rental_rate
	WHEN 2.99 THEN 1
	ELSE 0
END) AS regular,
SUM(CASE rental_rate
	WHEN 4.99 THEN 1
	ELSE 0
END) AS premium
FROM film;
------------------------------------
--We want to know and compare the various amounts of films we have per movie rating
SELECT
SUM(CASE rating
	WHEN 'R' THEN 1 ELSE 0
	END
) AS R,
SUM(CASE rating
	WHEN 'PG' THEN 1 ELSE 0
END) AS PG,
SUM(CASE rating
	WHEN 'PG-13' THEN 1 ELSE 0
END) AS PG13
FROM film;
---------------------------------------
--COALESCE = Returns the first non null value
--CAST operator lets you convert from one data type into another
SELECT CAST('5' AS INTEGER) AS new_int;
--Postresql da soyle de yapabiliriz
SELECT '5'::INTEGER;

SELECT CHAR_LENGTH(CAST(inventory_id AS VARCHAR)) FROM rental
-----------------------------------------
--NULLIF = Takes 2 inputs and returns NULL IF both are equal otherwise it returns the first argument passed
--nullif(10,10) returns 10 for exmple




