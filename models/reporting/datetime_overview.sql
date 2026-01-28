select
    fired_at as date_time, --aggregate to date,hour or week in bi tool
    count(*) as total_events,
    count(*) filter (
        where event_type in ('ReferralRecommendClick', 'FaqClick')
    ) as engagement_events
from {{ ref('fact_event') }}
group by date_time
order by date_time