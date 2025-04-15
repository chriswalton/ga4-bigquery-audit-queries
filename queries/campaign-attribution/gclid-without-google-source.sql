SELECT
  traffic_source.source,
  traffic_source.medium,
  traffic_source.gclid,
  COUNT(*) AS sessions
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND traffic_source.gclid IS NOT NULL
  AND traffic_source.source NOT LIKE '%google%'
GROUP BY traffic_source.source, traffic_source.medium, traffic_source.gclid
ORDER BY sessions DESC
