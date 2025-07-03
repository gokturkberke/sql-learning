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

SELECT first_pageview.website_session_id,
		website_pageviews.pageview_url as landing_page
    FROM first_pageview
	LEFT JOIN website_pageviews
		ON first_pageview.min_pv_id = website_pageviews.website_pagevie_id