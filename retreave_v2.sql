/* retreave */
/* for PosgreSQL 14 on DO */

-- 最新状況 --
WITH assign
AS (
  SELECT employee_number, department_id, position, is_main, SUM(assign_value) AS assign_summary
   FROM Assign_Leave
     WHERE move_date <= '2023-05-01'
   GROUP BY employee_number, department_id, position, is_main
   HAVING SUM(assign_value) > 0
)
SELECT asgn.employee_number, emp.name, department_id, dpt.name, asgn.is_main, asgn.position
 FROM assign AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;
  

-- 途中の状況 --
WITH assign
AS (
  SELECT employee_number, department_id, position, is_main, SUM(assign_value) AS assign_summary
   FROM Assign_Leave
     WHERE move_date <= '2021-05-01'
   GROUP BY employee_number, department_id, position, is_main
   HAVING SUM(assign_value) > 0
)
SELECT asgn.employee_number, emp.name, department_id, dpt.name, asgn.is_main, asgn.position
 FROM assign AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;
