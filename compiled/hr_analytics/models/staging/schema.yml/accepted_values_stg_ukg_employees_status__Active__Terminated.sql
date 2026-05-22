
    
    

with all_values as (

    select
        status as value_field,
        count(*) as n_records

    from `hr-analytics-portfolio-495323`.`dbt_datajosh`.`stg_ukg_employees`
    group by status

)

select *
from all_values
where value_field not in (
    'Active','Terminated'
)


