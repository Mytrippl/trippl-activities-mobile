import '../trippl_activities_mobile.dart';

class ActivityComparisonBoard {
  ActivityComparisonBoard({
    required this.clock,
    required this.currency,
    this.locale = 'en',
  });
  final DateTime Function() clock;
  final String currency, locale;
  final _products = <String, ActivityProduct>{};
  int _revision = 1;
  int get revision => _revision;
  List<String> get productIds => List.unmodifiable(_products.keys);
  void add(ActivityProduct product, {required int expectedRevision}) {
    ActivityGuard.revision(_revision, expectedRevision);
    ActivityGuard.product(product, now: clock());
    if (!_products.containsKey(product.id) && _products.length >= 4)
      throw StateError('Compare at most four activities');
    final old = _products[product.id];
    if (old != null &&
        (product.revision < old.revision ||
            old.observedAt != null &&
                (product.observedAt == null ||
                    product.observedAt!.isBefore(old.observedAt!))))
      throw StateError('Comparison product would regress');
    _products[product.id] = product;
    _revision++;
  }

  void remove(String id, {required int expectedRevision}) {
    ActivityGuard.revision(_revision, expectedRevision);
    if (!_products.containsKey(id))
      throw StateError('Compared activity missing');
    _products.remove(id);
    _revision++;
  }

  ActivityComparison snapshot() {
    final now = clock(),
        cards = <ActivityResultCard>[],
        warnings = <String>{},
        bases = <String>{},
        precisions = <int>{};
    var hasAll = true;
    for (final product in _products.values) {
      cards.add(
        ActivityPresentation.card(
          product,
          now: now,
          currency: currency,
          locale: locale,
        ),
      );
      final price = ActivityPricing.startingPrice(product, currency: currency);
      if (price == null) {
        hasAll = false;
        warnings.add('priceUnknown');
      } else
        precisions.add(price.decimals);
      final values = {
        for (final o in product.options.where((o) => o.active))
          for (final r in o.priceRules)
            if (r.money.currency == currency) r.basis,
      };
      if (values.length != 1) hasAll = false;
      bases.addAll(values);
      if (!ActivityGuard.fresh(product.observedAt, product.expiresAt, now)) {
        hasAll = false;
        warnings.add('staleComparison');
      }
    }
    if (bases.length > 1) warnings.add('pricingBasesDiffer');
    final comparable =
        hasAll &&
        _products.length > 1 &&
        bases.length == 1 &&
        precisions.length == 1;
    if (comparable) warnings.add('indicativeStartingPricesOnly');
    return ActivityComparison(
      evaluatedAt: now,
      productIds: productIds,
      cards: cards,
      comparablePrices: comparable,
      currency: currency,
      revision: _revision,
      warningCodes: warnings.toList()..sort(),
    );
  }

  Map<String, Object?> differences() {
    final state = snapshot();
    return Map.unmodifiable({
      'revision': _revision,
      'comparablePrices': state.comparablePrices,
      'rows': [
        for (final card in state.cards)
          {
            'productId': card.productId,
            'price': card.priceLabel,
            'rating': card.ratingLabel,
            'duration': card.durationLabel,
            'cancellation': card.cancellationLabel,
            'availability': card.availabilityState,
          },
      ],
      'warnings': state.warningCodes,
    });
  }

  void clear({required int expectedRevision}) {
    ActivityGuard.revision(_revision, expectedRevision);
    _products.clear();
    _revision++;
  }
}

class ActivityOptionQuotes {
  /// Compare calculated totals for the same party, rather than comparing a
  /// per-person starting price with an unrelated group starting price.
  static List<Map<String, Object?>> compare(
    ActivityProduct product,
    ActivityTravelerMix travelers, {
    required String currency,
    required DateTime now,
    int units = 1,
    String? languageCode,
  }) {
    ActivityGuard.product(product, now: now);
    ActivityGuard.record(travelers.validate());
    if (units < 1 || units > 100)
      throw const FormatException('Invalid quote units');
    if (languageCode != null) ActivityGuard.language(languageCode);
    final rows = <Map<String, Object?>>[];
    final precisions = <int>{};
    for (final option in product.options) {
      if (!option.active) continue;
      final warnings = <String>[];
      ActivityPriceBreakdown? price;
      final eligible = ActivityTravelers.assess(
        travelers,
        option.ageBands,
        now: now,
        minimumTravelers: option.minimumTravelers,
        maximumTravelers: option.maximumTravelers,
      );
      if (!eligible.eligible) warnings.addAll(eligible.reasonCodes);
      if (languageCode != null &&
          !option.languages.any(
            (language) => language.available && language.code == languageCode,
          )) {
        warnings.add('guideLanguageUnavailable');
      }
      if (warnings.isEmpty) {
        try {
          price = ActivityPricing.calculate(
            option,
            travelers,
            currency: currency,
            now: now,
            units: units,
          );
          precisions.add(price.total.decimals);
        } on StateError {
          warnings.add('matchingPriceRuleUnavailable');
        } on FormatException {
          warnings.add('priceRuleConflict');
        }
      }
      rows.add({
        'optionId': option.id,
        'title': option.title,
        'travelerCount': travelers.travelers.length,
        'units': units,
        'eligible': eligible.eligible,
        'calculatedTotal': price?.total.toJson(),
        'basis': price?.basis,
        'components': price?.components
            .map((component) => component.toJson())
            .toList(),
        'warningCodes': warnings,
        'requiresProviderQuote': true,
        'bookable': false,
      });
    }
    rows.sort((a, b) {
      final first = a['calculatedTotal'] as Map<String, Object?>?;
      final second = b['calculatedTotal'] as Map<String, Object?>?;
      if ((first == null) != (second == null)) return first == null ? 1 : -1;
      if (precisions.length == 1 && first != null && second != null) {
        final comparison = (first['amountMinor'] as int).compareTo(
          second['amountMinor'] as int,
        );
        if (comparison != 0) return comparison;
      }
      return (a['optionId'] as String).compareTo(b['optionId'] as String);
    });
    return List.unmodifiable(
      rows.map(
        (row) => Map<String, Object?>.unmodifiable({
          ...row,
          'comparableTotals':
              precisions.length == 1 && row['calculatedTotal'] != null,
          if (precisions.length > 1)
            'comparisonWarning': 'currencyPrecisionDiffers',
        }),
      ),
    );
  }
}
