SELECT
  traffic_source.source,
  traffic_source.medium,
  (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'gclid') AS gclid,
  COUNT(*) AS sessions
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'gclid') IS NOT NULL
  AND LOWER(traffic_source.source) NOT LIKE '%google%'
GROUP BY traffic_source.source, traffic_source.medium, gclid
ORDER BY sessions DESC
