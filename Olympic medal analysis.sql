select * from athletes
select * from athlete_events

--1 which team has won the maximum gold medals over the years.
select team,count(medal) as cnt_gold_medal
from athletes a
inner join athlete_events ae on a.id = ae.athlete_id
where medal='gold'
group by team
order by cnt_gold_medal desc


--1 which team has won the maximum gold medals over the years.
select * from athletes
select * from athlete_events

select a.team,count(e.medal) as cn
from athletes a
inner join athlete_events e on a.id=e.athlete_id
where medal='gold'
group by a.team
order by cn desc

--2 for each team print total silver medals and year in which they won maximum silver medal..output 3 columns
-- team,total_silver_medals, year_of_max_silver
with abc as(
select team,count(e.medal) as total_silver_medals
from athletes a
inner join athlete_events e on a.id=e.athlete_id
where medal='silver'
group by team
),
mx as (
select team,year,count(e.medal) as total_silver_medals,rank() over (partition by team order by count(e.medal) desc) as rn
from athletes a
inner join athlete_events e on a.id=e.athlete_id
where medal='silver'
group by team,year
)
select a.team,a.total_silver_medals,b.year,b.total_silver_medals as max_medals_year 
from abc a 
inner join mx b on a.team = b.team
where rn = 1

--3 which player has won maximum gold medals  amongst the players 
--which have won only gold medal (never won silver or bronze) over the years
with cte as (
select a.name as player,count(medal) as total_medal,count(case when medal='gold' then medal end) as gold_medals ,count(case when medal='silver' then medal end) as silver_medals,count(case when medal='bronze' then medal end) as bronze_medals
from athletes a
inner join athlete_events b on a.id = b.athlete_id
group by a.name
)
select  player,total_medal,gold_medals,silver_medals,bronze_medals
from cte
where silver_medals = 0 and bronze_medals = 0
order by gold_medals desc

----4 in each year which player has won maximum gold medal . Write a query to print year,player name 
--and no of golds won in that year . In case of a tie print comma separated player names.
select * from athlete_events
select * from athletes

with cte as (
select year, a.name as player,count(case when b.medal = 'gold' then b.medal end) as max_gold_medals
from athletes a
inner join athlete_events b on a.id=b.athlete_id
group by year,a.name
)
select year,STRING_AGG(player,',') as player_names, max_gold_medals
from (select *,rank() over (partition by year order by max_gold_medals desc) as rn from cte) a
where rn = 1
group by year,max_gold_medals
order by year
--5 in which event and year India has won its first gold medal,first silver medal and first bronze medal
--print 3 columns medal,year,sport
with cte as(
select event, year,medal
from athletes a
inner join athlete_events b on a.id=b.athlete_id
where team = 'india'
group by event,year,medal
)
select medal, year, event
from (select *,rank() over (partition by medal order by year) as rn from cte)c
where rn =1 and medal not in ('na')
order by year 