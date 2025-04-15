SELECT
  COUNT(DISTINCT (
    SELECT value.string_value FROM UNNEST(event_params)
    WHERE key = 'transaction_id'
  )) AS transactions_without_items
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND event_name = 'purchase'
  AND (items IS NULL OR ARRAY_LENGTH(items) = 0)
