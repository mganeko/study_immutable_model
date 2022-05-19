
-- 個人別、メイン所属の最新状況 --
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
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id
 WHERE asgn.employee_number = '0001' AND asgn.is_main = true;

-- 個人別、メイン所属の最新状況、所属のIDのみ --
WITH assign
AS (
  SELECT employee_number, department_id, position, is_main, SUM(assign_value) AS assign_summary
   FROM Assign_Leave
     WHERE move_date <= '2021-05-01'
   GROUP BY employee_number, department_id, position, is_main
   HAVING SUM(assign_value) > 0
)
SELECT asgn.employee_number, asgn.is_main, asgn.position
 FROM assign AS asgn
 WHERE asgn.employee_number = '0001' AND asgn.is_main = true;

-- 最新状況のキャッシュを更新 ---
WITH assign
AS (
  SELECT employee_number, department_id, position, is_main, SUM(assign_value) AS assign_summary
   FROM Assign_Leave
     -- WHERE move_date <= '2021-05-01'
   GROUP BY employee_number, department_id, position, is_main
   HAVING SUM(assign_value) > 0
)
UPDATE Employee SET main_department_id = assign.department_id, main_position = assign.position
 FROM assign WHERE Employee.employee_number = assign.employee_number AND assign.is_main = TRUE;

-- 確認 --
SELECT * FROM Employee;
