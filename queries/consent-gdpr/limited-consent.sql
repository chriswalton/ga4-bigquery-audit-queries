WITH all_events AS (
  SELECT
    user_pseudo_id,
    CAST((SELECT value.int_value 
          FROM UNNEST(event_params) 
          WHERE key = 'ga_session_id') AS INT64) AS ga_session_id,
    event_name,
    privacy_info.analytics_storage AS analytics_storage,
    privacy_info.ads_storage AS ads_storage
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
),

-- Sessions with valid IDs
sessions AS (
  SELECT
    CONCAT(user_pseudo_id, '-', CAST(ga_session_id AS STRING)) AS session_id,
    user_pseudo_id,
    ga_session_id,
    analytics_storage,
    ads_storage
  FROM all_events
  WHERE user_pseudo_id IS NOT NULL AND ga_session_id IS NOT NULL
  GROUP BY session_id, user_pseudo_id, ga_session_id, analytics_storage, ads_storage
),

-- Purchases with session info
purchases AS (
  SELECT DISTINCT
    CONCAT(user_pseudo_id, '-', CAST((SELECT value.int_value 
          FROM UNNEST(event_params) 
          WHERE key = 'ga_session_id') AS STRING)) AS session_id
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
    AND event_name = 'purchase'
),

-- Count sessions grouped by consent status
session_summary AS (
  SELECT
    'session_group' AS type,
    analytics_storage,
    ads_storage,
    COUNT(*) AS count,
    COUNT(*) AS total_sessions,
    COUNTIF(session_id IN (SELECT session_id FROM purchases)) AS total_purchases
  FROM sessions
  GROUP BY analytics_storage, ads_storage
),

-- Count cookieless pings (no user or session IDs)
cookieless_summary AS (
  SELECT
    'cookieless_pings' AS type,
    CAST(NULL AS STRING) AS analytics_storage,
    CAST(NULL AS STRING) AS ads_storage,
    COUNT(*) AS count,
    CAST(NULL AS INT64) AS total_sessions,
    CAST(NULL AS INT64) AS total_purchases
  FROM all_events
  WHERE user_pseudo_id IS NULL AND ga_session_id IS NULL
)

-- Combine both tables
SELECT * FROM session_summary
UNION ALL
SELECT * FROM cookieless_summary
ORDER BY count DESC
