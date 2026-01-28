{{ config(
    materialized='table',
    full_refresh=true,
) }}

SELECT 
    event_id,
    fired_at,
    event_type,
    user_id,
    customer_id
FROM {{ ref('event') }}