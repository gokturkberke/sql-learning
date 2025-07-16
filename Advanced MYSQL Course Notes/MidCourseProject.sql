select * from orders;
select * from website_sessions;
select * from website_pageviews;
-- select * from website_pageviews

SELECT 
COUNT(DISTINCT orders.order_id) AS total_orders,
COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions,
DATE_FORMAT(website_sessions.created_at,'%Y-%m') AS year_monthh,
COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate
 FROM 
website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE
	website_sessions.created_at < '2012-11-27'
    AND utm_source = 'gsearch'
GROUP BY 3
order by 3;

-- question 2
SELECT 
COUNT(DISTINCT orders.order_id) AS total_orders,
COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions,
DATE_FORMAT(website_sessions.created_at,'%Y-%m') AS year_monthh,
COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN website_sessions.website_session_id ELSE NULL END) AS nonbrand_sessions,
COUNT(DISTINCT CASE WHEN utm_campaign = 'nonbrand' THEN orders.order_id ELSE NULL END) AS nonbrand_orders,
COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN website_sessions.website_session_id ELSE NULL END) AS brand_sessions,
COUNT(DISTINCT CASE WHEN utm_campaign = 'brand' THEN orders.order_id ELSE NULL END) AS brand_orders
FROM 
website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE
	website_sessions.created_at < '2012-11-27'
    AND utm_source = 'gsearch'
GROUP BY 3
order by 3;

-- question 3
SELECT
	DATE_FORMAT(website_sessions.created_at,'%Y-%m') AS year_month_date,
    COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions,
    COUNT(DISTINCT orders.order_id) AS total_orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate,
    website_sessions.device_type
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE
website_sessions.created_at < '2012-11-27' AND
website_sessions.utm_source = 'gsearch' AND
website_sessions.utm_campaign = 'nonbrand'
GROUP BY 1,5
ORDER BY 1;

-- question 4
SELECT DISTINCT
    utm_source, utm_campaign, http_referer
FROM
    website_sessions
WHERE
    website_sessions.created_at < '2012-11-27';

SELECT
	DATE_FORMAT(website_sessions.created_at, '%Y-%m') as year_month_date,
    COUNT(DISTINCT CASE WHEN utm_source = 'gsearch' THEN website_sessions.website_session_id ELSE NULL END) AS total_gsearch,
	COUNT(DISTINCT CASE WHEN utm_source = 'bsearch' THEN website_sessions.website_session_id ELSE NULL END) AS total_bsearch,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NOT NULL THEN website_sessions.website_session_id ELSE NULL END) AS organic_search_session,
    COUNT(DISTINCT CASE WHEN utm_source IS NULL AND http_referer IS NULL THEN website_sessions.website_session_id ELSE NULL END) AS direct_type_in_session
FROM website_sessions
	LEFT JOIN orders
		ON orders.website_session_id  = website_sessions.website_session_id
	WHERE website_sessions.created_at < '2012-11-27'
    GROUP BY 1;
    
-- question 5 (session to order conversion rates by month)
SELECT
	DATE_FORMAT(website_sessions.created_at, '%Y-%m') AS year_month_date,
    COUNT(DISTINCT website_sessions.website_session_id) AS total_sessions,
    COUNT(DISTINCT orders.order_id) AS total_orders,
    COUNT(DISTINCT orders.order_id) / COUNT(DISTINCT website_sessions.website_session_id) AS conv_rate
FROM website_sessions
LEFT JOIN orders
ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2012-11-27'
GROUP BY 1
ORDER BY 1;

-- question 6
SELECT
	MIN(website_pageview_id) AS first_test_pv
FROM website_pageviews
WHERE pageview_url = '/lander-1';

CREATE TEMPORARY TABLE first_test_pageviews
SELECT
	website_pageviews.website_session_id,
    MIN(website_pageviews.website_pageview_id) AS min_pageview_id
FROM website_pageviews
	INNER JOIN website_sessions
		ON website_sessions.website_session_id = website_pageviews.website_session_id
        AND website_sessions.created_at < '2012-07-28'
        AND website_pageviews.website_pageview_id >= 23504
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 1;

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_landing_pages
SELECT
	first_test_pageviews.website_session_id,
    website_pageviews.pageview_url AS landing_page
