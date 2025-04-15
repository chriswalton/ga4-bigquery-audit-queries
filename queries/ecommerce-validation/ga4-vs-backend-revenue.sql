SELECT
  ga.transaction_id,
  ga.ga4_revenue,
  backend.revenue AS backend_revenue,
  ga.ga4_revenue - backend.revenue AS variance,
  ROUND(SAFE_DIVIDE(ga.ga4_revenue - backend.revenue, backend.revenue) * 100, 2) AS variance_pct
FROM (
  SELECT
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'transaction_id') AS transaction_id,
    SUM((SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value')) AS ga4_revenue
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
    AND event_name = 'purchase'
  GROUP BY transaction_id
) ga
JOIN `your_project.your_dataset.backend_transactions` AS backend
  ON ga.transaction_id = backend.transaction_id
ORDER BY ABS(variance_pct) DESC
