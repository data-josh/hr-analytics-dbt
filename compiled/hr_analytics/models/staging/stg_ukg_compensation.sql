with source as (

    select * from `hr-analytics-portfolio-495323`.`raw`.`ukg_compensation`

),

renamed as (

    select
        compensation_id,
        employee_id,
        safe.parse_date('%Y-%m-%d', left(effective_date, 10))  as effective_date,
        safe_cast(annual_salary as float64)                    as annual_salary,
        currency_code,
        change_reason,
        safe_cast(change_pct as float64)                       as change_pct,
        safe_cast(bonus_target_pct as float64)                 as bonus_target_pct,
        safe_cast(equity_grant_units as float64)               as equity_grant_units,
        _loaded_at

    from source

)

select * from renamed