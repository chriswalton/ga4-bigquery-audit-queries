WITH page_views AS (
  SELECT
    user_pseudo_id,
    CAST((SELECT value.int_value 
          FROM UNNEST(event_params) 
          WHERE key = 'ga_session_id') AS INT64) AS ga_session_id,
    event_timestamp,
    (SELECT value.string_value 
     FROM UNNEST(event_params) 
     WHERE key = 'page_location') AS page_location
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`,
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
    AND event_name = 'page_view'
),

-- Split into broken and valid page views
broken_pages AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    event_timestamp AS broken_time,
    page_location AS broken_page
  FROM page_views
  WHERE page_location LIKE '%/404%'
),

valid_pages AS (
  SELECT
    user_pseudo_id,
    ga_session_id,
    event_timestamp AS valid_time,
    page_location AS previous_page
  FROM page_views
  WHERE page_location NOT LIKE '%/404%'
)

-- Join within same session, and get the last valid page before the 404
SELECT
  CONCAT(bp.user_pseudo_id, '-', CAST(bp.ga_session_id AS STRING)) AS session_id,
  bp.broken_page,
  vp.previous_page,
  COUNT(*) AS hits
FROM broken_pages bp
JOIN valid_pages vp
  ON bp.user_pseudo_id = vp.user_pseudo_id
  AND bp.ga_session_id = vp.ga_session_id
  AND vp.valid_time < bp.broken_time
WHERE NOT EXISTS (
    SELECT 1
    FROM valid_pages vp2
    WHERE vp2.user_pseudo_id = vp.user_pseudo_id
      AND vp2.ga_session_id = vp.ga_session_id
      AND vp2.valid_time < bp.broken_time
      AND vp2.valid_time > vp.valid_time
)
GROUP BY session_id, bp.broken_page, vp.previous_page
ORDER BY hits DESC
