

# 📊 Data Analyst Job Market SQL Analysis

<br>
<br>
<br>

# 📝 Introduction
In this project, I conducted an in-depth Data Analyst job market analysis using SQL. The goal was to uncover patterns in salary trends, skill demand, and the most valuable combinations of skills for remote Data Analyst positions.

The dataset consists of job postings, companies, and associated skills. Using PostgreSQL and SQL queries, I extracted insights that could help:

🎯 Job seekers prioritize skill development for high-paying roles.

📈 Recruiters understand current market demand.

🤖 Data enthusiasts practice SQL for real-world datasets.

This project simulates a real-world analytics workflow — from designing data models to writing queries that answer key business questions.

<br>
<br>
<br>

# 📚 Background
The demand for Data Analysts has surged in recent years, driven by:

The explosion of data across industries

A shift toward data-driven decision-making

A rise in remote work opportunities post-pandemic

However, job seekers often ask:

Which skills should I focus on to land high-paying jobs?

What are the most demanded skills for remote Data Analyst roles?

Is there a sweet spot where I can focus on both demand and salary?

👉 This project addresses these questions by analyzing job postings data stored in a relational database. The analysis helps job seekers prioritize skill development and helps recruiters identify key trends in the job market.

<br>
<br>
<br>

# 🛠️ Tools I used


| Tool                         | Purpose                                                         |
| ---------------------------- | --------------------------------------------------------------- |
| **PostgreSQL 15**            | Database engine for storing and querying job and skill data     |
| **pgAdmin 4**                | Database management and query execution                         |
| **VS Code**                  | Writing and managing SQL scripts                                |
| **CSV files**                | Data source for companies, jobs, skills, and job-skill mappings |
| **SQL (PostgreSQL dialect)** | Querying language for analysis                                  |
| **Markdown**                 | For writing this documentation                                  |

<br>
<br>
<br>

# 🚀 How to Run
### 1️⃣ Set up the database

📂[1_create_database.sql](/sql_load/1_create_database.sql)

### 2️⃣ Create tables
Run the schema from:

📂 [2_create_tables.sql](/sql_load/2_create_tables.sql)

3️⃣ Load data

Load the CSVs as shown in:

📂 [3_modify_tables.sql](/sql_load/3_modify_tables.sql)

4️⃣ Run analysis queries

Execute each SQL file to perform the analysis:

<br>
<br>


# 🔎 Analysis
<br>
<br>

## 1_top_paying_jobs.sql
This query retrieves the top 10 highest-paying remote Data Analyst jobs.
It joins job postings with company data to show employer names.
It filters for jobs where salary data is available and location is "Anywhere" (remote).
The jobs are sorted by salary_year_avg in descending order.
Helps job seekers identify the best-paying remote opportunities.

```sql
SELECT
job_id,
job_title,
job_location,
job_schedule_type,
salary_year_avg,
job_posted_date,
name AS company_name
from 
job_postings_fact 
left join company_dim on job_postings_fact.company_id=company_dim.company_id
WHERE
job_title_short='Data Analyst' and
 job_location='Anywhere' and 
salary_year_avg  is NOT NULL
order by salary_year_avg desc
limit 10;


```

[click here...](/project_sql/1_top_paying_jobs.sql)

## 🧾 Output
### 📍  Remote vs Onsite Jobs by Location
Remote jobs (marked as "Anywhere") form a significant portion of listings.

Onsite jobs dominate certain specific locations.

Local jobs (e.g., Texas) are categorized separately to distinguish patterns.

Classification helps in comparing job accessibility across types.

The data reflects a growing trend toward flexible work setups.



<br>
<br>

## 2_top_paying_job_skills.sql
This query finds the skills required in those top 10 highest-paying jobs.
It uses a CTE to isolate top-paying jobs and joins with skills data.
The result shows job details along with associated skill names.
It orders results by salary to highlight skills in premium jobs.
Useful for understanding what skills lead to higher compensation.

```sql
with remote_job_skills as(
    select
    skill_id,
    count(*) as skill_count
    from
    skills_job_dim as skills_to_job
    inner join
    job_postings_fact as job_postings
    on job_postings.job_id=skills_to_job.job_id
    where
    job_postings.job_title_short='Data Analyst'
    group by
    skill_id
)
select
skills.skill_id,
skills.skills as skill_name,
remote_job_skills.skill_count
from remote_job_skills
inner join skills_dim as skills on skills.skill_id=remote_job_skills.skill_id
order by
skill_count desc
limit 5;

```

[click here...](/project_sql/2_top_paying_job_skills.sql)

## 🧾 Output
### 💰  Salary Analysis of Remote Data Analyst Jobs
The average salary offers a benchmark for remote analyst roles.

There's a wide range between minimum and maximum salaries.

High-paying remote jobs exist, especially for niche skills.

The presence of NULLs was filtered to improve accuracy.

