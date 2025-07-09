-- pull bounce rates for traffic landing on the homepage(sessions,bounced_sessions and % of sessions which bounced)
select * from website_pageviews;
select * from website_sessions;

CREATE TEMPORARY TABLE first_pageview
select 
website_session_id,
	MIN(website_pageview_id) as min_pageview
FROM website_pageviews
WHERE created_at < '2012-06-14'
GROUP BY 1;

CREATE TEMPORARY TABLE sessions_w_home_landing_page
SELECT
	website_pageviews.pageview_url as landing_page,
	first_pageview.website_session_id
    from first_pageview
    LEFT JOIN website_pageviews
    ON website_pageviews.website_pageview_id  = first_pageview.min_pageview
    where website_pageviews.pageview_url = '/home';

CREATE TEMPORARY TABLE bounced_sessions
SELECT 
	sessions_w_home_landing_page.website_session_id,
    sessions_w_home_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_home_landing_page
LEFT JOIN website_pageviews
ON website_pageviews.website_session_id = sessions_w_home_landing_page.website_session_id
GROUP BY 1,2
HAVING COUNT(website_pageviews.website_pageview_id) = 1;

SELECT
	COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) as sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT bounced_sessions.website_session_id) / COUNT(DISTINCT sessions_w_home_landing_page.website_session_id) as bounced_rate
FROM sessions_w_home_landing_page
	LEFT JOIN bounced_sessions
		ON sessions_w_home_landing_page.website_session_id = bounced_sessions.website_session_id;
        
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- we ran a new custom landing page(/lander-1) in a 50/50 test against the homepage for our gsearch nonbrand traffic
-- can you pull bounce rates for the two groups so we can evaluate the new page

SELECT
	MIN(created_at) AS first_created_at,
    MIN(website_pageview_id) AS first_pageview_id -- 23504
FROM website_pageviews
WHERE pageview_url = '/lander-1'
	AND created_at IS NOT NULL;

CREATE TEMPORARY TABLE first_test_pageviews
SELECT
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
        AND website_sessions.created_at < '2012-07-28' -- prescribed by the assignment
        AND website_pageviews.website_pageview_id > 23504 -- the min_pageview we found 
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY
	website_pageviews.website_session_id;

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_page
SELECT
	first_test_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_test_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_test_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url IN ('/home','/lander-1');

CREATE TEMPORARY TABLE nonbrand_test_bounced_sessions
SELECT
	nonbrand_test_sessions_w_landing_page.website_session_id,
    nonbrand_test_sessions_w_landing_page.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM nonbrand_test_sessions_w_landing_page
LEFT JOIN website_pageviews
	ON website_pageviews.website_session_id = nonbrand_test_sessions_w_landing_page.website_session_id
GROUP BY
	1,2
HAVING
	COUNT(website_pageviews.website_pageview_id) = 1;

SELECT
	nonbrand_test_sessions_w_landing_page.landing_page,
    COUNT(DISTINCT nonbrand_test_sessions_w_landing_page.website_session_id) AS sessions,
    COUNT(DISTINCT nonbrand_test_bounced_sessions.website_session_id) AS bounced_sessions,
    COUNT(DISTINCT nonbrand_test_bounced_sessions.website_session_id) / COUNT(DISTINCT nonbrand_test_sessions_w_landing_page.website_session_id) AS bounce_rate
FROM nonbrand_test_sessions_w_landing_page
	LEFT JOIN nonbrand_test_bounced_sessions
		ON nonbrand_test_sessions_w_landing_page.website_session_id = nonbrand_test_bounced_sessions.website_session_id
GROUP BY
	1;
-- ---------------------------------------------------------------------------------------------------------------------------------------------------------
-- could you pull the volume of paid search nonbrand traffic landing on /home and /lander-1 trended weekly since june 1st
-- could you also pull our overall paid seach bounce rate trended weekly

CREATE TEMPORARY TABLE session_w_min_pv_id_and_view_count
SELECT
	website_sessions.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS first_pageview_id,
    COUNT(website_pageviews.website_pageview_id) AS count_pageviews
    
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
	website_sessions.created_at > '2012-06-01' 
    AND website_sessions.created_at < '2012-08-31'
    AND website_sessions.utm_source = 'gsearch'
    AND website_sessions.utm_campaign = 'nonbrand'
GROUP BY
	website_sessions.website_session_id;

CREATE TEMPORARY TABLE session_w_counts_lander_and_created_at
SELECT
	session_w_min_pv_id_and_view_count.website_session_id,
    session_w_min_pv_id_and_view_count.first_pageview_id,
    session_w_min_pv_id_and_view_count.count_pageviews,
    website_pageviews.pageview_url AS landing_page,
    website_pageviews.created_at AS session_created_at
    FROM
	session_w_min_pv_id_and_view_count
    LEFT JOIN website_pageviews
		ON session_w_min_pv_id_and_view_count.first_pageview_id = website_pageviews.website_pageview_id;

SELECT
	-- YEARWEEK(session_created_at) AS year_week,
    MIN(DATE(session_created_at)) AS week_start_date,
    -- COUNT(DISTINCT website_session_id) AS total_sessions,
    -- COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id  ELSE NULL END) AS bounced_sessions,
    COUNT(DISTINCT CASE WHEN count_pageviews = 1 THEN website_session_id ELSE NULL END) * 1.0/COUNT(DISTINCT website_session_id) as bounce_rate,
    COUNT(DISTINCT CASE WHEN landing_page = '/home' THEN website_session_id ELSE NULL END) AS home_sessions,
    COUNT(DISTINCT CASE WHEN landing_page = '/lander-1' THEN website_session_id ELSE NULL END) AS lander_sessions

FROM session_w_counts_lander_and_created_at
GROUP BY 
	YEARWEEK(session_created_at);








