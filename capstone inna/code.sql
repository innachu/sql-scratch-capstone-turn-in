SELECT COUNT(DISTINCT utm_campaign),
COUNT(DISTINCT utm_source)
FROM page_visits
ORDER BY utm_source;

SELECT DISTINCT utm_source,
    utm_campaign
FROM page_visits
ORDER BY utm_campaign;

SELECT DISTINCT page_name
FROM page_visits;

WITH first_touch AS (
    SELECT user_id,
        MIN(timestamp) AS first_touch_at
    FROM page_visits
    GROUP BY user_id),
ft_attr AS (
  SELECT ft.user_id,
         ft.first_touch_at,
         pv.utm_source,
         pv.utm_campaign
  FROM page_visits pv
  LEFT JOIN first_touch ft
    ON ft.user_id = pv.user_id
    AND ft.first_touch_at =        pv.timestamp)
SELECT ft_attr.utm_campaign,
       ft_attr.utm_source,
       COUNT(*)
FROM ft_attr
GROUP BY utm_campaign
ORDER BY COUNT(*) DESC;


WITH last_touch AS ( 
 SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  LEFT JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp
)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

SELECT COUNT(DISTINCT user_id),
  page_name
FROM page_visits
GROUP BY page_name;

WITH last_touch AS ( 
 SELECT user_id,
        MAX(timestamp) AS last_touch_at
    FROM page_visits
    WHERE page_name = '4 - purchase'
    GROUP BY user_id),
lt_attr AS (
  SELECT lt.user_id,
         lt.last_touch_at,
         pv.utm_source,
         pv.utm_campaign,
         pv.page_name
  FROM last_touch lt
  LEFT JOIN page_visits pv
    ON lt.user_id = pv.user_id
    AND lt.last_touch_at = pv.timestamp)
SELECT lt_attr.utm_source,
       lt_attr.utm_campaign,
       COUNT(*)
FROM lt_attr
GROUP BY 1, 2
ORDER BY 3 DESC;