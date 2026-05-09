with source as (

    select * from {{ source('raw', 'ukg_time_off') }}

),

renamed as (

    select
        request_id,
        employee_id,
        leave_type,
        safe.parse_date('%Y-%m-%d', left(start_date, 10))  as start_date,
        safe.parse_date('%Y-%m-%d', left(end_date, 10))    as end_date,
        days_requested,
        status,
        _loaded_at

    from source

)

select * from renamed