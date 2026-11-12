SELECT department_id, ROUND(AVG(salary),2) AS avg_salary
FROM hr.employees
GROUP BY department_id
HAVING COUNT(employee_id) > 5
ORDER BY avg_salary DESC;

SELECT COUNT(employee_id), job_id
FROM hr.employees
WHERE EXTRACT(YEAR FROM hire_date) > 1990
GROUP BY job_id;

SELECT
STRING_AGG(last_name || '//' || job_id || '//' || salary, ', '),
MIN(salary), MAX(salary), ROUND(AVG(salary),2)
FROM hr.employees
GROUP BY department_id;

SELECT COUNT(employee_id), manager_id
FROM hr.employees
GROUP BY manager_id
HAVING AVG(salary) BETWEEN 3000 AND 7000
ORDER BY COUNT(employee_id);

SELECT department_id || '-' || COUNT(employee_id) AS dept_count, 
ROUND(AVG(salary), 2),
STRING_AGG(last_name, ', ')
FROM hr.employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) < 6000;

SELECT 
    job_id,
    COUNT(employee_id) AS num_employees,
    SUM(salary) AS total_salary
FROM hr.employees
GROUP BY job_id
ORDER BY total_salary DESC;

SELECT 
    department_id,
    COUNT(employee_id) AS num_employees,
    ROUND(AVG(salary), 2) AS avg_salary,
    SUM(salary) AS total_salary
FROM hr.employees
WHERE department_id IS NOT NULL
GROUP BY department_id
HAVING AVG(salary) > 5000 
   AND COUNT(employee_id) > 3
ORDER BY avg_salary DESC;