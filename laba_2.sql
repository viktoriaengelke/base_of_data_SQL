SELECT CONCAT(last_name, ' ', SUBSTRING(first_name FROM 1 FOR 1), '.') AS full_name
FROM hr.employees
WHERE salary*6>50000
ORDER BY last_name;

SELECT department_id, SUBSTRING(first_name FROM 2)
FROM hr.employees
WHERE last_name ILIKE 'HUNOLD';

SELECT LOWER(last_name), round(salary/20*5)
FROM hr.employees
WHERE first_name NOT ILIKE 'Steven'
ORDER BY salary DESC;

SELECT first_name, last_name, salary*12 AS year_salary, ROUND(salary * 0.1) AS bonus
FROM hr.employees
WHERE salary/20 <= 400 AND (LENGTH(first_name) = 5 OR LENGTH(last_name) = 5);

SELECT CONCAT(last_name, ' ', first_name), trunc(salary/20)||' руб '||round((salary/20-trunc(salary/20))*100,0)||' коп ' AS
daily_salary
FROM hr.employees;

SELECT first_name, last_name, salary, salary - 10000 AS raw_diff,
    ABS(salary - 10000) AS abs_diff,
    SIGN(salary - 10000) AS direction
FROM hr.employees
ORDER BY abs_diff DESC;

SELECT ROUND(SQRT(salary), 2) AS sqrt_salary
FROM hr.employees;
