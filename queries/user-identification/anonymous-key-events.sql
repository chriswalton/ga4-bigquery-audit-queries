SELECT
  event_name,
  COUNTIF(user_id IS NULL) AS anonymous_event_count,
  COUNTIF(user_id IS NOT NULL) AS identified_event_count,
  ROUND(SAFE_DIVIDE(COUNTIF(user_id IS NULL), COUNT(*)) * 100, 2) AS percent_anonymous
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND event_name IN ('purchase', 'generate_lead', 'login', 'sign_up', 'form_submit')
GROUP BY event_name
ORDER BY percent_anonymous DESC
