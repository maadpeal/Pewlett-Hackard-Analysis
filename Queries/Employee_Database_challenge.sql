-- Creating Tables

CREATE TABLE departments (
    "dept_no" varchar(4)   NOT NULL,
    "dept_name" varchar(40)   NOT NULL,
    CONSTRAINT "pk_Departments" PRIMARY KEY (
        "dept_no"
     ),
	UNIQUE (dept_name)
);

CREATE TABLE employees (
    "emp_no" int   NOT NULL,
    "birth_date" date   NOT NULL,
    "first_name" varchar   NOT NULL,
    "last_name" varchar   NOT NULL,
    "gender" varchar   NOT NULL,
    "hire_date" date   NOT NULL,
    CONSTRAINT "pk_Employees" PRIMARY KEY (
        "emp_no"
     )
);

-- se le quita el pk por que se repite
CREATE TABLE titles (
    "emp_no" int   NOT NULL,
    "title" varchar   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_Titles" PRIMARY KEY (
        "emp_no"
     ),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE salaries (
    "emp_no" int   NOT NULL,
    "salary" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_Salaries" PRIMARY KEY (
        "emp_no"
     ),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

CREATE TABLE dept_emp (
    "emp_no" int   NOT NULL,
    "dept_no" varchar   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_Dept_emp" PRIMARY KEY (
        "emp_no","dept_no"
     ),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

CREATE TABLE dept_manager (
    "dept_no" varchar(4)   NOT NULL,
    "emp_no" int   NOT NULL,
    "from_date" date   NOT NULL,
    "to_date" date   NOT NULL,
    CONSTRAINT "pk_Managers" PRIMARY KEY (
        "dept_no","emp_no"
     ),
	FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no)
);

-- Retrieving employees and titles

select 
    emp.emp_no, 
	emp.first_name, 
	emp.last_name,
	t.title,
	t.from_date,
	t.to_date
into retirement_info
from employees as emp
join titles as t on emp.emp_no = t.emp_no
where birth_date between '1952-01-01' and '1955-12-31'
order by emp.emp_no asc;


-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no)
   emp_no,
   first_name,
   last_name,
   title
INTO unique_titles
FROM retirement_info
WHERE to_date = '9999-01-01'
ORDER BY emp_no, to_date DESC;

-- get retiring total
select 
   count(*),
   title
into retiring_titles
from unique_titles
group by title
order by count desc;

-- mentorship_eligibilty

select
distinct on (e.emp_no)
   e.emp_no,
   e.first_name,
   e.last_name,
   e.birth_date,
   dept.from_date,
   dept.to_date,
   t.title
into mentorship_eligibilty
from employees as e
join dept_emp as dept on e.emp_no = dept.emp_no
join titles as t on e.emp_no = t.emp_no
where dept.to_date = '9999-01-01'
and birth_date between '1965-01-01' and '1965-12-31'
order by e.emp_no asc;

-- Total of mentorship employees

select 
    COUNT(*),
	title
from mentorship_eligibilty
GROUP BY title
order by count desc;

