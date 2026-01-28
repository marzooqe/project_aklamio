select
    customer_id,
    count(*) filter (where event_type = 'ReferralPageLoad') as page_loads,
    count(*) filter (where event_type = 'ReferralRecommendClick') as recommend_clicks,
    count(*) filter (where event_type = 'ReferralRecommendClick')::float
        / nullif(count(*) filter (where event_type = 'ReferralPageLoad'), 0) as conversion_rate
from {{ ref('fact_event') }}
group by customer_id
having count(*) filter (where event_type = 'ReferralPageLoad') >= 10
order by conversion_rate desc