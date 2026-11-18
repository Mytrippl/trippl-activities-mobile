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
  await workspace.close();
  await cache.close();
  print(
    'Activities browser smoke passed: eligibility, exact money, discovery, availability, quotes and cache.',
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
