with source as (

    select * from `hr-analytics-portfolio-495323`.`raw`.`ukg_employees`

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

        -- department: normalize 47 dirty values to 12 standard names
        case trim(lower(department))
            when 'analytics'                then 'Data & Analytics'
            when 'data'                     then 'Data & Analytics'
            when 'data & analytics'         then 'Data & Analytics'
            when 'data science'             then 'Data & Analytics'
            when 'engineering'              then 'Engineering'
            when 'eng'                      then 'Engineering'
            when 'engineering & product'    then 'Engineering'
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

        -- job info
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