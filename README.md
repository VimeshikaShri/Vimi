# End-to-End Google Ads Conversion Tracking

An implementation-ready, privacy-aware measurement blueprint for a lead-generation or ecommerce website. It connects a GTM web container, GA4 event collection, Google Ads conversions, enhanced conversions, CRM/offline outcomes, Consent Mode v2, DebugView, and GA4-to-BigQuery analysis. It is designed to be hosted in a private Notion workspace.

## What this project delivers

| Layer | Outcome |
| --- | --- |
| GTM | One web container, a dependable `dataLayer` contract, conversion linker, GA4 Google tag, Google Ads conversion tags, and consent controls. |
| GA4 | Recommended events and a clean funnel: `generate_lead` / `purchase` -> `qualified_lead` -> `closed_won`. |
| Google Ads | Separate primary online conversion actions and secondary diagnostics/micro-conversions; value and order-ID controls. |
| Enhanced conversions | User-provided first-party data is sent only when permitted by `ad_user_data` and only for a real conversion. |
| Offline outcomes | CRM pipeline updates are sent using Google Ads Data Manager, preserving GCLID/WBRAID/GBRAID and consent. |
| Privacy | Consent Mode v2 defaults, CMP updates, regional/legal review points, and auditable tests. |
| Analytics | DebugView test script plus GA4 BigQuery export and funnel/revenue SQL. |

## Start here

1. Read [implementation plan](docs/implementation-plan.md) and obtain the IDs/access in its preflight section.
2. Agree the event/field contract in [measurement specification](docs/measurement-specification.md) with the website and CRM teams.
3. Configure the GTM build from [container build sheet](docs/gtm-container-build.md). Do this in a GTM workspace; do **not** paste production IDs into this repository.
4. Implement the web `dataLayer` examples in [data-layer contract](templates/data-layer-contract.js), then configure the CMP integration from [Consent Mode V2](docs/consent-mode-v2.md).
5. Create Google Ads conversion actions and configure enhanced conversions as described in [Google Ads and enhanced conversions](docs/google-ads-and-enhanced-conversions.md).
6. Set up the CRM-to-Data-Manager feed from [offline conversion import](docs/offline-conversion-import.md).
7. Pass every scenario in the [validation checklist](docs/validation-checklist.md) before publishing the GTM container.
8. Link GA4 to BigQuery and schedule the queries in [BigQuery](bigquery/README.md).

## Operating rules

- Use stable `lead_id` / `transaction_id` values for de-duplication. A form submit is not a qualified lead; CRM lifecycle events own offline truth.
- Retain raw click IDs (`gclid`, `wbraid`, `gbraid`) with the lead record where lawful, but never put them in GA4 event parameters or user properties.
- Do not send email, phone, names, addresses, or any other PII to GA4. Enhanced conversions sends qualifying first-party data to the Google Ads tag under the applicable consent state.
- Keep `qualified_lead` and `closed_won` secondary in Google Ads during the 3–4 week parallel-validation window. Promote only the agreed bidding metric to primary.
- Configure every tag in a staging GTM environment first and publish production only after sign-off.

## Project layout

```text
docs/        Configuration, privacy, and test runbooks
templates/   Web/CRM examples to adapt to the implementation
bigquery/    Export setup, SQL, and data-quality checks
notion-import/  Importable Notion page and database templates
```

## Host in Notion

Follow [the Notion hosting guide](docs/notion-hosting.md). Import [the self-contained Notion page](notion-import/End-to-End%20Google%20Ads%20Conversion%20Tracking.md) into a private workspace, then import the CSV files in `notion-import/databases/` as Notion databases.

Do not publish this workspace to the web. Store all IDs, API keys, CRM exports, and consent records in access-controlled tools—not in the Notion documentation.

## Authoritative references

- [Consent Mode overview](https://developers.google.com/tag-platform/security/concepts/consent-mode)
- [GA4 consent types](https://support.google.com/analytics/answer/12334711)
- [Enhanced conversions with GTM](https://support.google.com/google-ads/answer/13262500)
- [Offline conversion import guidance](https://support.google.com/google-ads/answer/15081888)
- [GA4 DebugView](https://support.google.com/analytics/answer/7201382)
- [GA4 BigQuery export setup](https://support.google.com/analytics/answer/9823238)
