WITH events_with_session_id AS (
  SELECT
    user_pseudo_id,
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value 
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    event_name,
    event_timestamp
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
),

first_event_per_session AS (
  SELECT
    session_id,
    event_name AS first_event
  FROM (
    SELECT
      session_id,
      event_name,
      ROW_NUMBER() OVER (PARTITION BY session_id ORDER BY event_timestamp) AS rn
    FROM events_with_session_id
  )
  WHERE rn = 1
)

SELECT
  first_event AS event_name,
  COUNT(DISTINCT session_id) AS sessions_starting_with_event
FROM first_event_per_session
GROUP BY first_event
ORDER BY sessions_starting_with_event DESC
