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
