-- DATEDIFF() allows to compare the time difference between two dates
-- datediff substracts the second date from the first date so typically you will list the more recent date
-- for example DATEDIFF(NOW(), born_on_date) AS days_old

-- Could you please pull data on how many of our website visitors come back for another session 2014 to date is good
select * from website_sessions;

CREATE TEMPORARY TABLE sessions_w_repeats
SELECT
	new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    website_sessions.website_session_id AS repeat_session_id
FROM
(
SELECT
	user_id,
    website_session_id
FROM website_sessions
WHERE created_at < '2014-11-01'
	AND created_at >= '2014-01-01'
    AND is_repeat_session = 0 -- sadece ilk ziyaret(tekrar olmayan oturumlari seciyoruz)
) AS new_sessions
	LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1 -- no need but good to illustrate
        AND website_sessions.website_session_id > new_sessions.website_session_id -- eslesen oturumun buldugumuz ilk oturumdan daha sonra gerceklestigini garanti eder
        AND website_sessions.created_at < '2014-11-01'
        AND website_sessions.created_at > '2014-01-01';



SELECT
	repeat_sessions,
    COUNT(DISTINCT user_id) AS users
FROM
(
SELECT
	user_id,
    COUNT(DISTINCT new_session_id) AS new_sessions,
    COUNT(DISTINCT repeat_session_id) AS repeat_sessions
FROM sessions_w_repeats
GROUP BY 1
ORDER BY 3 DESC
) AS user_level
GROUP BY 1;

-- Could you help me understand the minimum maximum and average time between the first and second session for customer who do come back?
CREATE TEMPORARY TABLE sessions_w_repeats_for_time_diff
SELECT
	new_sessions.user_id,
    new_sessions.website_session_id AS new_session_id,
    new_sessions.created_at AS new_sessions_created_at,
    website_sessions.website_session_id AS repeat_session_id,
    website_sessions.created_at AS repeat_session_created_at
FROM
(
SELECT
	user_id,
    website_session_id,
    created_at
FROM website_sessions
WHERE created_at < '2014-11-03'
	AND created_at >= '2014-01-01'
    AND is_repeat_session = 0
) AS new_sessions
	LEFT JOIN website_sessions
		ON website_sessions.user_id = new_sessions.user_id
        AND website_sessions.is_repeat_session = 1
        AND website_sessions.website_session_id > new_sessions.website_session_id
        AND website_sessions.created_at < '2014-11-03'
        AND website_sessions.created_at >= '2014-01-01';

CREATE TEMPORARY TABLE users_first_to_second
SELECT
	user_id,
    DATEDIFF(second_session_created_at,new_sessions_created_at) days_first_to_second_session
FROM
(
SELECT
	user_id,
    new_session_id,
    new_sessions_created_at,
    MIN(repeat_session_id) AS second_session_id,
    MIN(repeat_session_created_at) AS second_session_created_at
FROM sessions_w_repeats_for_time_diff
WHERE repeat_session_id IS NOT NULL
GROUP BY 1,2,3
) AS first_second;

SELECT
	AVG(days_first_to_second_session) AS avg_days_first_to_second,
    MIN(days_first_to_second_session) AS min_days_first_to_second,
	MAX(days_first_to_second_session) AS max_days_first_to_second
FROM users_first_to_second;

-- Comparing new vs. repeat sessions by channel would be really valuable
SELECT
	utm_source,
    utm_campaign,
    http_referer,
    COUNT(CASE WHEN is_repeat_session = 0 THEN website_session_id ELSE NULL END) AS new_sessions,
    COUNT(CASE WHEN is_repeat_session = 1 THEN website_session_id ELSE NULL END) AS repeat_sessions
FROM website_sessions
WHERE website_sessions.created_at < '2014-11-03'
	AND website_sessions.created_at >= '2014-01-01'
GROUP BY 1,2,3
ORDER BY 5 DESC;

SELECT 
    CASE
        WHEN
            utm_source IS NULL
                AND http_referer IN ('https://www.gsearch.com' , 'https://www.bsearch.com')
        THEN
            'organic_search'
        WHEN utm_campaign = 'nonbrand' THEN 'paid_nonbrand'
        WHEN utm_campaign = 'brand' THEN 'paid_brand'
        WHEN
            utm_source IS NULL
                AND http_referer IS NULL
        THEN
            'direct_type_in'
        WHEN utm_source = 'socialbook' THEN 'paid_social'
    END AS channel_group,
    COUNT(CASE
        WHEN is_repeat_session = 0 THEN website_session_id
        ELSE NULL
    END) AS new_sessions,
    COUNT(CASE
        WHEN is_repeat_session = 1 THEN website_session_id
        ELSE NULL
    END) AS repeat_sessions
FROM website_sessions
WHERE created_at < '2014-11-05'
	AND created_at >= '2014-01-01'
GROUP BY 1;

-- comparison of conversion rates and revenue per session for repeat sessions vs new sessions
SELECT
	is_repeat_session,
	COUNT(DISTINCT website_sessions.website_session_id) AS sessions,
    COUNT(DISTINCT orders.order_id)/COUNT(DISTINCT website_sessions.website_session_id)  AS conversion_rates,
    SUM(price_usd) / COUNT(DISTINCT website_sessions.website_session_id) AS revenue_per_session
FROM website_sessions
LEFT JOIN orders
	ON orders.website_session_id = website_sessions.website_session_id
WHERE website_sessions.created_at < '2014-11-08'
	AND website_sessions.created_at >= '2014-01-01'
GROUP BY 1;