-- select * from website_pageviews;
-- select * from website_sessions
select * from orders;
-- www.abcwebsite.com?utm_source=trafficSource&utm_campaign=campaignName
SELECT
	utm_content,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS session_order_conv_rt
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 1
ORDER BY sessions desc;

-- we launced a second paid search channel bsearch, can you pull weekly trended session volume compare to gsearch nonbrand
SELECT
    MIN(website_sessions.created_at) AS datee,
    COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id END) AS gsearch_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id END) AS bsearch_sessions
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-08-22' AND '2012-11-29'
AND
utm_campaign = 'nonbrand'
GROUP BY YEAR(website_sessions.created_at),
		WEEK(website_sessions.created_at)
ORDER BY 1;

-- pull the percentage of traffic coming on mobile and compare that to gsearch aggregate data since August 22nd(bsearch nonbrand)
SELECT
	utm_source,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END) AS mobile_sessions,
    COUNT(DISTINCT CASE WHEN device_type = 'mobile' THEN website_sessions.website_session_id ELSE NULL END)/ COUNT(DISTINCT website_sessions.website_session_id) AS pct_mobile
FROM website_sessions
WHERE website_sessions.created_at > '2012-08-22'
AND website_sessions.created_at < '2012-10-30'
AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY 
1;

-- could you pull nonbrand conversion rates from sessions to order for gsearch and bsearch and slice the data by device type(between august 22 and september 18)
SELECT
	website_sessions.device_type,
    website_sessions.utm_source,
    COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id)  AS conv_rate
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.utm_campaign = 'nonbrand'
AND website_sessions.created_at BETWEEN '2012-08-22' 
AND '2012-09-18'
GROUP BY 1,2;

-- can you pull weekly session volume for gsearch and bsearch nonbrand,broken down by device since november 4th
SELECT
	MIN(DATE(created_at)) AS week_start_date, -- date kelimesi saat saniye dakika bilgilerini atar
	COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id END) AS g_dtop_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id END) AS b_dtop_sessions,
	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'desktop' THEN website_session_id END) / COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'desktop' THEN website_session_id END) AS b_pct_of_g_dtop,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id END) AS g_mob_sessions,
	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id END) AS b_mob_sessions,
    COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' AND device_type = 'mobile' THEN website_session_id END) / COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' AND device_type = 'mobile' THEN website_session_id END) AS b_pct_of_g_mob
FROM website_sessions
WHERE created_at BETWEEN '2012-11-4' AND '2012-12-22'
GROUP BY YEARWEEK(created_at); -- haftalara gore gruplandirma;

-- keeping a pulse on how well your brand is doing with consumers and how well your brand drives business
SELECT 
	CASE WHEN http_referer IS NULL THEN 'direct_type_in'
		WHEN http_referer = 'https://www.gsearch.com' AND utm_source IS NULL THEN 'gsearch_organic'
		WHEN http_referer = 'https://www.bsearch.com' AND utm_source IS NULL THEN 'bsearch_organic'
        ELSE 'other'
	END,
    COUNT(DISTINCT website_session_id) AS sessions
FROM website_sessions
WHERE website_session_id BETWEEN 100000 AND 115000
-- AND utm_source IS NULL
group by 1
ORDER BY 2;

-- pull organic search direct type in and paid brand search sessions by month and show those sessions as a % of paid search nonbrand
SELECT
	YEAR(created_at) AS yr,
    MONTH(created_at) AS mo,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id END) AS nonbrand,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id END) AS brand,
    COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_session_id END) / COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id END) AS brand_pct_of_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IS NULL THEN website_session_id END) AS direct,
    COUNT(DISTINCT CASE WHEN utm_campaign IS NULL AND http_referer IS NULL THEN website_session_id END) /  COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id END) AS direct_pcf_of_nonbrand,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN website_session_id END) as organic,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IN ('https://www.gsearch.com','https://www.bsearch.com') THEN website_session_id END) / COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_session_id END)
FROM website_sessions
WHERE
created_at < '2012-12-23'
GROUP BY 1,2;
-- ----------------------------------------------------------------------------------------------------------------
SELECT 
    website_session_id,
    created_at,
    HOUR(created_at) AS hr,
    WEEKDAY(created_at) AS wkday,
    CASE
        WHEN WEEKDAY(created_at) = 0 THEN 'Monday'
        ELSE 'other_day'
    END AS clean_weekday,
    QUARTER(created_at) AS qtr,
    MONTH(created_at) AS mo,
    DATE(created_at) AS date,
    WEEK(created_at) AS wk
FROM
    website_sessions
WHERE
    website_session_id BETWEEN 150000 AND 155000;

-- take a look at 2012's monthly and weekly volume patterns to see if we can find any seasonal trends we should plan for in 2013
SELECT
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
    YEAR(website_sessions.created_at),
    MONTH(website_sessions.created_at)
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-01-02' AND '2013-01-01'
GROUP BY 3,4;

SELECT
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id) AS orders,
	MIN(DATE (website_sessions.created_at)) AS week_start_date
FROM website_sessions
LEFT JOIN orders
ON website_sessions.website_session_id = orders.website_session_id
WHERE website_sessions.created_at BETWEEN '2012-01-02' AND '2013-01-01'
GROUP BY YEAR(website_sessions.created_at),
		WEEK(website_sessions.created_at);
        
-- Could you analyze the average website session volume by hour of day and by day week(date range sep 15- nov15)
SELECT 
	hr,
	-- ROUND(AVG(website_sessions),1) AS avg_sessions,
    ROUND(AVG(CASE WHEN wkday = 0 THEN website_sessions ELSE NULL END),1) as monday,
    ROUND(AVG(CASE WHEN wkday = 1 THEN website_sessions ELSE NULL END),1) as tuesday,
    ROUND(AVG(CASE WHEN wkday = 2 THEN website_sessions ELSE NULL END),1) as wednesday,
    ROUND(AVG(CASE WHEN wkday = 3 THEN website_sessions ELSE NULL END),1) as thursday,
    ROUND(AVG(CASE WHEN wkday = 4 THEN website_sessions ELSE NULL END),1) as friday,
    ROUND(AVG(CASE WHEN wkday = 5 THEN website_sessions ELSE NULL END),1) as saturday,
    ROUND(AVG(CASE WHEN wkday = 6 THEN website_sessions ELSE NULL END),1) as sunday
FROM(
SELECT
	DATE(created_at) AS created_date,
    WEEKDAY(created_at) AS wkday,
    HOUR(created_at) AS hr,
    COUNT(DISTINCT website_session_id) AS website_sessions
FROM website_sessions
WHERE created_at BETWEEN '2012-09-15' AND '2012-11-15'
GROUP BY 1,2,3
) AS dairly_hourly_sessions
GROUP BY 1
ORDER BY 1
