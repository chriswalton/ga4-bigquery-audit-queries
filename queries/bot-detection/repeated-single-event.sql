WITH session_data AS (
  SELECT
    user_pseudo_id,
    event_name,
    CAST((SELECT value.int_value 
          FROM UNNEST(event_params) 
          WHERE key = 'ga_session_id') AS INT64) AS ga_session_id
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
),

session_summary AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    CONCAT(user_pseudo_id, '-', CAST(ga_session_id AS STRING)) AS session_id,
    COUNT(*) AS total_events,
    COUNT(DISTINCT event_name) AS unique_event_names,
    ARRAY_AGG(event_name ORDER BY event_name LIMIT 1)[OFFSET(0)] AS repeated_event
  FROM session_data
  GROUP BY user_pseudo_id, ga_session_id
),

event_counts AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    event_name,
    COUNT(*) AS event_name_count
  FROM session_data
  GROUP BY user_pseudo_id, ga_session_id, event_name
)

SELECT
  s.session_id,
  s.user_pseudo_id,
  s.total_events,
  s.unique_event_names,
  s.repeated_event,
  ec.event_name_count AS repeated_event_count
FROM session_summary s
LEFT JOIN event_counts ec
  ON s.user_pseudo_id = ec.user_pseudo_id
  AND s.ga_session_id = ec.ga_session_id
  AND s.repeated_event = ec.event_name
WHERE s.unique_event_names = 1 AND s.total_events > 50
ORDER BY s.total_events DESC
