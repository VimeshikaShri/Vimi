# Google Ads conversions and enhanced conversions

## Create conversion actions

In Google Ads, create distinct actions for `Lead submitted`, `Purchase`, `Qualified lead`, and `Closed won`. Set the appropriate category, counting method, value rule, attribution setting, and goal role in coordination with marketing and finance. Link Google Ads and GA4 only when the reporting/activation use case is approved; do not import duplicate GA4 and Google Ads tag conversions into the same bidding goal.

For lead generation, use an on-site Google Ads conversion tag for `Lead submitted`, and send downstream qualified/won events through the CRM feed. A conversion action should have exactly one authoritative source.

## Enhanced conversions implementation

Enable enhanced conversions only after accepting the applicable customer-data terms and confirming the organization meets the customer-data policies. Use GTM and a Google tag in the existing container.

1. In Google Ads, turn on enhanced conversions at the account or conversion-action level as appropriate and select the GTM / Google tag setup path.
2. In GTM, configure user-provided data from a well-defined source—not global DOM scraping. Prefer an application-generated `user_data` object that is available only at a confirmed conversion.
3. Gate enhanced-conversion data on the consent state that legal/CMP requires. `ad_user_data` must be granted before hashed first-party user data is sent for advertising measurement.
4. Keep the GA4 events free of PII. Map `user_data` to the Google tag only.
5. Publish after preview testing, then check Google Ads enhanced-conversion diagnostics after sufficient real traffic.

### Approved user-data shape

The app may place the following in the data layer only at a true conversion and only under the approved consent policy. GTM/Google tag handles normalization and hashing as supported by the selected Google implementation.

```js
user_data: {
  email: 'customer@example.com',
  phone_number: '+14155552671',
  address: {
    first_name: 'Ada',
    last_name: 'Lovelace',
    street: '1 Example Street',
    city: 'London',
    region: 'London',
    postal_code: 'SW1A 1AA',
    country: 'GB'
  }
}
```

This object is illustrative, not a license to collect every field. Send only fields the user supplied and that have been approved. Never make this data available to GA4 tags, custom pixels, logs, or data warehouse exports without an independent approved purpose.

## Current platform note (July 2026)

For new lead/offline setups, prefer **Enhanced Conversions for Leads with Google Ads Data Manager**. Google states that offline conversion import and enhanced-conversion-for-leads uploads were migrated to the Data Manager API on June 15, 2026, and legacy Google Ads API uploads are blocked except for eligible legacy access. This project therefore uses Data Manager as the default ingestion design.

## Diagnostics

Review conversion action status, tag diagnostics, and enhanced conversion diagnostics after production traffic begins. Investigate missing user-data matches, consent failures, incorrect selector/data-layer mapping, duplicate transaction IDs, and unexpected conversion volumes before changing bidding goals.

## Sources

- [Enhanced conversions with GTM](https://support.google.com/google-ads/answer/13262500)
- [Configure enhanced conversions for leads in GTM](https://support.google.com/google-ads/answer/11347292)
- [2026 enhanced-conversion updates](https://support.google.com/google-ads/answer/16884284)
