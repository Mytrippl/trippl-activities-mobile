# Trippl Activities Mobile

Mobile-side activity discovery, traveler eligibility, option pricing, availability, cancellation and experience presentation used within Mytrippl.

The repository contains the existing FlutterFlow custom functions and an independently testable Dart processing layer. It prepares activity searches, validates supplier age bands, calculates traveler-adjusted prices and coordinates option, departure and quote selection. Inventory and booking operations are supplied separately by the host application and backend.

## Activity Discovery

`ActivitySearch` applies destination, text, category, rating, duration, guide-language, accessibility, cancellation and distance filters. Price ranges carry an explicit currency. Results have stable ordering, pagination and completeness information. Missing ratings, prices and accessibility details remain unknown.

`ActivityRequests` creates account-scoped search, detail, availability and quote reads. `ActivityDiscoveryController` validates response identity and freshness, bounds retries and prevents late responses from replacing newer state. `ActivitySearchDebouncer` coordinates rapid search edits. `ActivityPagination` detects repeated cursors and conflicting product snapshots.

## Travelers and Age Bands

`ActivityTravelers` recognizes supplier `startAge` and `endAge` fields and validates category bounds, overlapping bands, booking limits and adult accompaniment. Capacity-exempt travelers remain included in the total party. Missing supplier age bands require review rather than being replaced with invented eligibility rules.

Traveler records contain the information needed for this stage: an internal identifier, age and optional category context. They do not require names or contact details.

## Activity Pricing

`ActivityAmounts` represents money in integer minor units with explicit currency precision. Decimal parsing does not guess thousands separators or silently round excess precision.

`ActivityPricing` supports per-person, per-group and per-unit rules, separates taxes, fees and discounts, and rejects ambiguous rule selection. Provider quotes are bound to a product, option, slot, currency and request fingerprint and have an explicit expiry. Local calculations remain indicative until the provider supplies a valid quote.

`ActivityOptionQuotes` compares calculated totals for the same party. `ActivityComparisonBoard` compares up to four activities and flags differences in pricing basis or currency precision.

## Availability and Departure Selection

`ActivityInventory` requires fresh slot status, known capacity, traveler eligibility and an explicit local UTC offset before presenting availability. A non-empty slot list alone does not establish bookability. Selected guide languages, meeting points and pickup choices are validated against the option and departure context.

`ActivityWorkspace` coordinates discovery, local refinement, comparison inputs, product and option selection, availability reads and quote review. Changing relevant query or selection inputs invalidates dependent availability and quotes. Readiness means the selection can proceed to host review; it does not confirm a booking or payment.

## Cancellation and Details

Cancellation assessments use explicit cutoffs, refund percentages and fees. Unknown or expired policy data stays unresolved. A generic standard policy without deadlines is not presented as an unconditional refund promise.

Detail presentation covers fixed and ranged durations, guide, audio and written languages, reviews, photos, inclusions, meeting instructions and accessibility. Attribution remains attached to displayed provider and media content. Resource links must use credential-free HTTPS.

## Local Discovery Cache

`ActivityDiscoveryCache` accepts a host-provided `ActivityLocalStorage`. Entries are account-scoped, size bounded and checked for integrity and expiry. Stale restoration is explicit. Live availability and quotes are not cached as discovery pages.

The host controls device storage protection, account sign-out cleanup and provider retention rules. Checksums detect corruption; they do not provide encryption or authentication.

## Repository Structure

- `lib/custom_code/functions`: existing FlutterFlow helpers with preserved parameter interfaces.
- `lib/activity_core/models`: typed activity, traveler, pricing, policy and discovery records.
- `lib/activity_core`: validation, requests, provider coordination, search, cache and presentation services.
- `lib/trippl_activities_mobile.dart`: package exports.
- `test`: offline contract, domain, lifecycle and legacy-helper regression tests.
- `tool`: model generation, compatibility checks, source inventory and packaging.

## Development

Use Dart 3.13.7:

```sh
dart pub get --enforce-lockfile
dart analyze
dart test
python3 tool/verify_generated.py
python3 tool/verify_host_interfaces.py
python3 tool/verify_legacy_helpers.py
python3 tool/source_inventory.py
```

Record definitions and validation rules live in `tool/activity_models.json` and `tool/activity_rules.json`. Run `python3 tool/generate_activity_models.py` to regenerate them, then format the model directory using Dart language version 3.10.

The standalone analyzer excludes FlutterFlow custom code because the full generated application and its platform dependencies are not included here. Three pure legacy helpers are tested through verified source extraction. The original function parameter interfaces are checked separately.

See [integration notes](docs/integration.md) and [verification](docs/verification.md) for transport responsibilities and application testing boundaries.

## Source Package

Run `python3 tool/package_source.py` after committing changes. The tool writes a deterministic source archive, checksum and file manifest to `dist/` and verifies the archive contents. This is a source package, not an application binary.
