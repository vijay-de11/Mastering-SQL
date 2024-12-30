select * from icc_world_cup;

select team_1 as team_name, case when team_1=winner then 1 else 0 end as win_flag
from icc_world_cup
union all
select team_2 as team_name, case when team_2=winner then 1 else 0 end as win_flag
from icc_world_cup;

select team_1 as team_name from icc_world_cup
union
select team_2 as team_name from icc_world_cup
;
select d1.id as driver_id,count(1) as total_rides,count(d2.id) as profit_rides
from  drivers d1
left join drivers d2 
on d1.id=d2.id and d1.end_loc=d2.start_loc and d1.end_time=d2.start_time
group by d1.id;

select * from orders

hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
category , Technology, 2000, 1500
;

select 'category' as hierarchy_type, category as hierarchy_name 
,sum(case when region='West' then sales end) as total_sales_west_region
,sum(case when region='East' then sales end) as total_sales_east_region
,null as total_sales_south_region
from orders
group by category
union all
select 'sub-categories' , sub_category 
,sum(case when region='West' then sales end) 
,sum(case when region='East' then sales end) 
,0 as total_sales_south_region
from orders
group by sub_category
union all
select 'ship mode' as hierarchy_type, ship_mode as hierarchy_name
,sum(case when region='West' then sales end) as total_sales_west_region
,sum(case when region='East' then sales end) as total_sales_east_region
,sum(case when region='South' then sales end) as total_sales_south_region
from orders
group by ship_mode
;
select * from orders;


create view orders_vw as 
select * from orders;

select * from orders_vw;

create view orders_summary_vw as 
select 'category' as hierarchy_type, category as hierarchy_name 
,sum(case when region='West' then sales end) as total_sales_west_region
,sum(case when region='East' then sales end) as total_sales_east_region
,null as total_sales_south_region
from orders
group by category
union all
select 'sub-categories' , sub_category 
,sum(case when region='West' then sales end) 
,sum(case when region='East' then sales end) 
,0 as total_sales_south_region
from orders
group by sub_category
union all
select 'ship mode' as hierarchy_type, ship_mode as hierarchy_name
,sum(case when region='West' then sales end) as total_sales_west_region
,sum(case when region='East' then sales end) as total_sales_east_region
,sum(case when region='South' then sales end) as total_sales_south_region
from orders
group by ship_mode
;
select * from orders_summary_vw
;
select * from orders;

create view - as 
select * from orders where region='South';

select * from orders_south_vw;

create view emp_master as 
select * from master.dbo.emp;


refrencial intergrity constaint 

select * from employee;
select * from dept;

drop table emp
create table emp 
(
emp_id integer  ,
emp_name varchar(10),
dep_id int not null references dept(dep_id)
)

insert into emp 
values (1,'Ankit',100);

update  dept 
set dep_id=600
where dep_id=500;

insert into emp 
values (1,'Ramesh',500);


select * from emp;
select * from dept


insert into dept values (500,'Operations')


alter table dept alter  column  dep_id int not null

alter table dept add constraint primary_key primary key (dep_id)


create table dept1 
(
id int  identity(1,1) ,
dep_id int,
dep_name varchar(10)
)

insert into dept1(dep_id,dep_name) values(100,'HR')
insert into dept1 values(200,'Analytics')
select * from dept1;


ALTER TABLE dbo.Content
   ADD CONSTRAINT FK_Content_Libraries
   FOREIGN KEY(LibraryID, Application)
   REFERENCES dbo.Libraries(ID, Application)



































