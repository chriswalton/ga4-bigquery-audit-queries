SELECT
  event_name,
  ROUND(AVG(param_count), 2) AS avg_params,
  MAX(param_count) AS max_params,
  COUNT(*) AS total_events
FROM (
  SELECT
    event_name,
    ARRAY_LENGTH(event_params) AS param_count
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
)
GROUP BY event_name
HAVING avg_params > 10
ORDER BY avg_params DESC