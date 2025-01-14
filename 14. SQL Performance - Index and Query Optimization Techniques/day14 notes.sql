create table emp_index
(
emp_id int primary key ,
emp_name varchar(20),
salary int
);

insert into emp_index values(1,'Ankit',10000)
,(3,'rahul',10000),(2,'manish',10000),(4,'pushkar',10000);

select * from emp_index;

create nonclustered index idx_name on emp_index(emp_name desc) 

execute sp_helpindex emp_index;

select max(rn) from orders_index
drop index idx_rn on orders_index;

select * from orders_index where rn=100

select  row_number() over(order by a.row_id) as rn, a.* into orders_index 
from orders a, (select top 100 * from orders) b ;

select rn,customer_id from orders_index where rn=100
43.
999400

create  clustered index idx_rn on orders_index(rn) include(customer_id)

create nonclustered index idx_cust on orders_index(customer_id asc,customer_name desc) 

create nonclustered index idx_cust_sales on orders_index(customer_id asc,sales asc) 

name like 'Ank%'

select  customer_id,customer_name from orders_index 
where customer_id like 'DB%' and sales > 100;

create table emp_dup1
(
emp_id int,
emp_name varchar(20)
);
insert into emp_dup
values(1,'Ankit',getdate());

select * from emp_dup;

delete emp_dup 
from emp_dup e
LEFT join (select emp_id,max(create_time) as create_time  from emp_dup group by emp_id ) d
on e.emp_id=d.emp_id and e.create_time=d.create_time
where d.emp_id is null
;

select distinct * into emp_dup1_back  from emp_dup1

select * from emp_dup1
_back

truncate table emp_dup1;

insert into emp_dup1 select * from emp_dup1_back

select * from emp_dup


























