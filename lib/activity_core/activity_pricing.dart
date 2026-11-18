import '../trippl_activities_mobile.dart';

class ActivityPricing {
  static ActivityPriceBreakdown calculate(
    ActivityOption option,
    ActivityTravelerMix travelers, {
    required String currency,
    required DateTime now,
    int units = 1,
    List<ActivityPriceComponent> extras = const [],
  }) {
    ActivityGuard.record(option.validate());
    ActivityGuard.record(travelers.validate());
    if (units < 1 || units > 100)
      throw const FormatException('Invalid activity unit quantity');
    final eligibility = ActivityTravelers.assess(
      travelers,
      option.ageBands,
      now: now,
      minimumTravelers: option.minimumTravelers,
      maximumTravelers: option.maximumTravelers,
    );
    if (!eligibility.eligible)
      throw StateError('Traveler eligibility is not satisfied');
    final available = option.priceRules
        .where(
          (r) =>
              r.money.currency == currency &&
              travelers.travelers.length >= r.minimumTravelers &&
              travelers.travelers.length <= r.maximumTravelers &&
              units >= r.minimumUnits &&
              (r.maximumUnits == null || units <= r.maximumUnits!),
        )
        .toList();
    if (available.isEmpty) throw StateError('No matching activity price rule');
    final bases = available.map((r) => r.basis).toSet();
    if (bases.length != 1) throw StateError('Activity pricing bases conflict');
    final basis = bases.single, components = <ActivityPriceComponent>[];
    ActivityPriceRule choose(String? category) {
      final rules = available.where((r) => r.category == category).toList()
        ..sort((a, b) => b.priority.compareTo(a.priority));
      if (rules.isEmpty ||
          rules.length > 1 && rules[0].priority == rules[1].priority)
        throw StateError('Missing or ambiguous activity price rule');
      return rules.first;
    }

    if (basis == 'perPerson') {
      final counts = <String, int>{};
      for (final c in eligibility.assignedCategories)
        counts[c] = (counts[c] ?? 0) + 1;
      for (final e in counts.entries) {
        final rule = available.any((r) => r.category == e.key)
            ? choose(e.key)
            : choose(null);
        components.add(
          ActivityPriceComponent(
            id: 'base-${e.key}',
            label: '${e.key} travelers',
            unit: rule.money,
            quantity: e.value,
            category: e.key,
          ),
        );
      }
    } else {
      final rule = choose(null);
      components.add(
        ActivityPriceComponent(
          id: 'base',
          label: 'Activity price',
          unit: rule.money,
          quantity: basis == 'perUnit' ? units : 1,
        ),
      );
    }
    if (extras.length > 50)
      throw const FormatException('Too many price components');
    components.addAll(extras);
    ActivityGuard.distinct(components.map((c) => c.id));
    var amount = components.first.unit.copyWith(amountMinor: 0),
        discount = amount;
    for (final c in components) {
      ActivityGuard.record(c.validate());
      ActivityAmounts.compatible(amount, c.unit);
      if (!c.included) continue;
      if (c.kind == 'discount')
        discount = ActivityAmounts.add(
          discount,
          ActivityAmounts.multiply(c.unit, c.quantity),
        );
      else
        amount = ActivityAmounts.add(
          amount,
          ActivityAmounts.multiply(c.unit, c.quantity),
        );
    }
    amount = ActivityAmounts.subtract(amount, discount);
    final result = ActivityPriceBreakdown(
      evaluatedAt: now,
      total: amount,
      components: components,
      travelerCount: travelers.travelers.length,
      basis: basis,
      complete: true,
      warningCodes: ['indicativeCalculation', 'providerQuoteRequired'],
    );
    ActivityGuard.record(result.validate());
    return result;
  }

  static void validateQuote(
    ActivityPriceQuote quote, {
    required ActivityQuoteRequest request,
    required String requestFingerprint,
    required DateTime now,
  }) {
    ActivityGuard.record(quote.validate());
    ActivityGuard.record(request.validate());
    if (quote.productId != request.productId ||
        quote.optionId != request.optionId ||
        quote.slotId != request.slotId ||
        quote.requestFingerprint != requestFingerprint ||
        quote.total.currency != request.currency ||
        !ActivityGuard.fresh(quote.observedAt, quote.expiresAt, now))
      throw const FormatException(
        'Quote selection currency or freshness mismatch',
      );
    if (quote.components.isNotEmpty) {
      var sum = quote.total.copyWith(amountMinor: 0), discount = sum;
      ActivityGuard.distinct(quote.components.map((c) => c.id));
      for (final c in quote.components) {
        ActivityAmounts.compatible(sum, c.unit);
        if (!c.included) continue;
        if (c.kind == 'discount')
          discount = ActivityAmounts.add(
            discount,
            ActivityAmounts.multiply(c.unit, c.quantity),
          );
        else
          sum = ActivityAmounts.add(
            sum,
            ActivityAmounts.multiply(c.unit, c.quantity),
          );
      }
      if (ActivityAmounts.subtract(sum, discount) != quote.total)
        throw const FormatException(
          'Provider quote components do not match total',
        );
    }
  }

  static ActivityMoney? startingPrice(
    ActivityProduct product, {
    required String currency,
  }) {
    ActivityGuard.product(product);
    final values = <ActivityMoney>[];
    for (final option in product.options.where((o) => o.active))
      for (final rule in option.priceRules)
        if (rule.money.currency == currency) values.add(rule.money);
    if (values.isEmpty) return null;
    if (values.map((m) => m.decimals).toSet().length != 1)
      throw const FormatException('Price precision conflicts');
    values.sort((a, b) => a.amountMinor.compareTo(b.amountMinor));
    return values.first;
  }
}
