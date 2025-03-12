
-- CREATE TABLE depts(
-- fisrt_name VARCHAR(50),
-- department VARCHAR(50)
-- )

INSERT INTO depts(fisrt_name,department)
VALUES(
'Vinton','A'
),
('Lauren','A'),
('Claire','B');

--Eger yanlis yazarsak su sekilde duzeltebiliriz column ismini
ALTER TABLE depts RENAME COLUMN fisrt_name TO first_name;

SELECT (
SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END)/
SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END)
) AS department_ratio
FROM depts;

DELETE FROM depts
WHERE department = 'B';


SELECT (
SUM(CASE WHEN department = 'A' THEN 1 ELSE 0 END)/
	NULLIF(SUM(CASE WHEN department = 'B' THEN 1 ELSE 0 END),0)
	--Eğer SUM(...)=0 ise, NULLIF(0, 0) olduğu için sonuç NULL olur.
) AS department_ratio
FROM depts;
----------------------------------
--EXPORT AND IMPORT CSV FILES
--INDIRECEGIM Csv dosyasinin ozelliklerine gore table olusturmamiz lazim
CREATE TABLE users (
    username VARCHAR(50),
    identifier INT,
    first_name VARCHAR(100),
    last_name VARCHAR(100)
);

--CSV dosyasini ice aktar
\copy users (username, identifier, first_name, last_name) 
FROM '/Users/gokturkberkekorkut/Downloads/username.csv' 
CSV HEADER;

SELECT * FROM users;