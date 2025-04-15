WITH session_event_map AS (
  SELECT
    user_pseudo_id,
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value 
      FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    event_name,
    MAX(IF(event_name = 'purchase', 1, 0)) OVER (
      PARTITION BY user_pseudo_id, CONCAT(user_pseudo_id, '-', CAST((
        SELECT value.int_value 
        FROM UNNEST(event_params)
        WHERE key = 'ga_session_id'
      ) AS STRING))
    ) AS purchase_session
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
)

SELECT
  event_name,
  COUNTIF(purchase_session = 1) AS events_in_purchasing_sessions,
  COUNTIF(purchase_session = 0) AS events_in_non_purchasing_sessions,
  ROUND(SAFE_DIVIDE(COUNTIF(purchase_session = 1), COUNT(*)), 4) AS purchase_session_ratio
FROM session_event_map
GROUP BY event_name
ORDER BY purchase_session_ratio DESC
