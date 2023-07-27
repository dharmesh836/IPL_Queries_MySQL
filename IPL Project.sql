use ipl;

select * from ipl_match_ball_by_ball_data;

/*
1. Find out total runs scored in IPL till date.
2. Total runs every season by teams, by batsman
3. Total 4s and 6s hit by team and players
4. Top scores of the IPL Carrerr
5. Top 5 Highest  totals
6. Lowest totals
7. Largest victory 
8. smallest victroy
9. Most 100s, 50s by batsman
10. Most extras In an innings
11. Number of win by teams, loss, match_played
12. First innings winner, seccond innings win
13. 200 above winning percentage
14. Which player played how many matches for a particular team
*/

-- 1. Find out total runs scored in IPL till date.
select sum(runs_off_bat)+sum(extras) as 
Total_score_ever_in_IPL from ipl_match_ball_by_ball_data;

-- 1.1 Find out total first inning runs scored in IPL till date.
select sum(runs_off_bat)+sum(extras) as 
first_inning_total_run from ipl_match_ball_by_ball_data where innings=1;

-- 1.2 Find out total second inning runs scored in IPL till date.
select sum(runs_off_bat)+sum(extras) as 
second_inning_total_run from ipl_match_ball_by_ball_data where innings=2;

--  1.3 Find out difference btw first and second inning runs scored in IPL till date.
with first_inning_total_run as(
select sum(runs_off_bat)+sum(extras) as 
first_inning_total_runs from ipl_match_ball_by_ball_data where innings=1
),
second_inning_total_run as(
select sum(runs_off_bat)+sum(extras) as 
second_inning_total_runs from ipl_match_ball_by_ball_data where innings=2
)
select *, a.first_inning_total_runs-b.second_inning_total_runs as difference,
case when a.first_inning_total_runs>b.second_inning_total_runs
		then 'First Inning Scored the Most'
		else 'Second Inning Scored the Most'
		END as result
from first_inning_total_run a, second_inning_total_run b;





-- 2. Total runs ever by teams
select batting_team, sum(runs_off_bat)+sum(extras) as 
total_runs from ipl_match_ball_by_ball_data 
group by batting_team
order by total_runs desc;

-- 2.1 Total runs every season by teams.
select season, batting_team, sum(runs_off_bat)+sum(extras) as 
total_runs from ipl_match_ball_by_ball_data 
group by season, batting_team
order by season desc, total_runs desc;

-- 2.2 Total runs ever by players.
select  striker, sum(runs_off_bat)+sum(extras) as 
total_runs from ipl_match_ball_by_ball_data 
group by striker
order by total_runs desc;

-- 2.3 Total runs by players per season.
select  season, striker, sum(runs_off_bat)+sum(extras) as 
total_runs from ipl_match_ball_by_ball_data 
group by season, striker
order by season desc, total_runs desc;

-- 2.4 List max run scorer for every season
with total_run_by_each_player_per_season as (
select  season, striker, sum(runs_off_bat)+sum(extras) as 
total_runs,
count(striker) as ball_played
 from ipl_match_ball_by_ball_data 
group by season, striker
order by season desc, total_runs desc
)
select t.season, 
max(total_runs) as max_runs 
from total_run_by_each_player_per_season t
group by season;
;
-- above query - unable to get names of the player.. 
-- Below is one more try
with ABC as(
select match_id, season,batting_team, striker, sum(runs_off_bat) as runs from ipl_match_ball_by_ball_data 
group by match_id,season ,batting_team, striker
order by runs desc)
select season, striker, sum(runs) as runs from abc group by season, striker order by runs desc;



