{% macro fiscal_quarter(date_column) %}
    case
        when extract(month from {{ date_column }}) in (1, 2, 3)   then 'Q1'
        when extract(month from {{ date_column }}) in (4, 5, 6)   then 'Q2'
        when extract(month from {{ date_column }}) in (7, 8, 9)   then 'Q3'
        when extract(month from {{ date_column }}) in (10, 11, 12) then 'Q4'
    end
{% endmacro %}