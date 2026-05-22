with comp as (

    select * from `hr-analytics-portfolio-495323`.`dbt_datajosh`.`stg_ukg_compensation`

),

employees as (

    select
        employee_id,
        department,
        job_level,
        country,
        currency_code

    from `hr-analytics-portfolio-495323`.`dbt_datajosh`.`stg_ukg_employees`

),

-- FX rates to normalize everything to USD
fx as (

    select 'USD' as currency_code, 1.00 as usd_rate union all
    select 'GBP', 1.27 union all
    select 'EUR', 1.09 union all
    select 'CAD', 0.74 union all
    select 'AUD', 0.65 union all
    select 'INR', 0.012 union all
    select 'BRL', 0.20 union all
    select 'PLN', 0.25 union all
    select 'UAH', 0.024

),

final as (

    select
        c.compensation_id,
        c.employee_id,
        e.department,
        e.job_level,
        e.country,
        c.annual_salary,
        c.currency_code,
        f.usd_rate,
        round(c.annual_salary * f.usd_rate, 2)      as annual_salary_usd,
        c.change_reason,
        c.change_pct,
        c.bonus_target_pct,
        c.equity_grant_units,
        c.effective_date

    from comp c
    left join employees e on c.employee_id = e.employee_id
    left join fx f on c.currency_code = f.currency_code

)

select * from final