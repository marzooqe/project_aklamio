--1 — Engagement Rate && 2 — Conversion Rate
with event_level as 
(
    select
        event_id,
        max(case when event_type = 'ReferralPageLoad' then 1 else 0 end) as has_page_load,
        max(case when event_type in ('FaqClick', 'ReferralRecommendClick') then 1 else 0 end) as has_engagement,
        max(case when event_type = 'ReferralRecommendClick' then 1 else 0 end) as has_recommend_click
    from analytics.fact_event
    group by event_id
)
select
    count(*) filter (where has_page_load = 1 and has_engagement = 1)::float*100
        / nullif(count(*) filter (where has_page_load = 1), 0)
        as engagement_rate,
    count(*) filter (where has_page_load = 1 and has_recommend_click = 1)::float*100
        / nullif(count(*) filter (where has_page_load = 1), 0)
        as conversion_rate
from event_level;

--3 — Customer Engagement Score
with event_level as (
    select
        event_id,
        customer_id,
        max(case when event_type = 'ReferralPageLoad' then 1 else 0 end) as has_page_load,
        max(case when event_type in ('FaqClick', 'ReferralRecommendClick') then 1 else 0 end) as has_engagement,
        max(case when event_type = 'ReferralRecommendClick' then 1 else 0 end) as has_conversion
    from analytics.fact_event
    group by event_id, customer_id
),
customer_metrics as (
    select
        customer_id,
        count(*) filter (where has_page_load = 1) as referral_events,
        count(*) filter (
            where has_page_load = 1 and has_engagement = 1
        )::float*100
        / nullif(count(*) filter (where has_page_load = 1), 0) as engagement_rate,
        count(*) filter (
            where has_page_load = 1 and has_conversion = 1
        )::float*100
        / nullif(count(*) filter (where has_page_load = 1), 0) as conversion_rate
    from event_level
    group by customer_id
),
scored as (
    select
        customer_id,
        referral_events,
        engagement_rate,
        conversion_rate,
        referral_events::float
            / max(referral_events) over () as volume_score
    from customer_metrics
)
select
    customer_id,
    referral_events,
    engagement_rate,
    conversion_rate,
    (0.4 * volume_score) +(0.3 * engagement_rate) +(0.3 * conversion_rate)as customer_engagement_score
from scored
order by customer_engagement_score desc;

--4 — Bounce Rate
with event_level as (
    select
        event_id,
        max(case when event_type = 'ReferralPageLoad' then 1 else 0 end) as has_page_load,
        max(case when event_type in ('FaqClick', 'ReferralRecommendClick') then 1 else 0 end) as has_follow_up
    from analytics.fact_event
    group by event_id
)
select
    count(*) filter (
        where has_page_load = 1
          and has_follow_up = 0
    )::float*100
    / nullif(
        count(*) filter (where has_page_load = 1),
        0
    ) as bounce_rate
from event_level;

--5 — Sessions per User
with sessions_per_user as (
    select
        user_id,
        count(distinct event_id) as session_count
    from analytics.fact_event
    group by user_id
)
select
    avg(session_count)::INT as avg_sessions_per_user
from sessions_per_user;

--6 — User Per Day
with daily_active_users as (
    select
        date_trunc('day', fired_at) as activity_date,
        count(distinct user_id) as daily_active_users
    from analytics.fact_event
    group by activity_date
)
select
    avg(daily_active_users)::float as avg_users_active_per_day
from daily_active_users;

--Day of week
select	
	EXTRACT(DOW FROM fired_at) as dow,
    count(distinct user_id) as daily_active_users
from analytics.fact_event
group by 1;