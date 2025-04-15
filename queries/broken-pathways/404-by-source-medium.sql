SSELECT DISTINCT
  traffic_source.source,
  traffic_source.medium,
  traffic_source.name AS campaign
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND (
    traffic_source.medium IS NULL
    OR traffic_source.medium = '(not set)'
    OR traffic_source.source IS NULL
    OR traffic_source.source = '(not set)'
  )