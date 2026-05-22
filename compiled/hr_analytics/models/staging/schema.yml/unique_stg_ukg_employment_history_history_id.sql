
    
    

with dbt_test__target as (

  select history_id as unique_field
  from `hr-analytics-portfolio-495323`.`dbt_datajosh`.`stg_ukg_employment_history`
  where history_id is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


