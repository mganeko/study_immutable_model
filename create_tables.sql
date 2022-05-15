/* create table */
/* for MySQL 8 on DO */

/* ---- clean up ----- */

/*
DROP VIEW Assign_Levae;
DROP TABLE Leaves;  -- old name: Leave_event;
DROP TABLE Assignment;
DROP TABLE Employee;
DROP TABLE Department;
*/


/* ---- create tables ----- */

CREATE TABLE Department (
  id INTEGER NOT NULL,
  name VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE Employee (
  employee_number VARCHAR(16) NOT NULL,
  name VARCHAR(50) NOT NULL,
  birthday DATE,
  join_date DATE NOT NULL,
  main_department_id INTEGER NOT NULL,
  main_position VARCHAR(16),
  PRIMARY KEY (employee_number),

  INDEX department_ind (main_department_id),
  FOREIGN KEY (main_department_id) REFERENCES Department(id)
);

CREATE TABLE Assignment (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  assign_date DATE NOT NULL,

  PRIMARY KEY(department_id, employee_number, position, assign_date),

  INDEX department_ind (department_id),
  INDEX employee_ind (employee_number)
  , FOREIGN KEY (department_id) REFERENCES Department(id)
);

--  Leave はキーワードらしく、テーブル名に使えない
CREATE TABLE Leaves (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  leave_date DATE NOT NULL,

  PRIMARY KEY(department_id, employee_number, position, leave_date),

  INDEX department_ind (department_id),
  INDEX employee_ind (employee_number)
  , FOREIGN KEY (department_id) REFERENCES Department(id)
);

CREATE VIEW Assign_Levae (employee_number,  department_id, position, move_date, event_name, assign_value)
AS
 SELECT employee_number,  department_id, position, leave_date AS move_date,
   'a:離任' AS event_name, -1 AS assign_value FROM Leaves
  UNION
 SELECT employee_number,  department_id, position, assign_date AS move_date,
   'b:配属' AS event_name, 1 AS assign_value FROM Assignment;


/* ==============
 create table
 ================= */
/* for PostgresQLon DO */


CREATE TABLE Department (
  id INTEGER NOT NULL,
  name VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);



CREATE TABLE Employee (
  employee_number VARCHAR(16) NOT NULL,
  name VARCHAR(50) NOT NULL,
  birthday DATE,
  join_date DATE NOT NULL,
  main_department_id INTEGER NOT NULL,
  main_position VARCHAR(16),
  PRIMARY KEY (employee_number),

  -- INDEX department_ind (main_department_id),
  FOREIGN KEY (main_department_id) REFERENCES Department(id)
);

CREATE INDEX ON Employee(main_department_id);



CREATE TABLE Assignment (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  assign_date DATE NOT NULL,

  PRIMARY KEY(department_id, employee_number, position, assign_date),

  -- INDEX department_ind (department_id),
  -- INDEX employee_ind (employee_number),
  FOREIGN KEY (department_id) REFERENCES Department(id)
);


CREATE TABLE Leaves (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  leave_date DATE NOT NULL,

  PRIMARY KEY(department_id, employee_number, position, leave_date),

  -- INDEX department_ind (department_id),
  -- INDEX employee_ind (employee_number), 
  FOREIGN KEY (department_id) REFERENCES Department(id)
);

CREATE VIEW Assign_Levae (employee_number,  department_id, position, move_date, event_name, assign_value)
AS
 SELECT employee_number,  department_id, position, leave_date AS move_date,
   'a:離任' AS event_name, -1 AS assign_value FROM Leaves
  UNION
 SELECT employee_number,  department_id, position, assign_date AS move_date,
   'b:配属' AS event_name, 1 AS assign_value FROM Assignment;
   
   
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


/* ---- 最新状況 ----*/
SELECT employee_number, department_id, position, SUM(assign_value), count(*)
 FROM Assign_Levae
 GROUP BY employee_number, department_id, position;
 
SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary, count(*)
 FROM Assign_Levae
   WHERE move_date < '2022-05-01'
 GROUP BY employee_number, department_id, position
  HAVING  SUM(assign_value) > 0;
  
/* --- WITH -- */

WITH assign
AS (
  SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary
   FROM Assign_Levae
    WHERE move_date <= '2020-05-01'
   GROUP BY employee_number, department_id, position
   HAVING SUM(assign_value) > 0
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
   HAVING SUM(assign_value) > 0
)
SELECT asgn.employee_number, emp.name, department_id, dpt.name, position
 FROM assign AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;


/*--- mainフラグ追加 --*/

CREATE TABLE Assignment (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  assign_date DATE NOT NULL,
  is_main boolean,

  PRIMARY KEY(department_id, employee_number, position, assign_date),

  -- INDEX department_ind (department_id),
  -- INDEX employee_ind (employee_number),
  FOREIGN KEY (department_id) REFERENCES Department(id)
);

-- 差分 --
ALTER TABLE Assignment ADD COLUMN is_main boolean DEFAULT false;


CREATE TABLE Leaves (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  leave_date DATE NOT NULL,
  is_main boolean,

  PRIMARY KEY(department_id, employee_number, position, leave_date),

  -- INDEX department_ind (department_id),
  -- INDEX employee_ind (employee_number), 
  FOREIGN KEY (department_id) REFERENCES Department(id)
);

-- 差分 --
ALTER TABLE Leaves ADD COLUMN is_main boolean DEFAULT false;


-- 値のアップデート --

/*
INSERT INTO Assignment (department_id, employee_number, position, assign_date)
 VALUES
  (2, '0021', 'メンバー', '2022-04-01') -- main:true
  , (3, '0001', 'メンバー', '1995-10-01') -- main:true
  , (4, '0001', 'リーダー', '1998-04-01') -- main:true
  , (1, '0001', '副課長', '2015-04-01') -- main:true
  , (2, '0001', 'メンバー', '2020-04-01') -- main:false
  , (1, '0001', '課長', '2021-04-01') -- main:true
;

INSERT INTO Leaves (department_id, employee_number, position, leave_date)
 VALUES
  (3, '0001', 'メンバー', '2015-04-01') -- main:true
  , (4, '0001', 'リーダー', '2015-04-01') -- main:true
  , (1, '0001', '副課長', '2021-04-01') -- main:true
  , (2, '0001', 'メンバー', '2022-04-01') -- main:false
;
*/

UPDATE Assignment SET is_main = false
 WHERE department_id = 2 AND employee_number = '0001';

UPDATE Leaves SET is_main = false
 WHERE department_id = 2 AND employee_number = '0001';


-- VIEW --
DROP VIEW Assign_Levae;


CREATE VIEW Assign_Leave (employee_number,  department_id, position, move_date, is_main, event_name, assign_value)
AS
 SELECT employee_number,  department_id, position, leave_date AS move_date, is_main,
   'a:離任' AS event_name, -1 AS assign_value FROM Leaves
  UNION
 SELECT employee_number,  department_id, position, assign_date AS move_date, is_main,
   'b:配属' AS event_name, 1 AS assign_value FROM Assignment;


-- 最新状況 --
WITH assign
AS (
  SELECT employee_number, department_id, position, is_main, SUM(assign_value) AS assign_summary
   FROM Assign_Leave
     WHERE move_date <= '2023-05-01'
   GROUP BY employee_number, department_id, position, is_main
   HAVING SUM(assign_value) > 0
)
SELECT asgn.employee_number, emp.name, department_id, dpt.name, asgn.is_main position
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
SELECT asgn.employee_number, emp.name, department_id, dpt.name, asgn.is_main position
 FROM assign AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;
