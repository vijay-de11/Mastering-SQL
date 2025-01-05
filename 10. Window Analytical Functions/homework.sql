-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.

-- Q1- write a query to print 3rd highest salaried employee details for each department (give preferece to younger employee in case of a tie). 
-- In case a department has less than 3 employees then print the details of highest salaried employee in that department.
select * from employee;
select * from dept;

select 
	emp_name, emp_age, dept_id, salary, rn
from 
(
select e.emp_name, e.emp_age, e.dept_id, e.salary,
row_number() over(partition by e.dept_id order by e.salary desc, e.emp_age asc) rn,
rank() over(partition by e.dept_id order by e.salary desc, e.emp_age asc) rnk
from employee e
) t
where rn=3 or (select count(*) from employee where dept_id = t.dept_id) < 3 and rn = 1;