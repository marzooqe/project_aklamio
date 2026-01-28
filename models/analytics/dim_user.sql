--to be converted to scd table based on business cases

{{ config(
    materialized='table',
    full_refresh=true,
) }}

SELECT distinct
    ip,
    email,
    user_id
FROM {{ ref('event') }}