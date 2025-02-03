# Comprehensive MLB Data Analysis Project

## Project Overview
This project utilizes Microsoft SQL Server to perform an in-depth analysis of Major League Baseball (MLB) player data along with team financials and school contributions to the sport. By combining data from multiple tables, including player demographics, school details, and salary records, this analysis aims to uncover trends and insights that influence MLB's landscape over the years.

The purpose of this project is to leverage SQL's powerful data manipulation capabilities to answer complex queries that can aid in decision-making for scouts, team managers, and sports analysts. This comprehensive study not only looks at player performance and career longevity but also examines financial aspects and the educational background of the players.

## Data Description
The data for this analysis is sourced from several SQL tables stored in a Microsoft SQL Server database. These tables include:

- `[dbo].[players]`: Contains detailed player information including birth dates, debut game dates, and career spans.
- `[dbo].[salaries]`: Lists annual player salary data, allowing analysis of financial trends and team spending.
- `[dbo].[schools]`: Records of schools contributing players to the MLB.
- `[dbo].[school_details]`: Additional details about the schools such as name, location, and number of players produced.

## SQL Functions and Analysis Techniques
Several SQL functions and techniques are used throughout this project to organize, filter, and derive meaningful patterns from the data:

- **Aggregate Fundamental**: Fundamental in performing calculations such as sums, averages, counts, and maximum values, which help in summarizing and analyzing large datasets efficiently. Examples from the project include `SUM()`, `AVG()`, `COUNT()`, and `MAX()` to aggregate player statistics and financial data.
- **Window Functions**: Utilized for performing calculations across sets of rows related to the current row, crucial for assessing running totals and calculating ranks or indexes without the need for a separate subquery. This includes `ROW_NUMBER()` and `NTILE()`, which are used to rank schools and analyze spending thresholds.
- **Date Functions**: Applied to manage and manipulate date data types for calculating player ages, career durations, and temporal data analysis. Functions such as `DATEDIFF()` and `DATEFROMPARTS()` help determine time spans and specific date values.
- **Common Table Expressions (CTEs) & Sub-query**: These are used to create temporary result sets that simplify the execution of complex queries involving multiple joins and subqueries, enhancing readability and maintainability of SQL scripts. 
- **Joins**: Essential in merging data from different tables based on related columns, enabling a comprehensive analysis across players, schools, and financial records. Joins facilitate a unified view of the data necessary for multi-dimensional analysis.

## Objectives of the Analysis
- **Educational Impact**: Assess the contribution of various educational institutions to MLB by identifying schools that have produced the most professional players.
- **Financial Trends**: Analyze team spending patterns over the years and identify the financial thresholds that correlate with team success.
- **Player Careers**: Evaluate how player careers have evolved over decades, including the impact of starting and ending teams on player longevity.
- **Comparative Metrics**: Compare players based on physical attributes and performance criteria to identify potential trends and outliers.

