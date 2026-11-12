SELECT first_name 
FROM hr.employees 
WHERE first_name LIKE '_%e%n';

SELECT first_name, last_name, manager_id, phone_number, email, salary 
FROM hr.employees 
WHERE salary < 25000 
ORDER BY salary DESC;

SELECT first_name, last_name
FROM hr.employees 
WHERE (first_name LIKE '%l%l%' AND first_name LIKE '%a%') OR email LIKE '%!_%' ESCAPE '!';

SELECT last_name, hire_date
FROM hr.employees 
WHERE EXTRACT(YEAR FROM hire_date) BETWEEN 1997 AND 2000
ORDER BY last_name;

SELECT first_name, last_name
FROM hr.employees 
WHERE first_name LIKE '%oo%' OR last_name SIMILAR TO '%oo%';

SELECT DISTINCT manager_id 
FROM hr.employees
WHERE EXTRACT(YEAR FROM hire_date) < 1997 AND phone_number IS NULL
ORDER BY manager_id DESC;

SELECT last_name || ' ' || first_name as "full_name"
FROM hr.employees
ORDER BY 1;

SELECT *
FROM hr.employees
WHERE phone_number IS NULL;