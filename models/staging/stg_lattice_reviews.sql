with source as (

    select * from {{ source('raw', 'lattice_reviews') }}

),

renamed as (

    select
        review_id,
        employee_id,
        manager_id,
        review_cycle,
        overall_rating,
        safe_cast(overall_score as float64)                     as overall_score,
        safe.parse_date('%Y-%m-%d', left(submitted_date, 10))  as submitted_date,
        _loaded_at

    from source

)

select * from renamed