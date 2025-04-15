SELECT
  event_name,
  param.key AS parameter_name,
  param.value.string_value AS suspicious_value,
  COUNT(*) AS occurrences
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`,
     UNNEST(event_params) AS param
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND LOWER(param.value.string_value) IN ('null', 'undefined', 'nan', '')
GROUP BY event_name, parameter_name, suspicious_value
ORDER BY occurrences DESC
