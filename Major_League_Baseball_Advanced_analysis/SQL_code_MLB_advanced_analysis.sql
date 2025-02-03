
--PART A: School Analysis

SELECT * FROM [dbo].[school_details]
SELECT * FROM [dbo].[schools]

-- a) In each decade, how many schools were there that produced MLB players?
SELECT FLOOR(yearID/10)*10 AS decade, COUNT(DISTINCT schoolID) AS total_players
FROM [dbo].[schools]
GROUP BY FLOOR(yearID/10)*10
ORDER BY FLOOR(yearID/10)*10 ASC;

-- b) What are the names of the top 5 schools that produced the most players?
SELECT TOP 5.sch.schoolID, sd.name_full, sd.city, sd.state, sd.country, COUNT(DISTINCT sch.playerID) AS total_players
FROM  [dbo].[schools] AS sch LEFT JOIN [dbo].[school_details] AS sd
		ON sch.schoolID = sd.schoolID
GROUP BY sch.schoolID, sd.name_full, sd.city, sd.state, sd.country
ORDER BY COUNT(DISTINCT sch.playerID) DESC;

-- c) For each decade, what were the names of the top 3 schools that produced the most players?

SELECT *
FROM

		(SELECT  FLOOR(sch.yearID/10)*10 AS decade, sch.schoolID, sd.name_full, sd.city, sd.state, sd.country, COUNT(DISTINCT sch.playerID) AS total_players,
				ROW_NUMBER() OVER(PARTITION BY FLOOR(sch.yearID/10)*10 ORDER BY COUNT(DISTINCT sch.playerID) DESC) AS row_num
		FROM [dbo].[schools] AS sch LEFT JOIN [dbo].[school_details] AS sd
				ON sch.schoolID = sd.schoolID
		GROUP BY FLOOR(sch.yearID/10)*10, sch.schoolID, sd.name_full, sd.city, sd.state, sd.country
		) AS rd

WHERE row_num <=3

-- PART B: Salary Analysis

-- a) Return the top 20% of teams in terms of average annual spending

-- b) For each team, show the cumulative sum of spending over the years

-- c) Return the first year that each team's cumulative spending surpassed 1 billion

SELECT * FROM [dbo].[salaries]

-- a) Return the top 20% of teams in terms of average annual spending

WITH T1 AS (SELECT teamID, yearID, ROUND(SUM(CAST(salary AS FLOAT)),3) AS total_salary
			FROM [dbo].[salaries]
			GROUP BY teamID, yearID),

	T2 AS(
			SELECT teamID, AVG(total_salary) AS avg_spend,
					NTILE(5) OVER(ORDER BY AVG(total_salary) DESC) AS row_num
			FROM T1
			GROUP BY teamID)

SELECT teamID, ROUND(avg_spend /1000000, 1) AS avg_spend
FROM T2
WHERE row_num =1;

-- b) For each team, show the cumulative sum of spending over the years

SELECT *,
		SUM(total_salary) OVER(PARTITION BY teamID ORDER BY yearID ASC) AS cumulative_sum
FROM
		(SELECT teamID, yearID, ROUND(SUM(CAST(salary AS FLOAT))/1000000,1) AS total_salary
		FROM [dbo].[salaries]
		GROUP BY teamID, yearID) AS rd;

-- c) Return the first year that each team's cumulative spending surpassed 1 billion
WITH T1 AS (SELECT *,
					ROW_NUMBER() OVER(PARTITION BY teamID ORDER BY cumulative_sum) AS row_num
			FROM

			(SELECT *,
					SUM(total_spend) OVER(PARTITION BY teamID ORDER BY yearID ASC) AS cumulative_sum
			FROM
					(SELECT teamID, yearID, ROUND(SUM(CAST(salary AS FLOAT))/1000000000,1) AS total_spend
					FROM [dbo].[salaries]
					GROUP BY teamID, yearID) AS rd) AS rd

			WHERE cumulative_sum > 1)

SELECT teamID, yearID, cumulative_sum
FROM T1
WHERE row_num = 1

-- PART C: Player Career Analysis

-- a) For each player, calculate their age at their first (debut) game, their last game, and their career length (all in years). Sort from longest career to shortest career.

-- b) What team did each player play on for their starting and ending years?

-- c) How many players started and ended on the same team and also played for over a decade?

SELECT * FROM [dbo].[players]
SELECT * FROM [dbo].[salaries]

-- a) For each player, calculate their age at their first (debut) game, their last game, 
--and their career length (all in years). Sort from longest career to shortest career.
SELECT COUNT(playerID) FROM [dbo].[players]
SELECT COUNT(DISTINCT playerID) FROM [dbo].[players]
-- Each rows represent one player.

