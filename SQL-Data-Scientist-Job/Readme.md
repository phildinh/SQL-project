# Introduction
📊 Dive into the data job market! Focusing on data scientist roles, this project explores 💰 top-paying jobs, 🔥 in-demand skills, and 📈 where high demand meets high salary in data analytics.

🔍 SQL queries?, questons and answer Check them out here:[SQL_Questions_Answer](https://github.com/phildinh/SQL-project/blob/main/SQL-Data-Scientist-Job/SQL_Questions_Answer)

# Background
Driven by a quest to navigate the Data Scientist job market more effectively, this project was born from a desire to pinpoint top-paid and in-demand skills, streamlining others work to find optimal jobs.

### The questions I wanted to answer through my SQL queries were:

1. What are the top-paying Data Scientist jobs?
2. What skills are required for these top-paying jobs?
3. What skills are most in demand for Data Scientist?
4. Which skills are associated with higher salaries?
5. What are the most optimal skills to learn?

# Tools I Used
For my deep dive into the data analyst job market, I harnessed the power of several key tools:

- **SQL:** The backbone of my analysis, allowing me to query the database and unearth critical insights.
- **PostgreSQL:** The chosen database management system, ideal for handling the job posting data.
-  **Python:** Visualize charts which easy to understand.
- **Visual Studio Code:** My go-to for database management and executing SQL queries.

# The Analysis
Each query for this project aimed at investigating specific aspects of the Data Scientist job market. Here’s how I approached each question:

### 1. Top Paying Data Scientist Jobs
To identify the highest-paying roles, I filtered Data Scientist positions by average yearly salary and location, focusing on remote jobs. This query highlights the high paying opportunities in the field.

Reveiw columns and information from tables first.
```sql
SELECT * FROM job_postings_fact
LIMIT 100;
SELECT * FROM company_dim
LIMIT 100;
```
Answer question 1:
```sql
SELECT	
	job_id,
	job_title,
	job_location,
	job_schedule_type,
	salary_year_avg,
	job_posted_date,
    name AS company_name
FROM
    job_postings_fact
LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Scientist' AND 
    job_location = 'Anywhere' AND 
    salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10;
```
Here’s the breakdown of the top data scientist jobs in 2023:
- **Wide Salary Range**: The top 10 paying data scientist roles show a significant salary range, spanning from $300,000 to $550,000, highlighting the lucrative potential in the field.
- **Diverse Employers**: Companies such as Selby Jennings, Algo Capital Group, and Walmart are among those offering high salaries, demonstrating a wide interest across different industries from finance to retail.
- **Job Title Variety**: There’s notable diversity in job titles, ranging from Staff Data Scientist/Quant Researcher to Head of Battery Data Science, reflecting varied roles and specializations within the data science discipline.

I make chart by Python, ask GPT to help me:
![image](https://github.com/user-attachments/assets/4033e474-c46c-42ea-8c9d-cfbe5810010b)

### 2. Skills for Top Paying Jobs
To understand what skills are required for the top-paying jobs, I joined the job postings with the skills data, providing insights into what employers value for high-compensation roles.

Reveiw columns and information from other tables, later I can do CTE
```sql
SELECT * FROM skills_dim
LIMIT 100;
SELECT * FROM skills_job_dim
LIMIT 100;
```
Answer question 2:
```sql
WITH top_paying_jobs AS (
    SELECT	
        job_id,
        job_title,
        salary_year_avg,
        name AS company_name
    FROM
        job_postings_fact
    LEFT JOIN company_dim ON job_postings_fact.company_id = company_dim.company_id
    WHERE
        job_title_short = 'Data Scientist' AND 
        job_location = 'Anywhere' AND 
        salary_year_avg IS NOT NULL
    ORDER BY
        salary_year_avg DESC
    LIMIT 10
)
SELECT 
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN skills_job_dim ON top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY
    salary_year_avg DESC;
```
Skill Demand for Top-Paying Data Scientist Roles in 2023:

- **Predominant Skills**: SQL and Python lead the demand, essential for data manipulation and analytics, noted in the majority of the high-paying job postings.
- **Visualization and Analysis Tools**: Tableau's prominence underscores the value of data visualization skills alongside analytical capabilities.
- **Advanced Technologies**: Emerging tools like TensorFlow and PyTorch highlight a growing need for expertise in machine learning and advanced data modeling.
![image](https://github.com/user-attachments/assets/52e9860a-3699-413d-8e2c-d1cf1e1eb46b)


### 3. In-Demand Skills for Data Scientist:
This query helped identify the skills most frequently requested in job postings, directing focus to areas with high demand.
```sql
SELECT 
    skills,
    COUNT(skills_job_dim.job_id) AS demand_count
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist' 
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    demand_count DESC
LIMIT 5;
```
Key Skills Demand for Data Scientist in 2023

As we move deeper into the data-driven age, the need for skilled Data Scientist remains high, with certain technical skills proving particularly indispensable. Here's a look at the most sought-after skills in the field:

- **Python Leads the Way**: Dominating the landscape, Python is the most demanded skill with 10,390 mentions, reflecting its pivotal role in Data Scientist, machine learning, and automation.
- **SQL's Enduring Relevance**: SQL remains a fundamental tool, with 7,488 mentions, underscoring its importance in data querying and management.
R Gains Traction: With 4,674 mentions, the programming language R is highly valued for statistical analysis and visualization, indicating its strong presence in academic and research settings.
- **AWS and Tableau**: AWS, with 2,593 mentions, highlights the growing need for cloud-based solutions in data handling, while Tableau, with 2,458 mentions, continues to be crucial for data visualization and decision-making insights.

| Skills  | Demand Count |
|---------|--------------|
| Python  | 10,390       |
| SQL     | 7,488        |
| R       | 4,674        |
| AWS     | 2,593        |
| Tableau | 2,458        |


### 4. Skills Based on Salary
Exploring the average salaries associated with different skills revealed which skills are the highest paying.

```sql
SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM job_postings_fact
INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Scientist'
    AND salary_year_avg IS NOT NULL
    AND job_work_from_home = True 
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25;
```
Top Paying Skills for Data Scientist in 2023

The evolving landscape of data analytics continues to demand a diverse set of skills, driving competitive salaries for those proficient in specialized technologies. Here’s a detailed breakdown of the results for top-paying skills for Data Scientist:

- **Specialized Programming Proficiency**: Skills in GDPR, Golang, and Selenium lead in commanding top salaries, highlighting the premium on niche technical skills that drive data compliance, system performance, and automation.
- **Database and Big Data Expertise**: Mastery in technologies like Neo4j and Microstrategy reflects a high demand for professionals capable of managing complex data structures and delivering insights at scale.
- **Emerging Technologies and Tools**: Familiarity with cutting-edge tools like Solidity and Elixir points to a growing trend where knowledge in new programming languages and frameworks correlates with higher earning potential.

| Skills        | Average Salary ($) |
|---------------|-------------------:|
| GDPR          |           217,738  |
| Golang        |           208,750  |
| Atlassian     |           189,700  |
| Selenium      |           180,000  |
| OpenCV        |           172,500  |
| Neo4j         |           171,655  |
| Microstrategy |           171,147  |
| DynamoDB      |           169,670  |
| PHP           |           168,125  |
| Tidyverse     |           165,513  |
| Solidity      |           165,000  |
| C             |           164,865  |
| Go            |           164,691  |
| Datarobot     |           164,500  |
| Qlik          |           164,485  |
| Redis         |           162,500  |
| Watson        |           161,710  |
| Rust          |           161,250  |
| Elixir        |           161,250  |
| Cassandra     |           160,850  |
| Looker        |           158,715  |
| Terminal      |           158,333  |
| Airflow       |           157,414  |
| Julia         |           157,244  |

### 5. Most Optimal Skills to Learn
Combining insights from demand and salary data, this query aimed to pinpoint skills that are both in high demand and have high salaries, offering a strategic focus for skill development.

```sql
WITH skills_demand AS (
    SELECT
        skills_dim.skill_id,
        skills_dim.skills,
        COUNT(skills_job_dim.job_id) AS demand_count
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Scientist' 
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY
        skills_dim.skill_id
), 
-- Skills with high average salaries for Data Scientist roles
-- Use Query #4
average_salary AS (
    SELECT 
        skills_job_dim.skill_id,
        ROUND(AVG(job_postings_fact.salary_year_avg), 0) AS avg_salary
    FROM job_postings_fact
    INNER JOIN skills_job_dim ON job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN skills_dim ON skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst'
        AND salary_year_avg IS NOT NULL
        AND job_work_from_home = True 
    GROUP BY
        skills_job_dim.skill_id
)
-- Return high demand and high salaries for 10 skills 
SELECT
    skills_demand.skill_id,
    skills_demand.skills,
    demand_count,
    avg_salary
FROM
    skills_demand
INNER JOIN  average_salary ON skills_demand.skill_id = average_salary.skill_id
WHERE  
    demand_count > 10
ORDER BY
    avg_salary DESC,
    demand_count DESC
LIMIT 25;
```
Key Skills and Technologies for Data Scientists in 2023

As data science continues to evolve, specific skills stand out for their critical role in the industry:

- **Advanced Programming and Data Handling**: Python leads the demand with a significant count of 763, reflecting its essential role in a variety of data-driven tasks, from machine learning to data manipulation. Notably, other programming languages such as Java and R also show substantial demand, emphasizing their importance in statistical computing and application development.
- **Big Data Technologies**: Technologies such as Hadoop, Snowflake, and Databricks are highly sought after, underscoring the importance of skills in managing and analyzing large datasets efficiently.
- **Machine Learning and Data Analysis Tools**: Scikit-Learn and Pandas remain crucial for their powerful data processing and machine learning capabilities, which are fundamental to extracting insights from data.
- **Cloud Computing and Infrastructure Management**: Cloud services like AWS and GCP along with tools like Kubernetes and Docker highlight the ongoing shift towards scalable, flexible solutions for deploying and managing data science applications.

| Skills       | Demand Count | Average Salary ($) |
|--------------|--------------|--------------------|
| Python       | 763          | 101,397            |
| Java         | 64           | 106,906            |
| R            | 148          | 104,534            |
| Hadoop       | 82           | 113,193            |
| Snowflake    | 72           | 112,948            |
| Databricks   | 63           | 141,907            |
| Scikit-Learn | 81           | 125,781            |
| Pandas       | 113          | 151,821            |
| AWS          | 217          | 108,317            |
| GCP          | 59           | 122,500            |
| Azure        | 122          | 111,225            |
| Kubernetes   | 25           | 132,500            |
| Docker       | 22           | 104,918            |

## What I Learned

Throughout this learning journey, I've significantly upgraded my technical skills, focusing on SQL and data analytics:

- **🧩 Complex Query Crafting:** Mastered advanced SQL, skillfully merging tables and utilizing WITH clauses for complex dataset manipulations.
- **📊 Data Aggregation:** Proficient use of GROUP BY with aggregate functions like COUNT() and AVG() to distill insights from data.
- **💡 Analytical Wizardry:** Transformed intricate real-world questions into actionable, insightful SQL queries.

## Conclusions

### Insights

From the detailed analysis, several key insights emerged:

1. **Top-Paying Data Scientist Roles**:
   - Highest-paying positions command salaries up to $550,000, highlighting the lucrative potential in specialized areas like machine learning and big data technologies.

2. **Essential Skills for High-Paying Roles**:
   - Core proficiency in Python and SQL is crucial, reflecting their foundational role in data manipulation and analytics.

3. **Most In-Demand Skills**:
   - Python emerges as the most demanded skill, essential for its versatility in various data science applications.

4. **Specialized Skills Yield Higher Salaries**:
   - Advanced skills in technologies such as Hadoop and Databricks are linked to higher salaries, indicating a premium on specialized expertise.

5. **Optimal Skills for Maximizing Market Value**:
   - Skills in cloud technologies like AWS and Azure, alongside machine learning tools like Scikit-Learn and TensorFlow, are particularly valuable, offering significant salary potential and job market relevance.

### Closing Thoughts

This project not only refined my SQL and data analysis skills but also provided deep insights into the evolving landscape of the data scientist job market. The findings suggest a clear direction for aspiring data scientists: to prioritize learning high-demand, high-value skills. This strategy can help them secure top-tier positions and excel in an increasingly competitive field. Emphasizing continuous education and adaptability to new technologies will remain crucial in navigating the future of data science.
