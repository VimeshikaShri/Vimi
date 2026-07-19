# Consent Mode V2

Consent Mode is a technical control, not legal advice or a substitute for a CMP/privacy review. The site must collect consent as required in its target regions, send the user’s choice to Google, and ensure non-Google tags honor that choice too.

## Required ads and analytics signals

| Consent type | Purpose | Default |
| --- | --- | --- |
| `ad_storage` | Advertising cookies/device identifiers | `denied` unless policy/CMP supplies another permitted default |
| `analytics_storage` | Analytics cookies/device identifiers | `denied` unless policy/CMP supplies another permitted default |
| `ad_user_data` | Sending user data to Google for advertising measurement, including enhanced conversions | `denied` |
| `ad_personalization` | Personalized advertising | `denied` |

## Implementation order

1. Configure the CMP’s supported GTM/Google consent integration where available.
2. Set consent defaults in GTM’s **Consent Initialization** trigger—before all other tags execute.
3. When a user makes a choice, call the consent update immediately; the mapping must distinguish ads measurement from ads personalization where the CMP presents separate choices.
4. Set custom/third-party tags’ Additional Consent Checks in GTM; Google’s built-in tags already contain consent checks.
5. Test no-choice, reject, analytics-only, ads-measurement-only, and accept-all paths in every applicable region.

## Reference implementation (custom CMP only)

Put the default before the Google tag loads. Adapt the integration to the CMP; do not copy this as a complete banner.

```html
<script>
  window.dataLayer = window.dataLayer || [];
  function gtag(){ dataLayer.push(arguments); }
  gtag('consent', 'default', {
    ad_storage: 'denied',
    analytics_storage: 'denied',
    ad_user_data: 'denied',
    ad_personalization: 'denied',
    wait_for_update: 500
  });

  // Invoke only after the CMP has recorded a valid user choice.
  function updateGoogleConsent(choice) {
    gtag('consent', 'update', {
      analytics_storage: choice.analytics ? 'granted' : 'denied',
      ad_storage: choice.adsMeasurement ? 'granted' : 'denied',
      ad_user_data: choice.adsMeasurement ? 'granted' : 'denied',
      ad_personalization: choice.adsPersonalization ? 'granted' : 'denied'
    });
  }
</script>
```

The boolean mapping is a product/legal decision. Do not map an affirmative cookie preference automatically to `ad_user_data` unless the notice and consent policy allow advertising measurement/user-data use.

## Test evidence

In Tag Assistant Preview, record the Consent tab before and after the choice, confirm tags’ consent status, and inspect network requests only with approved test data. In GA4, consented DebugView tests should appear; GA4 documents that debug events may not appear when privacy controls/client-side blocking apply or Analytics cookies have not been consented to.

## Sources

- [Consent Mode overview](https://developers.google.com/tag-platform/security/concepts/consent-mode)
- [Google tag consent reference](https://developers.google.com/tag-platform/gtagjs/reference)
- [GA4 consent types](https://support.google.com/analytics/answer/12334711)
