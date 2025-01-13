select *  from employee;
select *  from dept;

update employee 
set salary=salary * 1.1
where dept_id in (select dep_id from dept where dep_name='HR');

alter table employee add dep_name varchar(20)


update employee 
set dep_name=d.dep_name
from employee e
inner join dept d on e.dept_id=d.dep_id
where d.dep_name='Analytics'

select * from employee
--where dept_id in (select dep_id from dept where dep_name='HR');


update employee 
set dep_name=d.dep_name
from employee e
inner join dept_back d on e.dept_id=d.dep_id
--where d.dep_name='Analytics';

select * from dept_back
insert into dept_back values (100,'Marketing');

select * from employee e
inner join dept_back d on e.dept_id=d.dep_id;

delete employee 
from employee e
inner join dept d on e.dept_id=d.dep_id
where d.dep_name='HR';

--where dept_id not in (select dep_id from dept)

--exists / not exists 

select * from employee_back e
where dept_id in (select dep_id from dept)
--where  exists ( select 1 from dept_back d where e.dept_id=d.dep_id )
and  dept_id=100 
;
select * from employee_back;
select * from dept_back;

--ddl data definition language create, drop,alter
--dml data manipulation launguage --insert update delete 
--dql data query language
--dcl data control launguage -- grant , revoke
--tcl transaction control launguge -- commit and rollback
grant select,insert,update,create table on employees to guest

grant select on schema::dbo to guest

revoke select,insert,delete on employees from guest;

create role role_sales
grant select on employees to role_sales

alter role role_sales add member guest;


grant select on employees to guest with grant option;

--tcl transaction control launguge -- commit and rollback
--insert,update,delete 
--select
begin tran d 
update employee set salary = 35000 where emp_id=1
commit tran d;

savepoint a
insert
rollback tran d

select * from employee

update employee set salary = 50000 where emp_id=1
rollback ;

select * from orders










































