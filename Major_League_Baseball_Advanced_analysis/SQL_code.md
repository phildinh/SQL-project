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

- **Aggregate Functions**: Used to perform calculations on sets of values to return a single scalar value, helping summarize data. Examples include `SUM()`, `AVG()`, `COUNT()`, and `MAX()`.
- **Window Functions**: Enable calculations across sets of rows that are related to the current row, providing a way to carry out running totals, moving averages, and cumulative sums. Functions like `ROW_NUMBER()` and `NTILE()` are particularly useful.
- **Date Functions**: Essential for extracting specific elements from dates (e.g., year, month, day) and calculating differences between dates to determine ages and career lengths.
- **Common Table Expressions (CTEs)**: These temporary result sets are defined within the execution scope of a single SELECT, INSERT, UPDATE, DELETE, or MERGE statement, and they are used to simplify complex joins and subqueries.
- **Joins**: Enable the merging of rows from two or more tables based on a related column between them. This project utilizes various joins to combine data across the player, school, and salary tables to perform comprehensive analyses.

## Objectives of the Analysis
- **Educational Impact**: Assess the contribution of various educational institutions to MLB by identifying schools that have produced the most professional players.
- **Financial Trends**: Analyze team spending patterns over the years and identify the financial thresholds that correlate with team success.
- **Player Careers**: Evaluate how player careers have evolved over decades, including the impact of starting and ending teams on player longevity.
- **Comparative Metrics**: Compare players based on physical attributes and performance criteria to identify potential trends and outliers.

