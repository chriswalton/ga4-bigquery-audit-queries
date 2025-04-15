SELECT
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'transaction_id') AS transaction_id,
  COUNT(*) AS transaction_count,
  COUNT(DISTINCT CONCAT(user_pseudo_id, '-', CAST((
    SELECT value.int_value FROM UNNEST(event_params)
    WHERE key = 'ga_session_id'
  ) AS STRING))) AS unique_sessions,
  COUNT(DISTINCT event_date) AS unique_days
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`,
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND event_name = 'purchase'
GROUP BY transaction_id
HAVING transaction_count > 1
ORDER BY transaction_count DESC