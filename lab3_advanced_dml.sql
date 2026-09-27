
CREATE DATABASE advanced_lab;

CREATE  TABLE employees(
    emp_id SERIAL PRIMARY KEY ,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    department VARCHAR(50),
    salary INTEGER,
    hire_date DATE,
    status VARCHAR(20) default 'Active'
);
CREATE  TABLE departments(
    dept_id SERIAL PRIMARY KEY ,
    dept_name VARCHAR(100),
    budget INTEGER,
    manager_id INTEGER
);
CREATE TABLE projects(
    project_id SERIAL PRIMARY KEY ,
    project_name  VARCHAR(100),
    dept_id INTEGER,
    start_date DATE,
    end_date DATE,
    budget INTEGER
);
-- 2 tapsyrmaaaa
INSERT INTO employees (emp_id, first_name, last_name,department  )
VALUES (7, 'Ronaldo', 'Cristiano', 'IT');
-- 3goooo
INSERT INTO employees(emp_id, first_name, last_name, department, salary, status)
VALUES (10,'Messi','Leo','IT',DEFAULT,DEFAULT);
-- 4
INSERT INTO departments (dept_name,budget,dept_id)
VALUES ('IT', 9000000, 1),
       ('HR',500000,2),
       ('Teacher',600000,3);
-- 5
INSERT INTO employees( first_name , hire_date ,salary , last_name)
VALUES ('Jude','Bellingham', CURRENT_DATE, 50000 * 1.1 );
-- 6
CREATE TEMPORARY TABLE temp_employees AS
SELECT *
FROM employees
WHERE department='IT';
SELECT * FROM temp_employees;
-- 7
UPDATE employees
SET salary= salary * 1.10 ;
-- 8
UPDATE employees
SET status = 'Senior'
WHERE salary > 60000
    AND hire_date ='2020-01-01 ';
-- 9
UPDATE employees
SET  department = CASE
    WHEN salary > 80000 THEN 'Management'
    WHEN salary BETWEEN 50000 AND  80000  THEN 'Senior'
ELSE 'Junior'
END ;
-- 10
UPDATE employees
SET department= DEFAULT
WHERE status='Inactive';
-- 11
UPDATE departments d
SET budget=(
    SELECT AVG(e.salary) * 1.20
    FROM employees e
    WHERE e.department=d.dept_name

    );
-- 12
UPDATE employees
SET salary= salary * 1.15,
    status =  'Promoted'
WHERE department = 'Sales';
-- 13
DELETE FROM employees
WHERE status ='Terminated';

-- 14
DELETE  FROM  employees
WHERE  salary < 40000
    AND hire_date > '2023-01-01'
    AND department IS NOT NULL;
-- 15
DELETE FROM departments
 WHERE dept_id NOT IN (
     SELECT DISTINCT department
     FROM employees
     WHERE department IS NOT NULL
     );
-- 16
DELETE FROM projects
WHERE  end_date < '2023-01-01'
RETURNING *;
-- 17
INSERT INTO employees (
    first_name,
    last_name,
    salary,
    department
)
VALUES (
    'John',
    'Smith',
    NULL,
    NULL
);
-- 18
UPDATE employees
SET department = 'Unassigned'
WHERE department IS NULL;
-- 19
DELETE FROM employees
WHERE salary IS NULL
   OR department IS NULL;
-- 20

INSERT INTO employees (
    first_name,
    last_name,
    department,
    salary,
    hire_date
)
VALUES (
    'Alice',
    'Brown',
    'IT',
    60000,
    CURRENT_DATE
)
RETURNING
    emp_id,
    first_name || ' ' || last_name AS full_name;

-- 21
UPDATE  employees
SET salary = salary + 5000
WHERE department = 'IT'
RETURNING
    emp_id,
    salary - 5000 AS old_salary,
    salary AS new_salary;
-- 22
DELETE FROM employees
WHERE hire_date < '2020-01-01'
RETURNING *;
-- 23
INSERT INTO employees(
                      FIRST_NAME,
                      LAST_NAME,
                      DEPARTMENT,
                      SALARY,
                      HIRE_DATE,

)
SELECT
    'VINI', 'JR', 'IT', 5000, CURRENT_DATE
WHERE NOT EXISTS(
    SELECT 1
    FROM employees
    WHERE first_name = 'VINI'
    AND last_name = 'JR'
);

-- 25
INSERT INTO employees(
                      FIRST_NAME,
                      LAST_NAME,
                      DEPARTMENT,
                      SALARY,
                      hire_date
)
VALUES
    ('LAMIN','YAMAL','teacher',200000, current_date),
    ('Mbappe','Kilian','player',800000, current_date),
    ('Arda','Guller','IT', 88888888 ,CURRENT_DATE),
    ('Erkebulan','usen','HR', 777777777, CURRENT_DATE),
    ('Xabi','Alonsa','coach', 8000000, CURRENT_DATE);

UPDATE employees
SET salary = salary * 1.10
WHERE first_name IN (
    'LAMIN',
    'Mbappe',
    'Arda',
    'Erkebulan',
    'Xabi'
);


-- 24
UPDATE employees e
SET salary = salary * CASE
    WHEN (
        SELECT d.budget
        FROM departments d
        WHERE d.dept_name = e.department
    ) > 100000
    THEN 1.10
    ELSE 1.05
END;

-- 26
CREATE TABLE employee_archive AS
SELECT *
FROM employees
WHERE 1 = 0;
INSERT INTO employee_archive
SELECT *
FROM employees
WHERE status = 'Inactive';
DELETE FROM employee
WHERE status = 'Inactive';
SELECT * FROM employee_archive;

-- 27
UPDATE projects p
SET end_date = end_date + INTERVAL '30 days'
WHERE budget > 50000
  AND (
      SELECT COUNT(*)
      FROM employees e
      JOIN departments d
        ON d.dept_name = e.department
      WHERE d.dept_id = p.dept_id
  ) > 3;