SELECT d.department_name, 
COUNT(e.employee_id), ROUND(AVG(e.salary),2)
FROM hr.departments d JOIN hr.employees e ON d.department_id = e.department_id
GROUP BY d.department_name
HAVING AVG(e.salary) > 5000;

SELECT e.first_name || ' ' || e.last_name AS full_name, 
j.job_title, e.hire_date
FROM hr.employees e JOIN hr.jobs j ON e.job_id = j.job_id
WHERE e.phone_number IS NULL;

SELECT e.employee_id, j.job_title, e.salary
FROM hr.employees e JOIN hr.jobs j ON e.job_id = j.job_id JOIN hr.departments d ON e.department_id = d.department_id
WHERE d.department_name = 'IT' AND e.salary > 5000;

SELECT d.department_name,  c.country_name, l.city
FROM hr.departments d 
LEFT JOIN hr.locations l ON d.location_id = l.location_id 
LEFT JOIN hr.countries c ON l.country_id = c.country_id
JOIN hr.employees e ON e.department_id = d.department_id
GROUP BY d.department_name, c.country_name, l.city
HAVING COUNT(e.employee_id) >= 2;

SELECT d.department_name, l.city, COUNT(DISTINCT e.employee_id) AS num_employees, COUNT(dep.dependent_id) AS num_dep
FROM hr.departments d JOIN hr.locations l ON d.location_id = l.location_id
JOIN hr.employees e ON e.department_id = d.department_id 
LEFT JOIN hr.dependents dep ON dep.employee_id = e.employee_id AND dep.relationship = 'Child'
GROUP BY d.department_name, l.city;

SELECT e.first_name || ' ' || e.last_name AS full_name, d.department_name, l.city, r.region_name
FROM hr.employees e LEFT JOIN hr.departments d ON e.department_id = d.department_id
LEFT JOIN hr.locations l ON d.location_id = l.location_id 
LEFT JOIN hr.countries c ON l.country_id = c.country_id
LEFT JOIN hr.regions r ON c.region_id = r.region_id
ORDER BY e.last_name DESC;

SELECT e.first_name || ' ' || e.last_name AS full_name, e.salary, d.department_name
FROM hr.employees e JOIN hr.departments d USING (department_id)
JOIN hr.locations l USING (location_id)
WHERE l.state_province = 'Washington';

SELECT DISTINCT r.region_name
FROM hr.regions r
LEFT JOIN hr.countries c ON c.region_id = r.region_id
LEFT JOIN hr.locations l ON l.country_id = c.country_id
LEFT JOIN hr.departments d ON d.location_id = l.location_id
WHERE d.department_id IS NULL;

SELECT e.first_name || ' ' || e.last_name AS full_name, d.department_name, l.city, r.region_name
FROM hr.employees e LEFT JOIN hr.departments d USING (department_id)
LEFT JOIN hr.locations l USING (location_id)
LEFT JOIN hr.countries c USING (country_id)
LEFT JOIN hr.regions r USING (region_id)
WHERE e.last_name ILIKE '%o%';

SELECT d.department_id, d.department_name, r.region_name, MAX(e.salary), 
STRING_AGG(last_name || ' ' ||SUBSTRING(first_name FROM 1 FOR 1) ||'.', ', ') AS full_name
FROM hr.employees e RIGHT JOIN hr.departments d USING (department_id)
LEFT JOIN hr.locations l USING (location_id)
LEFT JOIN hr.countries c USING (country_id)
LEFT JOIN hr.regions r USING (region_id)
GROUP BY d.department_id, d.department_name, r.region_name;

SELECT e.first_name || ' ' || e.last_name AS full_name,
d.department_name, l.city, c.country_name, e.salary
FROM hr.employees e
JOIN hr.departments d ON e.department_id = d.department_id
JOIN hr.locations l ON d.location_id = l.location_id
JOIN hr.countries c ON l.country_id = c.country_id
WHERE e.salary > 5000
ORDER BY e.salary DESC;

SELECT e.first_name || ' ' || e.last_name AS full_name,
d.department_name, l.city, c.country_name, e.salary
FROM hr.employees e, hr.departments d, hr.locations l, hr.countries c
WHERE e.department_id = d.department_id
  AND d.location_id = l.location_id
  AND l.country_id = c.country_id
  AND e.salary > 5000
ORDER BY e.salary DESC;

SELECT d.department_name, l.city, c.country_name, r.region_name
FROM hr.departments d
LEFT JOIN hr.locations l ON d.location_id = l.location_id
LEFT JOIN hr.countries c ON l.country_id = c.country_id
RIGHT JOIN hr.regions r ON c.region_id = r.region_id
ORDER BY r.region_name, d.department_name;