FROM first_test_pageviews
	LEFT JOIN website_pageviews
		ON website_pageviews.website_pageview_id = first_test_pageviews.min_pageview_id
WHERE website_pageviews.pageview_url IN('/home','/lander-1');

CREATE TEMPORARY TABLE nonbrand_test_sessions_w_orders
SELECT
	nonbrand_test_sessions_w_landing_pages.website_session_id,
    nonbrand_test_sessions_w_landing_pages.landing_page,
    orders.order_id AS order_id
FROM nonbrand_test_sessions_w_landing_pages
LEFT JOIN orders
	ON orders.website_session_id = nonbrand_test_sessions_w_landing_pages.website_session_id;

-- to find the difference between conversion rates
SELECT
	landing_page,
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT order_id) as orders,
    COUNT(DISTINCT order_id) / COUNT(DISTINCT website_session_id) AS conv_rate
FROM nonbrand_test_sessions_w_orders
group by 1;

-- finding the most recent (en son) pageview for gsearch nonbrand where the traffic was sent to home
SELECT
	MAX(website_sessions.website_session_id) AS most_recent_gsearch_nonbrand_home_pageview -- auto increment idyi maxlayip sonuncuyu bulduk
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_pageviews.website_session_id = website_sessions.website_session_id
WHERE utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
    AND pageview_url = '/home'
    AND website_sessions.created_at < '2012-11-27';
-- max website_session_id = 17145

SELECT
	COUNT(website_session_id) AS sessions_since_test
FROM website_sessions
WHERE created_at < '2012-11-27'
	AND website_session_id > 17145
    AND utm_source = 'gsearch'
    and utm_campaign = 'nonbrand';
-- 22972 website sessions

-- for the landing page test you analzyed show a full conversion funnel from each of the two pages to orders

CREATE TEMPORARY TABLE session_level_made_it_flagged
SELECT
	website_session_id,
    MAX(homepage) AS saw_homepage,
    MAX(custom_lander) AS saw_custom_lander,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(
SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS homepage,
    CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS custom_lander,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
	WHERE website_sessions.utm_source = 'gsearch'
		AND website_sessions.utm_campaign = 'nonbrand'
        AND website_sessions.created_at < '2012-07-08'
        AND website_sessions.created_at > '2012-06-19'
	ORDER BY
		website_sessions.website_session_id,
        website_pageviews.created_at
) AS pageview_level
GROUP BY website_session_id;

SELECT
	CASE
		WHEN saw_homepage = 1 THEN 'saw_homepage'
		WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
	END AS 'check logic...',
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flagged
GROUP BY 1;

SELECT
	CASE
		WHEN saw_homepage = 1 THEN 'saw_homepage'
		WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
	END AS 'check logic...',
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS products_click_rt,
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_click_rt,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rt,
	COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_click_rt,
	COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rt,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou_click_rt
FROM session_level_made_it_flagged
GROUP BY 1;

-- quantify the impact of our billing test please analyze revenue per billing page session
SELECT
	billing_version_seen,
    COUNT(DISTINCT website_session_id) AS sessions,
    SUM(price_usd) / COUNT(DISTINCT website_session_id) AS revenue_per_billing_page_seen
FROM(
SELECT
	website_pageviews.website_session_id,
    website_pageviews.pageview_url AS billing_version_seen,
    orders.order_id,
    orders.price_usd
FROM website_pageviews
	LEFT JOIN orders
		ON orders.website_session_id = website_pageviews.website_session_id
WHERE website_pageviews.created_at > '2012-09-10'
	AND website_pageviews.created_at < '2012-11-10'
    AND website_pageviews.pageview_url IN ('/billing','/billing-2')
) AS billing_pageviews_and_order_data
GROUP BY 1;
-- 22.83 old version billing
-- 31.34 for the new version

SELECT
	COUNT(website_session_id) AS billing_sessions_past_month
FROM website_pageviews
WHERE website_pageviews.pageview_url IN ('/billing','/billing-2')
	AND created_at BETWEEN '2012-10-27' AND '2012-11-27' -- past month
    -- 1193 sesssions
