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



--4 in each year which player has won maximum gold medal . Write a query to print year,player name and no of golds won in that year . In case of a tie print comma separated player names.

--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal print 3 columns medal,year,sport

--6 find players who won gold medal in summer and winter olympics both.

--7 find players who won gold, silver and bronze medal in a single olympics. print player name along with year.

--8 find players who have won gold medals in consecutive 3 summer olympics in the same event . Consider only olympics 2000 onwards. 
--Assume summer olympics happens every 4 year starting 2000. print player name and event name.

