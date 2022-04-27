/* init data */
/* for MySQL 8 on DO */


/* ---- data clean up ----- */

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
  ('0001', '山田太郎', '1970-05-10', '1995-10-01', 1, '課長'),
  ('0021', '鈴木一美', '2000-08-25', '2022-04-01', 2, 'メンバー')
;




INSERT INTO Assignment (department_id, employee_number, position, assign_date)
 VALUES
  (2, '0021', 'メンバー', '2022-04-01')
  , (3, '0001', 'メンバー', '1995-10-01')
  , (4, '0001', 'リーダー', '1998-04-01')
  , (1, '0001', '副課長', '2015-04-01')
  , (2, '0001', 'メンバー', '2020-04-01')
  , (1, '0001', '課長', '2021-04-01')
;

INSERT INTO Leaves (department_id, employee_number, position, leave_date)
 VALUES
  (3, '0001', 'メンバー', '2015-04-01')
  , (4, '0001', 'リーダー', '2015-04-01')
  , (1, '0001', '副課長', '2021-04-01')
  , (2, '0001', 'メンバー', '2022-04-01')
;


