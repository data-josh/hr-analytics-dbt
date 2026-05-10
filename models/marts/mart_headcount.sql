select
    snapshot_month,
    department,
    job_level,
    country,
    employment_type,
    headcount,
    remote_headcount,
    active_headcount,
    round(
        safe_divide(remote_headcount, headcount) * 100, 1
    ) as remote_pct

from {{ ref('int_headcount_daily') }}