with source as (

    select * from {{ source('raw', 'icims_jobs') }}

),

renamed as (

    select
        job_id,
        job_title,
        department,
        job_level,
        country_code,
        country,
        cast(remote_eligible as string)                        as remote_eligible_raw,
        case
            when cast(remote_eligible as string)
                in ('True', 'Yes', 'true', 'yes', '1') then true
            else false
        end                                                    as is_remote_eligible,
        hiring_manager_id,
        lower(trim(recruiter_email))                           as recruiter_email,
        safe.parse_date('%Y-%m-%d', left(posted_date, 10))    as posted_date,
        safe.parse_date('%Y-%m-%d', left(closed_date, 10))    as closed_date,
        status,
        salary_min,
        salary_max,
        salary_currency,
        _loaded_at

    from source

)

select * from renamed