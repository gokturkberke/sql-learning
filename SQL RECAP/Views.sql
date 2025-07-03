use tv_db;

select title,released_year,genre,rating,first_name,last_name from reviews
join series
on series.id = reviews.series_id
join reviewers on reviewers.id = reviews.reviewer_id;

-- full_reviews adinda kullanmamiza izin verir uzun uzun yazmamiza gerek kalmaz
CREATE VIEW full_reviews AS
select title,released_year,genre,rating,first_name,last_name from reviews
join series
on series.id = reviews.series_id
join reviewers on reviewers.id = reviews.reviewer_id;

select * from full_reviews;

SELECT genre,AVG(rating) FROM  full_reviews GROUP BY genre;

CREATE VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year;
-- its a insertable table
INSERT INTO ordered_series (title,released_year,genre)
VALUES ( 'The Great Year' , 2020, 'Comedy');

-- it is also added to our series
select * from series;

select * from series where title = 'The Great Year'; -- id 15
DELETE FROM series WHERE id = 15;
-- bunu safe moddan dolayi izin vermiyo
DELETE FROM ordered_series WHERE title = 'The Great Year';

-- create or replace view
CREATE OR REPLACE VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year DESC;

ALTER VIEW ordered_series AS
SELECT * FROM series ORDER BY released_year;

DROP VIEW ordered_series;

-- HAVING using with group by)
SELECT title,AVG(rating), count(rating) as review_counts 
FROM full_reviews 
GROUP BY title
HAVING COUNT(rating) > 1;

-- WITH ROLLUP -> GROUP BY ile birlikte kullanıldığında, gruplanmış sonuçlara ek olarak ara toplam (subtotal) ve genel toplam (grand total) satırları ekler.
-- (mesela SELECT region, product, SUM(amount) AS total_sales
-- FROM sales
-- GROUP BY region, product WITH ROLLUP;
-- Çıktı:
-- | region | product | total_sales |
-- | :------- | :-------- | :------------ |
-- | Güney | Klavye | 330.00 | <-- Detay satırı
-- | Güney | Laptop | 1400.00 | <-- Detay satırı
-- | Güney | NULL | 1730.00 | <-- Güney bölgesi için ARA TOPLAM
-- | Kuzey | Laptop | 3100.00 | <-- Detay satırı
-- | Kuzey | Monitör | 400.00 | <-- Detay satırı
-- | Kuzey | NULL | 3500.00 | <-- Kuzey bölgesi için ARA TOPLAM
-- | NULL | NULL | 5230.00 | <-- GENEL TOPLAM


SELECT title,AVG(Rating) FROM full_reviews GROUP BY title WITH ROLLUP;
SELECT title,AVG(Rating),COUNT(Rating) FROM full_reviews GROUP BY title WITH ROLLUP;

SELECT  released_year,genre,AVG(rating) from full_reviews group by released_year, genre WITH ROLLUP;

SELECT 
    first_name, released_year, genre, AVG(rating)
FROM
    full_reviews
GROUP BY released_year , genre , first_name WITH ROLLUP;


