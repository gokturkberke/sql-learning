CREATE TABLE shops(
	name VARCHAR(150) NOT NULL
);

-- tirnakli string nasil yazilir
INSERT INTO shops (name)
VALUES('mario\'s pizza');

INSERT INTO shops (name)
VALUES('she said "haha"');

select * FROM shops;

DROP TABLE shops;

-- -----------------------------------------------
-- PRIMARY KEY(unique
CREATE TABLE unique_cats(
cat_id INT AUTO_INCREMENT PRIMARY KEY,
name VARCHAR(150) NOT NULL,
age INT NOT NULL
);

-- insert into ile cat_id yazmamiza gerek yok otomatik kendiis articak
INSERT INTO unique_cats(name,age)
VALUES('Boingo',5);

select * FROM unique_cats;

DESC unique_cats;

-- CREATE TABLE Employees (
-- id INT AUTO_INCREMENT PRIMARY KEY,
-- last_name VARCHAR(100) NOT NULL,
-- first_name VARCHAR(100) NOT NULL,
-- middle_name VARCHAR(100),
-- age INT NOT NULL,
-- current_status VARCHAR(100) NOT NULL DEFAULT 'employed'
-- );
-- -----------------------------------------------
CREATE TABLE cats (
    cat_id INT AUTO_INCREMENT,
    name VARCHAR(100),
    breed VARCHAR(100),
    age INT,
    PRIMARY KEY (cat_id)
); 

INSERT INTO cats(name, breed, age) 
VALUES ('Ringo', 'Tabby', 4),
       ('Cindy', 'Maine Coon', 10),
       ('Dumbledore', 'Maine Coon', 11),
       ('Egg', 'Persian', 4),
       ('Misty', 'Tabby', 13),
       ('George Michael', 'Ragdoll', 9),
       ('Jackson', 'Sphynx', 7);

-- aliases(renaming column)
select cat_id as id,name from cats; -- cat_id yi direkt id seklinde gorebiliriz tablo da

-- UPDATE
UPDATE cats SET name = 'Alex'
WHERE cat_id = 1;

select * from cats;

-- DELETE 
-- delete from cats; butun rowlari siler table silmez ama
DELETE FROM cats WHERE cat_id = 4;
select * from cats;



