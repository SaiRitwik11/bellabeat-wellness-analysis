-- ================================================
-- BELLABEAT WELLNESS ANALYSIS — SQL EXPLORATION
-- Analyst: Jannu Sai Ritwik
-- Date: March 2026
-- Tables: dailyactivity_merged
-- ================================================

USE bellabeat;

-- ================================================
-- SECTION 1: USER & DATA OVERVIEW
-- ================================================
-- 1.1. How many unique users are in the daily activity dataset?
-- Business Purpose: To verify our sample size before deep analysis.
-- ================================================

SELECT COUNT(DISTINCT Id) AS total_users
FROM dailyactivity_merged;

-- Result: Total users = 33


-- ================================================
-- 1.2. What is the start date, the end date, and the total number of days tracked in this dataset?
-- Business Purpose: To understand the exact time frame of the competitor data we are analyzing.
-- ================================================

SELECT 
    MIN(STR_TO_DATE(ActivityDate, '%c/%e/%Y')) AS start_date,
    MAX(STR_TO_DATE(ActivityDate, '%c/%e/%Y')) AS end_date,
    COUNT(DISTINCT ActivityDate) AS total_days
FROM dailyactivity_merged;

-- Result:
-- start_date  | end_date   | days_covered
-- 2016-04-12  | 2016-05-12 | 31


-- ================================================
-- 1.3. How consistently do users track their data?
-- Business Purpose: To see if users wear their devices every day or if they abandon them. 
-- 					  High usage means the app is sticky; low usage means we need better retention features.
-- ================================================

select Id, count(ActivityDate) as total_days
	from dailyactivity_merged
group by id
order by total_days desc;

-- Result:
-- Id         | days_tracked
-- 1503960366 | 31
-- 1624580081 | 31
-- 7086361926 | 31
-- 1844505072 | 31
-- ... (Total 33 rows returned)


-- ================================================
-- 1.4. What are the average daily steps and calories for each user?
-- Business Purpose: To segment users into different lifestyle categories (e.g., highly active vs. sedentary) based on their actual habits.
-- ================================================

select Id, Round(avg(TotalSteps), 2) as Average_steps,
	round(avg(Calories), 2) as Average_calories
from dailyactivity_merged
group by Id
Order by Average_steps desc, Average_calories desc;

-- Result:
-- Id         | Average_steps	   | Average_calories
-- 8877689391 | 16040.03           | 3420.26
-- 8053475328 | 14763.29           | 2945.81
-- 1503960366 | 12116.74           | 1816.42
-- 2022484408 | 11370.65           | 2509.97
-- ... (Total 33 rows returned)

-- ================================================
-- 1.5. What is the average daily time spent in different activity levels?
-- Business Purpose: To identify how much time users spend in different intensity levels (Sedentary vs. Active). 
-- This helps Bellabeat understand if users are primarily using the device for intense workouts or general daily movement, allowing for better-targeted app notifications.
-- ================================================

select Id, Round(avg(VeryActiveMinutes), 2) as Avg_Veryactiveminutes,
	Round(avg(FairlyActiveMinutes), 2) as Avg_fairlyactiveminutes,
    round(avg(LightlyActiveMinutes), 2) as Avg_lightlyactiveminutes,
    round(avg(SedentaryMinutes), 2) as Avg_sedentaryminutes
from dailyactivity_merged
Group by Id
ORDER BY Avg_Veryactiveminutes DESC, Avg_sedentaryminutes DESC;

-- Result:
-- Id         | Avg_Veryactiveminutes	| Avg_fairlyactiveminutes | Avg_lightlyactiveminutes  | Avg_sedentaryminutes
-- 5577150313 | 87.33                   | 29.83                   | 147.93                    | 754.43
-- 8053475328 | 85.16                   | 9.58                    | 150.97                    | 1148.00
-- 8877689391 | 66.06                   | 9.94                    | 234.71                    | 1112.87
-- 8378563200 | 58.68                   | 10.26                   | 156.1                     | 716.13
-- ... (Total 33 rows returned)


-- ================================================
-- 1.6. What is the overall average daily steps, calories, and sedentary minutes across ALL users combined?
-- Business Purpose: To establish dataset-wide benchmarks we can compare against WHO health recommendations and use as headline numbers in our final report.
-- ================================================

select Round(avg(TotalSteps), 0) as overall_avg_steps,
	Round(avg(Calories), 0) as overall_avg_calories,
	Round(avg(SedentaryMinutes), 0) as overall_avg_sedantaryminutes
from dailyactivity_merged;

-- Result:
-- overall_avg_steps | overall_avg_calories | overall_avg_sedentarymins
-- 7638              | 2304                 | 991


-- ================================================
-- 1.7. What percentage of users are meeting the WHO recommended 10,000 steps per day on average?
-- Business Purpose: To quantify the "activity gap" — how many users actually hit the health benchmark vs how many fall short. This becomes the core statistic in our marketing recommendation.
-- ================================================

With Useraverages as (
	select Id, Round(avg(TotalSteps), 0) as Avg_steps
	from dailyactivity_merged
    Group by Id), 
Userstotal as (
	select count(Id) as total_users,
	sum(case when avg_steps >= 10000 then 1 else 0 end) as users_meeting_goals
	from Useraverages)
select total_users, users_meeting_goals,
	Round((users_meeting_goals / total_users * 100), 1) as pct_users_meeting_goals
from Userstotal;

-- Result:
-- total_users | users_meeting_goals | pct_users_meeting_goals
-- 33          | 7                  | 21.2


-- ================================================
-- 1.8. Which day of the week has the highest and lowest average steps?
-- Business Purpose: To identify peak and low activity days. This tells us when users are most vs least engaged with their devices — critical for deciding when Bellabeat should send push notifications.
-- ================================================

select dayname(str_to_date(ActivityDate, '%c/%e/%Y')) as day_of_week,
	Round(avg(TotalSteps), 0) as avg_steps
from dailyactivity_merged
group by day_of_week
order by avg_steps desc;

-- Result:
-- day_of_week | avg_steps
-- Saturday    | 8153
-- Tuesday     | 8125
-- Monday      | 7781
-- Wednesday   | 7559
-- Friday      | 7448
-- Thursday    | 7406
-- Sunday      | 6933