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

/* -- VALUES は、シングルクォートで囲む必要あり？？ ---- */
INSERT INTO Department (id, name) VALUES (1, '総務部');
INSERT INTO Department (id, name) VALUES (2, '人事部');
INSERT INTO Department (id, name) VALUES (3, '営業部');
INSERT INTO Department (id, name) VALUES (4, '開発部');


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

-- FOREIGN KEY 追加 --
ALTER TABLE Assignment ADD CONSTRAINT department_exist FOREIGN KEY department_ind (department_id) 
 REFERENCES Department(id) ALGORITHM=COPY;

-- ALTER TABLE tbl1 ADD CONSTRAINT fk_name FOREIGN KEY index (col1) REFERENCES tbl2(col2) referential_actions;

-- try ---

CREATE TABLE try_country (
  id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY (id)
);

CREATE TABLE try_person (
  id INT NOT NULL,
  country_id INT NOT NULL,
  name VARCHAR(255) NOT NULL,
  PRIMARY KEY(id),
  KEY country_idx (country_id),
  CONSTRAINT person_country_fk FOREIGN KEY (country_id) REFERENCES try_country(id) ON DELETE NO ACTION
);

/*
-- NG ---

foreign key constraints are not allowed,
 see https://vitess.io/blog/2021-06-15-online-ddl-why-no-fk/

*/

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


/* --- Assignment & Leave with Departmet --- */
SELECT employee_number,  department_id, Department.name, position, leave_date AS move_date, "a:離任" AS event_name
  FROM Leave INNER JOIN Department ON Leave.department_id = Department.id
 UNION
SELECT employee_number,  department_id, Department.name, position, assign_date AS move_date, "b:配属" AS event_name
 FROM Assignment INNER JOIN Department ON Assignment.department_id = Department.id
ORDER BY employee_number, move_date, event_name;

/*--- current assignement ----*/
SELECT employee_number,  department_id, position, leave_date AS move_date,
  "a:離任" AS event_name, -1 AS assign_value FROM Leave
 UNION
SELECT employee_number,  department_id, position, assign_date AS move_date,
  "b:配属" AS event_name, 1 AS assign_value FROM Assignment;

--  VIEW --
CREATE VIEW Assign_Levae (employee_number,  department_id, position, move_date, event_name, assign_value)
AS
 SELECT employee_number,  department_id, position, leave_date AS move_date,
   "a:離任" AS event_name, -1 AS assign_value FROM Leave
  UNION
 SELECT employee_number,  department_id, position, assign_date AS move_date,
   "b:配属" AS event_name, 1 AS assign_value FROM Assignment;

-- summary --
SELECT employee_number, department_id, position, SUM(assign_value), count(*)
 FROM assign_levae
 GROUP BY employee_number, department_id, position;

 -- OK --
SELECT * FROM assign_levae 
  WHERE move_date < "2022-05-01";

-- OK --
SELECT employee_number, department_id, position, SUM(assign_value), count(*)
 FROM assign_levae
   WHERE move_date < "2020-05-01"
 GROUP BY employee_number, department_id, position;

SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary, count(*)
 FROM assign_levae
   WHERE move_date < "2020-05-01" AND assign_summary > 0
 GROUP BY employee_number, department_id, position;

/* --- 最新の現在状況 ----*/
SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary, count(*)
 FROM assign_levae
   WHERE move_date < "2020-05-01"
 GROUP BY employee_number, department_id, position
  HAVING assign_summary > 0;

SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary, count(*)
 FROM assign_levae
   WHERE move_date < "2022-05-01"
 GROUP BY employee_number, department_id, position
  HAVING assign_summary > 0;

SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary, count(*)
 FROM assign_levae
   WHERE move_date <= "2022-04-01"
 GROUP BY employee_number, department_id, position
  HAVING assign_summary > 0;

SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary, count(*)
 FROM assign_levae
   WHERE move_date <= CURRENT_DATE()
 GROUP BY employee_number, department_id, position
  HAVING assign_summary > 0;

SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary, count(*)
 FROM assign_levae
   WHERE move_date <= CURRENT_DATE()
 GROUP BY employee_number, department_id, position
  HAVING assign_summary > 0
 ORDER BY employee_number;


 /* --- 社員一覧の取得 ----*/

CREATE VIEW current_assignment (employee_number, department_id, position, assign_summary)
AS
  SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary
   FROM assign_levae
    WHERE move_date <= CURRENT_DATE()
   GROUP BY employee_number, department_id, position
   HAVING assign_summary > 0;

SELECT * from current_assignment ORDER BY employee_number;


SELECT employee_number, department_id, Department.name, position
 FROM current_assignment INNER JOIN Department ON current_assignment.department_id = Department.id;

SELECT current_assignment.employee_number, Employee.name, department_id, Department.name, position
 FROM current_assignment
  INNER JOIN Employee ON current_assignment.employee_number = Employee.employee_number
  INNER JOIN Department ON current_assignment.department_id = Department.id;

SELECT asgn.employee_number, emp.name, department_id, dpt.name, position
 FROM current_assignment AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;

-- 2020/05/01 --
CREATE VIEW past_assignment_202005 (employee_number, department_id, position, assign_summary)
AS
  SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary
   FROM assign_levae
    WHERE move_date <= "2020-05-01"
   GROUP BY employee_number, department_id, position
   HAVING assign_summary > 0;
   
SELECT * from past_assignment_202005 ORDER BY employee_number;


SELECT past_assignment_202005.employee_number, Employee.name, department_id, Department.name, position
 FROM past_assignment_202005
  INNER JOIN Employee ON past_assignment_202005.employee_number = Employee.employee_number
  INNER JOIN Department ON past_assignment_202005.department_id = Department.id;

SELECT asgn.employee_number, emp.name, department_id, dpt.name, position
 FROM past_assignment_202005 AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;


/* --- WITH を使う ERROR？ ---*/


WITH assign
AS
  SELECT employee_number, department_id, position, SUM(assign_value) AS assign_summary
   FROM assign_levae
    WHERE move_date <= "2020-05-01"
   GROUP BY employee_number, department_id, position
   HAVING assign_summary > 0
SELECT asgn.employee_number, emp.name, department_id, dpt.name, position
 FROM assign AS asgn
  INNER JOIN Employee AS emp ON asgn.employee_number = emp.employee_number
  INNER JOIN Department AS dpt ON asgn.department_id = dpt.id;

-- ------------

/* ----
TRY WITH

----*/

WITH emp AS (SELECT employee_number, name FROM Employee)
SELECT * from emp;
