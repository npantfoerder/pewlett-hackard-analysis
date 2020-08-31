-- Retirement eligibility
SELECT first_name, last_name
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Number of employees retiring
SELECT COUNT(first_name)
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Create a new table for retiring employees
SELECT emp_no, first_name, last_name
INTO retirement_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (hire_date BETWEEN '1985-01-01' AND '1988-12-31');

-- Joining departments and dept_manager tables
SELECT d.dept_name, dm.emp_no, dm.from_date, dm.to_date
FROM departments AS d
    INNER JOIN dept_manager AS dm
        ON (d.dept_no = dm.dept_no);

-- Joining retirement_info and dept_emp tables
SELECT ri.*, de.to_date
FROM retirement_info AS ri
	LEFT JOIN dept_emp AS de
		ON ri.emp_no = de.emp_no;

-- Create a new table for current employees
SELECT ri.*, de.to_date
INTO current_emp
FROM retirement_info AS ri
    LEFT JOIN dept_emp AS de
        ON (ri.emp_no = de.emp_no)
WHERE de.to_date = ('9999-01-01');

-- Create a new table for employee counts by department
SELECT de.dept_no, COUNT(ce.emp_no)
INTO emp_count
FROM current_emp AS ce
    LEFT JOIN dept_emp AS de
        ON (ce.emp_no = de.emp_no)
GROUP BY de.dept_no
ORDER BY de.dept_no;

-- Salaries ordered by to_date
SELECT * FROM salaries
ORDER BY to_date DESC;

-- Create a table for employee information
SELECT e.emp_no, e.first_name, e.last_name, e.gender, de.to_date, s.salary
INTO emp_info
FROM employees AS e
    INNER JOIN salaries AS s
        ON (e.emp_no = s.emp_no)
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
    AND (e.hire_date BETWEEN '1985-01-01' AND '1988-12-31')
    AND (de.to_date = '9999-01-01');

-- Create a table for manager information
SELECT d.dept_name, 
	dm.dept_no, dm.emp_no, dm.from_date, dm.to_date,
	ce.first_name, ce.last_name
INTO manager_info
FROM dept_manager AS dm
	INNER JOIN current_emp AS ce
		ON (dm.emp_no = ce.emp_no)
	LEFT JOIN departments AS d
		ON (d.dept_no = dm.dept_no);

-- Create a table for department information
SELECT ce.emp_no, ce.first_name, ce.last_name,
	d.dept_name
INTO dept_info
FROM current_emp AS ce
	LEFT JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	LEFT JOIN departments AS d
	 	ON (de.dept_no = d.dept_no);

-- Employee counts by department name
SELECT ec.*, d.dept_name
FROM emp_count AS ec
	LEFT JOIN departments AS d
		ON (ec.dept_no = d.dept_no);

-- Sales department information
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
FROM current_emp AS ce
	LEFT JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
    LEFT JOIN departments AS d
        ON (de.dept_no = d.dept_no)
WHERE d.dept_name = 'Sales';

-- Sales and development departments info
SELECT ce.emp_no, ce.first_name, ce.last_name, d.dept_name
FROM current_emp AS ce
	LEFT JOIN dept_emp AS de
		ON (ce.emp_no = de.emp_no)
	LEFT JOIN departments AS d
		ON (de.dept_no = d.dept_no)
WHERE d.dept_name IN ('Sales', 'Development');

-- Create a table for retirement titles
SELECT e.emp_no, e.first_name, e.last_name,
    t.title, t.from_date, t.to_date
INTO retirement_titles
FROM employees AS e
    LEFT JOIN titles AS t
        ON (e.emp_no = t.emp_no)
WHERE (e.birth_date BETWEEN '1952-01-01' AND '1955-12-31')
ORDER BY e.emp_no;

-- Find birth years of employees
SELECT *, EXTRACT(YEAR FROM birth_date) AS birth_year
FROM employees;

-- Create a table for CURRENT employee info
SELECT e.emp_no, e.first_name, e.last_name,
    t.title, t.from_date, t.to_date
INTO current_titles
FROM employees AS e
    LEFT JOIN titles AS t
        ON (e.emp_no = t.emp_no)
WHERE t.to_date = '9999-01-01'
ORDER BY e.emp_no;

-- Use Dictinct with Orderby to remove duplicate rows
SELECT DISTINCT ON (emp_no) 
	emp_no, first_name, last_name, title
INTO unique_titles
FROM retirement_titles AS rt
ORDER BY emp_no, to_date DESC;

-- Create a table for retiring title counts
SELECT COUNT(emp_no), title
INTO retiring_titles
FROM retirement_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

-- Create a table for mentorship eligibility
SELECT DISTINCT ON (e.emp_no) 
	e.emp_no, e.first_name, e.last_name, e.birth_date,
    de.from_date, de.to_date, title
INTO mentorship_eligibility
FROM employees AS e
    INNER JOIN dept_emp AS de
        ON (e.emp_no = de.emp_no)
	INNER JOIN titles AS t
		ON (e.emp_no = t.emp_no)		
WHERE (e.birth_date BETWEEN '1965-01-01' AND '1965-12-31')
	AND (de.to_date = '9999-01-01')
ORDER BY e.emp_no, t.to_date DESC;

-- Create a table for current title counts
SELECT COUNT(emp_no) AS current_emps, title
INTO current_counts
FROM current_titles 
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

-- Create a table for retiree counts
SELECT COUNT(emp_no) AS retirees, title
INTO retiree_counts
FROM unique_titles
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

-- Create a table of eligible mentor counts
SELECT COUNT(emp_no) AS mentors, title
INTO mentor_counts
FROM mentorship_eligibility
GROUP BY title
ORDER BY COUNT(emp_no) DESC;

-- Join all current employee counts
SELECT cc.*, retirees, mentors
INTO current_info
FROM current_counts AS cc
	INNER JOIN retiree_counts AS rc
		ON (cc.title = rc.title)
	LEFT JOIN mentor_counts AS mc
		ON (cc.title = mc.title)
ORDER BY retirees DESC;

-- Add percent of employees retiring by title
ALTER TABLE current_info 
ADD COLUMN r_percent FLOAT,
ADD COLUMN m_percent FLOAT,
ADD COLUMN r_per_m FLOAT;

UPDATE current_info 
SET r_percent = CAST(retirees AS FLOAT) / 
   	CAST(current_emps AS FLOAT) * 100,
 	m_percent = CAST(mentors AS FLOAT) / 
 	CAST(current_emps AS FLOAT) * 100,
	r_per_m = CAST(retirees AS FLOAT) / 
	CAST(mentors AS FLOAT);

-- Create a table for count sums
SELECT SUM(current_emps) AS current,
	SUM(retirees) AS retiring,
	SUM(mentors) AS mentorship
INTO sums
FROM current_info;

ALTER TABLE sums 
ADD COLUMN r_percent FLOAT,
ADD COLUMN m_percent FLOAT,
ADD COLUMN r_per_m FLOAT;

UPDATE sums 
SET r_percent = CAST(retiring AS FLOAT) / 
	CAST(current AS FLOAT) * 100,
	m_percent = CAST(mentorship AS FLOAT) / 
	CAST(current AS FLOAT) * 100,
	r_per_m = CAST(retiring AS FLOAT) / 
	CAST(mentorship AS FLOAT);

