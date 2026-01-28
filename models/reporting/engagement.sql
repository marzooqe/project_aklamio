with referral_users as (
    select distinct user_id
    from {{ ref('fact_event') }}
    where event_type = 'ReferralPageLoad'
),

engaged_users as (
    select distinct user_id
    from {{ ref('fact_event') }}
    where event_type in ('ReferralRecommendClick', 'FaqClick')
)

select
    count(distinct e.user_id)::float
    / nullif(count(distinct r.user_id), 0) as referral_engagement_rate
from referral_users r
left join engaged_users e
    on r.user_id = e.user_id
