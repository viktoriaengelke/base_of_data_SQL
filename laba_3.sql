SELECT 
    CONCAT(last_name, ' ', first_name) AS full_name,
    job_id
FROM hr.employees
WHERE EXTRACT(DAY FROM (DATE_TRUNC('month', hire_date) + INTERVAL '1 month') - hire_date) < 10;

SELECT 
    CONCAT(last_name, ' ', SUBSTRING(first_name FROM 1 FOR 1), '.') AS full_name,
    TO_CHAR(hire_date, 'J') AS julian_day
FROM hr.employees
ORDER BY last_name DESC;

SELECT 
    CONCAT(last_name, ' - ', phone_number) AS contact,
    TO_CHAR(hire_date, 'FMDD MON YYYY') AS hire_date_formatted,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) * 12 
      + EXTRACT(MONTH FROM AGE(CURRENT_DATE, hire_date)) AS months_worked
FROM hr.employees;

SELECT 
    CONCAT(last_name, ' ', first_name) AS full_name,
    hire_date
FROM hr.employees
WHERE EXTRACT(YEAR FROM AGE(CURRENT_DATE, hire_date)) > 30
  AND EXTRACT(YEAR FROM hire_date) BETWEEN 1990 AND 1995;

SELECT 
    UPPER(last_name) || ' ' || TO_CHAR(hire_date, 'DD.MM.YYYY') AS last_name_and_date,
    TO_CHAR(hire_date, 'FMDay – FMMonth') AS day_and_month
FROM hr.employees
WHERE job_id BETWEEN 14 AND 19
   OR salary BETWEEN 9000 AND 25000;

SELECT 
    CONCAT(last_name, ' ', first_name) AS full_name,
    hire_date,
    CURRENT_DATE - hire_date AS days_since_hire
FROM hr.employees
ORDER BY days_since_hire DESC;

SELECT 
    CONCAT(last_name, ' ', first_name) AS full_name,
    hire_date,
    TO_CHAR(hire_date, 'Q') AS quarter,
    TO_CHAR(hire_date, 'Day') AS weekday
FROM hr.employees
ORDER BY hire_date;