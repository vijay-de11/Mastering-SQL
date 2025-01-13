--select * into employee_backup from employee;
--select * into dept_backup from dept;

alter table employee add dept_name varchar(20);
select * from employee;
select * from dept;

-- update using join
update employee
set dept_name = d.dep_name
from employee e
join dept d
on e.dept_id = d.dep_id;

-- delete using join
delete employee
from employee e
join dept d
on e.dept_id = d.dep_id
where e.emp_id%2=0

--exists / not exists
select * from employee_backup;
select * from dept_backup;

-- exists -> return true if atleast 1 row is found else false
select * from employee_backup e
where exists (select 1 from dept_backup d where e.dept_id = d.dep_id);

-- exists -> return true if atleast 1 row is found else false
select * from employee_backup e
where not exists (select 1 from dept_backup d where e.dept_id = d.dep_id);

-- DCL (Data Control Language)
-- 1. GRANT
-- 2. REVOKE

grant select on schema::dbo to guest; -- All the dbo objects can be accessed by guest user
revoke select on employee from guest;

-- To give access to specific users we can create a role and add the members and assign a privilege to that role
create role role_sales; 
grant select on employee to role_sales;   

alter role role_sales add member guest;

-- Although we have given the privileges to guest user, but guest can't give privileges to other users, If we want the guest user to
-- add other users we need to exec the below query
grant select on employee to guest with grant option;

--
-- DDL - auto commit , cannot be rollback
-- DML - we can rollback

-- TCL (Transaction Control Language)
-- 1. Commit
-- 2. Rollback

begin tran d
update employee set salary = 20000 where emp_id = 1
commit tran d;

select * from employee;

begin tran d
update employee set salary = 25000 where emp_id = 1
rollback tran d;

-- By default, AUTO COMMIT is ON, we have to turn this OFF, because once COMMIT is done, it can't be ROLLBACK
update employee set salary = 27000 where emp_id=1;
select * from employee;
rollback -- The ROLLBACK TRANSACTION request has no corresponding BEGIN TRANSACTION.

-- We can run the below command to turn off the AUTO COMMIT feature
--SET IMPLICIT_TRANSACTIONS OFF