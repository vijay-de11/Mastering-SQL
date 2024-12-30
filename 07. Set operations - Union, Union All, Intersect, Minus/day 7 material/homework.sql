-- Note: please do not use any functions which are not taught in the class. you need to solve the questions only with the concepts that have been discussed so far.
-- Run below table script to create icc_world_cup table:
/*
create table icc_world_cup
(
Team_1 Varchar(20),
Team_2 Varchar(20),
Winner Varchar(20)
);
INSERT INTO icc_world_cup values('India','SL','India');
INSERT INTO icc_world_cup values('SL','Aus','Aus');
INSERT INTO icc_world_cup values('SA','Eng','Eng');
INSERT INTO icc_world_cup values('Eng','NZ','NZ');
INSERT INTO icc_world_cup values('Aus','India','India');
*/
-- Q1- write a query to produce below output from icc_world_cup table.
-- O/P format - (team_name, no_of_matches_played , no_of_wins , no_of_losses)
select * from icc_world_cup;

with matches_played as (
  select 
    temp.team_name, 
    sum(temp.no_of_matches_played) as no_of_matches_played 
  from 
    (
      select 
        Team_1 as team_name, 
        count(1) as no_of_matches_played 
      from 
        icc_world_cup 
      group by 
        Team_1 
      union all 
      select 
        Team_2 as team_name, 
        count(1) as no_of_matches_played 
      from 
        icc_world_cup 
      group by 
        Team_2
    ) temp 
  group by 
    temp.team_name
), 
winner_teams as (
  select 
    Winner as team_name, 
    count(1) as no_of_wins 
  from 
    icc_world_cup 
  group by 
    Winner
), 
loser_teams as (
  select 
    m.team_name, 
    count(1) as no_of_losses 
  from 
    matches_played m 
  where 
    m.team_name not in (
      select 
        Winner 
      from 
        icc_world_cup
    ) 
  group by 
    m.team_name
) 
select 
  m.team_name, 
  m.no_of_matches_played, 
  CASE WHEN w.no_of_wins IS NULL THEN 0 ELSE w.no_of_wins END AS no_of_wins, 
  case when (
    m.no_of_matches_played - w.no_of_wins
  ) is null then m.no_of_matches_played else (
    m.no_of_matches_played - w.no_of_wins
  ) end AS no_of_losses 
from 
  matches_played m 
  left join winner_teams w on m.team_name = w.team_name 
  left join loser_teams l on m.team_name = l.team_name;

-- GPT Query:
WITH matches_played AS (
  SELECT 
    team_name, 
    COUNT(*) AS no_of_matches_played 
  FROM (
    SELECT Team_1 AS team_name FROM icc_world_cup
    UNION ALL
    SELECT Team_2 AS team_name FROM icc_world_cup
  ) t
  GROUP BY team_name
),
winner_teams AS (
  SELECT 
    Winner AS team_name, 
    COUNT(*) AS no_of_wins 
  FROM 
    icc_world_cup 
  GROUP BY 
    Winner
)
SELECT 
  m.team_name, 
  m.no_of_matches_played, 
  COALESCE(w.no_of_wins, 0) AS no_of_wins, 
  m.no_of_matches_played - COALESCE(w.no_of_wins, 0) AS no_of_losses
FROM 
  matches_played m
LEFT JOIN 
  winner_teams w 
ON 
  m.team_name = w.team_name;

-- AB's query
with all_teams as 
(select Team_1 as team, case when Team_1=Winner then 1 else 0 end as win_flag from icc_world_cup
union all
select Team_2 as team, case when Team_2=Winner then 1 else 0 end as win_flag from icc_world_cup)
select team,count(1) as total_matches_played , sum(win_flag) as matches_won,count(1)-sum(win_flag) as matches_lost
from all_teams
group by team;

with all_teams_match as
(select Team_1 as team_name, case when Team_1=Winner then 1 else 0 end as win_flag from icc_world_cup
union all
select Team_2 as team_name, case when Team_2=Winner then 1 else 0 end as win_flag from icc_world_cup)
select team_name, count(1) as no_of_matches, sum(win_flag) as no_of_wins, count(1)-sum(win_flag) as no_of_losses
from all_teams_match
group by team_name;
-- Q2- write a query to print first name and last name of a customer using orders table(everything after first space can be considered as last name) - customer_name, first_name, last_name
select customer_name, left(customer_name, charindex(' ', customer_name)) as first_name,
right(customer_name, len(customer_name) - CHARINDEX(' ', customer_name)) as last_name from orders;

