import '../trippl_activities_mobile.dart';

class ActivityProviderAdapter {
  /// Canonical normalized payloads; raw supplier envelopes must be mapped by
  /// the host transport before they reach the mobile discovery core.
  static ActivityProduct product(
    Object? input, {
    ActivityFieldMask? mask,
    DateTime? now,
  }) {
    final row = ActivityGuard.object(input),
        rules = mask ?? ActivityFieldMask();
    ActivityGuard.record(rules.validate());
    final allowed = {
      'id',
      'title',
      'description',
      'destinationId',
      'coordinate',
      'rating',
      'duration',
      'cancellation',
      'accessibility',
      'options',
      'photos',
      'reviews',
      'categories',
      'inclusions',
      'attributions',
      'observedAt',
      'expiresAt',
      'instantConfirmation',
      'revision',
    };
    ActivityCodec.keys(row, allowed);
    final projected = Map<String, Object?>.from(row);
    if (!rules.includeOptions) projected.remove('options');
    if (!rules.includeCancellation) projected.remove('cancellation');
    if (!rules.includePhotos)
      projected.remove('photos');
    else if (projected['photos'] is List)
      projected['photos'] = (projected['photos'] as List)
          .take(rules.maximumPhotos)
          .toList();
    if (!rules.includeReviews)
      projected.remove('reviews');
    else if (projected['reviews'] is List)
      projected['reviews'] = (projected['reviews'] as List)
          .take(rules.maximumReviews)
          .toList();
    final value = ActivityProduct.fromJson(projected);
    ActivityGuard.product(value, now: now);
    for (final photo in value.photos) ActivityDetails.secureUri(photo.url);
    ActivityDetails.credits(
      provider: value.attributions,
      photos: value.photos,
      reviews: value.reviews,
    );
    return value;
  }

  static ActivityProviderPage page(
    Object? input, {
    ActivityFieldMask? mask,
    DateTime? now,
  }) {
    final row = ActivityGuard.object(input);
    final raw = row['products'];
    if (raw != null && raw is! List)
      throw const FormatException('Activity products must be a list');
    if (raw is List)
      row['products'] = raw
          .map((p) => product(p, mask: mask, now: now).toJson())
          .toList();
    final value = ActivityProviderPage.fromJson(row);
    if (now != null && value.observedAt.isAfter(now))
      throw const FormatException('Activity page observed in future');
    return value;
  }

  static ActivityResult<List<ActivityProduct>> batch(
    List<Object?> input, {
    ActivityFieldMask? mask,
    DateTime? now,
  }) {
    if (input.length > 100)
      return ActivityResult(
        issues: const [
          ActivityIssue('products', 'capacity', 'Activity input exceeds limit'),
        ],
      );
    final values = <ActivityProduct>[],
        issues = <ActivityIssue>[],
        seen = <String>{};
    for (var i = 0; i < input.length; i++) {
      try {
        final value = product(input[i], mask: mask, now: now);
        if (!seen.add(value.id))
          throw const FormatException('Activity identity repeats');
        values.add(value);
      } catch (_) {
        issues.add(
          ActivityIssue(
            'products[$i]',
            'invalidProduct',
            'Activity product could not be decoded',
            severity: ActivitySeverity.warning,
          ),
        );
      }
    }
    return ActivityResult(value: List.unmodifiable(values), issues: issues);
  }

  static ActivitySlot slot(Object? input) =>
      ActivitySlot.fromJson(ActivityGuard.object(input));
  static ActivityPriceQuote quote(Object? input) =>
      ActivityPriceQuote.fromJson(ActivityGuard.object(input));
}
