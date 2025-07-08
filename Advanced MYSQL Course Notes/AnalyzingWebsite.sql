-- CREATING TEMPORARY TABLES

CREATE TEMPORARY TABLE first_pageview
SELECT 
	website_session_id,
    MIN(website_pageview_id) AS min_pv_id
FROM
    website_pageviews
WHERE
    website_pageview_id < 1000
GROUP BY website_session_id;

select * from website_pageviews;

SELECT 
    COUNT(DISTINCT first_pageview.website_session_id) AS session_hitting_this_lander,
    website_pageviews.pageview_url AS landing_page
FROM
    first_pageview
        LEFT JOIN
    website_pageviews ON first_pageview.min_pv_id = website_pageviews.website_pageview_id
GROUP BY 2;

-- pulling the most viewed website pages ranked by session volume
select pageview_url,COUNT(website_pageview_id) as sessions from website_pageviews
where created_at < '2012-06-09'
group by 1
order by 2 desc;

-- pull all entry pages and rank them on entry volume
CREATE TEMPORARY TABLE first_pageview
SELECT
	website_session_id,
    MIN(website_pageview_id) as landing_page
FROM website_pageviews
WHERE created_at < '2012-06-12'
group by 1
order by 2;
-- DROP TEMPORARY TABLE first_pageview
-- select * from website_pageviews;

SELECT 
    COUNT(DISTINCT (first_pageview.website_session_id)) AS sessions_hitting,
    website_pageviews.pageview_url AS landing_page
FROM
    first_pageview
        LEFT JOIN
    website_pageviews ON first_pageview.website_session_id = website_pageviews.website_pageview_id
where created_at < '2012-06-12'
GROUP BY 2
ORDER BY 1 desc; 

-- we want to see landing page performance for certain time period
-- STEP 1: find the first website_pageview_id for relevant sessions
-- 2: identify the landing page of each session
-- 3: counting pageviews for each sessions to identify bounces
-- 4: summarizing total sessions and bounced sessions
select * from website_sessions;
select * from website_pageviews;

CREATE TEMPORARY TABLE first_pageviews_demo
SELECT 
    website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM
    website_pageviews
        INNER JOIN
    website_sessions ON website_sessions.website_session_id = website_pageviews.website_session_id
        AND website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
GROUP BY 1;

-- the landing page to each session
CREATE TEMPORARY TABLE sessions_w_landing_page_demo
SELECT
	first_pageviews_demo.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_pageviews_demo
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_pageviews_demo.min_pageview_id;

-- we make a table to include count of pageviews per session
CREATE TEMPORARY TABLE bounced_sessions_only
SELECT
	sessions_w_landing_page_demo.website_session_id,
    sessions_w_landing_page_demo.landing_page,
    COUNT(website_pageviews.website_pageview_id) AS count_of_pages_viewed
FROM sessions_w_landing_page_demo
LEFT JOIN website_pageviews
	ON website_pageviews.website_session_id = sessions_w_landing_page_demo.website_session_id
GROUP BY 
	1,2
HAVING COUNT(website_pageviews.website_pageview_id) = 1;


SELECT 
	sessions_w_landing_page_demo.landing_page,
    COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_session_id
FROM sessions_w_landing_page_demo
	LEFT JOIN bounced_sessions_only
		ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
GROUP BY 1;

-- final output we  will use the same query we previously ran and we will group by landing page then we'll add a bounce rate

SELECT 
	sessions_w_landing_page_demo.landing_page,
    COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) AS sessions,
    COUNT(DISTINCT bounced_sessions_only.website_session_id) AS bounced_session_id,
	COUNT(DISTINCT bounced_sessions_only.website_session_id) / COUNT(DISTINCT sessions_w_landing_page_demo.website_session_id) as bounce_rate
FROM sessions_w_landing_page_demo
	LEFT JOIN bounced_sessions_only
		ON sessions_w_landing_page_demo.website_session_id = bounced_sessions_only.website_session_id
GROUP BY 1;