-- AB's query
select customer_name , trim(SUBSTRING(customer_name,1,CHARINDEX(' ',customer_name))) as first_name
, SUBSTRING(customer_name,CHARINDEX(' ',customer_name)+1,len(customer_name)-CHARINDEX(' ',customer_name)+1) as second_name
from orders
-- Run below script to create drivers table:
/*
create table drivers(id varchar(10), start_time time, end_time time, start_loc varchar(10), end_loc varchar(10));
insert into drivers values('dri_1', '09:00', '09:30', 'a','b'),('dri_1', '09:30', '10:30', 'b','c'),('dri_1','11:00','11:30', 'd','e');
insert into drivers values('dri_1', '12:00', '12:30', 'f','g'),('dri_1', '13:30', '14:30', 'c','h');
insert into drivers values('dri_2', '12:15', '12:30', 'f','g'),('dri_2', '13:30', '14:30', 'c','h');
*/
-- Q3- write a query to print below output using drivers table. Profit rides are the no of rides where end location of a ride is same as start location of immediate next ride for a driver
-- id, total_rides , profit_rides
-- dri_1,5,1
-- dri_2,2,0
-- For visualizaton, run the below query first
select d1.* , d2.* from drivers d1
left join drivers d2 on d1.id = d2.id and d1.end_loc = d2.start_loc and d1.end_time = d2.start_time

select d1.id, count(d1.id) as total_rides, count(d2.id) as profit_rides
from drivers d1
left join drivers d2 on d1.id = d2.id and d1.end_loc = d2.start_loc and d1.end_time = d2.start_time
group by d1.id;

-- Q4- write a query to print customer name and no of occurence of character 'n' in the customer name.
-- customer_name , count_of_occurence_of_n
select 
	customer_name,
	len(replace(lower(customer_name), 'n', '__'))-len(customer_name) as count_of_occurence_of_n 
from orders
where len(replace(lower(customer_name), 'n', '__'))-len(customer_name) > 0
group by customer_name;

-- AB's query
select customer_name , len(customer_name)-len(replace(lower(customer_name),'n','')) as count_of_occurence_of_n
from orders

-- Q5-write a query to print below output from orders data. example output
/*hierarchy type,hierarchy name ,total_sales_in_west_region,total_sales_in_east_region
category , Technology, ,
category, Furniture, ,
category, Office Supplies, ,
sub_category, Art , ,
sub_category, Furnishings, ,*/
--and so on all the category ,subcategory and ship_mode hierarchies 
select top 5 * from orders;

select 'category' as hierarchy_type, category as hierarchy_name,
sum(case when region='West' then sales end) as total_sales_in_west_region,
sum(case when region='East' then sales end) as total_sales_in_east_region
from orders
group by category
union
select 'sub_category', sub_category,
sum(case when region = 'West' then sales end) as total_sales_in_west_region,
sum(case when region='East' then sales end) as total_sales_in_east_region
from orders
group by sub_category
union
select 'ship_mode', ship_mode,
sum(case when region = 'West' then sales end) as total_sales_in_west_region,
sum(case when region='East' then sales end) as total_sales_in_east_region
from orders
group by ship_mode;

-- The below is different query
select category, sub_category, ship_mode, region, sum(sales) as total_sales from orders
where region = 'West'
group by category, sub_category, ship_mode, region
union 
select category, sub_category, ship_mode, region, sum(sales) as total_sales from orders
where region = 'East'
group by category, sub_category, ship_mode, region;


-- Q6- the first 2 characters of order_id represents the country of order placed . write a query to print total no of orders placed in each country (an order can have 2 rows in the data when more than 1 item was purchased in the order but it should be considered as 1 order)

select top 50 order_id from orders;
select SUBSTRING(order_id, 1, 2) as country_code, count(distinct order_id) as total_orders from orders
group by SUBSTRING(order_id, 1, 2);

-- AB's query
select left(order_id,2) as country, count(distinct order_id) as total_orders
from orders 
group by left(order_id,2)