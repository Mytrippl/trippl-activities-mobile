import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';

void check(bool value, String message) {
  if (!value) throw StateError(message);
}

Future<void> main() async {
  final now = DateTime.utc(2026, 11, 18, 12);
  final party = ActivityTravelerMix(
    travelers: [ActivityTraveler(id: 'adult', age: 30)],
  );
  final option = ActivityOption(
    id: 'option',
    productId: 'product',
    title: 'Guided tour',
    ageBands: [
      ActivityAgeBand(
        id: 'adult',
        category: 'adult',
        startAge: 18,
        endAge: 120,
      ),
    ],
    priceRules: [
      ActivityPriceRule(
        id: 'price',
        money: ActivityMoney(currency: 'USD', amountMinor: 1234),
      ),
    ],
  );
  final product = ActivityProduct(
    id: 'product',
    title: 'Museum tour',
    options: [option],
    observedAt: now,
    expiresAt: now.add(const Duration(hours: 1)),
  );
  final slot = ActivitySlot(
    id: 'slot',
    productId: 'product',
    optionId: 'option',
    startsAt: now.add(const Duration(hours: 2)),
    remainingCapacity: 10,
    state: 'available',
    observedAt: now,
    expiresAt: now.add(const Duration(minutes: 10)),
  );
  final factory = ActivityRequests(scope: 'smoke', clock: () => now);
  final controller = ActivityDiscoveryController(
    SmokeProvider(product, slot, now),
    scope: 'smoke',
    clock: () => now,
  );
  final cache = ActivityDiscoveryCache(SmokeStorage(), scope: 'smoke');
  final workspace = ActivityWorkspace(
    controller: controller,
    clock: () => now,
    cache: cache,
  );
  check(
    await workspace.refresh(factory.search(ActivitySearchQuery())),
    'Discovery read',
  );
  workspace.select(
    'product',
    optionId: 'option',
    expectedRevision: workspace.revision,
  );
  final input = ActivityAvailabilityRequest(
    productId: 'product',
    optionId: 'option',
    travelDate: DateTime.utc(2026, 11, 18),
    travelers: party,
    currency: 'USD',
  );
  check(
    await workspace.checkAvailability(
      factory.availability(input),
      offsetMinutes: 0,
      expectedRevision: workspace.revision,
    ),
    'Availability read',
  );
  workspace.selectSlot('slot', expectedRevision: workspace.revision);
  check(
    await workspace.checkQuote(
      factory.availability(input.copyWith(selectedSlotId: 'slot'), quote: true),
      expectedRevision: workspace.revision,
    ),
    'Quote read',
  );
  check(workspace.review().readyForHostReview, 'Bound selected quote');
  check(
    workspace.review().toJson()['bookingConfirmed'] == false,
    'No booking write',
  );
  check(
    ActivityPricing.calculate(
          option,
          party,
          currency: 'USD',
          now: now,
        ).total.amountMinor ==
        1234,
    'Exact price',
  );
  check(
    ActivityAmounts.parse('12.34', currency: 'USD').amountMinor == 1234,
    'Exact decimal parse',
  );
  final discount = ActivityAmounts.percent(
    ActivityMoney(currency: 'USD', amountMinor: 9000000000000),
    9999,
  );
  check(discount.amountMinor == 8999100000000, 'Web-safe refund arithmetic');
  final req = factory.search(ActivitySearchQuery());
  check(
    (await cache.load(req, now: now))!.offline,
    'Account-scoped discovery cache',
  );

  final selectedInput = input.copyWith(selectedSlotId: 'slot');
  final draft = ActivityBookingDrafts(
    ActivityBookingDrafts.create(
      id: 'draft',
      scope: 'smoke',
      product: product,
      slot: slot,
      selection: selectedInput,
      offsetMinutes: 0,
      now: now,
    ),
    clock: () => now,
  );
  draft.contact(
    ActivityBookingContact(email: 'guest@example.com', updatedAt: now),
    expectedRevision: draft.value.revision,
  );
  final quoteRequest = factory.availability(selectedInput, quote: true);
  draft.quote(
    ActivityPriceQuote(
      id: 'booking-quote',
      productId: 'product',
      optionId: 'option',
      slotId: 'slot',
      requestFingerprint: ActivityRequests.fingerprint(quoteRequest),
      observedAt: now,
      expiresAt: now.add(const Duration(minutes: 3)),
      total: ActivityMoney(currency: 'USD', amountMinor: 1234),
      indicative: false,
    ),
    quoteRequest,
    expectedRevision: draft.value.revision,
  );
  draft.acceptTerms(
    id: 'terms',
    termsVersion: 'v1',
    accepted: true,
    expectedRevision: draft.value.revision,
  );
  final confirmation = ActivityConfirmationPolicy(termsVersion: 'v1');
  final intent = ActivityBookingIntents.prepare(
    draft.value,
    confirmation,
    id: 'intent',
    now: now,
    confirmedByUser: true,
  );
  final bookingController = ActivityBookingController(
    SmokeBookingTransport(now),
    scope: 'smoke',
    clock: () => now,
  );
  final bookingOutcome = await bookingController.submit(
    draft.value,
    intent,
    policy: confirmation,
    confirmedByUser: true,
  );
  check(bookingOutcome.confirmed, 'Matching backend booking receipt');
  final saved = ActivitySavedLibrary(scope: 'smoke', clock: () => now);
  saved.save(product, id: 'saved');
  final account = ActivityAccountStore(
    SmokeStorage(),
    scope: 'smoke',
    clock: () => now,
  );
  await account.saveLibrary(saved.checkpoint());
  check(
    (await account.loadLibrary())!.saved.single.product.id == 'product',
    'Saved graph persistence',
  );
  final trip = ActivityItineraries(
    ActivityItinerary(
      id: 'trip',
      scope: 'smoke',
      title: 'Museum day',
      startDate: DateTime.utc(2026, 11, 18),
      endDate: DateTime.utc(2026, 11, 18),
      createdAt: now,
      updatedAt: now,
    ),
    clock: () => now,
  );
  trip.addDay(
    id: 'day',
    date: DateTime.utc(2026, 11, 18),
    offsetMinutes: 0,
    expectedRevision: 1,
  );
  trip.addStop(
    'day',
    product,
    id: 'stop',
    startsAt: bookingOutcome.record!.startsAt,
    endsAt: bookingOutcome.record!.startsAt.add(const Duration(hours: 1)),
    expectedRevision: 2,
    booking: bookingOutcome.record,
  );
  check(trip.conflicts().isEmpty, 'Confirmed activity itinerary');
  final calendar = ActivityPortability.calendar(trip, id: 'export', now: now);
  check(
    calendar.content.contains('STATUS:CONFIRMED'),
    'Calendar reflects backend booking state',
  );
  final cancellation = ActivityCancellations(
    SmokeCancellationTransport(now),
    scope: 'smoke',
    clock: () => now,
  );
  final cancelRequest = ActivityCancellations.prepare(
    bookingOutcome.record!,
    id: 'cancel',
    reasonCode: 'plansChanged',
    confirmedByUser: true,
    now: now,
  );
  check(
    (await cancellation.submit(cancelRequest, bookingOutcome.record!))!.state ==
        'cancelled',
    'Matched cancellation response',
  );
  final privacy = ActivityAccountPrivacy(
    scope: 'smoke',
    clock: () => now,
    policyVersion: 'v1',
  );
  check(!privacy.permitted('draftDetails'), 'Private detail retention default');
  cancellation.close();
  await bookingController.close();
  await saved.close();
  await account.close();
  await workspace.close();
  await cache.close();
  print(
    'Activities browser smoke passed: discovery, booking receipts, cancellation, saved storage, itinerary and privacy.',
  );
}

