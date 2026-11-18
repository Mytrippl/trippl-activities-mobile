import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';
import 'support.dart';

void main() {
  test('direct availability assessment rejects an empty traveler draft', () {
    expect(
      () => ActivityInventory.assess(
        option(),
        availability(ages: []),
        [slot()],
        now: now,
        offsetMinutes: 0,
      ),
      throwsFormatException,
    );
  });

  test('supplier startAge and endAge fields preserve eligibility bounds', () {
    final normalized = ActivityTravelers.normalizeBands([
      {'ageBand': 'ADULT', 'startAge': 18, 'endAge': 120},
      {'ageBand': 'CHILD', 'startAge': 3, 'endAge': 17},
    ]);
    final result = ActivityTravelers.assess(
      travelers(ages: [30, 8]),
      normalized,
      now: now,
    );
    expect(result.eligible, isTrue);
    expect(result.assignedCategories, ['adult', 'child']);
  });
  test(
    'ambiguous overlapping bands are rejected before assigning travelers',
    () {
      expect(
        () => ActivityTravelers.assess(travelers(), [
          bands.first,
          bands[1].copyWith(endAge: 20),
        ], now: now),
        throwsFormatException,
      );
    },
  );
  test('unsupported ages and unaccompanied children fail explicitly', () {
    expect(
      ActivityTravelers.assess(
        travelers(ages: [8]),
        bands,
        now: now,
      ).reasonCodes,
      contains('adultRequired'),
    );
    expect(
      ActivityTravelers.assess(travelers(ages: [2]), [
        bands.first,
      ], now: now).unsupportedTravelerIds,
      ['traveler-0'],
    );
  });
  test(
    'infants can be exempt from capacity while remaining in traveler total',
    () {
      final result = ActivityTravelers.assess(
        travelers(ages: [30, 1]),
        bands,
        now: now,
      );
      expect(result.totalTravelers, 2);
      expect(result.capacityTravelers, 1);
    },
  );
  test(
    'unknown supplier age bands are not replaced with invented eligibility',
    () {
      final result = ActivityTravelers.assess(travelers(), [], now: now);
      expect(result.eligible, isFalse);
      expect(result.requiresReview, isTrue);
    },
  );
  test('decimal money parsing is exact and rejects excess precision', () {
    expect(ActivityAmounts.parse('12.34', currency: 'USD'), money(1234));
    expect(
      ActivityAmounts.parse('12,34', currency: 'USD', separator: ','),
      money(1234),
    );
    expect(
      () => ActivityAmounts.parse('1.005', currency: 'USD'),
      throwsFormatException,
    );
    expect(
      () => ActivityAmounts.parse('1,000.00', currency: 'USD'),
      throwsFormatException,
    );
  });
  test('money never mixes currencies or silently allows excess discounts', () {
    expect(
      () => ActivityAmounts.add(money(100), money(100, currency: 'EUR')),
      throwsFormatException,
    );
    expect(
      () => ActivityAmounts.subtract(money(100), money(101)),
      throwsFormatException,
    );
    expect(ActivityAmounts.percent(money(101), 5000), money(50));
  });
  test('per-person and per-group prices use different quantities', () {
    final party = travelers(ages: [30, 40, 10]);
    expect(
      ActivityPricing.calculate(
        option(),
        party,
        currency: 'USD',
        now: now,
      ).total.amountMinor,
      3000,
    );
    expect(
      ActivityPricing.calculate(
        option(basis: 'perGroup'),
        party,
        currency: 'USD',
        now: now,
      ).total.amountMinor,
      1000,
    );
    expect(
      ActivityPricing.calculate(
        option(basis: 'perUnit'),
        party,
        currency: 'USD',
        now: now,
        units: 2,
      ).total.amountMinor,
      2000,
    );
  });
  test('matching price rules with tied priorities are ambiguous', () {
    final original = option();
    final ambiguous = original.copyWith(
      priceRules: [
        ...original.priceRules,
        original.priceRules.single.copyWith(id: 'other'),
      ],
    );
    expect(
      () => ActivityPricing.calculate(
        ambiguous,
        travelers(),
        currency: 'USD',
        now: now,
      ),
      throwsStateError,
    );
  });
  test('taxes fees and discounts reconcile into a single exact total', () {
    final result = ActivityPricing.calculate(
      option(),
      travelers(),
      currency: 'USD',
      now: now,
      extras: [
        ActivityPriceComponent(
          id: 'tax',
          label: 'Tax',
          unit: money(100),
          kind: 'tax',
        ),
        ActivityPriceComponent(
          id: 'discount',
          label: 'Discount',
          unit: money(50),
          kind: 'discount',
        ),
      ],
    );
    expect(result.total.amountMinor, 1050);
  });
  test(
    'option comparison uses party totals rather than per-person headline prices',
    () {
      final p = product().copyWith(
        options: [
          option(id: 'person', price: 600),
          option(id: 'group', basis: 'perGroup', price: 1000),
        ],
      );
      final rows = ActivityOptionQuotes.compare(
        p,
        travelers(ages: [30, 40]),
        currency: 'USD',
        now: now,
      );
      expect(rows.first['optionId'], 'group');
      expect(rows.first['requiresProviderQuote'], isTrue);
      expect(rows.first['bookable'], isFalse);
    },
  );
  test('standard cancellation without deadlines stays unknown', () {
    final policy = ActivityCancellationPolicy(
      id: 'p',
      kind: 'standard',
      observedAt: now,
      expiresAt: now.add(const Duration(days: 1)),
    );
    expect(
      ActivityCancellation.assess(policy, money(1000), now: now).state,
      'unknown',
    );
  });
  test('cancellation percentages use cutoffs and deduct explicit fees', () {
    final policy = ActivityCancellationPolicy(
      id: 'p',
      kind: 'custom',
      requiresReview: false,
      observedAt: now,
      expiresAt: now.add(const Duration(days: 3)),
      tiers: [
        ActivityCancellationTier(
          id: 'full',
          cutoffAt: now.add(const Duration(days: 1)),
          refundBasisPoints: 10000,
        ),
        ActivityCancellationTier(
          id: 'partial',
          cutoffAt: now.add(const Duration(days: 2)),
          refundBasisPoints: 5000,
          fee: money(100),
        ),
      ],
    );
    expect(
      ActivityCancellation.assess(policy, money(1000), now: now).state,
      'free',
    );
    expect(
      ActivityCancellation.assess(
        policy,
        money(1000),
        now: now.add(const Duration(hours: 30)),
      ).refund,
      money(400),
    );
    expect(
      ActivityCancellation.assess(
        policy,
        money(1000),
        now: now.add(const Duration(hours: 50)),
      ).state,
      'expired',
    );
  });
  test('unknown capacity and stale slots cannot become bookable', () {
    expect(
      ActivityInventory.assess(
        option(),
        availability(),
        [slot(capacity: null)],
        now: now,
        offsetMinutes: 0,
      ).bookable,
      isFalse,
    );
    expect(
      ActivityInventory.assess(
        option(),
        availability(),
        [
          slot().copyWith(
            observedAt: now.subtract(const Duration(hours: 1)),
            expiresAt: now,
          ),
        ],
        now: now,
        offsetMinutes: 0,
      ).state,
      'stale',
    );
  });
  test(
    'capacity uses eligible travelers and explicit local departure date',
    () {
      expect(
        ActivityInventory.assess(
          option(),
          availability(ages: [30, 1]),
          [slot(capacity: 1)],
          now: now,
          offsetMinutes: 0,
        ).bookable,
        isTrue,
      );
      expect(
        ActivityInventory.assess(
          option(),
          availability(ages: [30, 40]),
          [slot(capacity: 1)],
          now: now,
          offsetMinutes: 0,
        ).state,
        'insufficientCapacity',
      );
      final late = slot().copyWith(
        startsAt: DateTime.utc(2026, 11, 18, 23),
        endsAt: DateTime.utc(2026, 11, 19, 1),
      );
      expect(
        ActivityInventory.assess(
          option(),
          availability(),
          [late],
          now: now,
          offsetMinutes: 180,
        ).bookable,
        isFalse,
      );
    },
  );
  test('price filters require the same currency as their query', () {
    expect(
      () => ActivitySearch.run(
        [product()],
        query: ActivitySearchQuery(currency: 'USD'),
        filter: ActivitySearchFilter(currency: 'EUR', maximumPriceMinor: 10000),
        sort: ActivitySearchSort(),
        now: now,
      ),
      throwsFormatException,
    );
  });
  test('search keeps unknown ratings last and uses stable identity ties', () {
    final a = product(id: 'a'),
        b = product(id: 'b').copyWith(rating: ActivityRating(value: 4.8));
    final result = ActivitySearch.run(
      [a, b],
      query: ActivitySearchQuery(),
      filter: ActivitySearchFilter(),
      sort: ActivitySearchSort(field: 'rating', descending: true),
      now: now,
    );
    expect(result.products.map((p) => p.id), ['b', 'a']);
  });
  test('stale products are excluded unless explicitly requested', () {
    final p = product().copyWith(
      observedAt: now.subtract(const Duration(hours: 1)),
      expiresAt: now,
    );
    expect(
      ActivitySearch.run(
        [p],
        query: ActivitySearchQuery(),
        filter: ActivitySearchFilter(),
        sort: ActivitySearchSort(),
        now: now,
      ).products,
      isEmpty,
    );
    expect(
      ActivitySearch.run(
        [p],
        query: ActivitySearchQuery(),
        filter: ActivitySearchFilter(includeStale: true),
        sort: ActivitySearchSort(),
        now: now,
      ).products.length,
      1,
    );
  });
  test('media attribution conflicts and credential URLs are rejected', () {
    final a = ActivityAttribution(id: 'a', displayName: 'Author');
    expect(
      () => ActivityDetails.credits(
        provider: [
          a,
          a.copyWith(displayName: 'Other'),
        ],
      ),
      throwsStateError,
    );
    expect(
      () => ActivityDetails.secureUri('https://example.com/photo?key=secret'),
      throwsFormatException,
    );
  });
  test('malformed provider entries are isolated and reported', () {
    final result = ActivityProviderAdapter.batch([
      product().toJson(),
      {'id': 'bad'},
    ], now: now);
    expect(result.value!.length, 1);
    expect(result.issues.single.severity, ActivitySeverity.warning);
  });
  test('requests reject contradictory selections and date rollover', () {
    final r = ActivityRequests(
      scope: 'test-user',
      clock: () => now,
    ).availability(availability());
    expect(
      () => ActivityRequests.validate(r.copyWith(productId: 'other')),
      throwsFormatException,
    );
    expect(
      ActivityAvailabilityRequest.tryDecode({
        ...availability().toJson(),
        'travelDate': '2026-02-30',
      }).isSuccess,
      isFalse,
    );
  });
  test('comparison is bounded and marks mixed pricing bases incomparable', () {
    final board = ActivityComparisonBoard(clock: () => now, currency: 'USD');
    board.add(product(id: 'a'), expectedRevision: 1);
    board.add(
      product(id: 'b').copyWith(
        options: [option(productId: 'b', basis: 'perGroup')],
      ),
      expectedRevision: 2,
    );
    expect(board.snapshot().comparablePrices, isFalse);
    expect(board.snapshot().warningCodes, contains('pricingBasesDiffer'));
    expect(() => board.remove('a', expectedRevision: 1), throwsStateError);
  });
  test('quote must reconcile its total and exact selected slot', () {
    final req = ActivityQuoteRequest(
      productId: 'product',
      optionId: 'option',
      slotId: 'slot',
      travelers: travelers(),
      currency: 'USD',
      createdAt: now,
    );
    final quote = ActivityPriceQuote(
      id: 'q',
      productId: 'product',
      optionId: 'option',
      slotId: 'slot',
      requestFingerprint: 'a' * 64,
      observedAt: now,
      expiresAt: now.add(const Duration(minutes: 5)),
      total: money(1000),
      components: [
        ActivityPriceComponent(id: 'base', label: 'Base', unit: money(900)),
      ],
    );
    expect(
      () => ActivityPricing.validateQuote(
        quote,
        request: req,
        requestFingerprint: 'a' * 64,
        now: now,
      ),
      throwsFormatException,
    );
  });
  test('nested input cycles and nonfinite values are rejected', () {
    final input = <String, Object?>{};
    input['self'] = input;
    expect(() => ActivityGuard.inspect(input), throwsFormatException);
    expect(
      () => ActivityGuard.inspect({'price': double.nan}),
      throwsFormatException,
    );
  });
}
