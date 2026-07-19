# Offline conversion import (CRM → Google Ads Data Manager)

## Recommended design

Use **Google Ads Data Manager** for a governed connection from the CRM or warehouse source to the `Qualified lead` and `Closed won` conversion actions. The source should export newly changed lifecycle records on an agreed schedule. Include records from all channels in the source when feasible; Google Ads performs attribution for eligible ad interactions.

Do not use client-side JavaScript to infer qualification or revenue. CRM is the system of record for offline status, conversion time, amount, and currency.

## Source schema

| Field | Required | Notes |
| --- | --- | --- |
| `conversion_name` | Yes | Exact Google Ads action name, e.g. `Qualified lead`. |
| `conversion_time` | Yes | ISO timestamp with explicit time-zone offset; CRM event time, not upload time. |
| `gclid` | Strongly recommended | Preserve original click ID. Required when no tag/user-data path provides matching data. |
| `wbraid` / `gbraid` | When present | Preserve from the landing URL for privacy-safe attribution. |
| `email`, `phone`, `address` | At least one where enhanced lead conversions are used | First-party data, normalized/hashed as required by the selected Data Manager mapping. |
| `order_id` | Strongly recommended | Stable CRM opportunity/order ID for de-duplication and adjustments. |
| `conversion_value`, `currency` | Recommended; required for revenue reporting | Use real/approved economic value, e.g. `1250.00`, `USD`. |
| `consent` | Strongly recommended | Populate based on captured consent and legal policy. |
| `session_attributes` | Recommended where available | Preserve approved attributes needed for campaign performance. |

The mapping UI and required headers can vary by source/connection. Generate the live template inside Data Manager and map it to these canonical CRM fields; do not assume a historical CSV/API schema remains current.

## Sample staging CSV

```csv
conversion_name,conversion_time,gclid,wbraid,gbraid,email,phone,order_id,conversion_value,currency,consent
Qualified lead,2026-07-19T14:25:00+05:30,EAIaIQobChMIexample,,,,lead_8f3b6a,150.00,USD,GRANTED
Closed won,2026-07-20T09:00:00+05:30,EAIaIQobChMIexample,,,,opp_20a4d9,1250.00,USD,GRANTED
```

Examples deliberately use fake IDs and blank customer fields. Never commit customer data, real click IDs, or real consent records to this repository.

## Data-quality and reconciliation

1. Test with internal/staging leads that have known timestamps and IDs.
2. Check the Data Manager/import diagnostics for accepted, rejected, and duplicate rows.
3. Reconcile CRM outcomes to accepted uploads daily for the first two weeks, then weekly.
4. Alert on late uploads, source lag, missing click IDs/consent, invalid timestamps, action-name mismatch, and duplicate `order_id`.
5. Re-run only failed/changed records using stable IDs; do not create a second conversion by changing timestamps casually.

## Timing and migration safeguards

Google’s current guidance says standard offline conversions uploaded more than 90 days after the associated last click are not imported; enhanced-conversions-for-leads uploads have a 63-day limit. Queue processing therefore must target at least daily delivery and alert well before 60 days. Legacy offline imports should migrate to enhanced conversions for leads/Data Manager rather than starting a new legacy process.

## Sources

- [Offline conversion import guidance](https://support.google.com/google-ads/answer/15081888)
- [Upgrade offline imports](https://support.google.com/google-ads/answer/14274408)
- [Offline conversion import overview](https://support.google.com/google-ads/answer/2998031)
