
    
    

with dbt_test__target as (

  select snapshot_month_dept_key as unique_field
  from `hr-analytics-portfolio-495323`.`dbt_datajosh`.`mart_headcount`
  where snapshot_month_dept_key is not null

)

select
    unique_field,
    count(*) as n_records

from dbt_test__target
group by unique_field
having count(*) > 1


