/* handle event */
/* for PosgreSQL 14 on DO */

/* --- init data のあと --- */

/* --- move history --- */


-- 1995-10-01 入社、dept:3、メンバー、メイン
-- Assign (3, '0001', 'メンバー', '1995-10-01', true)
-- add event --
INSERT INTO Assignment (department_id, employee_number, position, assign_date, is_main)
 VALUES (3, '0001', 'メンバー', '1995-10-01', true);

-- update cache usign View --
UPDATE Employee SET main_department_id = assign.department_id, main_position = assign.position
 FROM Recent_Assign as assign WHERE Employee.employee_number = assign.employee_number AND assign.is_main = TRUE;

-- 確認 --
SELECT * FROM Assign_Leave;
SELECT * FROM Recent_Assign;
SELECT * FROM Recent_Employee;
SELECT * FROM Employee;



-- 1998-04-01 兼務＆主所属変更、

-- add event --
INSERT INTO Leaves (department_id, employee_number, position, leave_date, is_main)
 VALUES (3, '0001', 'メンバー', '1998-04-01', true);

INSERT INTO Assignment (department_id, employee_number, position, assign_date, is_main)
 VALUES
  (4, '0001', 'リーダー', '1998-04-01', true),
  (3, '0001', 'メンバー', '1998-04-01', false);

-- update cache usign View --
UPDATE Employee SET main_department_id = assign.department_id, main_position = assign.position
 FROM Recent_Assign as assign WHERE Employee.employee_number = assign.employee_number AND assign.is_main = TRUE;

-- 確認 --
SELECT * FROM Assign_Leave;
SELECT * FROM Recent_Assign;
SELECT * FROM Recent_Employee;
SELECT * FROM Employee;


-- 2015-04-01 異動,

-- add event --
INSERT INTO Leaves (department_id, employee_number, position, leave_date, is_main)
 VALUES
  (4, '0001', 'リーダー', '2015-04-01', true),
  (3, '0001', 'メンバー', '2015-04-01', false)
;

INSERT INTO Assignment (department_id, employee_number, position, assign_date, is_main)
 VALUES (1, '0001', '副課長', '2015-04-01', true);

-- update cache usign View --
UPDATE Employee SET main_department_id = assign.department_id, main_position = assign.position
 FROM Recent_Assign as assign WHERE Employee.employee_number = assign.employee_number AND assign.is_main = TRUE;

-- 確認 --
SELECT * FROM Assign_Leave;
SELECT * FROM Recent_Assign;
SELECT * FROM Recent_Employee;
SELECT * FROM Employee;


-- 2020-04-01 兼務
-- add event --
-- Assign  (2, '0001', 'メンバー', '2020-04-01', false)
INSERT INTO Assignment (department_id, employee_number, position, assign_date, is_main)
 VALUES (2, '0001', 'メンバー', '2020-04-01', false);

-- update cache usign View --
UPDATE Employee SET main_department_id = assign.department_id, main_position = assign.position
 FROM Recent_Assign as assign WHERE Employee.employee_number = assign.employee_number AND assign.is_main = TRUE;

-- 確認 --
SELECT * FROM Assign_Leave;
SELECT * FROM Recent_Assign;
SELECT * FROM Recent_Employee;
SELECT * FROM Employee;

-- 2021-04-01 副課長→課長
-- Leave (1, '0001', '副課長', '2021-04-01', true)
-- Assign (1, '0001', '課長', '2021-04-01', true)
-- add event --
INSERT INTO Leaves (department_id, employee_number, position, leave_date, is_main)
 VALUES (1, '0001', '副課長', '2021-04-01', true);
INSERT INTO Assignment (department_id, employee_number, position, assign_date, is_main)
 VALUES (1, '0001', '課長', '2021-04-01', true);

-- update cache usign View --
UPDATE Employee SET main_department_id = assign.department_id, main_position = assign.position
 FROM Recent_Assign as assign WHERE Employee.employee_number = assign.employee_number AND assign.is_main = TRUE;

-- 確認 --
SELECT * FROM Assign_Leave;
SELECT * FROM Recent_Assign;
SELECT * FROM Recent_Employee;
SELECT * FROM Employee;


-- 2021-10-01 入社、
-- Assign (2, '0021', 'メンバー', '2021-10-01', true)
-- add event --
INSERT INTO Assignment (department_id, employee_number, position, assign_date, is_main)
 VALUES (2, '0021', 'メンバー', '2021-10-01', true);

-- update cache usign View --
UPDATE Employee SET main_department_id = assign.department_id, main_position = assign.position
 FROM Recent_Assign as assign WHERE Employee.employee_number = assign.employee_number AND assign.is_main = TRUE;

-- 確認 --
SELECT * FROM Assign_Leave;
SELECT * FROM Recent_Assign;
SELECT * FROM Recent_Employee;
SELECT * FROM Employee;

-- 2022-04-01 兼務解除、
-- Leave  (2, '0001', 'メンバー', '2022-04-01', false)
-- add event --
INSERT INTO Leaves (department_id, employee_number, position, leave_date, is_main)
 VALUES (2, '0001', 'メンバー', '2022-04-01', false);

-- update cache usign View --
UPDATE Employee SET main_department_id = assign.department_id, main_position = assign.position
 FROM Recent_Assign as assign WHERE Employee.employee_number = assign.employee_number AND assign.is_main = TRUE;

-- 確認 --
SELECT * FROM Assign_Leave;
SELECT * FROM Recent_Assign;
SELECT * FROM Recent_Employee;
SELECT * FROM Employee;

----*/

