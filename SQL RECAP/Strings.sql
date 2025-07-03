-- CREATE DATABASE book_shop;

-- use book_shop;

CREATE TABLE books 
	(
		book_id INT NOT NULL AUTO_INCREMENT,
		title VARCHAR(100),
		author_fname VARCHAR(100),
		author_lname VARCHAR(100),
		released_year INT,
		stock_quantity INT,
		pages INT,
		PRIMARY KEY(book_id)
	);

INSERT INTO books (title, author_fname, author_lname, released_year, stock_quantity, pages)
VALUES
('The Namesake', 'Jhumpa', 'Lahiri', 2003, 32, 291),
('Norse Mythology', 'Neil', 'Gaiman',2016, 43, 304),
('American Gods', 'Neil', 'Gaiman', 2001, 12, 465),
('Interpreter of Maladies', 'Jhumpa', 'Lahiri', 1996, 97, 198),
('A Hologram for the King: A Novel', 'Dave', 'Eggers', 2012, 154, 352),
('The Circle', 'Dave', 'Eggers', 2013, 26, 504),
('The Amazing Adventures of Kavalier & Clay', 'Michael', 'Chabon', 2000, 68, 634),
('Just Kids', 'Patti', 'Smith', 2010, 55, 304),
('A Heartbreaking Work of Staggering Genius', 'Dave', 'Eggers', 2001, 104, 437),
('Coraline', 'Neil', 'Gaiman', 2003, 100, 208),
('What We Talk About When We Talk About Love: Stories', 'Raymond', 'Carver', 1981, 23, 176),
("Where I'm Calling From: Selected Stories", 'Raymond', 'Carver', 1989, 12, 526),
('White Noise', 'Don', 'DeLillo', 1985, 49, 320),
('Cannery Row', 'John', 'Steinbeck', 1945, 95, 181),
('Oblivion: Stories', 'David', 'Foster Wallace', 2004, 172, 329),
('Consider the Lobster', 'David', 'Foster Wallace', 2005, 92, 343);

-- CONCAT
SELECT CONCAT(author_fname,' ',author_lname) as author_name from books;
-- aralara bir sey koymak istersek concat_ws
SELECT CONCAT_WS('-',title,author_fname,author_lname) from books;

-- CAST = type converter
SELECT 
  title,
  CAST(pages AS CHAR(5)) AS pages_text -- int'i chara donustururduk
FROM books
LIMIT 3;

-- SUBSTRING
SELECT SUBSTRING(title,1,15) FROM books;
SELECT 
    SUBSTRING(author_fname, 1, 1) AS initial
FROM
    books; -- hepsinin ilk harfini verir mesela

-- combining concat and substring
SELECT CONCAT(SUBSTRING(title,1,10),'...') as short_title FROM books;

-- replace (str,from_str,to_str)
SELECT
  REPLACE('cheese bread coffee milk', ' ', ' and ');
  
-- REVERSE
SELECT CONCAT('woof', REVERSE('woof'));
-- LENGTH
SELECT LENGTH("Hey!");
SELECT CHAR_LENGTH(title) as length, title FROM books;

-- upper and lower
SELECT upper(title) FROM books;

-- INSERT
SELECT INSERT('Hello Bobby', 6, 0, 'There'); 
SELECT LEFT('omghahalol!', 3);
SELECT RIGHT('omghahalol!', 4);
SELECT REPEAT('ha', 4);
SELECT TRIM('  pickle  ');

SELECT UPPER(REVERSE("Why does my cat look at me with such hatred"));
SELECT REPLACE(title,' ','->') as title from books;
SELECT author_lname as forwards ,REVERSE(author_lname) as backwards from books;
SELECT UPPER(CONCAT(author_fname,' ',author_lname)) AS 'full name in caps' from books;
SELECT CONCAT(title, ' was released in ', released_year) AS blurb FROM books;