-- 3. Total 4s hit by team 
select batting_team, count(runs_off_bat) as '4s' from ipl_match_ball_by_ball_data where runs_off_bat=4
group by batting_team ;
-- 3.1 Total number of 4s hit by players
select striker, count(runs_off_bat) as '4s' from ipl_match_ball_by_ball_data where runs_off_bat=4
group by striker;
-- 3.2 Total 6s hit by team
select batting_team, count(runs_off_bat) as '6s' from ipl_match_ball_by_ball_data where runs_off_bat=6
group by batting_team;
-- 3.3 Total 6s hit by players
select striker, count(runs_off_bat) as '6s' from ipl_match_ball_by_ball_data where runs_off_bat=6
group by striker;

-- 3.4 Total no. of 4s and 6s hit by players
with total_6s as(
select striker, count(runs_off_bat) as sixes from ipl_match_ball_by_ball_data where runs_off_bat=6
group by striker
),
total_4s as(
select striker, count(runs_off_bat) as fours from ipl_match_ball_by_ball_data where runs_off_bat=4
group by striker
)
select t6.striker, fours, sixes from total_6s t6 inner join total_4s t4 on
t6.striker=t4.striker;


-- 3.5 Total no. of 4s and 6s hit by Teams
with total_6s as(
select batting_team, count(runs_off_bat) as sixes from ipl_match_ball_by_ball_data where runs_off_bat=6
group by batting_team
),
total_4s as(
select batting_team, count(runs_off_bat) as fours from ipl_match_ball_by_ball_data where runs_off_bat=4
group by batting_team
)
select t6.batting_team, fours, sixes from total_6s t6 inner join total_4s t4 on
t6.batting_team=t4.batting_team;


use ipl;
-- 4. Top scores of the IPL Carrerr
select match_id, batting_team, striker, sum(runs_off_bat) as runs from ipl_match_ball_by_ball_data 
group by match_id,batting_team, striker;

-- 5 Top 5 Highest individual scores
select match_id, batting_team, striker, sum(runs_off_bat) as runs from ipl_match_ball_by_ball_data 
group by match_id,batting_team, striker
order by runs desc;

-- 4.2 No. of centuries by players
select striker, count(runs) as no_of_centuries from (
select match_id, batting_team, striker, sum(runs_off_bat) as runs from ipl_match_ball_by_ball_data 
group by match_id,batting_team, striker
order by runs desc) T where T.runs >= 100
group by striker
order by no_of_centuries desc;

-- 4.3 No of ducks for a player
select striker, count(runs) as no_of_centuries from (
select match_id, batting_team, striker, sum(runs_off_bat) as runs from ipl_match_ball_by_ball_data 
group by match_id,batting_team, striker
order by runs desc) T where T.runs = 0
group by striker
order by no_of_centuries desc;

-- 6 Lowest Total
select season,match_id, batting_team, sum(runs_off_bat)+sum(extras) as 
total_runs from ipl_match_ball_by_ball_data 
group by season, match_id,batting_team
order by season desc, total_runs asc;

-- 6.1 List of totals by each team less than 100
select batting_team ,count(total_runs) as no from (
select season,match_id, batting_team, sum(runs_off_bat)+sum(extras) as 
total_runs from ipl_match_ball_by_ball_data 
group by season, match_id,batting_team
having total_runs < 100
order by season desc, total_runs asc) T
group by batting_team;



-- 7 Largest Victory
with first_inning as ( 
select match_id,  batting_team, (count(ball)-sum(wides)-sum(noballs)) as balls,sum(runs_off_bat)+sum(extras) as 
total_runs from ipl_match_ball_by_ball_data where innings=1
group by match_id,  batting_team
), 
second_inning as ( 
select match_id,  batting_team, (count(ball)-sum(wides)-sum(noballs)) as balls,sum(runs_off_bat)+sum(extras) as 
total_runs from ipl_match_ball_by_ball_data where innings=2
group by match_id,  batting_team
)
select f.match_id, f.batting_team as First_inning_bat,
f.total_runs as first_inning_score, 
f.balls as ball_played_in_First_innings,
s.batting_team as Second_inning_bat,
s.total_runs as Second_inning_score,
s.balls as ball_played_in_Second_innings,
f.total_runs-s.total_runs as Difference
from first_inning f inner join second_inning s on f.match_id=s.match_id;



