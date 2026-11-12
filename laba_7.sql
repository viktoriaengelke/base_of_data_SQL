WITH RECURSIVE employees_tree AS(
SELECT r.employee_id, r.last_name, r.last_name || SUBSTR(r.first_name, 1, 1) || '.' || ' - ' || d.department_name AS full_name, 
1 AS level, '' AS managers_path
FROM hr.employees r JOIN hr.departments d USING (department_id)
WHERE r.manager_id IS NULL
UNION ALL
SELECT emp.employee_id, emp.last_name, emp.last_name || SUBSTR(emp.first_name, 1, 1) || '.' || ' - ' || dep.department_name, 
p.level+1, p.managers_path || ', ' || p.last_name AS managers_path
FROM hr.employees emp JOIN hr.departments dep ON dep.department_id = emp.department_id
JOIN employees_tree p ON emp.manager_id = p.employee_id
)
SELECT full_name, TRIM(BOTH ', ' FROM managers_path) AS managers
FROM employees_tree
WHERE level = 3;

WITH RECURSIVE employee_subs AS(
SELECT boss.employee_id AS root_id, emp.employee_id AS sub_id
FROM hr.employees boss JOIN hr.employees emp ON emp.manager_id = boss.employee_id
UNION ALL 
SELECT s.root_id, emp.employee_id AS sub_id
FROM employee_subs s JOIN hr.employees emp ON emp.manager_id = s.sub_id
)
SELECT e.last_name, COUNT(sub_id) AS num_subordinates
FROM employee_subs JOIN hr.employees e ON (root_id = e.employee_id)
GROUP BY e.last_name
HAVING COUNT(sub_id) > 1
ORDER BY num_subordinates DESC
LIMIT 7;

WITH RECURSIVE manager_subs AS(
SELECT boss.employee_id AS root_id, emp.employee_id AS sub_id, emp.salary AS sub_salary, emp.last_name AS sub_last_name
FROM hr.employees boss JOIN hr.employees emp ON emp.manager_id = boss.employee_id
JOIN hr.employees top ON boss.manager_id = top.employee_id
WHERE top.manager_id IS NULL
UNION ALL
SELECT s.root_id, emp.employee_id, emp.salary, emp.last_name
FROM manager_subs s 
JOIN hr.employees emp ON emp.manager_id = s.sub_id
)
SELECT m.last_name AS manager_name, SUM(ms.sub_salary) AS total_salary,
STRING_AGG(ms.sub_last_name, ', ') AS subordinates
FROM manager_subs ms 
JOIN hr.employees m ON ms.root_id = m.employee_id
GROUP BY m.last_name
ORDER BY m.last_name;

WITH RECURSIVE chain AS(
SELECT employee_id, last_name, manager_id, last_name::varchar AS full_chain
FROM hr.employees
UNION ALL
SELECT c.employee_id, c.last_name, boss.manager_id, c.full_chain || ' -> ' || boss.last_name
FROM chain c JOIN hr.employees boss ON c.manager_id = boss.employee_id
)
SELECT employee_id, last_name, full_chain
FROM chain
WHERE manager_id IS NULL
ORDER BY last_name;