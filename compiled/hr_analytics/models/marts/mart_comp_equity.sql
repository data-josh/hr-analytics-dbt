with comp as (

    select * from `hr-analytics-portfolio-495323`.`dbt_datajosh`.`int_compensation_normalized`

),

medians as (

    select
        job_level,
        percentile_cont(annual_salary_usd, 0.5) over (
            partition by job_level
        ) as median_salary_usd

    from comp
    where annual_salary_usd is not null

),

bands as (

    select
        c.job_level,
        round(avg(annual_salary_usd), 0)        as avg_salary_usd,
        round(min(annual_salary_usd), 0)        as min_salary_usd,
        round(max(annual_salary_usd), 0)        as max_salary_usd,
        round(max(m.median_salary_usd), 0)      as median_salary_usd

    from comp c
    left join medians m on c.job_level = m.job_level
    where c.annual_salary_usd is not null
    group by job_level

),

final as (

    select
        c.employee_id,
        c.department,
        c.job_level,
        c.country,
        c.annual_salary,
        c.currency_code,
        c.annual_salary_usd,
        c.effective_date,
        b.avg_salary_usd,
        b.median_salary_usd,
        b.min_salary_usd,
        b.max_salary_usd,
        round(
            safe_divide(c.annual_salary_usd, b.median_salary_usd), 2
        )                                       as compa_ratio

    from comp c
    left join bands b on c.job_level = b.job_level

)

select * from final