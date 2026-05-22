with source as (

    select * from `hr-analytics-portfolio-495323`.`raw`.`icims_applications`

),

renamed as (

    select
        application_id,
        job_id,
        trim(candidate_first_name)                              as candidate_first_name,
        trim(candidate_last_name)                               as candidate_last_name,
        lower(trim(candidate_email))                            as candidate_email,
        safe.parse_date('%Y-%m-%d', left(applied_date, 10))    as applied_date,
        current_stage,
        furthest_stage_reached,
        source,
        safe.parse_date('%Y-%m-%d', left(outcome_date, 10))    as outcome_date,
        rejected_reason,
        hired_employee_id,
        case
            when current_stage = 'Hired' then true
            else false
        end                                                     as is_hired,
        case
            when current_stage like 'Rejected%' then true
            else false
        end                                                     as is_rejected,
        _loaded_at

    from source

)

select * from renamed