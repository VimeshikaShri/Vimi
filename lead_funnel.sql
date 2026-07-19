-- Daily web funnel. Replace YOUR_PROJECT.analytics_PROPERTY_ID.
-- This query uses opaque lead IDs and transaction IDs; it does not select PII.

WITH events AS (
  SELECT
    PARSE_DATE('%Y%m%d', event_date) AS event_day,
    event_name,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'form_id') AS form_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'lead_id') AS lead_id,
    (SELECT value.string_value FROM UNNEST(event_params) WHERE key = 'transaction_id') AS transaction_id,
    COALESCE(
      (SELECT value.double_value FROM UNNEST(event_params) WHERE key = 'value'),
      CAST((SELECT value.int_value FROM UNNEST(event_params) WHERE key = 'value') AS FLOAT64)
    ) AS value
  FROM `YOUR_PROJECT.analytics_PROPERTY_ID.events_*`
  WHERE _TABLE_SUFFIX BETWEEN FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 90 DAY))
                          AND FORMAT_DATE('%Y%m%d', DATE_SUB(CURRENT_DATE(), INTERVAL 1 DAY))
    AND event_name IN ('generate_lead', 'purchase')
)
SELECT
  event_day,
  COALESCE(form_id, '(not applicable)') AS form_id,
  COUNT(DISTINCT IF(event_name = 'generate_lead', lead_id, NULL)) AS submitted_leads,
  COUNT(DISTINCT IF(event_name = 'purchase', transaction_id, NULL)) AS purchases,
  ROUND(SUM(IF(event_name = 'purchase', value, 0)), 2) AS purchase_value
FROM events
GROUP BY 1, 2
ORDER BY event_day DESC, form_id;
