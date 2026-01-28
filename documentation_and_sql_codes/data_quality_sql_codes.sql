--Overall counts, unique and nulls summary check
select  
	count(event_id) as count,
	count(distinct event_id) as unique,
	sum(case when event_id is null then 1 else 0 end) as nulls
from "transform"."event"
union 
select  
	count(user_id ),
	count(distinct user_id),
	sum(case when user_id is null then 1 else 0 end) as nulls
from "transform"."event"
union 
select  
	count(fired_at),
	count(distinct fired_at),
	sum(case when fired_at is null then 1 else 0 end) as nulls
from "transform"."event"
union 
select  
	count(event_type),
	count(distinct event_type),
	sum(case when event_type is null or event_type = 'EMPTY_VALUE' then 1 else 0 end) as nulls
from "transform"."event"
union 
select  
	count(email),
	count(distinct email ),
	sum(case when email is null then 1 else 0 end) as nulls
from "transform"."event"
union 
select  
	count(event_id||event_type ),
	count(distinct event_id || event_type),
	sum(case when event_id || event_type is null then 1 else 0 end) as nulls
from "transform"."event";

--date range check
select  
	min(fired_at),
	max(fired_at)
from "transform"."event";

--same event duplicit customer check
select
  event_id,
  count(distinct customer_id) as customer_count
from "transform"."event" e
group by event_id
having count(distinct customer_id) > 1;

--same event duplicit user check
select
  event_id,
  count(distinct user_id) as user_count
from "transform"."event" e
group by event_id
having count(distinct user_id) > 1;

--existing event_type_count case verification
select
  event_id,
  count(distinct event_type) as event_type_count
from "transform"."event" e
group by event_id
having count(distinct event_type) > 1;

--same email duplicate user_ids check
select
  email,
  count(distinct user_id) as same_email_user_ids
from "transform"."event" e
group by email
having count(distinct user_id) > 1;

--time gap between events check
select
  event_id,
  max(fired_at) - min(fired_at) as time_gap
from "transform"."event" e
group by event_id
having max(fired_at) - min(fired_at) > interval '1 hour';

--event per user skew check 
select
  user_id,
  count(*) as event_count
from "transform"."event" e
group by user_id
order by event_count desc
limit 10;

--sequence of events check
select event_id
from "transform"."event" e
group by event_id
having
  min(case when event_type = 'ReferralPageLoad' then fired_at end)
  >
  min(case when event_type = 'ReferralRecommendClick' then fired_at end);