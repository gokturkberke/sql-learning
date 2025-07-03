-- char vs varchar
-- char veri uzunlugu hep sabitse mantikli(ulkekodu)  varchar daha az yer kaplar cogu zaman varchar kullanilir

-- DECIMAL -> PARA finans muhasebe gibi konularda kullaniyoruz sayiyi tam olarak belirttigimiz gibi saklar
-- decimal(5,2) demek total 5 numara olacak 2 tanesi virgulden sonra 999.99

-- float -> bilimsel veriler giizksel olcumler kesinligin gerekmedi hizin onemli oldugu yerler
-- double gloatin hassasiyetin yetmedigi hesaplamalar daha yuksek hassasiyete sahip ama daha gfazla yer kaplar

-- Bir FLOAT veya DOUBLE sütununda 0.1 + 0.2 işlemini yaparsanız, sonuç 0.30000000000000004 gibi garip bir şey olabilir.

-- Bir DECIMAL sütununda aynı işlemi yaparsanız, sonuç tam olarak 0.3 olur.

-- Bu yüzden asla ve asla para birimi, bakiye, fiyat gibi finansal verileri FLOAT veya DOUBLE ile saklamamalısınız!
-- ------------------------------------------------------------------------------------------------------------------------------
-- DATE(yyyy-mm-dd) and Times
CREATE TABLE people(
	name VARCHAR(100),
    birthdate DATE,
    birthtime TIME,
    birthdt DATETIME
);

INSERT INTO people (name,birthdate,birthtime,birthdt)
VALUES ('Elton','2012-12-15','11:00:00','2000-12-15 11:00:00')
;
INSERT INTO people (name,birthdate,birthtime,birthdt)
VALUES 
('Lulu','1985-04-11','09:45:10','1985-04-11 09:45:10'),
('Juan','2020-08-15','23:59:00','2020-08-15 23:59:15');

select * from people;
select curtime(); -- gives the current time (hour minute second)
select curdate();
select now(); -- ikisini birlikte verir current_timestamp() de ayni skeil

INSERT INTO people (name,birthdate,birthtime,birthdt)
VALUES ('Hazel', CURDATE(),CURTIME(), NOW());

select birthdate, monthname(birthdate) from people;
SELECT 
    birthdate,
    DAY(birthdate),
    DAYOFWEEK(birthdate),
    DAYOFYEAR(birthdate)
FROM people;
SELECT birthdate, DATE_FORMAT(birthdate, '%a %b %D') FROM people;

SELECT birthdate,DATEDIFF(CURDATE(),birthdate) from people;
SELECT birthdate, DATE_ADD(birthdate,INTERVAL 18 year) from people;
select timediff(curtime(),'07:00:00');
-- we can do basic math
select now() - interval 18 year;
-- timestamp; datetime ile aynidir farki zaman dilimine uygundur hangi anda oldu evrensel olarak sorusunu cevabi

