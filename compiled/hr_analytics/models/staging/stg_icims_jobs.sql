with source as (

    select * from `hr-analytics-portfolio-495323`.`raw`.`icims_jobs`

),

renamed as (

    select
        job_id,
        job_title,
        case trim(lower(department))
            when 'analytics'                then 'Data & Analytics'
            when 'data'                     then 'Data & Analytics'
            when 'data & analytics'         then 'Data & Analytics'
            when 'data science'             then 'Data & Analytics'
            when 'engineering'              then 'Engineering'
            when 'eng'                      then 'Engineering'
            when 'engineering & product'    then 'Engineering'
            when 'bizops'                   then 'Operations'
            when 'business operations'      then 'Operations'
            when 'operations'               then 'Operations'
            when 'ops'                      then 'Operations'
            when 'cs'                       then 'Customer Success'
            when 'customer experience'      then 'Customer Success'
            when 'customer success'         then 'Customer Success'
            when 'customersuccess'          then 'Customer Success'
            when 'design'                   then 'Design'
            when 'design & ux'              then 'Design'
            when 'ux/ui'                    then 'Design'
            when 'fp&a'                     then 'Finance'
            when 'fin'                      then 'Finance'
            when 'finance'                  then 'Finance'
            when 'finance & accounting'     then 'Finance'
            when 'gtm - sales'              then 'Sales'
            when 'sales'                    then 'Sales'
            when 'sales & revenue'          then 'Sales'
            when 'revenue'                  then 'Sales'
            when 'growth & marketing'       then 'Marketing'
            when 'marketing'                then 'Marketing'
            when 'marketing & growth'       then 'Marketing'
            when 'mktg'                     then 'Marketing'
            when 'hr'                       then 'People & HR'
            when 'human resources'          then 'People & HR'
            when 'people'                   then 'People & HR'
            when 'people & culture'         then 'People & HR'
            when 'people ops'               then 'People & HR'
            when 'infosec'                  then 'Security'
            when 'information security'     then 'Security'
            when 'sec'                      then 'Security'
            when 'security'                 then 'Security'
            when 'legal'                    then 'Legal & Compliance'
            when 'legal & compliance'       then 'Legal & Compliance'
            when 'pm'                       then 'Product'
            when 'product'                  then 'Product'
            when 'product management'       then 'Product'
            when 'product mgmt'             then 'Product'
            else trim(department)
        end                                 as department,
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