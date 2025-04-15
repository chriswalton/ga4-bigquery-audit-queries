WITH sessions AS (
  SELECT
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    ARRAY_AGG(DISTINCT event_name) AS event_list,
    COUNT(DISTINCT event_name) AS unique_events
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  GROUP BY session_id
),

summary AS (
  SELECT
    COUNT(*) AS total_sessions,
    COUNTIF(
      NOT 'user_engagement' IN UNNEST(event_list)
      AND NOT 'scroll' IN UNNEST(event_list)
      AND NOT 'click' IN UNNEST(event_list)
      AND unique_events <= 2
    ) AS non_engaged_sessions
  FROM sessions
)

SELECT
  total_sessions,
  non_engaged_sessions,
  ROUND(SAFE_DIVIDE(non_engaged_sessions, total_sessions) * 100, 2) AS non_engaged_pct
FROM summary
