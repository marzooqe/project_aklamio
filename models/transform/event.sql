{{ config(
    materialized='table',
    full_refresh=true,
) }}
	  
SELECT 
    payload->>'ip' as ip,
    payload->>'email' as email,
    payload->>'user_id' as user_id,
    payload->>'event_id' as event_id,
    to_timestamp(payload->>'fired_at', 'MM/DD/YYYY, HH24:MI:SS') at time zone 'CET' as fired_at,
    payload->>'event_type' as event_type,
    payload->>'customer_id' as customer_id
FROM {{ source('public','aklamio_challenge') }} 