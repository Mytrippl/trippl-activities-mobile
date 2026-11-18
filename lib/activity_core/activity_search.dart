import 'dart:math' as math;
import '../trippl_activities_mobile.dart';

class ActivitySearch {
  static String normalize(String value) =>
      value.toLowerCase().replaceAll(RegExp(r'\s+'), ' ').trim();
  static double distance(ActivityCoordinate a, ActivityCoordinate b) {
    ActivityGuard.record(a.validate());
    ActivityGuard.record(b.validate());
    double rad(double n) => n * math.pi / 180;
    final lat = rad(b.latitude - a.latitude),
        lng = rad(b.longitude - a.longitude);
    final h =
        math.pow(math.sin(lat / 2), 2) +
        math.cos(rad(a.latitude)) *
            math.cos(rad(b.latitude)) *
            math.pow(math.sin(lng / 2), 2);
    return 6371008.8 *
        2 *
        math.atan2(math.sqrt(h.clamp(0, 1)), math.sqrt((1 - h).clamp(0, 1)));
  }

  static List<String> exclusions(
    ActivityProduct product,
    ActivitySearchQuery query,
    ActivitySearchFilter filter, {
    required DateTime now,
  }) {
    ActivityGuard.product(product, now: now);
    ActivityGuard.record(query.validate());
    ActivityGuard.record(filter.validate());
    final codes = <String>[];
    if (!filter.includeStale &&
        !ActivityGuard.fresh(product.observedAt, product.expiresAt, now))
      codes.add('staleProduct');
    if (query.destinationId != null &&
        product.destinationId != query.destinationId)
      codes.add('destination');
    if (query.productId != null && product.id != query.productId)
      codes.add('product');
    if (query.text != 'all' &&
        !normalize(
          '${product.title} ${product.description ?? ''}',
        ).contains(normalize(query.text)))
      codes.add('text');
    if (filter.categories.isNotEmpty &&
        !filter.categories.any(product.categories.contains))
      codes.add('category');
    if (filter.minimumRating != null &&
        (product.rating?.value == null ||
            product.rating!.value! < filter.minimumRating!))
      codes.add('rating');
    if (filter.instantConfirmationOnly && !product.instantConfirmation)
      codes.add('confirmation');
    if (filter.freeCancellationOnly &&
        !ActivityCancellation.freeNow(
          product,
          now: now,
          currency: query.currency,
        ))
      codes.add('cancellation');
    if (filter.minimumDurationMinutes != null) {
      final minimum =
          product.duration?.fixedMinutes ?? product.duration?.minimumMinutes;
      if (minimum == null || minimum < filter.minimumDurationMinutes!)
        codes.add('durationMinimum');
    }
    if (filter.maximumDurationMinutes != null) {
      final maximum =
          product.duration?.fixedMinutes ?? product.duration?.maximumMinutes;
      if (maximum == null || maximum > filter.maximumDurationMinutes!)
        codes.add('durationMaximum');
    }
    if (filter.guideLanguage != null &&
        !product.options.any(
          (o) =>
              o.active &&
              o.languages.any(
                (l) => l.available && l.code == filter.guideLanguage,
              ),
        ))
      codes.add('guideLanguage');
    if (filter.wheelchairAccessible != null &&
        (product.accessibility?.confirmed != true ||
            product.accessibility?.wheelchairAccessible !=
                filter.wheelchairAccessible))
      codes.add('accessibilityUnknown');
    if (filter.radiusMeters != null &&
        (product.coordinate == null ||
            distance(filter.center!, product.coordinate!) >
                filter.radiusMeters!))
      codes.add('radius');
    if (filter.minimumPriceMinor != null || filter.maximumPriceMinor != null) {
      if (filter.currency != query.currency)
        throw const FormatException(
          'Search price filter currency differs from query',
        );
      final price = ActivityPricing.startingPrice(
        product,
        currency: query.currency,
      );
      if (price == null)
        codes.add('priceUnknown');
      else if (filter.minimumPriceMinor != null &&
              price.amountMinor < filter.minimumPriceMinor! ||
          filter.maximumPriceMinor != null &&
              price.amountMinor > filter.maximumPriceMinor!)
        codes.add('price');
    }
    return List.unmodifiable(codes);
  }

  static ActivitySearchResult run(
    Iterable<ActivityProduct> input, {
    required ActivitySearchQuery query,
    required ActivitySearchFilter filter,
    required ActivitySearchSort sort,
    required DateTime now,
    bool incomplete = true,
  }) {
    ActivityGuard.record(query.validate());
    ActivityGuard.record(filter.validate());
    ActivityGuard.record(sort.validate());
    if (sort.field == 'distance' && filter.center == null)
      throw const FormatException('Distance ordering needs origin');
    final rows = input.toList();
    if (rows.length > 1000)
      throw const FormatException('Activity search input exceeds capacity');
    ActivityGuard.distinct(rows.map((p) => p.id));
    final matched = rows
        .where((p) => exclusions(p, query, filter, now: now).isEmpty)
        .toList();
    final ranks = {for (var i = 0; i < rows.length; i++) rows[i].id: i};
    Object? value(ActivityProduct p) => switch (sort.field) {
      'price' => ActivityPricing.startingPrice(
        p,
        currency: query.currency,
      )?.amountMinor,
      'rating' => p.rating?.value,
      'reviewCount' => p.rating?.count,
      'duration' => p.duration?.fixedMinutes ?? p.duration?.minimumMinutes,
      'distance' =>
        p.coordinate == null ? null : distance(filter.center!, p.coordinate!),
      'title' => normalize(p.title),
      _ => ranks[p.id],
    };
    matched.sort((a, b) {
      final av = value(a), bv = value(b);
      if ((av == null) != (bv == null))
        return av == null
            ? (sort.unknownLast ? 1 : -1)
            : (sort.unknownLast ? -1 : 1);
      final c = av == null
          ? 0
          : av is num
          ? (av.compareTo(bv as num))
          : (av as String).compareTo(bv as String);
      return c == 0
          ? a.id.compareTo(b.id)
          : sort.descending
          ? -c
          : c;
    });
    final selected = matched.skip(query.offset).take(query.limit).toList();
    return ActivitySearchResult(
      evaluatedAt: now,
      resultFingerprint: ActivityCodec.digest({
        'query': query.toJson(),
        'filter': filter.toJson(),
        'sort': sort.toJson(),
        'ids': selected.map((p) => p.toJson()).toList(),
      }),
      matchedCount: matched.length,
      products: selected,
      offset: query.offset,
      limit: query.limit,
      hasMore: query.offset + selected.length < matched.length,
      incomplete: incomplete,
      warningCodes: [
        if (incomplete) 'providerResultsIncomplete',
        if (sort.field == 'price') 'startingPricesMayUseDifferentBases',
      ],
    );
  }

  static Map<String, int> facets(Iterable<ActivityProduct> input) {
    final rows = input.toList();
    if (rows.length > 1000)
      throw const FormatException('Activity facets exceed capacity');
    final counts = <String, int>{};
    for (final p in rows) {
      ActivityGuard.product(p);
      for (final c in p.categories.toSet()) counts[c] = (counts[c] ?? 0) + 1;
    }
    return Map.unmodifiable(counts);
  }
}