## Questions and Answers
```sql
-- PART A: School Analysis
-- This part focuses on analyzing schools that have contributed players to MLB, providing insights into educational contributions over the decades.

-- Query to select all records from school details
SELECT * FROM [dbo].[school_details];

-- Query to select all records from schools
SELECT * FROM [dbo].[schools];

-- a) Count of schools producing MLB players by decade
SELECT FLOOR(yearID/10)*10 AS decade, COUNT(DISTINCT schoolID) AS total_players
FROM [dbo].[schools]
GROUP BY FLOOR(yearID/10)*10
ORDER BY decade ASC;

-- b) Top 5 schools by number of players produced
SELECT TOP 5 sch.schoolID, sd.name_full, sd.city, sd.state, sd.country, COUNT(DISTINCT sch.playerID) AS total_players
FROM [dbo].[schools] AS sch
LEFT JOIN [dbo].[school_details] AS sd ON sch.schoolID = sd.schoolID
GROUP BY sch.schoolID, sd.name_full, sd.city, sd.state, sd.country
ORDER BY total_players DESC;

-- c) Top 3 schools each decade that produced the most players
SELECT * FROM (
    SELECT FLOOR(sch.yearID/10)*10 AS decade, sch.schoolID, sd.name_full, sd.city, sd.state, sd.country, COUNT(DISTINCT sch.playerID) AS total_players,
           ROW_NUMBER() OVER(PARTITION BY FLOOR(sch.yearID/10)*10 ORDER BY COUNT(DISTINCT sch.playerID) DESC) AS row_num
    FROM [dbo].[schools] AS sch
    LEFT JOIN [dbo].[school_details] AS sd ON sch.schoolID = sd.schoolID
    GROUP BY FLOOR(sch.yearID/10)*10, sch.schoolID, sd.name_full, sd.city, sd.state, sd.country
) AS ranked_data
WHERE row_num <= 3;
```
```sql
-- PART B: Salary Analysis
-- This part investigates the financial aspects of MLB teams, analyzing spending patterns and financial thresholds.

-- Query to select all records from salaries
SELECT * FROM [dbo].[salaries];

-- a) Top 20% of teams by average annual spending
WITH TeamSpending AS (
    SELECT teamID, yearID, ROUND(SUM(CAST(salary AS FLOAT)), 3) AS total_salary
    FROM [dbo].[salaries]
    GROUP BY teamID, yearID
), AvgSpending AS (
    SELECT teamID, AVG(total_salary) AS avg_spend,
           NTILE(5) OVER(ORDER BY AVG(total_salary) DESC) AS tier
    FROM TeamSpending
    GROUP BY teamID
)
SELECT teamID, ROUND(avg_spend / 1000000, 1) AS avg_spend_millions
FROM AvgSpending
WHERE tier = 1;

-- b) Cumulative spending over the years for each team
SELECT teamID, yearID, ROUND(total_salary / 1000000, 1) AS total_salary_millions, 
       SUM(total_salary) OVER(PARTITION BY teamID ORDER BY yearID) AS cumulative_sum
FROM (
    SELECT teamID, yearID, SUM(CAST(salary AS FLOAT)) AS total_salary
    FROM [dbo].[salaries]
    GROUP BY teamID, yearID
) AS yearly_totals;

-- c) First year when team's spending surpassed 1 billion
WITH CumulativeSpending AS (
    SELECT teamID, yearID, SUM(CAST(salary AS FLOAT)) / 1000000000 AS total_spend,
           SUM(total_spend) OVER(PARTITION BY teamID ORDER BY yearID) AS cumulative_sum
    FROM [dbo].[salaries]
    GROUP BY teamID, yearID
)
SELECT teamID, yearID, cumulative_sum
FROM (
    SELECT *, ROW_NUMBER() OVER(PARTITION BY teamID ORDER BY yearID) AS rn
    FROM CumulativeSpending
    WHERE cumulative_sum > 1
) AS ranked_spending
WHERE rn = 1;
```
```sql
-- PART C: Player Career Analysis
-- Analyzing player careers to evaluate longevity and impact, focusing on age at debut, career length, and transitions between teams.

-- Query to select all records from players and salaries
SELECT * FROM [dbo].[players];
SELECT * FROM [dbo].[salaries];

-- a) Age at first and last game, and career length
WITH PlayerAges AS (
    SELECT playerID, CAST(DATEFROMPARTS(birthYear, birthMonth, birthDay) AS DATE) AS birth_day, debut, finalGame,
           DATEDIFF(YEAR, birth_day, debut) AS starting_age,
           DATEDIFF(YEAR, birth_day, finalGame) AS finish_age,
           DATEDIFF(YEAR, debut, finalGame) AS career_length
    FROM [dbo].[players]
)
SELECT playerID, starting_age, finish_age, career_length
FROM PlayerAges
ORDER BY career_length DESC;

-- b) Teams for players' starting and ending years
SELECT pl.nameGiven, pl.debut, pl.finalGame, sa.yearID AS starting_year, sa.teamID AS starting_team, se.yearID AS ending_year, se.teamID AS ending_team
FROM [dbo].[players] AS pl
JOIN [dbo].[salaries] AS sa ON pl.playerID = sa.playerID AND YEAR(pl.debut) = sa.yearID
JOIN [dbo].[salaries] AS se ON pl.playerID = se.playerID AND YEAR(pl.finalGame) = se.yearID;

-- c) Players who started and ended with the same team and played for over a decade
SELECT pl.nameGiven, pl.debut, pl.finalGame, sa.teamID AS starting_team, se.teamID AS ending_team, se.yearID - sa.yearID AS total_years
FROM [dbo].[players] AS pl
JOIN [dbo].[salaries] AS sa ON pl.playerID = sa.playerID AND YEAR(pl.debut) = sa.yearID
JOIN [dbo].[salaries] AS se ON pl.playerID = se.playerID AND YEAR(pl.finalGame) = se.yearID
WHERE sa.teamID = se.teamID AND (se.yearID - sa.yearID > 10);
```
```sql
-- PART D: Player Comparison Analysis
-- This part focuses on comparing players based on birthdays and batting preferences, and analyzing physical attributes over decades.

-- a) Players sharing the same birthday
WITH PlayerBirthdays AS (
    SELECT nameGiven, CAST(DATEFROMPARTS(birthYear, birthMonth, birthDay) AS DATE) AS birth_day
    FROM [dbo].[players]
)
SELECT birth_day, STRING_AGG(nameGiven, ', ') AS players_with_same_birthday, COUNT(nameGiven) AS total
FROM PlayerBirthdays
WHERE birth_day IS NOT NULL
GROUP BY birth_day
HAVING COUNT(nameGiven) > 1;

-- b) Batting preferences summary by team
WITH BattingPreferences AS (
    SELECT sal.teamID, pl.bats,
           COUNT(sal.playerID) AS player_count
    FROM [dbo].[salaries] AS sal
    LEFT JOIN [dbo].[players] AS pl ON sal.playerID = pl.playerID
    GROUP BY sal.teamID, pl.bats
)
SELECT teamID, bats, ROUND(CAST(player_count AS FLOAT) / SUM(player_count) OVER(PARTITION BY teamID) * 100, 2) AS percentage
FROM BattingPreferences;

-- c) Changes in average height and weight at debut over the decades
WITH DecadeStats AS (
    SELECT ROUND(YEAR(debut), -1) AS decade, AVG(weight) AS average_weight, AVG(height) AS average_height
    FROM [dbo].[players]
    WHERE debut IS NOT NULL
    GROUP BY ROUND(YEAR(debut), -1)
)
SELECT decade, average_weight, average_height,
       average_weight - LAG(average_weight) OVER(ORDER BY decade) AS weight_change,
       average_height - LAG(average_height) OVER(ORDER BY decade) AS height_change
FROM DecadeStats;
```
