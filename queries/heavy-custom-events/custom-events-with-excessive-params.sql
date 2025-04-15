-- Custom Events with Excessive Parameters
SELECT
  event_name,
  COUNT(DISTINCT param.key) AS unique_param_keys,
  COUNT(*) AS total_events
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`,
     UNNEST(event_params) AS param
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND event_name NOT IN ('page_view', 'session_start', 'user_engagement')
GROUP BY event_name
ORDER BY unique_param_keys DESC
LIMIT 20

