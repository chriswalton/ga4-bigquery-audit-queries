WITH event_device_data AS (
  SELECT
    device.web_info.browser AS browser,
    device.operating_system AS operating_system,
    COUNT(*) AS event_count
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  GROUP BY browser, operating_system

------


WITH event_device_data AS (
  SELECT
    device.web_info.browser AS browser,
    device.operating_system AS operating_system,
    COUNT(*) AS event_count
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  GROUP BY browser, operating_system
),

known_valid_pairs AS (
  SELECT 'Chrome' AS browser, 'Windows' AS operating_system UNION ALL
  SELECT 'Chrome', 'macOS' UNION ALL
  SELECT 'Chrome', 'Android' UNION ALL
  SELECT 'Chrome', 'iOS' UNION ALL
  SELECT 'Chrome', 'Chrome OS' UNION ALL
  SELECT 'Safari', 'iOS' UNION ALL
  SELECT 'Safari', 'macOS' UNION ALL
  SELECT 'Safari', 'Macintosh' UNION ALL
  SELECT 'Safari (in-app)', 'iOS' UNION ALL
  SELECT 'Edge', 'Windows' UNION ALL
  SELECT 'Firefox', 'Windows' UNION ALL
  SELECT 'Firefox', 'macOS' UNION ALL
  SELECT 'Samsung Internet', 'Android' UNION ALL
  SELECT 'Internet Explorer', 'Windows' UNION ALL
  SELECT 'Android Webview', 'Android' UNION ALL
  SELECT 'Android Browser', 'Android'
)

SELECT
  e.browser,
  e.operating_system,
  e.event_count,
  IF(k.browser IS NULL, '⚠️ Unusual Combination', 'Valid') AS validity
FROM event_device_data e
LEFT JOIN known_valid_pairs k
  ON e.browser = k.browser AND e.operating_system = k.operating_system
ORDER BY validity DESC, e.event_count DESC
