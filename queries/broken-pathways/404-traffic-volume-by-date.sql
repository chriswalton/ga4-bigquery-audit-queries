SELECT
  PARSE_DATE('%Y%m%d', event_date) AS date,
  COUNT(*) AS hits_404
FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`,
     UNNEST(event_params) AS event_params
WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  AND event_name = 'page_view'
  AND event_params.key = 'page_location'
  AND event_params.value.string_value LIKE '%/404%'
GROUP BY date
ORDER BY date