SELECT
  CONCAT(user_pseudo_id, '-', CAST((
    SELECT value.int_value
    FROM UNNEST(event_params)
    WHERE key = 'ga_session_id'
  ) AS STRING)) AS session_id,
  user_pseudo_id,
  COUNTIF(event_name = 'login') AS login_count
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
GROUP BY session_id, user_pseudo_id
HAVING login_count > 1
ORDER BY login_count DESC