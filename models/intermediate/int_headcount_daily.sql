with employees as (

    select * from {{ ref('stg_ukg_employees') }}

),

spine as (

    select date
    from unnest(
        generate_date_array('2022-01-01', current_date(), interval 1 month)
    ) as date

),

final as (

    select
        s.date                              as snapshot_month,
        e.department,
        e.job_level,
        e.country,
        e.employment_type,
        count(e.employee_id)                as headcount,
        countif(e.is_remote = true)         as remote_headcount,
        countif(e.status = 'Active')        as active_headcount

    from spine s
    left join employees e
        on e.hire_date <= s.date
        and (e.termination_date is null or e.termination_date > s.date)
    group by 1, 2, 3, 4, 5

)

select * from final