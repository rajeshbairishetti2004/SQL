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


