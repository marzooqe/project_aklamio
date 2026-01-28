with base as (
    select
        customer_id,
        user_id,
        max(case when event_type = 'ReferralPageLoad' then 1 else 0 end) as viewed,
        max(case when event_type in ('ReferralRecommendClick', 'FaqClick') then 1 else 0 end) as engaged
    from {{ ref('fact_event') }}
    group by customer_id, user_id
)

select
    customer_id,
    count(distinct user_id) filter (where viewed = 1) as referral_users,
    count(distinct user_id) filter (where engaged = 1) as engaged_users,
    count(distinct user_id) filter (where engaged = 1)::float
        / nullif(count(distinct user_id) filter (where viewed = 1), 0) as engagement_rate
from base
group by customer_id
order by engagement_rate desc