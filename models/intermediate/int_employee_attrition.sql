with employees as (

    select * from {{ ref('stg_ukg_employees') }}

),

history as (

    select * from {{ ref('stg_ukg_employment_history') }}

),

terminations as (

    select
        employee_id,
        event_date                          as termination_date,
        event_type

    from history
    where event_type = 'Termination'

),

final as (

    select
        e.employee_id,
        e.full_name_clean,
        e.department,
        e.job_level,
        e.country,
        e.hire_date,
        t.termination_date,
        e.termination_reason,
        date_diff(
            coalesce(t.termination_date, current_date()),
            e.hire_date,
            day
        ) / 365.25                          as tenure_years,
        case
            when e.status = 'Terminated' then true
            else false
        end                                 as is_terminated,
        case
            when e.termination_reason like 'Voluntary%' then 'Voluntary'
            when e.termination_reason like 'Involuntary%' then 'Involuntary'
            else 'Unknown'
        end                                 as attrition_type

    from employees e
    left join terminations t on e.employee_id = t.employee_id
    where e.status = 'Terminated'
)

select * from final