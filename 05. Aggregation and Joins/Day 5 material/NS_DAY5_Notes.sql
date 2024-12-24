select student_id,count(*) as total_records,count(distinct marks)  as distinct_marks
from exams
where subject in ('Chemistry','Physics')
group by student_id
having count(*)=2 and count(distinct marks)=1
;
select student_id,marks , count(1) as total_rows
from exams
where subject in ('Chemistry','Physics')
group by student_id,marks 
having count(1)=2
order by student_id;
-------------------------------------------------
--create table returns (order_id  varchar(10),return_reason varchar(10))
-- database joins
select o.order_id,o.product_id,r.return_reason
from orders o
inner join returns r on o.order_id=r.order_id;


select o.order_id,o.product_id,r.return_reason, r.order_id as return_order_id
from orders o
left join returns r on o.order_id=r.order_id
;

select r.return_reason,sum(sales) as total_sales
from orders o
inner join returns r on o.order_id=r.order_id
group by r.return_reason;

--cross join
select e.emp_id,e.emp_name,e.dept_id,d.dep_name from 
employee e
inner join dept d on e.dept_id=d.dep_id;

select e.emp_id,e.emp_name,e.dept_id,d.dep_name from 
employee e
left join dept d on e.dept_id=d.dep_id

select e.emp_id,e.emp_name,e.dept_id,d.dep_id,d.dep_name from 
employee e
right join dept d on e.dept_id=d.dep_id;

select e.emp_id,e.emp_name,e.dept_id,d.dep_name from 
dept d
left join employee e on e.dept_id=d.dep_id;

select e.emp_id,e.emp_name,e.dept_id,d.dep_id ,d.dep_name from 
dept d
full outer join employee e on e.dept_id=d.dep_id;

select * from employee;
select * from dept;

select o.order_id,o.product_id,r.return_reason,p.manager
from orders o
left join returns r on o.order_id=r.order_id
inner join people p on o.region=p.region
;

select * from people
create table people
(
manager varchar(20),
region varchar(10)
)

insert into people
values ('Ankit','West')
,('Deepak','East')
,('Vishal','Central')
,('Sanjay','South')



















