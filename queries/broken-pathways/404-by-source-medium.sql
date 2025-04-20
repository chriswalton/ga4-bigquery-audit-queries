SELECT
  traffic_source.source,
  traffic_source.medium,
  event_params.value.string_value AS broken_page,
  COUNT(*) AS hits
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`,
     UNNEST(event_params) AS event_params
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND event_name = 'page_view'
  AND event_params.key = 'page_location'
  AND event_params.value.string_value LIKE '%/404%'
GROUP BY traffic_source.source, traffic_source.medium, broken_page
ORDER BY hits DESC
