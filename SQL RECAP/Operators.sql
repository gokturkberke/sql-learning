-- ! not equal operator
select title,author_lname from books where author_lname != 'Gaiman';

-- not like
select title from books where title not like '% %'; -- bosluk olmayan seyleri yazdirir

-- > < 
SELECT * FROM books
WHERE pages > 500;
SELECT * FROM books
WHERE released_year <= 1985;

-- and or
select * from books where author_lname = 'Eggers' 
and
released_year > 2010;
select title,author_lname,released_year from books
where author_lname = 'Eggers' or released_year > 2010;

-- between
select title,released_year from books where released_year between 2004 and 2015;

select * from people where year(birthdate) < 2005;
select * from people where birthtime between '12:00:00' and '16:00:00';  -- we can cast and make string int
select * from people where birthtime between cast('12:00:00' as time) and cast('16:00:00' as time);

-- in
select title,author_lname from books where author_lname in ('Carver','Lahiri','Smith'); -- or ile tane tane yazmaktan daha iyi
select title,released_year from books where released_year >= 2000 and
released_year % 2 =1; -- only get the odd numbers

-- Case
select title,released_year,
CASE 
	when released_year >= 2000 then 'modern lit'
    ELSE '20th century lit'
END AS genre
FROM books;

select title,stock_quantity,
case
	when stock_quantity between 0 and 40 then '*'
    when stock_quantity between 41 and 70 then '**'
    when stock_quantity between 71 and 100 then '***'
    when stock_quantity between 10 and 140 then '****'
    ELSE '*****'
END as stocks
from books;

-- is null select * from books where title is null;
select 1 in (5,3) or 9 between 8 and 10; -- 1 5 ile 3 listesi icinde mi no digeri yes sonuc 1
select * from books;
select title from books where released_year < 1980;
select title from books where author_lname ='Eggers' or 'Chabon';
select title from books where author_lname = 'Lahiri' and released_year >= 2000;
select title,pages from books where pages between 100 and 200;
select title,author_lname from books where author_lname like 'c%' or author_lname like 's%';
-- bunu su sekilde de yazabiliriz
select title,author_lname from books where substr(author_lname,1,1) in('C', 'S');

select title,author_lname,
case
	when title like '%stories%' then 'Short Stories'
    when title = 'Just Kids' or 'A Heartbreaking Work' then 'Memoir'
    ELSE 'Novel'
END as TYPE
from books;

select author_fname,author_lname,
	CASE
    WHEN COUNT(*) = 1 then '1 book'
    ELSE  CONCAT(COUNT(*), ' books')
	end as count
from books
WHERE author_lname is not null
group by author_lname,author_fname;

-- UNIQUE ayni olmamalari icin table olustururken tanimlayabiliriz
-- CHECK
CREATE TABLE users (
username varchar(30) not null,
age int check(age >0), -- checki bu sekilde kulalnabiliriz
word varchar(100) check(reverse(word) = word), -- tersiyle ayni olan seyleri ekleyebiliriz sadcece
-- checki constraint ile yazmak daha mantikli soyle
constraint age_over_18 check(age > 18),
-- multiple column with constraint
constraint username_age unique(username,age) -- bu ikili kombinasyonun unique olip olmamasina bakar
);

-- alter ile degistireibliyoruz tablolari
alter table users
add column phone varchar(15);

alter table users
drop column phone;

-- renaming with alter
RENAME TABLE users to suppliers;
alter table users
rename column username to users_username;

alter table suppliers
modify users_username varchar(100) default 'unkown';

alter table suppliers
change word wordd varchar(150); -- desek de oluyo

alter table users add constraint positive_price check(purchase_price >= 0);





























