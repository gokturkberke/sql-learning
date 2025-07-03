use mavenfuzzyfactory;
select * from website_sessions where website_session_id = 1059;
select * from website_pageviews where website_session_id = 1059;

SELECT 
    website_sessions.utm_content, COUNT(DISTINCT website_sessions.website_session_id) AS sessions, COUNT(DISTINCT orders.order_id) as orders
FROM
    website_sessions
    LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.website_session_id BETWEEN 1000 AND 2000
GROUP BY website_sessions.utm_content -- 1 de yazabiliriz bunun yerine
ORDER BY COUNT(DISTINCT website_sessions.website_session_id) DESC;

-- where the bulk of our website sessions are coming from through yesterday ( utm source campaign and reffering domain)
select * from website_sessions;
select * from website_pageviews;
select * from orders;

select utm_source,utm_campaign,http_referer,COUNT(website_session_id) as sessions 
from website_sessions
where created_at < '2012-04-12'
group by utm_source,utm_campaign,http_referer;

-- calculate the conversion rate from session to order
SELECT 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) as orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) as session_to_order_conv_rt
FROM
    website_sessions
	LEFT JOIN orders
    ON orders.website_session_id = website_sessions.website_session_id
WHERE
    website_sessions.created_at < '2012-04-12'
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand';

-- month(dateordatetime) extract the month same for year quearter week date now keywords
select 
	COUNT(DISTINCT website_session_id) as sessions,
    WEEK(created_at),
    YEAR(created_at),
    MIN(DATE(created_at)) AS week_start
from website_sessions
where website_session_id between 100000 and 115000 -- arbitrary
group by 2,3;

-- pivoting data
SELECT 
    primary_product_id,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 1 THEN order_id
            ELSE NULL
        END) AS count_single_item_orders,
    COUNT(DISTINCT CASE
            WHEN items_purchased = 2 THEN order_id
            ELSE NULL
        END) AS count_two_item_orders
FROM
    orders
WHERE
    order_id BETWEEN 31000 AND 32000
GROUP BY 1;

-- we bid down gsearch nonbrand on 2012-04-15 ; Can you pull gsearch nonbrand trended sesion volume by week
select
	COUNT(DISTINCT website_session_id) as sessions,
	MIN(DATE(created_at)) as weekstart_date
from website_sessions
where created_at  <  '2012-05-12'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
group by 
YEAR(created_at),
WEEK(created_at);

-- Conversion rates from session to order by device type
select * from website_sessions;
select * from website_pageviews;
select * from orders;

SELECT 
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    website_sessions.device_type,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS session_to_order_conv_rate
FROM
    website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
where website_sessions.created_at < '2012-05-11'
	AND utm_source =  'gsearch'
    AND utm_campaign = 'nonbrand'
group by 3;

-- Could you pull weekly trends for both destop and mobile use 2012-04-15 for baseline
select
	MIN(DATE(created_at)) as week_start,
    COUNT(DISTINCT CASE WHEN device_type = 'desktop' THEN website_session_id ELSE NULL END) AS desktop_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_session_id ELSE NULL END) AS mobile_sessions,
	COUNT(website_session_id) as total_sessions
from website_sessions
WHERE WEEK(DATE(created_at)) < '2012-05-11'
	AND utm_source = 'gsearch'
    AND utm_campaign = 'nonbrand'
group by 
WEEK(created_at),YEAR(created_at)
order by 1
