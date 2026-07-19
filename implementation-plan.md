# Implementation plan

## Preflight

| Owner | Required access / decision |
| --- | --- |
| Marketing | Google Ads Standard/Admin access; conversion naming, values, and which action is used for bidding. |
| Analytics | GA4 Editor; GTM Publish (or workflow approval); GA4 ↔ Google Ads link decision. |
| Engineering | Staging and production release path; site-wide `dataLayer` ownership; confirmation and error states. |
| CRM / RevOps | Lead ID, lifecycle status mapping, source-data retention, Data Manager access, and feed cadence. |
| Legal / Privacy | Approved CMP configuration, regions, lawful basis, retention, and permissions for advertising data use. |
| Cloud / Data | BigQuery project, billing, least-privilege access, dataset location, and cost owner. |

**Inputs to record securely:** `GTM-XXXX`, `G-XXXX`, Google Ads customer ID, conversion labels/IDs, GA4 property ID, BigQuery project/dataset, CRM source, CMP vendor, production/staging domains, and applicable regions.

## Delivery sequence

1. **Design:** approve the [measurement specification](measurement-specification.md), conversion values, and consent policy.
2. **Instrument:** implement the `dataLayer` contract on staging and persist click IDs plus consent with the lead in CRM.
3. **Tag:** build GTM in a staging workspace; create GA4 and Google Ads conversion actions as secondary while testing.
4. **Privacy test:** prove all four Consent Mode V2 signals default and update correctly; confirm no PII reaches GA4.
5. **Validate:** use GTM Preview/Tag Assistant, GA4 DebugView, Google Ads diagnostics, and the CRM upload report.
6. **Release:** obtain sign-off, publish the GTM version, annotate GA4/Ads, and capture container/version IDs in the change log.
7. **Optimize:** move validated qualified/closed outcomes through a parallel reporting period before they become bidding goals.

## Definition of done

- GTM preview shows exactly one intended GA4 event and one intended Ads conversion tag per conversion.
- GA4 DebugView receives the expected parameters for consented test traffic.
- Google Ads status/diagnostics show recent conversion activity and enhanced-conversion processing without errors.
- A CRM outcome upload is accepted, deduplicated by `order_id`, and has a documented reconciliation result.
- Consent is captured in CRM and feeds; denied users do not send enhanced-conversion user data.
- GA4 daily export appears in BigQuery and the data-quality query returns expected counts.
- A rollback version and named owners are recorded.

## Rollback

If tags overfire, reveal an unexpected parameter, or do not respect consent: pause Google Ads conversion actions if needed, immediately publish the last known-good GTM version, revoke the faulty Data Manager source/CRM feed, document the impact window, and retest in staging before re-release.
