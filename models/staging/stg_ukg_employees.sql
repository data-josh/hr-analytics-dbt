with source as (

    select * from {{ source('raw', 'ukg_employees') }}

),

renamed as (

    select
        -- ids
        employee_id,
        manager_id,

        -- name cleaning: strip whitespace, standardize to upper
        trim(upper(full_name))          as full_name_clean,
        trim(first_name)                as first_name,
        trim(last_name)                 as last_name,

        -- contact
        lower(trim(work_email))         as work_email,

        -- location
        country_code,
        country,
        city,

        -- job info
        department,
        job_title,
        job_level,
        employment_type,

        -- dates
        safe.parse_date('%Y-%m-%d', left(hire_date, 10))        as hire_date,
        safe.parse_date('%Y-%m-%d', left(termination_date, 10)) as termination_date,
        termination_reason,
        status,

        -- compensation
        currency_code,

       -- remote flag: normalize all variants to true/false
        case
            when cast(is_remote as string) in ('Y', 'YES', 'TRUE', 'true', '1') then true
            else false
        end                             as is_remote,

        -- metadata
        _loaded_at

    from source

)

select * from renamed