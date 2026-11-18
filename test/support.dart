import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';

final now = DateTime.utc(2026, 11, 18, 12);
ActivityMoney money(int minor, {String currency = 'USD', int decimals = 2}) =>
    ActivityMoney(currency: currency, amountMinor: minor, decimals: decimals);
ActivityTravelerMix travelers({
  List<int> ages = const [30],
  String basis = 'perPerson',
}) => ActivityTravelerMix(
  travelers: [
    for (var i = 0; i < ages.length; i++)
      ActivityTraveler(id: 'traveler-$i', age: ages[i]),
  ],
  pricingBasis: basis,
);
List<ActivityAgeBand> get bands => [
  ActivityAgeBand(id: 'adult', category: 'adult', startAge: 18, endAge: 120),
  ActivityAgeBand(
    id: 'child',
    category: 'child',
    startAge: 3,
    endAge: 17,
    requiresAdult: true,
  ),
  ActivityAgeBand(
    id: 'infant',
    category: 'infant',
    startAge: 0,
    endAge: 2,
    countsTowardCapacity: false,
    requiresAdult: true,
  ),
];
ActivityOption option({
  String id = 'option',
  String productId = 'product',
  String basis = 'perPerson',
  int price = 1000,
}) => ActivityOption(
  id: id,
  productId: productId,
  title: 'Guided visit',
  ageBands: bands,
  priceRules: [
    ActivityPriceRule(id: 'base', money: money(price), basis: basis),
  ],
  languages: [ActivityGuideLanguage(code: 'en')],
);
ActivityProduct product({
  String id = 'product',
  String title = 'Museum tour',
  int price = 1000,
}) => ActivityProduct(
  id: id,
  title: title,
  destinationId: 'istanbul',
  coordinate: ActivityCoordinate(latitude: 41, longitude: 29),
  options: [option(productId: id, price: price)],
  observedAt: now,
  expiresAt: now.add(const Duration(hours: 1)),
);
ActivitySlot slot({
  String id = 'slot',
  int? capacity = 10,
  String state = 'available',
}) => ActivitySlot(
  id: id,
  productId: 'product',
  optionId: 'option',
  startsAt: now.add(const Duration(hours: 2)),
  endsAt: now.add(const Duration(hours: 3)),
  remainingCapacity: capacity,
  state: state,
  observedAt: now,
  expiresAt: now.add(const Duration(minutes: 10)),
  languageCodes: ['en'],
);
ActivityAvailabilityRequest availability({
  String? slotId,
  List<int> ages = const [30],
}) => ActivityAvailabilityRequest(
  productId: 'product',
  optionId: 'option',
  travelDate: DateTime.utc(2026, 11, 18),
  travelers: travelers(ages: ages),
  currency: 'USD',
  selectedSlotId: slotId,
);
ActivityProviderRequest request(String id) => ActivityProviderRequest(
  id: id,
  scope: 'test-user',
  createdAt: now,
  mode: 'search',
  query: ActivitySearchQuery(),
);
ActivityProviderPage page(
  ActivityProviderRequest r, {
  List<ActivityProduct>? products,
  String? cursor,
}) => ActivityProviderPage(
  id: 'page-${r.id}',
  requestFingerprint: ActivityRequests.fingerprint(r),
  observedAt: now,
  expiresAt: now.add(const Duration(minutes: 10)),
  products: products ?? [product()],
  cursor: cursor,
  complete: cursor == null,
);

class FakeProvider implements ActivityProvider {
  FakeProvider(this.action);
  final Future<ActivityProviderPage> Function(ActivityProviderRequest) action;
  int calls = 0;
  @override
  Future<ActivityProviderPage> fetch(ActivityProviderRequest request) {
    calls++;
    return action(request);
  }
}

class MemoryStorage implements ActivityLocalStorage {
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

Future<void> noWait(Duration _) async {}
