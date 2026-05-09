with source as (

    select * from {{ source('raw', 'ukg_employment_history') }}

),

renamed as (

    select
        history_id,
        employee_id,
        event_type,
        safe.parse_date('%Y-%m-%d', left(event_date, 10))  as event_date,
        old_job_title,
        new_job_title,
        old_job_level,
        new_job_level,
        old_department,
        new_department,
        old_manager_id,
        new_manager_id,
        _loaded_at

    from source

)

select * from renamed