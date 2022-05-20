/* init data */
/* for PosgreSQL 14 on DO */

/* ---- clean up ----- */

/*
DELETE FROM Leaves;
DELETE FROM Assignment;
DELETE FROM Employee;
DELETE FROM Department;
*/


/* ---- init data ----- */

INSERT INTO Department (id, name) VALUES
  (1, '総務部'),
  (2, '人事部'),
  (3, '営業部'),
  (4, '開発部')
;

INSERT INTO Employee (employee_number, name, birthday, join_date, main_department_id, main_position)
 VALUES
  ('0001', '山田太郎', '1970-05-10', '1995-10-01', NULL, ''),
  ('0021', '鈴木一美', '1998-08-25', '2021-04-01', NULL, '')
;

-- 確認 --
SELECT * FROM Employee;

/* --- いっぺんに作る場合 --
INSERT INTO Assignment (department_id, employee_number, position, assign_date, is_main)
 VALUES
  (2, '0021', 'メンバー', '2022-04-01', true)
  , (3, '0001', 'メンバー', '1995-10-01', true)
  , (4, '0001', 'リーダー', '1998-04-01', true)
  , (1, '0001', '副課長', '2015-04-01', true)
  , (2, '0001', 'メンバー', '2020-04-01', false)
  , (1, '0001', '課長', '2021-04-01', true)
;

INSERT INTO Leaves (department_id, employee_number, position, leave_date, is_main)
 VALUES
  (3, '0001', 'メンバー', '2015-04-01', true)
  , (4, '0001', 'リーダー', '2015-04-01', true)
  , (1, '0001', '副課長', '2021-04-01', true)
  , (2, '0001', 'メンバー', '2022-04-01', false)
;
--- */

/* -- 値のアップデート -- */

-- 差分 --
UPDATE Assignment SET is_main = false
 WHERE department_id = 2 AND employee_number = '0001';

UPDATE Leaves SET is_main = false
 WHERE department_id = 2 AND employee_number = '0001';
