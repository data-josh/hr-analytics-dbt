with applications as (

    select * from {{ ref('stg_icims_applications') }}

),

jobs as (

    select * from {{ ref('stg_icims_jobs') }}

),

final as (

    select
        a.application_id,
        a.job_id,
        j.job_title,
        j.department,
        j.job_level,
        j.country,
        j.is_remote_eligible,
        j.posted_date,
        j.closed_date,
        j.salary_min,
        j.salary_max,
        a.candidate_first_name,
        a.candidate_last_name,
        a.candidate_email,
        a.applied_date,
        a.current_stage,
        a.furthest_stage_reached,
        a.source,
        a.outcome_date,
        a.rejected_reason,
        a.is_hired,
        a.is_rejected,
        a.hired_employee_id,
        date_diff(a.outcome_date, a.applied_date, day)  as days_to_outcome,
        date_diff(a.applied_date, j.posted_date, day)   as days_from_post_to_apply

    from applications a
    left join jobs j on a.job_id = j.job_id

)

select * from final