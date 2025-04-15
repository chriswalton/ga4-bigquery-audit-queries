SELECT
  user_pseudo_id,
  ARRAY_AGG(DISTINCT user_id IGNORE NULLS) AS user_ids
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
GROUP BY user_pseudo_id
HAVING ARRAY_LENGTH(user_ids) > 1