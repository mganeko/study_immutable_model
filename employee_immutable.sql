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

-- オンラインで FOREIGN KEY はサポートされない. COPYならOKかも？
-- ALTER TABLE tbl_name DROP PRIMARY KEY, ALGORITHM=COPY; -- ??


SELECT * from Employee;

CREATE INDEX department_ind ON Employee(main_department_id);

INSERT INTO Employee (employee_number, name, birthday, join_date, main_department_id, main_position)
 -- VALUES ("0001", "山田太郎", "1990-05-10", "2020-04-01", 1, "課長");
 VALUES ("0001", "山田太郎", "1970-05-10", "1995-10-01", 1, "課長");

INSERT INTO Employee (employee_number, name, birthday, join_date, main_department_id, main_position)
 -- VALUES ("0021", "鈴木一美", "2000-08-25", "2022-04-01", 2, NULL);
 VALUES ("0021", "鈴木一美", "2000-08-25", "2022-04-01", 2, "メンバー");


UPDATE Employee SET main_position = "メンバー" WHERE employee_number = "0021";

UPDATE Employee SET birthday = "1970-05-10", join_date = "1995-10-01" WHERE employee_number = "0001";



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


/* ---------
山田太郎 0001
経歴

"1995-10-01",  "営業部":3, "メンバー"
"1998-04-01",  "開発部":4, "リーダー", 兼務

"2015-04-01",  "総務部":1, "副課長"
"2020-04-01",  "人事":2, "メンバー", 兼務

"2021-04-01",  "総務":1, "課長",
"2022-04-01",  "人事":2, "メンバー" の兼務解除

--> 2022-04-01,  "総務":1, "課長",
*/

-- "1995-10-01",  "営業部", "メンバー"
INSERT INTO Assignment (department_id, employee_number, position, assign_date)
 VALUES (3, "0001", "メンバー", "1995-10-01");

-- "1998-04-01",  "開発部":4, "リーダー", 兼務
INSERT INTO Assignment (department_id, employee_number, position, assign_date)
 VALUES (4, "0001", "リーダー", "1998-04-01");


-- "2015-04-01",  "総務部":1, "副課長"
INSERT INTO Leave (department_id, employee_number, position, leave_date)
 VALUES (3, "0001", "メンバー", "2015-04-01");

INSERT INTO Leave (department_id, employee_number, position, leave_date)
 VALUES (4, "0001", "リーダー", "2015-04-01");

INSERT INTO Assignment (department_id, employee_number, position, assign_date)
 VALUES (1, "0001", "副課長", "2015-04-01");


-- "2020-04-01",  "人事":2, "メンバー", 兼務
INSERT INTO Assignment (department_id, employee_number, position, assign_date)
 VALUES (2, "0001", "メンバー", "2020-04-01");


-- "2021-04-01",  "総務":1, "副課長" --> "課長",
INSERT INTO Leave (department_id, employee_number, position, leave_date)
 VALUES (1, "0001", "副課長", "2021-04-01");
INSERT INTO Assignment (department_id, employee_number, position, assign_date)
 VALUES (1, "0001", "課長", "2021-04-01");

-- "2022-04-01",  "人事":2, "メンバー" の兼務解除
INSERT INTO Leave (department_id, employee_number, position, leave_date)
 VALUES (2, "0001", "メンバー", "2022-04-01");

/* ------------
  鈴木一美 0021
  "2022-04-01", "人事部":2, "メンバー"
*/

INSERT INTO Assignment (department_id, employee_number, position, assign_date)
 VALUES (2, "0021", "メンバー", "2022-04-01");


-- ----------

/* --- Employee & Department -- */
SELECT * from Employee INNER JOIN Department ON Employee.main_department_id = Department.id;

SELECT e.employee_number, e.name, d.name AS department_name, e.main_position
 from Employee AS e INNER JOIN Department AS d ON e.main_department_id = d.id;

/* --- Assignment & Leave --- */
SELECT department_id, employee_number, position, leave_date AS move_date, "離任" as event_name  FROM Leave
 UNION
SELECT department_id, employee_number, position, assign_date AS move_date, "配属" as event_name FROM Assignment
ORDER BY employee_number, move_date;

