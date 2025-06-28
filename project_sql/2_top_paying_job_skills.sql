

with top_paying_jobs as (
SELECT
job_id,
job_title,
salary_year_avg,
name AS company_name
from 
job_postings_fact 
left join company_dim on job_postings_fact.company_id=company_dim.company_id
WHERE
job_title_short='Data Analyst' and
 job_location='Anywhere' and 
salary_year_avg  is NOT NULL
order by salary_year_avg desc
limit 10
)
select
top_paying_jobs.*,
skills
 from top_paying_jobs
inner join skills_job_dim on top_paying_jobs.job_id=skills_job_dim.job_id
inner join skills_dim on skills_job_dim.skill_id=skills_dim.skill_id
ORDER BY salary_year_avg DESC;




-- actual code
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