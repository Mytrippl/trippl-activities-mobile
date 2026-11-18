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

Build the complete FlutterFlow application using its actual dependencies. Exercise empty results, rapid searches, account changes, screen disposal, translations, media attribution and device layouts. Verify real provider payload mapping and retention terms before enabling network reads. Connect the booking, voucher and post-booking ports to authorized backend APIs; payment processing remains a host responsibility.

## Booking transport and recovery

Implement `ActivityBookingTransport` using the existing authenticated backend. Authorize scope, persist the intent and enforce its idempotency key before a supplier write. Bind responses to the intent ID, draft fingerprint, booking identity and accepted total. The mobile controller does not automatically repeat uncertain writes.

A timeout, connection failure or invalid receipt becomes an uncertain outcome. Use `lookupIntent` to reconcile it. Do not generate a new intent ID to retry an uncertain booking. Pending and confirmed receipts need monotonic supplier/backend revisions. Status observations use the separate booking-status reconciliation rules.

Persist the reviewed draft and intent before dispatch using an appropriate recovery strategy. The provided protected recovery store can retain contact and answer data only when the relevant consent is effective. The host must supply actual protected storage and a backend account-recovery path; checksums alone are not encryption or authorization. Restoring local state does not prove that a booking or payment succeeded.

## Customer review

Supplier question revisions are part of answer validation. Required traveler-scoped questions need one answer for every applicable traveler. The application should surface review reason codes before submission. Local question validation does not replace supplier-side checks.

Terms acceptance records the current quote digest and terms version. Repricing invalidates acceptance. Required names and phone details are controlled by the confirmation policy. Pickup selection must match the supplier pickup configuration, point identity, option and deadline.

Quote, inventory and cancellation-policy observations expire independently. Revalidate relevant data at review time. A successful draft review only permits a backend submission; confirmation requires a matching backend receipt.

## Cancellation and voucher boundaries

Implement cancellation through `ActivityCancellationTransport`; use lookup after uncertainty. A cancellation request is not a cancelled booking. Reported refunds must use the booking currency and cannot exceed the paid amount. Provider refund progress is distinct from bank settlement.

Voucher display requires eligible booking state, supplier documents and valid access conditions. Do not synthesize a ticket from product details. Clear revoked vouchers and cancel reminders when backend booking status changes.

## Saved content and ownership

Use the saved-content sync port only for saved activities, collections, itineraries and preferences. It deliberately rejects booking and cancellation resources. Persist queued saved-content state before sending and resolve conflicting payloads explicitly; recording a conflict choice does not secretly rewrite a booking.

Account deletion must target every store owned by the host, including separately held itinerary IDs, protected draft IDs, discovery caches and platform reminders. The lifecycle erasure helper reports failed requested deletions and does not claim remote deletion. Resolve active uncertain operations before removing the recovery information needed by the host.

## Application release checks

Build and test the complete FlutterFlow host app before release. Exercise account changes, expired quotes, required answers, rapid duplicate taps, interrupted submissions, backend lookup, voucher revocation, cancellation uncertainty and notification permission changes. Test actual protected storage and provider payload mappings on the intended devices. The repository's fake transports verify local behavior without performing real bookings or cancellations.
