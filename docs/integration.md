# Activities Integration

## Application ownership

Keep the existing custom-function locations when importing the code into FlutterFlow. They depend on generated structs, enums and Flutter imports supplied by the application. The existing parameter interfaces remain preserved.

Import `package:trippl_activities_mobile/trippl_activities_mobile.dart` for the new core. Supply one controller and workspace per discovery screen, an account scope, a UTC clock and a provider implementation. Close the workspace on disposal; it closes its controller. A debouncer coordinates its supplied controller and must have an explicit screen owner. The host owns optional cache storage and closes it separately.

No Firebase configuration, credentials or deployed resources are changed by this package.

## Provider boundary

`ActivityProviderAdapter` consumes normalized canonical data, not arbitrary raw supplier responses. The host maps product codes, option codes, age bands, prices, timestamps and provider status values before decoding. Field masks are internal projection hints rather than vendor API field names.

`ActivityProvider.fetch` returns a page bound to `ActivityRequests.fingerprint(request)`. Pages carry UTC observation and expiry instants, explicit completeness or a continuation cursor and bounded result lists. Continuation cursors are excluded from the query fingerprint so search pages can be merged. The transport must bind cursors to their actual query; fingerprints are not authorization tokens.

Use read-only provider operations for this stage. Search results do not include unrelated availability or quote payloads. The backend must enforce authorization, supplier credentials, throttling and any eventual reservation, payment or cancellation operation.

## Prices and travelers

Prices use `amountMinor`, a currency code and explicit decimal precision. Do not combine different currencies or precisions. Local price calculations are indicative and use validated traveler categories. Unknown age bands or conflicting price rules prevent a valid calculation.

Per-unit quantities are part of availability and quote fingerprints. Quotes must correspond to the checked party, date, option, slot, language and currency. Provider quote components, where supplied, must reconcile with the total. No call in this package reserves inventory or charges money.

## Dates, freshness and cancellation

Travel dates are UTC date-only records representing the selected local calendar day. Supply the actual local offset when assessing slots. This package does not resolve IANA time-zone rules or daylight-saving changes.

Availability requires explicit slot status, capacity and freshness. Offline results cannot confirm availability. Readiness checks re-evaluate quote and slot expiry at the current clock instant and still require backend booking confirmation.

Cancellation tier cutoffs are explicit UTC instants. A tier applies through its cutoff instant; later tiers may reduce the refund. Fees reduce the calculated refund and cannot make it negative. Policy assessments are informational and do not execute a cancellation.

## Presentation and legacy helpers

Render provider, review and photo attribution with the corresponding content. Unknown accessibility is distinct from a confirmed negative value. Guide languages distinguish guided, audio and written delivery.

The legacy price-label helper has no pricing-basis input, so it now presents a neutral starting-price label. Standard cancellation text asks the user to check actual terms rather than promising an unconditional full refund. Supplier age validation recognizes startAge/endAge. Legacy distance and rating helpers reject invalid nonfinite values.

## Remaining host checks

Build the complete FlutterFlow application using its actual dependencies. Exercise empty results, rapid searches, account changes, screen disposal, translations, media attribution and device layouts. Verify real provider payload mapping and retention terms before enabling network reads. Add reservation, payment, voucher and post-booking flows separately through authorized backend APIs.
