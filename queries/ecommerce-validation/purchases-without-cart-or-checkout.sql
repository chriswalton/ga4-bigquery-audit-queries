WITH all_events_with_sessions AS (
  SELECT
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value FROM UNNEST(event_params)
      WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    user_pseudo_id,
    event_name
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
),

session_event_counts AS (
  SELECT
    session_id,
    COUNTIF(event_name = 'add_to_cart') AS add_to_cart_count,
    COUNTIF(event_name = 'begin_checkout') AS begin_checkout_count,
    COUNTIF(event_name = 'purchase') AS purchase_count
  FROM all_events_with_sessions
  GROUP BY session_id
),

purchasing_sessions AS (
  SELECT *
  FROM session_event_counts
  WHERE purchase_count > 0
)

SELECT
  COUNT(*) AS purchasing_sessions,
  COUNTIF(add_to_cart_count = 0) AS sessions_with_no_add_to_cart,
  COUNTIF(begin_checkout_count = 0) AS sessions_with_no_begin_checkout
FROM purchasing_sessions

