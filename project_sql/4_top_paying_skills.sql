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