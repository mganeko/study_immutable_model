/* ---- 最新状況 ----*/
SELECT employee_number, department_id, position, SUM(assign_value), count(*)
 FROM Assign_Levae
 GROUP BY employee_number, department_id, position;
 
SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary, count(*)
 FROM Assign_Levae
   WHERE move_date < '2022-05-01'
 GROUP BY employee_number, department_id, position
  HAVING assign_summary > 0;

/* --- WITH -- */

WITH assign
AS (
  SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary
   FROM Assign_Levae
    WHERE move_date <= '2020-05-01'
   GROUP BY employee_number, department_id, position
   HAVING assign_summary > 0
)
SELECT asgn.employee_number, emp.name, department_id, dpt.name, position
 FROM assign AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;


WITH assign
AS (
  SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary
   FROM Assign_Levae
    WHERE move_date <= '2023-05-01'
   GROUP BY employee_number, department_id, position
   HAVING assign_summary > 0
)
SELECT asgn.employee_number, emp.name, department_id, dpt.name, position
 FROM assign AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;