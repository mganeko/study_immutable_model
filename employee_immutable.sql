/* create table */
/* MySQL */

/* ------------------------------------------
Department {
  integer id
  string name
}
*/

CREATE TABLE Department (
  id INTEGER NOT NULL,
  name VARCHAR(50) NOT NULL,
  PRIMARY KEY (id)
);

SELECT * from Department;

INSERT INTO Department (id, name) VALUES (1, "総務部");
INSERT INTO Department (id, name) VALUES (2, "人事部");
INSERT INTO Department (id, name) VALUES (3, "営業部");
INSERT INTO Department (id, name) VALUES (4, "開発部");


/* ------------------------------------------
Employee {
  string employee_number
  string name
  date birthday
  date join_date
  integer main_department_id
  string main_position
}
*/

CREATE TABLE Employee (
  employee_number VARCHAR(16) NOT NULL,
  name VARCHAR(50) NOT NULL,
  birthday DATE,
  join_date DATE NOT NULL,
  main_department_id INTEGER NOT NULL,
  main_position VARCHAR(16),
  PRIMARY KEY (employee_number)

  -- , INDEX department_ind (main_department_id),
  -- FOREIGN KEY (main_department_id) REFERENCES Department(id)
);

SELECT * from Employee;


/* --------------
Assignment {
  integer department_id
  string employee_number
  string position
  date assign_date
}
*/


CREATE TABLE Assignment (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  assign_date DATE NOT NULL,

  INDEX department_ind (department_id),
  INDEX employee_ind (employee_number)
  -- , FOREIGN KEY (department_id) REFERENCES Department(id)
);

SELECT * from Assignment;

/* --------------
Leave {
  integer department_id
  string employee_number
  string position
  date leave_date
}
*/


CREATE TABLE Leave (
  department_id INTEGER NOT NULL,
  employee_number VARCHAR(16) NOT NULL,
  position VARCHAR(16) NOT NULL,
  leave_date DATE NOT NULL,

  INDEX department_ind (department_id),
  INDEX employee_ind (employee_number)
  -- , FOREIGN KEY (department_id) REFERENCES Department(id)
);

SELECT * from Leave;