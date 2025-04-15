WITH sessions_with_revenue AS (
  SELECT
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value 
      FROM UNNEST(event_params) WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    SUM((SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value')) AS session_revenue
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
    AND event_name = 'purchase'
  GROUP BY session_id
),

session_event_counts AS (
  SELECT
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value 
      FROM UNNEST(event_params) WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    COUNT(*) AS event_count
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  GROUP BY session_id
),

events_with_context AS (
  SELECT
    event_name,
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value 
      FROM UNNEST(event_params) WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
),

combined AS (
  SELECT
    e.event_name,
    s.session_revenue,
    c.event_count,
    SAFE_DIVIDE(s.session_revenue, c.event_count) AS fractional_revenue
  FROM events_with_context e
  LEFT JOIN sessions_with_revenue s ON e.session_id = s.session_id
  LEFT JOIN session_event_counts c ON e.session_id = c.session_id
  WHERE s.session_revenue IS NOT NULL AND c.event_count > 0
)

SELECT
  event_name,
  COUNT(*) AS event_count,
  ROUND(SUM(fractional_revenue), 2) AS total_revenue_when_present,
  ROUND(SAFE_DIVIDE(SUM(fractional_revenue), COUNT(*)), 2) AS avg_revenue_per_event_instance
FROM combined
GROUP BY event_name
ORDER BY avg_revenue_per_event_instance DESC