class SmokeProvider implements ActivityProvider {
  SmokeProvider(this.product, this.slot, this.now);
  final ActivityProduct product;
  final ActivitySlot slot;
  final DateTime now;
  @override
  Future<ActivityProviderPage> fetch(ActivityProviderRequest request) async =>
      ActivityProviderPage(
        id: 'page-${request.id}',
        requestFingerprint: ActivityRequests.fingerprint(request),
        observedAt: now,
        expiresAt: now.add(const Duration(minutes: 5)),
        products: request.mode == 'search' ? [product] : [],
        slots: request.mode == 'availability' ? [slot] : [],
        quotes: request.mode == 'quote'
            ? [
                ActivityPriceQuote(
                  id: 'quote',
                  productId: 'product',
                  optionId: 'option',
                  slotId: 'slot',
                  requestFingerprint: ActivityRequests.fingerprint(request),
                  observedAt: now,
                  expiresAt: now.add(const Duration(minutes: 3)),
                  total: ActivityMoney(currency: 'USD', amountMinor: 1234),
                  indicative: false,
                ),
              ]
            : [],
        complete: true,
      );
}

class SmokeStorage implements ActivityLocalStorage {
  final values = <String, String>{};
  @override
  Future<String?> read(String key) async => values[key];
  @override
  Future<void> write(String key, String value) async {
    values[key] = value;
  }

  @override
  Future<void> remove(String key) async {
    values.remove(key);
  }
}

class SmokeBookingTransport implements ActivityBookingTransport {
  SmokeBookingTransport(this.now);
  final DateTime now;
  ActivityBookingReceipt _receipt(ActivityBookingIntent intent) =>
      ActivityBookingReceipt(
        intentId: intent.id,
        scope: intent.scope,
        draftFingerprint: intent.draftFingerprint,
        receivedAt: now,
        state: 'confirmed',
        bookingId: 'booking',
        total: intent.total,
      );
  @override
  Future<ActivityBookingReceipt> submit(
    ActivityBookingIntent intent,
    ActivityBookingDraft draft,
  ) async => _receipt(intent);
  @override
  Future<ActivityBookingReceipt> lookupIntent(
    ActivityBookingIntent intent,
  ) async => _receipt(intent);
  @override
  Future<ActivityBookingStatus> status(String scope, String bookingId) async =>
      ActivityBookingStatus(
        bookingId: bookingId,
        scope: scope,
        observedAt: now,
        state: 'confirmed',
      );
}

class SmokeCancellationTransport implements ActivityCancellationTransport {
  SmokeCancellationTransport(this.now);
  final DateTime now;
  @override
  Future<ActivityCancellationResult> cancel(
    ActivityCancellationRequest request,
  ) async => ActivityCancellationResult(
    requestId: request.id,
    scope: request.scope,
    bookingId: request.bookingId,
    receivedAt: now,
    state: 'cancelled',
  );
  @override
  Future<ActivityCancellationResult> lookupCancellation(
    ActivityCancellationRequest request,
  ) => cancel(request);
}
