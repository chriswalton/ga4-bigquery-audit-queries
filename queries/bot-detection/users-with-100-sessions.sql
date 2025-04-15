SELECT
  user_pseudo_id,
  event_date,
  COUNT(DISTINCT CONCAT(user_pseudo_id, '-', CAST((SELECT value.int_value 
                                                   FROM UNNEST(event_params) 
                                                   WHERE key = 'ga_session_id') AS STRING))) AS session_count
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
GROUP BY user_pseudo_id, event_date
HAVING session_count > 100
ORDER BY session_count DESC