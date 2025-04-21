WITH
  sessions_per_month_year AS (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP_MICROS(event_timestamp)) AS month_year,
      EXTRACT(MONTH FROM TIMESTAMP_MICROS(event_timestamp))       AS month_num,
      FORMAT_TIMESTAMP('%B', TIMESTAMP_MICROS(event_timestamp))   AS month_name,
      COUNT(DISTINCT CAST(
        (SELECT value.int_value
         FROM UNNEST(event_params)
         WHERE key = 'ga_session_id' LIMIT 1
        ) AS INT64
      ))                                                           AS sessions_count
    FROM
      `..events_*`
    WHERE
      event_name = 'session_start'
    GROUP BY month_year, month_num, month_name
  ),
  transactions_per_month_year AS (
    SELECT
      FORMAT_TIMESTAMP('%Y-%m', TIMESTAMP_MICROS(event_timestamp)) AS month_year,
      EXTRACT(MONTH FROM TIMESTAMP_MICROS(event_timestamp))       AS month_num,
      FORMAT_TIMESTAMP('%B', TIMESTAMP_MICROS(event_timestamp))   AS month_name,
      COUNT(*)                                                    AS transactions_count
    FROM 
			`..events_*`
    WHERE
      event_name = 'purchase'
    GROUP BY month_year, month_num, month_name
  ),
  combined_month_year AS (
    SELECT
      s.month_year,
      s.month_num,
      s.month_name,
      s.sessions_count,
      COALESCE(t.transactions_count, 0) AS transactions_count
    FROM sessions_per_month_year s
    LEFT JOIN transactions_per_month_year t
      USING(month_year, month_num, month_name)
  ),
  stats AS (
    SELECT
      COUNT(*)                                      AS months_count,
      SUM(sessions_count)   / COUNT(*)              AS overall_avg_sessions,
      SUM(transactions_count) / COUNT(*)            AS overall_avg_transactions,
      SAFE_DIVIDE(SUM(transactions_count), SUM(sessions_count)) AS overall_avg_conv_rate
    FROM combined_month_year
  ),
  agg_by_month AS (
    SELECT
      month_num,
      month_name,
      AVG(sessions_count)     AS avg_sessions_by_month,
      AVG(transactions_count) AS avg_transactions_by_month,
      SAFE_DIVIDE(
        AVG(transactions_count),
        AVG(sessions_count)
      )                         AS avg_conv_rate_by_month
    FROM combined_month_year
    GROUP BY month_num, month_name
  )
SELECT
  month_name                                        AS month,
  ROUND(
    SAFE_DIVIDE(avg_sessions_by_month, stats.overall_avg_sessions),
    2
  )                                                  AS session_seasonality,
  ROUND(
    SAFE_DIVIDE(avg_transactions_by_month, stats.overall_avg_transactions),
    2
  )                                                  AS transaction_seasonality,
  ROUND(
    SAFE_DIVIDE(avg_conv_rate_by_month, stats.overall_avg_conv_rate),
    2
  )                                                  AS conversion_rate_seasonality
FROM agg_by_month
CROSS JOIN stats
ORDER BY month_num;