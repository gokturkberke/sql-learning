-- ORDER BY
SELECT * FROM books
ORDER BY author_lname;
-- multiple columns
SELECT author_fname,author_lname FROM books
ORDER BY author_lname,author_fname;
SELECT CONCAT(author_fname,' ',author_lname) AS author FROM books
ORDER BY author;

-- LIMIT
SELECT book_id, title,released_year FROM books 
ORDER BY released_year DESC LIMIT 10 ;

SELECT book_id, title,released_year FROM books 
ORDER BY released_year LIMIT 5,7 ; -- 5 satir atla 7 satir getir

-- LIKE
SELECT title,author_fname,author_lname FROM books 
WHERE author_fname LIKE '%da%';

SELECT * FROM books WHERE author_fname LIKE '____'; -- 4 karakter olan herhangi bir sey
SELECT * FROM books WHERE title LIKE '%\%%'; -- % ile baslayan bir sey arayacaksak bunu yapabiliriz mesela

select title from books where title LIKE '%stories%';
select title,pages from books order by pages desc limit 1;
select concat(title,' - ',released_year) as summary from books order by released_year desc limit 3;
select title,author_lname from books where author_lname like '% %' ;
select title,released_year,stock_quantity from books order by stock_quantity limit 3;
select title,author_lname from books order by author_lname,title;
select UPPER(CONCAT('my favorite author is ',author_fname,' ',author_lname)) as yell from book_shop.books order by author_lname;


-- AGGREGATE FUNCTIONS
-- count
SELECT COUNT(*) FROM books; -- total of rows
SELECT author_fname FROM books;

SELECT COUNT(author_fname) from books;
SELECT COUNT(DISTINCT author_fname) from books;

SELECT COUNT(title) from books where title LIKE '%the%';

-- GROUP BY
select title,author_lname from books group by author_lname; -- hata verir ; bir sorguda GROUP BY kullanıyorsanız, SELECT listesinde yalnızca şunlar bulunabilir:
-- GROUP BY ifadesinde kullandığınız sütunlar (author_lname gibi).
-- Toplama (aggregate) fonksiyonları (COUNT(), MAX(), MIN(), SUM(), AVG(), GROUP_CONCAT() gibi).
select author_lname, Count(*) as books_written from books group by author_lname; 
 
 -- MIN AND MAX
select min(released_year) from books;
select max(pages) from books;
SELECT author_lname,COUNT(*) as books_written, MIN(released_year) as earliest_year ,MAX(released_year) as latest_year from books group by author_lname;
SELECT 
    CONCAT(author_fname, ' ', author_lname) AS author,
    MIN(released_year)
FROM
    books
GROUP BY author;

-- SUBQUERY
SELECT title,pages from books
where pages = (SELECT MAX(pages) from books);

SELECT title,released_year from books
where released_year = (SELECT MIN(released_year) from books);

SELECT author_fname,author_lname, COUNT(*) from books
GROUP BY author_lname,author_fname;

-- SUM and AVG
select SUM(pages) from books;
select author_lname,SUM(pages) from books group by author_lname;
select avg(released_year) from books;
select avg(stock_quantity),released_year,COUNT(*) from books group by released_year;

select count(*) from books;
select count(*),released_year from books group by released_year;
select avg(released_year),author_fname,author_lname from books group by author_fname,author_lname;
select concat(author_fname,' ',author_lname) as author  from books where pages = (select max(pages) from books);
select released_year as year,count(*) as ' #books' ,avg(pages) from books group by year order by year;