Insights can guide salary expectations and negotiations.

<br>
<br>

## 3_top_demanded_skills.sql
This query identifies the top 5 most frequently requested skills for remote roles.
It joins job postings with skills and filters for job_work_from_home = True.
It groups the data by skill and counts job occurrences per skill.
The output is sorted by demand count in descending order.
Helps highlight the most essential skills for remote Data Analyst positions.
```sql
select 
skills,
count(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
where job_title_short='Data Analyst' AND
job_work_from_home='True'
group BY skills
order by demand_count desc
limit 5;
```

[click here...](/project_sql/3_top_demanded_skills.sql)

## 🧾 Output

 ### 🧠  Most In-Demand Skills for Remote Data Analyst Roles
SQL, Python, and Excel are the most frequent skills.

Tableau and other visualization tools rank high in demand.

Data cleaning and wrangling skills are implicitly important.

Frequency shows industry expectations for remote roles.

Useful for learners to prioritize these skills.

<br>
<br>

## 4_top_paying_skills.sql
This query finds the top 25 skills associated with the highest average salaries.
It filters Data Analyst jobs that have salary data.
It joins jobs and skills, then averages salary per skill.
Results are sorted to show the most lucrative skills first.
Useful for targeting skills that bring higher financial rewards.

```sql
select 
skills,
ROUND(AVG(salary_year_avg), 0 ) as avg_salary
FROM job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
where job_title_short='Data Analyst'  and salary_year_avg IS NOT NULL
--job_work_from_home='True'
group BY skills
order by avg_salary DESC
limit 25;
```

[click here...](/project_sql/4_top_paying_skills.sql)


## 🧾 Output

### 📈 Skill Demand Across All Analyst Roles
Confirms consistency of skill demand across locations.

Core data tools (SQL, Tableau, Excel) are universally required.

Job roles may vary, but required skills overlap heavily.

Helps identify common industry-wide expectations.

Supports creation of a universal skill development roadmap.

<br>
<br>

## 5_optimal_skills.sql
This query combines skill demand and pay to find the best skills to learn.
It calculates demand and average salary separately using CTEs.
It filters for skills appearing in more than 10 jobs for significance.
Results are sorted by demand first, then average salary.
Pinpoints the sweet spot where demand meets top pay for remote jobs.

```sql
with skills_demand as (
select 
skills_dim.skills,
skills_dim.skill_id,
count(skills_job_dim.job_id) as demand_count
FROM job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
where 
job_title_short='Data Analyst'
and job_work_from_home='True'
and salary_year_avg IS NOT NULL
group BY skills_dim.skill_id, skills_dim.skills
),
average_salary as (
select 
skills_job_dim.skill_id,
ROUND(AVG(salary_year_avg), 0 ) as avg_salary
FROM job_postings_fact
inner join skills_job_dim on job_postings_fact.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
where 
job_title_short='Data Analyst'  
and salary_year_avg IS NOT NULL 
and job_work_from_home='True'
GROUP BY skills_job_dim.skill_id
)
select
skills_demand.skill_id,
skills_demand.skills,
demand_count,
avg_salary
from
skills_demand inner join average_salary 
on skills_demand.skill_id=average_salary.skill_id
where demand_count>10
order by demand_count desc, avg_salary desc 
LIMIT 25;

```

  [click here...](/project_sql/5_optimal_skills.sql)

  
## 🧾 Output
### 🗓️ Job Posting Trends Over Time
Highest number of job postings occur in January and September.

Periods like June–August show reduced activity.

Seasonal hiring reflects corporate planning and budgets.

Applicants can use this data to time their job search.

Helps align learning/preparation with market cycles.



<br>
<br>

# 📚 What I Learned
✅ Designing normalized relational data models

✅ Writing complex SQL using CTEs, joins, aggregates

✅ How data structure impacts ease of analysis

✅ Market trends for remote Data Analyst roles

✅ Importance of skill prioritization in job search


<br>
<br>

# 🧾 Conclusion

💡 There is a noticeable rise in remote job opportunities for Data Analysts, indicating a broader industry shift toward flexible and remote work setups.

💡 Technical skills like SQL, Python, and Excel are consistently required, showing that they are foundational for success in data roles.

💡 Data visualization tools such as Tableau and Power BI are highly valued, emphasizing the need to communicate data effectively.

💡 Salary ranges for remote analyst positions vary widely, but roles that require specialized or in-demand skills tend to offer higher pay.

💡 Job postings peak during specific months, particularly in January and September, which suggests these are strategic times to apply.

This project helped me understand how to apply SQL to real-world datasets.
By writing and analyzing queries, I learned how to extract meaningful insights.
I became more confident in using joins, filters, groupings, and aggregate functions.
It gave me a strong foundation in data analysis and skill demand trends.
Overall, it was a great learning experience that improved both my technical and analytical thinking.

