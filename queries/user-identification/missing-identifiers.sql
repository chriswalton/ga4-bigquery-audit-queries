SELECT
  event_name,
  COUNTIF(user_id IS NULL) AS null_user_id,
  COUNTIF(user_id IS NOT NULL) AS valid_user_id,
  COUNTIF(user_pseudo_id IS NULL) AS null_user_pseudo_id,
  COUNTIF(user_pseudo_id IS NOT NULL) AS valid_user_pseudo_id,
  COUNTIF(user_id IS NULL AND user_pseudo_id IS NULL) AS null_both_ids
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
GROUP BY event_name
ORDER BY null_both_ids DESC