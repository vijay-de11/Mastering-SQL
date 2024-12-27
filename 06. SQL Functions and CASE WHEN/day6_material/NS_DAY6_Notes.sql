select e.dept_id,d.dep_name from
employee e
left join dept d on e.dept_id=d.dep_id
group by e.dept_id,d.dep_name
having count(distinct salary)=count(1);

select o.sub_category
from orders o
left join returns r on o.order_id=r.order_id
where return_reason in ('others','bad quanlity','wrong item')
group by o.sub_category
having count(distinct r.return_reason)=3;



select o.city
from orders o
left join returns r on o.order_id=r.order_id
--where city in ('Coral Springs' ,'Laguna Niguel')
where r.return_reason is null
group by o.city
having count(r.return_reason) = 0;
;
select 
e1.emp_id,e1.emp_name,e2.emp_name manager_name
from 
employee e1
inner join employee e2 on e1.manager_id=e2.emp_id
where e1.salary > e2.salary;


select dept_id,STRING_AGG(emp_name,';' )  WITHIN GROUP (ORDER BY salary desc) as list_of_employees
from employee
group by dept_id
;
select * from employee;
alter table  employee add dob date;
update employee set dob = dateadd(year,-1*emp_age,getdate())
--date functions

select order_id,order_date,ship_date
,datediff(day,order_date,ship_date) as date_diff_days
,datediff(week,order_date,ship_date) as date_diff_days
from orders;
/*
dateadd(day,5,order_date) as order_date_5
,dateadd(week,5,order_date) as order_date_week_5
,dateadd(day,-5,order_date) as order_date_week_5_minus

from orders;
/*,datepart(yy,order_date) as year_of_order_date
,datepart(month,order_date) as month_of_order_date
,datepart(week,order_date) as week_of_order_date
,DATENAME(month,order_date) as month_name
,DATENAME(weekday,order_date) as week_name*/
*/
--if profit < 100 then 'low profit' elseif profit > 100 then 'profit' else end
select order_id,profit,
case
when profit < 100 then 'Low Profit'
when profit < 250 then 'Medium Profit'
when profit < 400 then 'High Profit'
else 'Very high profit'
end as profit_category
,case
when  profit < 0 then 'Loss'
when profit  >= 100 and profit < 250 then 'Medium Profit'
when profit < 100 then 'Low Profit'
when profit >=250 and profit < 400 then 'High Profit'
else 'Very high profit'
end as profit_category
from orders
;





































having count(distinct r.return_reason)=3;


