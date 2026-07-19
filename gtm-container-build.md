# GTM web container build sheet

Create this in a new **staging workspace**. Use GTM environments to prevent production tags from firing on staging domains.

## Variables

| Name | Type | Configuration |
| --- | --- | --- |
| `DLV lead_id` | Data Layer Variable | `lead_id` |
| `DLV transaction_id` | Data Layer Variable | `transaction_id` |
| `DLV value` | Data Layer Variable | `value` |
| `DLV currency` | Data Layer Variable | `currency` |
| `DLV form_id` | Data Layer Variable | `form_id` |
| `DLV user_data` | Data Layer Variable | `user_data`; only used by Google tag enhanced-conversion config |
| `CE generate_lead` | Custom Event trigger | Event name exactly `generate_lead` |
| `CE purchase` | Custom Event trigger | Event name exactly `purchase` |
| `Lookup environment` | Lookup Table | Hostname → `staging` / `production`; use for tag firing guardrails |

## Tags

| Tag | Trigger | Required configuration |
| --- | --- | --- |
| Google tag / GA4 configuration | Initialization / All Pages after consent default | Measurement ID placeholder `G-XXXX`; send page views once; consent-aware. |
| Conversion Linker | All Pages | Leave default settings unless approved requirements dictate otherwise; consent-aware. |
| GA4 Event generate_lead | `CE generate_lead` | Event name `generate_lead`; map `lead_id`, `value`, `currency`, `form_id`; do not map `user_data`. |
| GA4 Event purchase | `CE purchase` | Event name `purchase`; map `transaction_id`, `value`, `currency`, `items`. |
| Google Ads Conversion Lead submitted | `CE generate_lead` | Enter Ads conversion ID/label; pass value/currency and transaction ID if the conversion type supports it. |
| Google Ads Conversion Purchase | `CE purchase` | Enter Ads conversion ID/label; pass value/currency/transaction ID. |

Configure enhanced conversions in the Google tag / Google Ads conversion setup using the approved `user_data` object, as described in [Google Ads and enhanced conversions](google-ads-and-enhanced-conversions.md). Do not create a generic custom HTML tag that reads form fields indiscriminately.

## Trigger safeguards

1. Trigger success events only after the server acknowledges the lead/order; do not trigger on submit-button clicks.
2. Require a non-empty opaque `lead_id` or `transaction_id` before a conversion tag can fire.
3. Add a blocking trigger or exception for test/internal traffic where that is part of the reporting policy.
4. Keep one conversion tag per business conversion action. Avoid combining multiple actions into one tag.

## Version control

For each publish: capture GTM container ID, workspace, version number, environment, submitter, approver, release ticket, change summary, validation evidence, and rollback version. Export the container JSON from GTM to an access-controlled system; it contains configuration details and should not be committed with production IDs.