-- list all the runs and no. of outs by each player.
with wicket_ball_table as 
(
select striker, count(wicket_type) as dissmissed from ipl_match_ball_by_ball_data b where b.wicket_type like '_%'
group by striker
),
rest_details as (
select striker, sum(runs_off_bat) as runs , count(distinct match_id) as matches_played
from ipl_match_ball_by_ball_data a group by striker
)
select r.striker,runs, dissmissed, matches_played, 
concat(((matches_played-dissmissed)/matches_played)*100) as not_outs_percentage
from rest_details r inner join wicket_ball_table w 
on r.striker=w.striker
order by not_outs_percentage desc;

-- list the total match played,
select batting_team, count(distinct match_id) as total_match_played 
from ipl_match_ball_by_ball_data group by batting_team;

-- List the low scoring (<100) matches and their winners
With Inning_2_below_hundred as (
select match_id, innings, batting_team, sum(runs_off_bat)+sum(extras)
as total_score
from ipl_match_ball_by_ball_data where innings = 2
group by match_id, batting_team
having Total_score <= 100
),
Inning_1_below_hundred as 
(
select match_id, innings, batting_team ,sum(runs_off_bat)+sum(extras) as 
total_score
from ipl_match_ball_by_ball_data where innings = 1
group by match_id, batting_team, innings
having total_score<=100
),
both_the_innings_having_below_hundred as 
(
select f.match_id, f.batting_team as first_inning_batting,
f.total_score as first_inning_score,
s.batting_team as second_inning_batting,
s.total_score as second_inning_score
from Inning_1_below_hundred f inner join Inning_2_below_hundred s on
f.match_id = s.match_id
),
below_100_winners_list as 
(
select *, 
case when first_inning_score > second_inning_score then 'First_Inning'
		else 'Second_Inning' END as 'Winner'
 from both_the_innings_having_below_hundred
)
select * from below_100_winners_list;



-- How many time +200 scores is done and which inning won the game.
With Inning_2_above_two_hundred as (
select match_id, innings, batting_team, sum(runs_off_bat)+sum(extras)
as total_score
from ipl_match_ball_by_ball_data where innings = 2
group by match_id, batting_team
having Total_score >=200
),
Inning_1_above_two_hundred as 
(
select match_id, innings, batting_team ,sum(runs_off_bat)+sum(extras) as 
total_score
from ipl_match_ball_by_ball_data where innings = 1
group by match_id, batting_team, innings
having total_score>=200
),
both_the_innings_having_above_two_hundred as 
(
select f.match_id, f.batting_team as first_inning_batting,
f.total_score as first_inning_score,
s.batting_team as second_inning_batting,
s.total_score as second_inning_score
from Inning_1_above_two_hundred f inner join Inning_2_above_two_hundred s on
f.match_id = s.match_id
),
above_200_winners_list as 
(
select *, 
case when first_inning_score > second_inning_score then 'First_Inning'
		else 'Second_Inning' END as 'Winner'
 from both_the_innings_having_above_two_hundred
)
select winner, count(winner) from above_200_winners_list
group by winner;



-- wickets in IPL cricket
select wicket_type, count(*) as count from ipl_match_ball_by_ball_data where wicket_type like '_%' 
group by wicket_type
order by count desc;

-- How many times dhoni got out
select 'MS Dhoni' as Name ,wicket_type, count(*) as count from ipl_match_ball_by_ball_data where wicket_type like '_%' 
and striker like 'MS Dhoni'
group by wicket_type
order by count desc;

-- 10. Most extras In an innings
select Match_id, innings, sum(extras) as Extras from ipl_match_ball_by_ball_data 
group by Match_id, innings
order by Extras desc;






