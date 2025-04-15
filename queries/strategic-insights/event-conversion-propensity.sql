WITH session_purchases AS (
  SELECT
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value 
      FROM UNNEST(event_params) WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id,
    MAX(IF(event_name = 'purchase', 1, 0)) AS converted
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
  GROUP BY session_id
),

event_in_sessions AS (
  SELECT
    event_name,
    CONCAT(user_pseudo_id, '-', CAST((
      SELECT value.int_value 
      FROM UNNEST(event_params) WHERE key = 'ga_session_id'
    ) AS STRING)) AS session_id
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
),

event_conversion_propensity AS (
  SELECT
    eis.event_name,
    COUNTIF(sp.converted = 1) AS conversions,
    COUNT(*) AS total_events,
    SAFE_DIVIDE(COUNTIF(sp.converted = 1), COUNT(*)) AS conversion_propensity
  FROM event_in_sessions eis
  JOIN session_purchases sp ON eis.session_id = sp.session_id
  GROUP BY eis.event_name
)

SELECT *
FROM event_conversion_propensity
ORDER BY conversion_propensity DESC

