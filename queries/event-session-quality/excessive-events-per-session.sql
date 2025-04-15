WITH sessions AS (
  SELECT
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    COUNT(*) AS total_events
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  GROUP BY session_id, user_pseudo_id
),

bucketed_sessions AS (
  SELECT
    CASE
      WHEN total_events < 50 THEN '< 50'
      WHEN total_events BETWEEN 50 AND 99 THEN '50–99'
      WHEN total_events BETWEEN 100 AND 149 THEN '100–149'
      ELSE '150+'
    END AS event_bracket
  FROM sessions
)

SELECT
  event_bracket,
  COUNT(*) AS session_count
FROM bucketed_sessions
GROUP BY event_bracket
ORDER BY 
  CASE event_bracket
    WHEN '< 50' THEN 1
    WHEN '50–99' THEN 2
    WHEN '100–149' THEN 3
    WHEN '150+' THEN 4
  END
