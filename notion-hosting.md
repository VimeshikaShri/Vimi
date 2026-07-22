## Import package

1. In Notion desktop or web, create a private parent page named **End-to-End Google Ads Conversion Tracking** in the approved teamspace.
2. On that page, use **Import → Text & Markdown** and upload [End-to-End Google Ads Conversion Tracking.md](../notion-import/End-to-End%20Google%20Ads%20Conversion%20Tracking.md). Notion will create a normal Notion page from its headings, tables, lists, and code blocks.
3. Move the imported page under the new parent and add a `/table of contents` block below the title if helpful.
4. Use **Import → CSV** to add [Conversion Registry.csv](../notion-import/databases/Conversion%20Registry.csv) and [Measurement Release Log.csv](../notion-import/databases/Measurement%20Release%20Log.csv) as databases. Move both under the parent page.
5. Limit sharing to the measurement team, engineering, RevOps, and privacy stakeholders. Keep the page unshared/public and do not put credentials, production IDs, or personal data into it.

Notion supports Markdown as an imported page and CSV as an imported database. Imports are available on Notion desktop and web. The package uses only standard Markdown because anchor links and nonstandard Markdown extensions may not import cleanly.

## Recommended page structure

```text
End-to-End Google Ads Conversion Tracking (private parent page)
├── Implementation guide (imported Markdown page)
├── Conversion Registry (database)
├── Measurement Release Log (database)
├── GTM container export (restricted attachment or secure-link only)
└── Validation evidence (restricted subpage)
```

## Database configuration after CSV import

### Conversion Registry

- Convert `Owner` to **Person** or **Select** and `Goal role` / `Status` to **Select**.
- Convert `Primary?` and `Enhanced conversions?` to **Checkbox**.
- Add views: `Bidding goals`, `Offline CRM goals`, and `Needs review` (where Status is not Live).
- Keep actual Google Ads conversion IDs/labels in a secure internal field only if workspace access is appropriately restricted.

### Measurement Release Log

- Convert `Release date` to **Date**, `Status` to **Select**, and `Approver` / `Owner` to **Person** where available.
- Add a relation to **Conversion Registry**, then add a rollup for conversion status if helpful.
- Add views: `Pending approval`, `Published`, and `Rollback candidates`.

## Operating cadence

- **Before each release:** create a release-log item, attach validation evidence, identify the prior GTM version, and obtain named approval.
- **Daily for 14 days after release:** review tag errors, conversion volume, consent distribution, and offline feed health.
- **Weekly:** reconcile CRM outcomes with accepted Data Manager imports and review enhanced-conversion diagnostics.
- **Quarterly:** review the conversion registry, purpose/consent policy, user access, data retention, and GA4/BigQuery cost/quality.

## Sources

- [Notion: Import data](https://www.notion.com/help/import-data-into-notion)
- [Notion: Export content](https://www.notion.com/help/export-your-content)
