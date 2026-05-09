with employees as (

    select * from {{ ref('stg_ukg_employees') }}

),

compensation as (

    select
        employee_id,
        annual_salary,
        currency_code,
        effective_date,
        row_number() over (
            partition by employee_id
            order by effective_date desc
        ) as comp_rank

    from {{ ref('stg_ukg_compensation') }}

),

latest_comp as (

    select * from compensation where comp_rank = 1

),

reviews as (

    select
        employee_id,
        avg(overall_score)                  as avg_performance_score,
        count(*)                            as total_reviews

    from {{ ref('stg_lattice_reviews') }}
    group by employee_id

),

final as (

    select
        e.*,
        lc.annual_salary,
        lc.currency_code                    as comp_currency,
        lc.effective_date                   as last_comp_date,
        r.avg_performance_score,
        r.total_reviews

    from employees e
    left join latest_comp lc on e.employee_id = lc.employee_id
    left join reviews r on e.employee_id = r.employee_id

)

select * from final