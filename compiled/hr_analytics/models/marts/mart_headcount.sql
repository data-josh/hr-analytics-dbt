-- mart_headcount: monthly headcount snapshot by department, level, country



with source as (

    select
        snapshot_month,
        department,
        job_level,
        country,
        employment_type,
        headcount,
        remote_headcount,
        active_headcount,
        round(
            safe_divide(remote_headcount, headcount) * 100, 1
        ) as remote_pct,
        concat(
            cast(snapshot_month as string), '_',
            coalesce(department, 'unknown'), '_',
            coalesce(job_level, 'unknown'), '_',
            coalesce(country, 'unknown'), '_',
            coalesce(employment_type, 'unknown')
        ) as snapshot_month_dept_key

    from `hr-analytics-portfolio-495323`.`dbt_datajosh`.`int_headcount_daily`

    
        where snapshot_month > (select max(snapshot_month) from `hr-analytics-portfolio-495323`.`dbt_datajosh`.`mart_headcount`)
    

)

select * from source