# Validation checklist

Run every test on staging first, then repeat the consented conversion path on production with an approved test record. Save screenshots, GTM version, browser/device, timestamp/time zone, and expected vs observed outcome in the release ticket.

## GTM Preview / Tag Assistant

- [ ] The initial `page_view` fires once; no duplicate Google tag is present from hard-coded site code.
- [ ] `generate_lead` appears only after a server-confirmed successful form submission, and contains non-empty `lead_id`, `value` (if used), `currency`, and `form_id`.
- [ ] `purchase` appears once with a non-empty unique `transaction_id`, numeric value, currency, and expected items.
- [ ] The GA4 event and its matching Google Ads conversion tag fire exactly once per test conversion.
- [ ] The Conversion Linker runs on intended pages and all live tags are scoped to the correct environment.
- [ ] Failed/cancelled forms, browser back navigation, and a repeat confirmation-page load do not create extra conversions.

## Consent Mode V2 matrix

| Scenario | Expected result |
| --- | --- |
| No choice yet | All four consent types have the configured default; no enhanced-conversion user data is sent. |
| Reject all | All relevant types remain denied; no ad/analytics cookies are stored by consent-aware Google tags. |
| Analytics only | `analytics_storage` is granted; advertising/UPD types remain denied. |
| Ads measurement yes, personalization no | `ad_storage` and `ad_user_data` are granted only if the CMP policy permits; `ad_personalization` stays denied. |
| Accept all | All approved types update to granted; tags respond without page-reload duplication. |

## GA4 DebugView

- [ ] Start GTM Preview/Tag Assistant for the test browser (or set `debug_mode: true` only for controlled test traffic).
- [ ] In **Admin → DebugView**, verify `page_view`, `generate_lead` / `purchase`, and their permitted parameters.
- [ ] Confirm unexpected parameters are absent: email, phone, name, address, raw click IDs, and other PII must never appear.
- [ ] Verify user properties/custom dimensions contain only approved low-cardinality values.
- [ ] Note that a denied Analytics consent state or client-side privacy controls can suppress DebugView visibility; this is expected behavior to log, not a reason to bypass consent.

## Google Ads and CRM

- [ ] Conversion action diagnostics show the tag and action as active after a valid test.
- [ ] Enhanced conversion diagnostics are reviewed after sufficient eligible real traffic—not judged from one test event.
- [ ] Data Manager test row is accepted with expected conversion action, time, value/currency, and de-duplication ID.
- [ ] Replaying the identical offline row results in duplicate protection rather than another counted conversion.
- [ ] A rejected row produces an actionable alert and does not silently disappear.

## BigQuery

- [ ] GA4 linked dataset `analytics_<property_id>` exists in the chosen BigQuery project/location.
- [ ] At least one daily table `events_YYYYMMDD` appears after link activation.
- [ ] [Data quality query](../bigquery/ga4_data_quality.sql) returns expected event volume and consent distributions.
- [ ] Dataset access, retention, and query-cost guardrails meet the organization’s policy.

## Release approval

Record marketing, engineering, analytics, CRM/RevOps, and privacy approvals. Attach the validated GTM version and rollback version. Monitor conversion volume, tag errors, data feed health, and consent signal distribution daily for 14 days.

## Source

[GA4 DebugView documentation](https://support.google.com/analytics/answer/7201382)
