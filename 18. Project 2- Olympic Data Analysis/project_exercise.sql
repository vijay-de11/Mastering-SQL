-- athlete table preview
select top 5 * from athletes;
-- Schema -> id, name, sex, height, weight, team

select distinct team from athletes; -- 1013

select top 5 * from athlete_events;
-- Schema -> athlete_id, games, year, season, city, sport, event, medal

select distinct sport from athlete_events; -- 66
select distinct medal from athlete_events; -- 4
----------------------------------------------------
--1 which team has won the maximum gold medals over the years.
select top 1 a.team, count(ae.medal) as max_gold_medals
from athletes a
join athlete_events ae
on a.id=ae.athlete_id
where ae.medal='Gold'
group by a.team
order by max_gold_medals desc

--2 for each team, print total silver medals and year in which they won maximum silver medal..output 3 columns team,total_silver_medals, year_of_max_silver

with team_medal_year as
(
select a.team, ae.medal, ae.year, count(1) as total_silver_medals
from athletes a
join athlete_events ae
on a.id=ae.athlete_id
group by a.team, ae.medal, ae.year
having ae.medal='Silver'
),
top_team_medal_year as
(
select team, medal, year, total_silver_medals,
row_number() over(partition by team order by team, total_silver_medals desc) rn
from team_medal_year
)
select team, medal, year, total_silver_medals from top_team_medal_year where rn=1;

--3 which player has won maximum gold medals  amongst the players which have won only gold medal (never won silver or bronze) over the years
with cte as
(
select a.name, ae.medal from athletes a 
join athlete_events ae
on a.id=ae.athlete_id where ae.medal = 'Gold' 
)
select top 1 name, medal, count(1) as total_counts from cte where name not in (select name from athletes where medal != 'Gold') 
group by name, medal order by total_counts desc;

--4 in each year which player has won maximum gold medal . Write a query to print year,player name and no of golds won in that year . In case of a tie print comma separated player names.
with cte as
(
select ae.year, a.name, ae.medal from athletes a
join athlete_events ae
on a.id = ae.athlete_id
where ae.medal='Gold'
),
intermediate_results as
(
select year, name, count(medal) as no_of_golds from cte 
group by year, name
--order by year desc, no_of_golds desc
),
intermediate_result_v2 as
(
select year, name, no_of_golds, 
dense_rank() over(partition by year, no_of_golds order by year desc, name desc) drk
from intermediate_results
--order by year desc, no_of_golds desc
)
--select * from intermediate_result_v2 order by year desc, no_of_golds desc
select year, 
case when count(drk) >= 1 then string_agg(name, ',') end as name,
no_of_golds from intermediate_result_v2
group by year, no_of_golds
order by year desc, no_of_golds desc;

--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal print 3 columns medal,year,sport
with year_sport_medal as
(
select ae.medal, ae.year, ae.sport
from athlete_events ae
join athletes a
on ae.athlete_id=a.id
where a.team='India' and ae.medal != 'NA'
)
select medal, year, sport from (
select medal, year, sport,
row_number() over(partition by medal order by year) rn
from year_sport_medal
) t where rn=1
order by medal;

--6 find players who won gold medal in summer and winter olympics both.
select a.name, ae.medal, ae.season
from athletes a join athlete_events ae
on a.id=ae.athlete_id
where ae.medal='Gold' and ae.season = 'Summer'
intersect
select a.name, ae.medal, ae.season
from athletes a join athlete_events ae
on a.id=ae.athlete_id
where ae.medal='Gold' and ae.season = 'Winter'

--7 find players who won gold, silver and bronze medal in a single olympics. print player name along with year.
with single_olympics_medals as
(
select a.name, ae.medal, ae.year
from athletes a join athlete_events ae
on a.id=ae.athlete_id
--where a.name = 'Carl Townsend Osburn'
where ae.medal in ('Bronze', 'Gold', 'Silver')
)
select name, year
--, count(distinct medal) 
from single_olympics_medals
group by name, year
having count(distinct medal)=3
order by name;

--8 find players who have won gold medals in consecutive 3 summer olympics in the same event . Consider only olympics 2000 onwards. 
--Assume summer olympics happens every 4 year starting 2000. print player name and event name.
with olympics_after_2000 as
(
	select * from athlete_events where year >=2000
),
consecutive_gold_medals as
(
	select a.name, oa.medal, oa.year, oa.event from athletes a
	join olympics_after_2000 oa
	on a.id = oa.athlete_id
	where oa.medal = 'Gold'
)
--,
--intermediate_results as
--(
select name, medal, year, event,
lag(year, 1, year) over(partition by name order by year asc) lag_rnk,
(year - lag(year, 1, year) over(partition by name order by year asc))  year_diff
from consecutive_gold_medals where name = 'Michael Fred Phelps, II';
)
select name, event, count(distinct event)
from intermediate_results
