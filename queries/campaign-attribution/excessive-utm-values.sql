SELECT
  COUNT(DISTINCT traffic_source.name) AS unique_campaigns,
  COUNT(DISTINCT traffic_source.source) AS unique_sources,
  COUNT(DISTINCT traffic_source.medium) AS unique_mediums
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'