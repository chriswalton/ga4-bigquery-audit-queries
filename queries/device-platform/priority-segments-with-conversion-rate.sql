WITH sessions AS (
  SELECT
    user_pseudo_id,
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    platform,
    device.web_info.browser AS browser,
    device.operating_system AS os,
    device.category AS device_type,
    COUNTIF(event_name = 'purchase') AS purchases
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  GROUP BY user_pseudo_id, session_id, platform, browser, os, device_type
)

SELECT
  platform,
  browser,
  os,
  device_type,
  COUNT(*) AS sessions,
  SUM(purchases) AS conversions,
  ROUND(SAFE_DIVIDE(SUM(purchases), COUNT(*)) * 100, 2) AS conversion_rate,
  ROUND(SAFE_DIVIDE(COUNT(*), SUM(COUNT(*)) OVER ()) * 100, 2) AS traffic_share_pct
FROM sessions
GROUP BY platform, browser, os, device_type
ORDER BY traffic_share_pct DESC