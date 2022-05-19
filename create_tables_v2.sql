/* create table */
/* for PosgreSQL 14 on DO */

/* ---- clean up ----- */

/*
DROP VIEW Assign_Leave;
DROP TABLE Leaves;  -- old name: Leave_event;
DROP TABLE Assignment;
DROP TABLE Employee;
DROP TABLE Department;
*/

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
  main_department_id INTEGER, -- NULLありに変更 
  main_position VARCHAR(16),
  PRIMARY KEY (employee_number),

  -- INDEX department_ind (main_department_id),
  FOREIGN KEY (main_department_id) REFERENCES Department(id)
);

CREATE INDEX ON Employee(main_department_id);


/*--- mainフラグ追加 --*/

CREATE TABLE Assignment (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  assign_date DATE NOT NULL,
  is_main boolean NOT NULL,

  PRIMARY KEY(department_id, employee_number, position, assign_date),

  -- INDEX department_ind (department_id),
  -- INDEX employee_ind (employee_number),
  FOREIGN KEY (department_id) REFERENCES Department(id)
);

/*
-- 差分 --
ALTER TABLE Assignment ADD COLUMN is_main boolean NOT NULL DEFAULT true;
*/


CREATE TABLE Leaves (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  leave_date DATE NOT NULL,
  is_main boolean NOT NULL,

  PRIMARY KEY(department_id, employee_number, position, leave_date),

  -- INDEX department_ind (department_id),
  -- INDEX employee_ind (employee_number), 
  FOREIGN KEY (department_id) REFERENCES Department(id)
);

/*
-- 差分 --
ALTER TABLE Leaves ADD COLUMN is_main boolean NOT NULL DEFAULT true;
*/


-- VIEW --
-- DROP VIEW Assign_Leavee;


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
