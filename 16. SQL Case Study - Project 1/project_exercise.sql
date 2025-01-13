select * from credit_card_transactions;
select distinct exp_type from credit_card_transactions;

--solve below questions
--1- write a query to print top 5 cities with highest spends and their percentage contribution of total credit card spends 
select top 5 city, max(amount) as highest_spends, round(max(amount)*100.0/sum(amount),2) as percent_contribution
from credit_card_transactions
group by city
order by highest_spends desc, percent_contribution desc;

--2- write a query to print highest spend month and amount spent in that month for each card type
--select top 5 * from credit_card_transactions;
with highest_spend_month as
(
select card_type, datepart(month, date) as spent_month, sum(amount) as total_spent
from credit_card_transactions 
group by card_type,datepart(month, date)
),
highest_spend_month_ranking as
(
select
*,
rank() over(partition by card_type order by total_spent desc) rn
from highest_spend_month
)
select card_type, spent_month, total_spent from highest_spend_month_ranking where rn=1;

--3- write a query to print the transaction details(all columns from the table) for each card type when it reaches a cumulative of 1000000 total spends(We should have 4 rows in the o/p one for each card type)
with transaction_details as
(
select *, sum(amount) over(partition by card_type order by date rows between unbounded preceding and current row) cumulative_amount from credit_card_transactions
)
select * from transaction_details where 
cumulative_amount/10 like '10%' or cumulative_amount/10 like '110%' ;

--4- write a query to find city which had lowest percentage spend for gold card type
with lowest_percentage as
(
select card_type, city, sum(amount) as total_spend
from credit_card_transactions
where card_type='Gold'
group by card_type, city
)
select top 1 card_type, city, total_spend, total_spend*100.0/(select sum(total_spend) from lowest_percentage) as percentage_spend
from lowest_percentage
order by percentage_spend;

--5- write a query to print 3 columns:  city, highest_expense_type , lowest_expense_type (example format : Delhi , bills, Fuel)
select top 5 * from credit_card_transactions;


--6- write a query to find percentage contribution of spends by females for each expense type
--7- which card and expense type combination saw highest month over month growth in Jan-2014
--9- during weekends which city has highest total spend to total no of transcations ratio 
--10- which city took least number of days to reach its 500th transaction after the first transaction in that city