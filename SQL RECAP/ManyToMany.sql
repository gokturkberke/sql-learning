CREATE DATABASE tv_db;
use tv_db;

CREATE TABLE reviewers(
	id INT PRIMARY KEY AUTO_INCREMENT,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL
);

CREATE TABLE series(
id INT PRIMARY KEY AUTO_INCREMENT,
title varchar(100),
released_year YEAR,
genre VARCHAR(50)
);

CREATE TABLE reviews(
id INT PRIMARY KEY AUTO_INCREMENT,
rating decimal(2,1),
series_id INT,
reviewer_id INT,
FOREIGN KEY(series_id) REFERENCES series(id),
FOREIGN KEY (reviewer_id) REFERENCES reviewers(id)
);

INSERT INTO series (title, released_year, genre) VALUES
    ('Archer', 2009, 'Animation'),
    ('Arrested Development', 2003, 'Comedy'),
    ("Bob's Burgers", 2011, 'Animation'),
    ('Bojack Horseman', 2014, 'Animation'),
    ("Breaking Bad", 2008, 'Drama'),
    ('Curb Your Enthusiasm', 2000, 'Comedy'),
    ("Fargo", 2014, 'Drama'),
    ('Freaks and Geeks', 1999, 'Comedy'),
    ('General Hospital', 1963, 'Drama'),
    ('Halt and Catch Fire', 2014, 'Drama'),
    ('Malcolm In The Middle', 2000, 'Comedy'),
    ('Pushing Daisies', 2007, 'Comedy'),
    ('Seinfeld', 1989, 'Comedy'),
    ('Stranger Things', 2016, 'Drama');
 
 
INSERT INTO reviewers (first_name, last_name) VALUES
    ('Thomas', 'Stoneman'),
    ('Wyatt', 'Skaggs'),
    ('Kimbra', 'Masters'),
    ('Domingo', 'Cortes'),
    ('Colt', 'Steele'),
    ('Pinkie', 'Petit'),
    ('Marlon', 'Crafford');
    
 
INSERT INTO reviews(series_id, reviewer_id, rating) VALUES
    (1,1,8.0),(1,2,7.5),(1,3,8.5),(1,4,7.7),(1,5,8.9),
    (2,1,8.1),(2,4,6.0),(2,3,8.0),(2,6,8.4),(2,5,9.9),
    (3,1,7.0),(3,6,7.5),(3,4,8.0),(3,3,7.1),(3,5,8.0),
    (4,1,7.5),(4,3,7.8),(4,4,8.3),(4,2,7.6),(4,5,8.5),
    (5,1,9.5),(5,3,9.0),(5,4,9.1),(5,2,9.3),(5,5,9.9),
    (6,2,6.5),(6,3,7.8),(6,4,8.8),(6,2,8.4),(6,5,9.1),
    (7,2,9.1),(7,5,9.7),
    (8,4,8.5),(8,2,7.8),(8,6,8.8),(8,5,9.3),
    (9,2,5.5),(9,3,6.8),(9,4,5.8),(9,6,4.3),(9,5,4.5),
    (10,5,9.9),
    (13,3,8.0),(13,4,7.2),
    (14,2,8.5),(14,3,8.9),(14,4,8.9);
    
select * from series;

select title,rating from series
inner join reviews
on reviews.series_id = series.id;

select title,AVG(rating) as avg_rating from series
join reviews 
on reviews.series_id = series.id
group by title
order by avg_rating;

-- select round(3.1412,2) = 3.14
select first_name,last_name,rating from reviewers
join reviews
on reviews.reviewer_id = reviewers.id;

select title from series
left join reviews
on reviews.series_id = series.id
where reviews.rating is null;

select genre,AVG(rating) from series -- if we want we can round it with ROUND(AVG(rating))
join reviews
on series.id = reviews.series_id
group by genre
order by genre
limit 3;

select first_name,last_name,COUNT(rating) AS COUNT,IFNULL(MIN(rating),0) as MIN, IFNULL(MAX(rating),0) as MAX,ROUND(IFNULL(AVG(rating),0),2) as AVG,
CASE 
	WHEN COUNT(rating)  > 0 THEN 'ACTIVE'
    ELSE 'INACTIVE'
END as STATUS
from reviewers
left join reviews
on reviewers.id = reviews.reviewer_id
group by first_name,last_name;

select series.title,reviews.rating,CONCAT(first_name, ' ',last_name) from reviewers
join reviews
on reviews.reviewer_id = reviewers.id 
join series
on
reviews.series_id = series.id
order by series.title;