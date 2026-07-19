# Measurement specification

## Funnel and ownership

| Business stage | Web/CRM event | GA4 collection | Google Ads conversion action | Default goal role |
| --- | --- | --- | --- | --- |
| Form successfully submitted | `generate_lead` | Yes | `Lead submitted` | Primary only if this is the intended bidding outcome |
| Ecommerce order complete | `purchase` | Yes | `Purchase` | Primary |
| Sales accepts/qualifies lead | `qualified_lead` | Optional server/Measurement Protocol reporting only; never send PII | `Qualified lead` via CRM feed | Secondary during validation |
| Deal is won | `closed_won` | Optional aggregate reporting only | `Closed won` via CRM feed | Secondary during validation |

Keep business-stage names stable. Any rename requires new conversion-action mapping, release notes, and a reporting cutover date.

## Event fields

| Field | `generate_lead` | `purchase` | Source / rule |
| --- | --- | --- | --- |
| `event` | Required | Required | Exact GA4 recommended event name. |
| `lead_id` / `transaction_id` | Required | Required | Stable, opaque, non-PII identifier. Never use an email or phone number. |
| `value` | Recommended | Required | Numeric. Use `0` only when value is genuinely unknown. |
| `currency` | If value | Required | ISO 4217, e.g. `USD`. |
| `form_id` | Recommended | — | Controlled vocabulary, e.g. `demo_request`. |
| `items` | — | Recommended | GA4 ecommerce item array; no PII. |
| `user_data` | Only for Ads enhanced conversions | Only for Ads enhanced conversions | GTM Google tag data; do not map to GA4. |

## CRM lead record contract

Store the following at lead creation, subject to the approved retention policy: `lead_id`, original event timestamp/time zone, landing URL (without unnecessary sensitive query strings), `gclid`, `wbraid`, `gbraid`, consent state at submit, consent capture timestamp/version, first-party contact fields for approved hashed matching, and lifecycle timestamps/statuses. Do not overwrite original click identifiers on later visits.

## Conversion-value policy

- `Lead submitted`: use a fixed expected value only if finance has approved it; otherwise track as a count but retain its role as secondary.
- `Qualified lead`: amount is the agreed expected gross margin or projected revenue, not an arbitrary constant.
- `Closed won`: actual signed/paid value and currency from CRM; use a unique `order_id`.
- Upload adjustments/refunds according to the documented finance process, with the same ID mapping.

## Parameter governance

Use lower snake_case values, maintain a controlled list for `form_id` and `lead_type`, and review GA4 custom dimensions before registering them. Never register identifiers such as user ID, click ID, email, or lead ID as GA4 custom dimensions.
