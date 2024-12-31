--sub query 
--find average order value
select avg(order_sales) as avg_order_value from
(select order_id,sum(sales) as order_sales
from orders
group by order_id) as orders_aggregated


--230 
--458
--find order with sales more than average order value

select * from orders where order_id='CA-2018-100090'


select order_id 
from orders
group by order_id 
having sum(sales) > (select avg(orders_aggregated.order_sales) as avg_order_value from
(select order_id,sum(sales) as order_sales
from orders
group by order_id) as orders_aggregated) ;

select * from employee
where dept_id not in (100,200,300)

select *,(select avg(salary) from employee) as avg_sal from employee
where dept_id  in (select dep_id from dept);

select dept_id from employee
except
select dep_id from dept

select avg(salary) from employee where dept_id !=700 --9200
select * from dept ;


select A.*,B.*
from 
(select order_id , sum(sales) as order_sales
from orders
group by order_id ) A
inner join
(select avg(orders_aggregated.order_sales) as avg_order_value from
(select order_id,sum(sales) as order_sales
from orders
group by order_id) as orders_aggregated) B 
on 1=1
where order_sales > avg_order_value;


select e.*,d.* from
employee e
inner join 
(select dept_id,avg(salary) as avg_dep_salary
from employee
group by dept_id) d
on e.dept_id=d.dept_id;

select team_name,count(*) as matches_played,sum(win_flag) matches_won,count(1)-sum(win_flag) as lost_matches
from
(select team_1 as team_name,case when team_1=winner then 1 else 0 end as win_flag
from icc_world_cup
union all
select team_2 as team_name,case when team_2=winner then 1 else 0 end as win_flag
from icc_world_cup) A
group by team_name
;
--cte common table expression
with A as
(select team_1 as team_name,case when team_1=winner then 1 else 0 end as win_flag
from icc_world_cup
union all
select team_2 as team_name,case when team_2=winner then 1 else 0 end as win_flag
from icc_world_cup) 

select team_name,count(*) as matches_played,sum(win_flag) matches_won,count(1)-sum(win_flag) as lost_matches
from A
group by team_name;

with dep as (select dept_id,avg(salary) as avg_dep_salary
from employee
group by dept_id)
,total_salary as (select sum(avg_dep_salary) as ts from dep)

select e.*,d.* from
employee e
inner join dep d
on e.dept_id=d.dept_id;


with order_wise_sales as (select order_id , sum(sales) as order_sales
from orders
group by order_id)

,B as (select avg(orders_aggregated.order_sales) as avg_order_value from
order_wise_sales as orders_aggregated)
,c as (select * from orders)
select A.*,B.*
from 
order_wise_sales A
, B 
where order_sales > avg_order_value;


select * from employee
where dept_id  in (select dep_id from dept)





































