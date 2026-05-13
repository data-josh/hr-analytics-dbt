-- mart_attrition: final attrition table joining employee history, tenure, and enriched compensation data

select
    a.employee_id,
    a.full_name_clean,
    a.department,
    a.job_level,
    a.country,
    a.hire_date,
    a.termination_date,
    a.termination_reason,
    a.tenure_years,
    a.is_terminated,
    a.attrition_type,
    e.annual_salary,
    e.comp_currency,
    e.avg_performance_score,
    {{ fiscal_quarter('a.termination_date') }}  as termination_quarter,
    round(a.tenure_years, 1)                as tenure_years_rounded,
    case
        when a.tenure_years < 1 then 'Under 1 year'
        when a.tenure_years < 2 then '1-2 years'
        when a.tenure_years < 3 then '2-3 years'
        when a.tenure_years < 5 then '3-5 years'
        else '5+ years'
    end                                     as tenure_band

from {{ ref('int_employee_attrition') }} a
left join {{ ref('int_employees_enriched') }} e
    on a.employee_id = e.employee_id