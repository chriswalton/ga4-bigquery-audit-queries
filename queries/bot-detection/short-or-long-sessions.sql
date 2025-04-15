WITH session_data AS (
  SELECT
    user_pseudo_id,
    CAST((SELECT value.int_value 
          FROM UNNEST(event_params) 
          WHERE key = 'ga_session_id') AS INT64) AS ga_session_id,
    event_timestamp
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
)

SELECT
  CONCAT(user_pseudo_id, '-', CAST(ga_session_id AS STRING)) AS session_id,
  user_pseudo_id,
  MIN(event_timestamp) AS session_start,
  MAX(event_timestamp) AS session_end,
  COUNT(*) AS event_count,
  ROUND((MAX(event_timestamp) - MIN(event_timestamp)) / 1000000, 2) AS session_duration_seconds
FROM session_data
GROUP BY user_pseudo_id, ga_session_id
HAVING 
  event_count > 1 AND 
  (session_duration_seconds < 2 OR session_duration_seconds > 1800)
ORDER BY session_duration_seconds
