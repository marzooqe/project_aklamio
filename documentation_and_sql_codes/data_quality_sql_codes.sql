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