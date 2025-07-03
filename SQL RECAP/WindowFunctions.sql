-- OVER
CREATE TABLE employees (
    emp_no INT PRIMARY KEY AUTO_INCREMENT,
    department VARCHAR(20),
    salary INT
);
 
INSERT INTO employees (department, salary) VALUES
('engineering', 80000),
('engineering', 69000),
('engineering', 70000),
('engineering', 103000),
('engineering', 67000),
('engineering', 89000),
('engineering', 91000),
('sales', 59000),
('sales', 70000),
('sales', 159000),
('sales', 72000),
('sales', 60000),
('sales', 61000),
('sales', 61000),
('customer service', 38000),
('customer service', 45000),
('customer service', 61000),
('customer service', 40000),
('customer service', 31000),
('customer service', 56000),
('customer service', 55000);

-- tum satirlara yazdirir
select emp_no,department, AVG(salary) OVER(), MIN(salary) OVER() FROM employees;

-- partition by ile kullanimi burada kendi maasini(salary) ve kendo departmaninin ortalama maasini yaninda gosteriyo
select emp_no, 
department, 
salary, 
AVG(salary) OVER(PARTITION BY department) AS dept_avg, AVG(salary) OVER() AS company_avg FROM employees;

SELECT 
    emp_no, 
    department, 
    salary, 
    COUNT(*) OVER(PARTITION BY department) as dept_count
FROM employees;

SELECT 
    emp_no, 
    department, 
    salary, 
    SUM(salary) OVER(PARTITION BY department) AS dept_payroll,
    SUM(salary) OVER() AS total_payroll
FROM employees;

-- using with order by
SELECT
emp_no, 
    department, 
    salary, 
    SUM(salary) OVER(PARTITION BY department) AS total_dept_salary,
    SUM(salary) OVER(PARTITION BY department ORDER BY salary DESC) AS rolling_dept_salary
FROM employees;

SELECT
emp_no, 
    department, 
    salary, 
    MIN(salary) OVER(PARTITION BY department ORDER BY salary ) AS rolling_min_salary
FROM employees;

-- using with RANK
SELECT
	emp_no, 
    department, 
    salary,
    RANK() OVER(PARTITION BY department ORDER BY salary desc) as dept_salary_rank,
    RANK() OVER(ORDER BY salary DESC) as overall_salary_rank
FROM employees;

-- DENSE_RANK AND ROW_NUMBER
SELECT
	emp_no, 
    department, 
    salary,
    ROW_NUMBER() OVER(PARTITION BY department ORDER BY salary DESC) as dept_row_number, -- departman siralamasina gore 1 den baslayarak siralar
    RANK() OVER(PARTITION BY department ORDER BY salary desc) as dept_salary_rank,
    RANK() OVER(ORDER BY salary DESC) as overall_rank,
    DENSE_RANK() OVER(ORDER BY salary DESC) as overall_dense_rank -- DENSE_RANK() fonksiyonu, RANK() gibidir ancak önemli bir farkla: Sıralamada asla boşluk bırakmaz.
FROM employees order by overall_rank;

-- NTILE (icine rakam yazariz ona gore mesela 4 ise 4 esit parcaya bolmek istedigimiz anlamina gelir)
SELECT
	emp_no,
    department,
    salary,
    NTILE(4) OVER(PARTITION BY department ORDER BY salary DESC) as dept_salary_quartile,
    NTILE(4) OVER(ORDER BY salary DESC) AS salary_quartile
FROM employees;

-- First values
SELECT
	emp_no,
    department,
    salary,
    FIRST_VALUE(emp_no) OVER(PARTITION BY department ORDER BY salary DESC) AS highest_paid_dept,
    FIRST_VALUE(emp_no) OVER(ORDER BY salary DESC)
FROM employees;

-- LEAD and LAG
-- LAG: Geriye bakar. Mevcut satırdan önceki satırın değerini getirir.
-- LEAD: İleriye bakar. Mevcut satırdan sonraki satırın değerini getirir.
SELECT 
	emp_no,
    department,
    salary,
    LAG(salary) OVER(ORDER BY salary DESC)
FROM employees;

SELECT 
	emp_no,
    department,
    salary,
    salary - LAG(salary) OVER(ORDER BY salary DESC) as salary_diff
FROM employees;

SELECT 
	emp_no,
    department,
    salary,
    salary - LEAD(salary) OVER(ORDER BY salary DESC) as salary_diff
FROM employees;

SELECT 
	emp_no,
    department,
    salary,
    salary - LAG(salary) OVER(PARTITION BY department ORDER BY salary DESC) as salary_diff -- we canprovide row with  lAG(salary,2)
FROM employees;