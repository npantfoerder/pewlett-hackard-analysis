# Employee Database with SQL

## Overview of the Analysis
### Purpose
As baby boomers are beginning to retire at a rapid rate, a hypothetical company, Pewlett Hackard, is preparing for thousands of job vacancies. Bobby, an HR analyst, needs help building an employee database with SQL and performing employee research. The assignment is to determine the number of retiring employees per title, and identify employees who are eligibile to participate in a mentorship program.

## Results
### Major Points from the Analysis
- The newly exported retirement_titles.csv file contains information about 72,458 employees who will be retiring in the next few years. This is 30.2% of the total employees currently working at the company. The first few rows are shown below:

<img src='https://github.com/npantfoerder/pewlett-hackard-analysis/blob/master/Images/retirement_titles.png' width=500>

- The retiring_titles.csv file shows that 25,916 Senior Engineers, 24,926 Senior Staffers, 9,285 Engineers, 7,636 Staff, 3,603 Technique Leaders, 1,090 Assistant Engineers, and 2 Managers will be retiring in the next few years. The table below shows that this is about 30% for each employee type, and 2 out of the 9 managers (22.2%).

<img src='https://github.com/npantfoerder/pewlett-hackard-analysis/blob/master/Images/retiree_percents.png' width=500>

- It can be seen that 1,549 employees are eligible to participate in the mentorship program in the mentorship_eligibility.csv file. This is only about 0.6% of all employees currently at the company.
The first few rows of the file can be seen below:

<img src='https://github.com/npantfoerder/pewlett-hackard-analysis/blob/master/Images/mentorship_eligibility.png' width=500>

- Using the criteria of employees born in 1965 is not returning nearly enough employees for the mentorship. With 72,458 employees retiring and 1,549 employees eligible for mentorship, the retirement-ready to mentorship eligible employee ratio is about 46 to 1. The ratio by employee type can be seen below:

<img src='https://github.com/npantfoerder/pewlett-hackard-analysis/blob/master/Images/ratios.png' width=500>

## Summary
### Insight into the "Silver Tsunami"
- All together, 72,458 roles will need to be filled as the "silver tsunami" begins to make an impact. The breakdown of how many employees in each role will be retiring can be seen in the retiring_titles.csv file.

- There are more than enough qualified, retirement-ready employees in the departments to mentor the next generation of Pewlett Hackard employees. In fact, there are enough retirement-ready employees in every department so that each mentorship eligible employee could have upwards of 37 mentors. Given these numbers, it could be a good idea to lessen the criteria for mentorship eligibility so that more retirement-ready employees can mentor the next generation of employees.

- Changing the criteria for mentorship eligibility from employees born in 1965 by adding employees born in December of 1964 and January of 1966, doubles the number of mentorship eligible employees. This would allow more retirement-ready employees to mentor employees of the next generation. The numbers of mentorship eligible employees with the updated criteria can be seen below:

<img src='https://github.com/npantfoerder/pewlett-hackard-analysis/blob/master/Images/new_eligibility.png' width=500>

*provide 2 additional queries or tables giving insight*

#### Note to Grader
When creating the retirement_titles.csv file, I added a WHERE (titles.to_date = '9999-01-01') statement to find only retiring employees who are currently at the company. By doing this, the DISTINCT ON statement used in creating the unique_titles.csv file made no difference since the roles that ended were already filtered out. The count column in my retiring_titles.csv file also has lower numbers than the example from the module since I am not inlcuding employees that already left the company.

#### Resources
- Data Sources: departments.csv, dept_emp.csv, dept_manager.csv, employees.csv, salaries.csv, titles.csv
- Software: PostgreSQL 11.9, pgAdmin 4.24
