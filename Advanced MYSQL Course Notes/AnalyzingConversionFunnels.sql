-- using subqueries
-- select columnName From(subquery)

SELECT 
    website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at,
    CASE
        WHEN pageview_url = '/products' THEN 1
        ELSE 0
    END AS products_page,
    CASE
        WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1
        ELSE 0
    END AS mrfuzzy_page,
    CASE
        WHEN pageview_url = '/cart' THEN 1
        ELSE 0
    END AS cart_page
FROM
    website_sessions
        LEFT JOIN
    website_pageviews ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
    website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
        AND website_pageviews.pageview_url IN ('/lander-2' , '/products',
        '/the-original-mr-fuzzy',
        '/cart')
ORDER BY website_sessions.website_session_id , website_pageviews.created_at;

-- next we will put the previous query inside a subquery
SELECT
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) as shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(SELECT 
    website_sessions.website_session_id,
    website_pageviews.pageview_url,
    website_pageviews.created_at AS pageview_created_at,
    CASE
        WHEN pageview_url = '/products' THEN 1
        ELSE 0
    END AS products_page,
    CASE
        WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1
        ELSE 0
    END AS mrfuzzy_page,
    CASE
        WHEN pageview_url = '/cart' THEN 1
        ELSE 0
    END AS cart_page
FROM
    website_sessions
        LEFT JOIN
    website_pageviews ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE
    website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
        AND website_pageviews.pageview_url IN ('/lander-2' , '/products',
        '/the-original-mr-fuzzy',
        '/cart')
ORDER BY website_sessions.website_session_id , website_pageviews.created_at) AS pageview_level
GROUP BY website_session_id;

-- next we will turn it into a temp table
CREATE TEMPORARY TABLE session_level_made_it_flags_demo
SELECT
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it
FROM(
SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page,
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page
FROM website_sessions
	LEFT JOIN website_pageviews
		ON website_sessions.website_session_id = website_pageviews.website_session_id
WHERE website_sessions.created_at BETWEEN '2014-01-01' AND '2014-02-01'
	AND website_pageviews.pageview_url IN ('/lander-2','/products','/the-original-mr-fuzzy','/cart')
ORDER BY
	website_sessions.website_session_id,
    website_pageviews.created_at
) AS pageview_level
GROUP BY
	website_session_id;
    
    
SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart
FROM session_level_made_it_flags_demo;
    
-- then we'll translate those counts to click rates for final output

    
SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT website_session_id) AS clicked_to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/ COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS clicked_to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) / COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)  AS clicked_to_cart
FROM session_level_made_it_flags_demo;

-- build us a full conversion funnel analyzing how many customers make it to each step(start with lander1)
SELECT 
    *
FROM
    website_pageviews;
select * from website_sessions;

SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
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
        AND website_sessions.created_at > '2012-08-05'
        AND website_sessions.created_at < '2012-09-05'
	ORDER BY
		website_sessions.website_session_id,
        website_pageviews.created_at;
     
CREATE TEMPORARY TABLE session_level_made_it_flags
SELECT
	website_session_id,
    MAX(products_page) AS product_made_it,
    MAX(mrfuzzy_page) AS mrfuzzy_made_it,
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
FROM(SELECT
	website_sessions.website_session_id,
    website_pageviews.pageview_url,
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
        AND website_sessions.created_at > '2012-08-05'
        AND website_sessions.created_at < '2012-09-05'
	ORDER BY
		website_sessions.website_session_id,
        website_pageviews.created_at
) AS pageview_level
group by 1;

SELECT
	COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
FROM session_level_made_it_flags;

-- then this as final output part 2
SELECT
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS products_click_rt,
	COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy_click_rt,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart_rt,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping_rt,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing_rt,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou_rt
FROM session_level_made_it_flags;
