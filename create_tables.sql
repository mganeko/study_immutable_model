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

