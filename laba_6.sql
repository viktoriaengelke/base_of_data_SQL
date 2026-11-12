SELECT d.department_name, ROUND(AVG(e.salary), 2) AS avg_salary
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) < (SELECT AVG(salary) FROM hr.employees);

SELECT e.first_name, d.department_name
FROM hr.employees e JOIN hr.departments d USING (department_id)
WHERE e.salary IN (SELECT salary FROM hr.employees WHERE first_name = 'Alexander');

SELECT e.employee_id, e.first_name, e.last_name, j.job_title, e.salary,
(SELECT MAX(emp.salary) FROM hr.employees emp WHERE e.job_id = emp.job_id) AS max_salary,
(SELECT MAX(emp.salary) FROM hr.employees emp WHERE emp.job_id = e.job_id) - e.salary AS diff_salary
FROM hr.employees e JOIN hr.jobs j USING (job_id)
WHERE (SELECT MAX(emp.salary) FROM hr.employees emp WHERE emp.job_id = e.job_id) - e.salary <> 0;

SELECT e.first_name || ' ' || e.last_name AS full_name
FROM hr.employees e
WHERE CURRENT_DATE - e.hire_date > (SELECT AVG(CURRENT_DATE - emp.hire_date) FROM hr.employees emp WHERE emp.department_id = e.department_id);

SELECT e.first_name || ' ' || e.last_name AS full_name,
(SELECT SUM(emp.salary) FROM hr.employees emp WHERE emp.manager_id = e.employee_id)
FROM hr.employees e
WHERE e.employee_id IN (SELECT emp.manager_id FROM hr.employees emp)
ORDER BY (SELECT AVG(emp.salary) FROM hr.employees emp WHERE emp.manager_id = e.employee_id) DESC;

SELECT e.first_name || ' ' || e.last_name AS full_name, sum_salary
FROM hr.employees e 
JOIN (SELECT manager_id, SUM(emp.salary) AS sum_salary, AVG(emp.salary) AS avg_salary 
	FROM hr.employees emp GROUP BY emp.manager_id) m ON e.employee_id = m.manager_id
ORDER BY avg_salary DESC;

SELECT e.first_name || ' ' || e.last_name AS full_name, d.department_name, j.job_title
FROM hr.employees e JOIN hr.departments d USING (department_id)
JOIN hr.jobs j USING (job_id)
WHERE (job_id, department_id) IN (SELECT emp.job_id, emp.department_id FROM hr.employees emp WHERE first_name = 'Alexander');