WITH T1 AS (SELECT playerID, birthYear, birthMonth, birthDay, nameGiven, debut, finalGame,
				CAST(DATEFROMPARTS(birthYear, birthMonth, birthDay)AS DATE) AS birth_day
			FROM [dbo].[players])

SELECT playerID, nameGiven, birth_day, debut, finalGame,
		DATEDIFF(YEAR, birth_day, debut) AS starting_age,
		DATEDIFF(YEAR, birth_day, finalGame) AS finish_age,
		DATEDIFF(YEAR, debut, finalGame) AS career_length
FROM T1
ORDER BY career_length DESC;

-- b) What team did each player play on for their starting and ending years?

SELECT pl.nameGiven, pl.debut, pl.finalGame,
		sa.yearID, sa.teamID, se.yearID, se.teamID  
FROM [dbo].[players] AS pl JOIN [dbo].[salaries] AS sa
							ON pl.playerID = sa.playerID
							AND YEAR(pl.debut) = sa.yearID
							JOIN [dbo].[salaries] AS se
							ON pl.playerID = se.playerID
							AND YEAR(pl.finalGame) = se.yearID

-- c) How many players started and ended on the same team and also played for over a decade?

SELECT pl.nameGiven, pl.debut, pl.finalGame,
		sa.yearID AS starting_year, sa.teamID AS starting_team, se.yearID AS ending_year, se.teamID AS ending_team,  se.yearID - sa.yearID AS total_years
FROM [dbo].[players] AS pl JOIN [dbo].[salaries] AS sa
							ON pl.playerID = sa.playerID
							AND YEAR(pl.debut) = sa.yearID
							JOIN [dbo].[salaries] AS se
							ON pl.playerID = se.playerID
							AND YEAR(pl.finalGame) = se.yearID
WHERE sa.teamID = se.teamID AND se.yearID - sa.yearID > 10;

-- PART D: Player Comparison Analysis

-- a) Which players have the same birthday?

-- b) Create a summary table that shows for each team, what percent of players bat right, left and both.

-- c) How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?

SELECT * FROM [dbo].[players]
SELECT * FROM [dbo].[salaries]

-- a) Which players have the same birthday?

WITH T1 AS (SELECT nameGiven, CAST(DATEFROMPARTS(birthYear, birthMonth, birthDay)AS DATE) AS birth_day
			FROM [dbo].[players])

SELECT birth_day, STRING_AGG(CAST(nameGiven AS VARCHAR(MAX)), ', ') AS concatenated_player_names, COUNT(nameGiven) AS total_people_birth
FROM T1
WHERE birth_day IS NOT NULL
GROUP BY birth_day
HAVING COUNT(nameGiven) > 1


-- b) Create a summary table that shows for each team, what percent of players bat right, left and both.

WITH T1 AS (
    SELECT sal.teamID, 
           COUNT(sal.playerID) AS total_players,
           SUM(CASE WHEN pl.bats = 'R' THEN 1 ELSE 0 END) AS right_player,
           SUM(CASE WHEN pl.bats = 'L' THEN 1 ELSE 0 END) AS left_player,
           SUM(CASE WHEN pl.bats = 'B' THEN 1 ELSE 0 END) AS both_player
    FROM [dbo].[salaries] AS sal 
    LEFT JOIN [dbo].[players] AS pl ON sal.playerID = pl.playerID
    GROUP BY sal.teamID
)

SELECT teamID,
       ROUND(CAST(right_player AS FLOAT) / NULLIF(total_players, 0)*100,2) AS right_player_ratio,
       ROUND(CAST(left_player AS FLOAT) / NULLIF(total_players, 0)*100,2) AS left_player_ratio,
       ROUND(CAST(both_player AS FLOAT) / NULLIF(total_players, 0)*100,2) AS both_player_ratio
FROM T1;

-- c) How have average height and weight at debut game changed over the years, and what's the decade-over-decade difference?

WITH T1 AS (SELECT ROUND(YEAR(debut),-1) AS decade, AVG(weight) AS average_weight,AVG(height) AS average_height
			FROM [dbo].[players]
			WHERE ROUND(YEAR(debut),-1) IS NOT NULL
			GROUP BY ROUND(YEAR(debut),-1))

SELECT decade,
		average_weight - LAG(average_weight) OVER(ORDER BY decade ASC) AS weight_diff,
		average_height - LAG(average_height) OVER(ORDER BY decade ASC) AS height_prior
FROM T1;
			



