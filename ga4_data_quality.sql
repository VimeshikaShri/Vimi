-- Daily GA4 conversion health and consent distribution.
-- Replace YOUR_PROJECT.analytics_PROPERTY_ID with the actual exported dataset.
-- Uses completed daily export tables only; no PII is selected.

WITH conversion_events AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS event_day,
    event_name,
    privacy_info.ads_storage AS ads_storage,
    privacy_info.analytics_storage AS analytics_storage,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'lead_id') AS lead_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'transaction_id') AS transaction_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'currency') AS currency,
    COALESCE(
      (SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value'),
      CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'value') AS FLOAT64)
    ) AS conversion_value
  FROM `YOUR_PROJECT.analytics_PROPERTY_ID.events_*`
  WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 30 DAY))
                          AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    AND event_name IN ('generate_lead', 'purchase')
)
SELECT
  event_day,
  event_name,
  ads_storage,
  analytics_storage,
  COUNT(*) AS events,
  COUNT(DISTINCT IF(event_name = 'generate_lead', lead_id, transaction_id)) AS unique_conversion_ids,
  COUNTIF(IF(event_name = 'generate_lead', lead_id, transaction_id) IS NULL) AS missing_conversion_id_events,
  ROUND(SUM(conversion_value), 2) AS total_value,
  ARRAY_AGG(DISTINCT currency IGNORE NULLS ORDER BY currency) AS currencies_seen
FROM conversion_events
GROUP BY 1, 2, 3, 4
ORDER BY event_day DESC, event_name, ads_storage, analytics_storage;
