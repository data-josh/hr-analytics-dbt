-- mart_recruiting: recruiting funnel metrics by job, department, and source

select
    job_id,
    job_title,
    department,
    job_level,
    country,
    is_remote_eligible,
    posted_date,
    closed_date,
    salary_min,
    salary_max,
    count(application_id)                           as total_applications,
    countif(furthest_stage_reached = 'Hired')       as total_hires,
    countif(is_rejected = true)                     as total_rejections,
    countif(current_stage = 'Withdrew')             as total_withdrawals,
    round(
        safe_divide(
            countif(furthest_stage_reached = 'Hired'),
            count(application_id)
        ) * 100, 1
    )                                               as hire_rate_pct,
    round(avg(days_to_outcome), 1)                  as avg_days_to_outcome,
    round(avg(days_from_post_to_apply), 1)          as avg_days_to_first_apply
from {{ ref('int_recruiting_pipeline') }}
group by 1, 2, 3, 4, 5, 6, 7, 8, 9, 10