WITH ecommerce_events AS (
  SELECT
    event_name,
    param.key AS param_key,
    param.value.string_value AS string_value,
    param.value.int_value AS int_value,
    param.value.double_value AS double_value
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`,
       UNNEST(event_params) AS param
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
    AND event_name IN (
      'add_to_cart', 'remove_from_cart', 'view_item',
      'begin_checkout', 'add_payment_info',
      'purchase', 'refund'
    )
),

-- Param-level validation for all events
enhanced_ecommerce_audit AS (
  SELECT
    event_name,
    param_key,
    COUNT(*) AS total_events,
    COUNTIF(
      (param_key IN ('item_id', 'item_name', 'currency', 'item_brand', 'item_category', 'item_variant', 'transaction_id')
        AND (string_value IS NULL OR string_value = ''))
      OR (param_key IN ('quantity', 'price')
        AND int_value IS NULL AND double_value IS NULL)
      OR (param_key = 'value' AND double_value IS NULL)
    ) AS missing_or_invalid_count
  FROM ecommerce_events
  WHERE param_key IN (
    'item_id', 'item_name', 'currency', 'value',
    'price', 'quantity', 'item_brand', 'item_category',
    'item_variant', 'transaction_id'
  )
  GROUP BY event_name, param_key
),

-- Purchase-specific deep check: missing or empty items array
purchase_events AS (
  SELECT
    event_name,
    (SELECT COUNT(*) FROM UNNEST(items)) AS item_count
  FROM `{{PROJECT_ID}}.{{DATASET}}.events_*`
  WHERE _TABLE_SUFFIX BETWEEN '{{START_DATE}}' AND '{{END_DATE}}'
    AND event_name = 'purchase'
),

purchase_quality_checks AS (
  SELECT
    'purchase' AS event_name,
    'items_missing_or_empty' AS param_key,
    COUNT(*) AS total_events,
    COUNTIF(item_count IS NULL OR item_count = 0) AS missing_or_invalid_count
  FROM purchase_events
)

-- Final combined result
SELECT
  event_name,
  param_key,
  total_events,
  missing_or_invalid_count,
  ROUND(SAFE_DIVIDE(missing_or_invalid_count, total_events) * 100, 2) AS pct_missing_or_invalid
FROM enhanced_ecommerce_audit

UNION ALL

SELECT
  event_name,
  param_key,
  total_events,
  missing_or_invalid_count,
  ROUND(SAFE_DIVIDE(missing_or_invalid_count, total_events) * 100, 2)
FROM purchase_quality_checks

ORDER BY event_name, pct_missing_or_invalid DESC
