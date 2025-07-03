CREATE TABLE customer (
	 id INT PRIMARY KEY AUTO_INCREMENT,
     first_name VARCHAR(50),
     last_name VARCHAR(50),
     email VARCHAR(50)
     );

create table orders (
	id int primary key auto_increment,
    order_date date,
    amount decimal(8,2),
    customer_id int,
    FOREIGN KEY (customer_id) REFERENCES customer(id)
);

INSERT INTO customer (first_name, last_name, email) 
VALUES ('Boy', 'George', 'george@gmail.com'),
       ('George', 'Michael', 'gm@gmail.com'),
       ('David', 'Bowie', 'david@gmail.com'),
       ('Blue', 'Steele', 'blue@gmail.com'),
       ('Bette', 'Davis', 'bette@aol.com');
       
       
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016-02-10', 99.99, 1),
       ('2017-11-11', 35.50, 1),
       ('2014-12-12', 800.67, 2),
       ('2015-01-03', 12.50, 2),
       ('1999-04-11', 450.25, 5);
       
select id from customer where last_name  = 'George';
select * from orders where customer_id = 1;   

select * from orders where customer_id  =(select id from customer where last_name  = 'George');
select * from customers,orders; 

-- inner join
SELECT *
FROM customer
JOIN orders
ON customer.id = orders.customer_id;

-- with group by
select first_name , last_name , SUM(amount) from customer
join orders on orders.customer_id = customer.id
group by first_name,last_name;

-- left join
select first_name ,last_name,order_date, amount from customer
left join orders
on orders.customer_id = customer.id;

-- with group by
select first_name ,last_name,IFNULL(SUM(amount),0) as money_spent from customer
left join orders
on orders.customer_id = customer.id
group by first_name,last_name;


-- delete

create table orders (
	id int primary key auto_increment,
    order_date date,
    amount decimal(8,2),
    customer_id int,
    FOREIGN KEY (customer_id) REFERENCES customer(id) ON DELETE CASCADE -- on delete cascade ona bagli tum bilgileri silmemize saglar
    -- bunu yazmazsak izin vermez delete from customer where id 1 desek mesela orders tablosunda bu musteriye ait kayitlar var once onlari sil der
);

-- exercises
create table students(
 id int auto_increment primary key,
 first_name varchar(50)
 );
 
 create table papers(
 title varchar(50),
 grade int,
 student_id int ,
 foreign key(student_id) references students(id)
 );
 
 INSERT INTO students (first_name) VALUES 
('Caleb'), ('Samantha'), ('Raj'), ('Carlos'), ('Lisa');
 
INSERT INTO papers (student_id, title, grade ) VALUES
(1, 'My First Book Report', 60),
(1, 'My Second Book Report', 75),
(2, 'Russian Lit Through The Ages', 94),
(2, 'De Montaigne and The Art of The Essay', 98),
(4, 'Borges and Magical Realism', 89);
 
 select first_name,title,grade from students
 join papers
 on students.id = papers.student_id;
 
select first_name,title,grade from students
left join papers
on students.id = papers.student_id;

select first_name,IFNULL(title,'MISSING'),IFNULL(grade,0) from students
left join papers
on students.id = papers.student_id;

select first_name,IFNULL(avg(grade),0) as average from students
left join papers
on students.id = papers.student_id
group by first_name
order by avg(grade) DESC;

select first_name,IFNULL(avg(grade),0) as average,
CASE
	WHEN avg(grade) between 40 and 100 then 'PASSING'
    ELSE 'FAILING'
END as status
from students
left join papers
on students.id = papers.student_id
group by first_name
order by average DESC;

-- COALESCE Fonksiyonu
-- Coalesce fonksiyonunda iki alan girişi yapılır, ilk alanda kayıt mevcut değilse ikinci alandaki kayıt getirilir
CREATE TABLE Calisanlar (
    ID INT PRIMARY KEY,
    Ad VARCHAR(50),
    Soyad VARCHAR(50),
    EvTelefonu VARCHAR(20),
    CepTelefonu VARCHAR(20)
);

INSERT INTO Calisanlar (ID, Ad, Soyad, EvTelefonu, CepTelefonu) VALUES
(1, 'Ahmet', 'Yılmaz', '02121112233', '05321112233'), -- İki numarası da var
(2, 'Ayşe', 'Kaya', NULL, '05424445566'),           -- Sadece cep telefonu var
(3, 'Mehmet', 'Demir', '03127778899', NULL),          -- Sadece ev telefonu var
(4, 'Fatma', 'Şahin', NULL, NULL);                    -- Hiçbir numarası yok

SELECT
    Ad,
    Soyad,
    COALESCE(CepTelefonu, EvTelefonu, 'İletişim Bilgisi Yok') AS IletisimNumarasi
FROM
    Calisanlar;








