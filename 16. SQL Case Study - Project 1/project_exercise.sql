/* Snapshot of credit_card_transactions data of India */
---------------------------------------------------------
select top 5 * from credit_card_transactions;
/*
5980	Ahmedabad, India	2014-11-08 00:00:00.000	Signature	Food	        F	203159
5981	Delhi, India	    2014-03-17 00:00:00.000	Silver	    Food	        M	11985
5982	Ahmedabad, India	2014-02-11 00:00:00.000	Silver	    Food	        F	269930
5983	Ahmedabad, India	2014-06-20 00:00:00.000	Gold	    Entertainment	M	55147
5984	Delhi, India	    2015-03-02 00:00:00.000	Silver	    Grocery	        F	15170
*/

-- Date Range
select min(date) as min_date, max(date) as max_date from credit_card_transactions;
-- min_date=2013-10-14, max_date=2015-05-26

-- Card Types
select distinct card_type from credit_card_transactions;
--Silver
--Signature
--Gold
--Platinum

-- Expense type 
select distinct exp_type from credit_card_transactions;
/*
Entertainment
Food
Bills
Fuel
Travel
Grocery
*/

-- Cities - 986
select distinct city from credit_card_transactions;
------------------------------------------------------
--solve below questions
--1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
with city_highest_spends as
(
select top 5 city, sum(amount) as highest_spends
from credit_card_transactions
group by city
order by sum(amount) desc
),
total_spends as
(
select sum(amount) as total_spends from credit_card_transactions
)
select city, highest_spends, total_spends, round(highest_spends*100.0/total_spends, 2) as percentage_contribution
from city_highest_spends
join total_spends
on 1=1 

--2- write a query to print highest spend month and amount spent in that month for each card type
--select top 5 * from credit_card_transactions;
with highest_spend_month as
(
select card_type, datepart(year, date) as spent_year, datepart(month, date) as spent_month, sum(amount) as total_spent
from credit_card_transactions 
group by card_type,datepart(year, date),datepart(month, date)
),
highest_spend_month_ranking as
(
select
*,
rank() over(partition by card_type order by total_spent desc) rn
from highest_spend_month
)
select card_type, spent_year , spent_month, total_spent from highest_spend_month_ranking where rn=1;

--3- write a query to print the transaction details(all columns from the table) for each card type when it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
with transaction_details as
(
select *, sum(amount) over(partition by card_type order by date, "index") as total_spend
from credit_card_transactions
),
cumulative_spends as
(
select *,
rank() over(partition by card_type order by total_spend) rnk
from transaction_details where  total_spend >= 1000000
)
select * from cumulative_spends where rnk=1;

--4- write a query to find city which had lowest percentage spend for gold card type
with lowest_percentage as
(
select card_type, city, sum(amount) as total_spend
from credit_card_transactions
where card_type='Gold'
group by card_type, city
)
select top 1 city, total_spend*100.0/(select sum(total_spend) from lowest_percentage) as gold_ratio
from lowest_percentage order by gold_ratio;

--5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
with highest_lowest as
(
	select city, exp_type, sum(amount) as total  from credit_card_transactions
	group by city, exp_type --order by city
)
,
expense_type as
(
select *,
rank() over(partition by city order by total desc) h_rnk,
rank() over(partition by city order by total asc) l_rnk
from highest_lowest
)
select city, 
highest_expense_type, 
lowest_expense_type from
(
select 
city,
max(case when h_rnk=1 then exp_type end) as highest_expense_type,
max(case when l_rnk=1 then exp_type end) as lowest_expense_type
from expense_type
group by city
) t ;

--6- write a query to find percentage contribution of spends by females for each expense type
--select top 5 * from credit_card_transactions;
select 
exp_type, 
sum(case when gender='F' then amount end) as female_spend, 
sum(amount) as total_spend,
round(sum(case when gender='F' then amount end)*100.0/sum(amount), 2) as percentage_contribution_females
from credit_card_transactions
group by exp_type;

--7- which card and expense type combination saw highest month over month growth in Jan-2014
--select top 5 * from credit_card_transactions;
with card_expense_year_month as
(
select 
card_type, 
exp_type,
amount,
datepart(year, date) as yo,
datepart(month, date) as mo
from credit_card_transactions 
where (datepart(year, date)=2013 and datepart(month, date)=12) or (datepart(year, date)=2014 and datepart(month, date)=01)
),
grouped_data as
(
select card_type, exp_type, yo, mo, sum(amount) as total_sales
from card_expense_year_month
group by card_type, exp_type, yo, mo
),
intermediate_result as
(
select *,
lag(total_sales, 1, total_sales) over(partition by card_type, exp_type order by yo) as yoy_growth,
(total_sales-lag(total_sales, 1, total_sales) over(partition by card_type, exp_type order by yo)) growth_sales,
(total_sales-lag(total_sales, 1, total_sales) over(partition by card_type, exp_type order by yo))*100.0/lag(total_sales, 1, total_sales) over(partition by card_type, exp_type order by yo) growth_percentage
from grouped_data
)
--select * from intermediate_result;
,
final_result as
(
select card_type, exp_type, total_sales, growth_sales, round(growth_percentage,2) as growth_percentage,
row_number() over(partition by card_type order by growth_percentage desc) rn
from intermediate_result
where yo=2014 and mo=1
)
select card_type, exp_type, total_sales, growth_sales, growth_percentage from final_result where rn=1;

--9- during weekends which city has highest total spend to total no of transcations ratio 
--select top 5 * from credit_card_transactions;

select top 1 city, sum(amount) as total_amount_spent, count(1) as total_no_of_transactions, sum(amount)/count(1) as transactions_ratio 
from credit_card_transactions where datepart(WEEKDAY, date) in (7,1)
group by city
order by transactions_ratio desc;

--10- which city took least number of days to reach its 500th transaction after the first transaction in that city
--select top 5 * from credit_card_transactions;
/*
select city, count(1) as number_of_days
from credit_card_transactions
group by city
having count(1)>=501; -- total 12 rows
*/
with transaction_details as
(
select city, card_type, exp_type, gender, amount, date, row_number() over(partition by city order by date) rn
from credit_card_transactions
),
intermediate_results as
(
select city, 
case when rn=1 then date end as first_txn_date,
case when rn=500 then date end as last_txn_date
from transaction_details 
)
select top 1 city, max(first_txn_date) as first_txn_date, max(last_txn_date) as last_txn_date, datediff(day, max(first_txn_date), max(last_txn_date)) as no_of_days
from intermediate_results 
group by city 
having max(last_txn_date) is not null
order by no_of_days
;
-- OPTIMIZED APPROACH
with txn_details as
(
select city, card_type, exp_type, gender, amount, date, row_number() over(partition by city order by date, "index") rn
from credit_card_transactions
)
select top 1 city, datediff(day, min(date), max(date)) as no_of_days
from txn_details
where rn=1 or rn=500 
group by city
having count(1)=2
order by no_of_days;

-- Suppose if we put rn=1 and rn=500 then it means both condition should satisfy because WHERE clause is row level filter
-- Suppose if we want to skip the records where year is leap year then we need to create a UDF of is_leap_year(date) which can return 1 or 0 based on if it is leap year or not
---------------------------
-- For Query Optimization
---------------------------
--1. Check the Query Execution Plan and check how many records will it scan w/o Indexing, we can see the cost
--2. Filter the data as early as possible
--3. We can check the joins
--4. If we can create Index then it will be faster