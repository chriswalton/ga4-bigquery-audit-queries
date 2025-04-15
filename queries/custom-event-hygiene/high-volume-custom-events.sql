SELECT
  event_name,
  COUNT(*) AS event_count
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND event_name NOT IN (
    'page_view', 'session_start', 'user_engagement', 
    'scroll', 'click', 'view_search_results', 
    'purchase', 'add_to_cart', 'begin_checkout'
  )
GROUP BY event_name
ORDER BY event_count DESC
LIMIT 20
