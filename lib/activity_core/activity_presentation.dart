import '../trippl_activities_mobile.dart';

class ActivityDetailSheet {
  ActivityDetailSheet({
    required this.card,
    required List<ActivityOption> options,
    required List<ActivityPhoto> photos,
    required List<ActivityReview> reviews,
    required List<ActivityAttribution> attributions,
    required List<ActivityInclusion> inclusions,
    required this.accessibility,
  }) : options = List.unmodifiable(options),
       photos = List.unmodifiable(photos),
       reviews = List.unmodifiable(reviews),
       attributions = List.unmodifiable(attributions),
       inclusions = List.unmodifiable(inclusions);
  final ActivityResultCard card;
  final List<ActivityOption> options;
  final List<ActivityPhoto> photos;
  final List<ActivityReview> reviews;
  final List<ActivityAttribution> attributions;
  final List<ActivityInclusion> inclusions;
  final ActivityAccessibility? accessibility;
}

class ActivityPresentation {
  static ActivityResultCard card(
    ActivityProduct product, {
    required DateTime now,
    required String currency,
    String locale = 'en',
    ActivityCoordinate? origin,
    ActivityAvailability? availability,
  }) {
    ActivityGuard.product(product, now: now);
    if (availability != null &&
        (availability.productId != product.id ||
            availability.evaluatedAt.isAfter(now)))
      throw const FormatException('Availability card context mismatch');
    final price = ActivityPricing.startingPrice(product, currency: currency);
    final rules = [
      for (final o in product.options.where((o) => o.active))
        ...o.priceRules.where((r) => r.money.currency == currency),
    ];
    final bases = rules.map((r) => r.basis).toSet(),
        basis = bases.length == 1 ? bases.single : 'unknown';
    final photos = ActivityDetails.photos(product, now: now, maximum: 1);
    final stale = !ActivityGuard.fresh(
      product.observedAt,
      product.expiresAt,
      now,
    );
    final cancellation = product.cancellation == null || price == null
        ? null
        : ActivityCancellation.assess(product.cancellation!, price, now: now);
    final meters = origin == null || product.coordinate == null
        ? null
        : ActivitySearch.distance(origin, product.coordinate!);
    final validAvailability =
        availability != null &&
        availability.slots.any(
          (s) =>
              s.startsAt.isAfter(now) &&
              ActivityGuard.fresh(s.observedAt, s.expiresAt, now),
        );
    final state = availability == null
        ? 'unknown'
        : availability.bookable && !validAvailability
        ? 'stale'
        : availability.state;
    return ActivityResultCard(
      productId: product.id,
      title: product.title,
      priceLabel: ActivityAmounts.label(
        bases.length > 1 ? null : price,
        basis: basis,
        locale: locale,
      ),
      ratingLabel: ActivityDetails.rating(product.rating, locale: locale),
      durationLabel: ActivityDetails.duration(
        product.duration ?? ActivityDuration(),
        locale: locale,
      ),
      cancellationLabel: ActivityCancellation.label(
        cancellation,
        locale: locale,
      ),
      availabilityState: state,
      photo: photos.firstOrNull,
      stale: stale,
      distanceLabel: meters == null
          ? null
          : distanceLabel(meters, locale: locale),
      warningCodes: [
        if (stale) 'activityStale',
        if (price == null) 'priceUnknown',
        if (bases.length > 1) 'mixedPricingBases',
        if (availability == null) 'availabilityNotChecked',
        if (meters != null) 'straightLineDistance',
        if (cancellation?.requiresReview != false) 'cancellationRequiresReview',
      ],
    );
  }

  static String distanceLabel(double meters, {String locale = 'en'}) {
    if (!meters.isFinite || meters < 0)
      throw const FormatException('Invalid activity distance');
    final text = meters < 1000
        ? '${meters.round()} m'
        : '${(meters / 1000).toStringAsFixed(1)} km';
    return locale.startsWith('tr') ? '$text uzaklıkta' : '$text away';
  }

  static ActivityDetailSheet details(
    ActivityProduct product, {
    required DateTime now,
    required String currency,
    String locale = 'en',
    ActivityCoordinate? origin,
    ActivityAvailability? availability,
  }) {
    final photos = ActivityDetails.photos(product, now: now),
        reviews = ActivityDetails.reviews(product, language: locale);
    return ActivityDetailSheet(
      card: card(
        product,
        now: now,
        currency: currency,
        locale: locale,
        origin: origin,
        availability: availability,
      ),
      options: product.options.where((o) => o.active).toList(),
      photos: photos,
      reviews: reviews,
      attributions: ActivityDetails.credits(
        provider: product.attributions,
        photos: photos,
        reviews: reviews,
      ),
      inclusions: product.inclusions,
      accessibility: product.accessibility,
    );
  }

  static List<ActivityResultCard> cards(
    ActivitySearchResult result, {
    required DateTime now,
    required String currency,
    String locale = 'en',
    ActivityCoordinate? origin,
  }) {
    ActivityGuard.record(result.validate());
    return List.unmodifiable(
      result.products.map(
        (p) => card(
          p,
          now: now,
          currency: currency,
          locale: locale,
          origin: origin,
        ),
      ),
    );
  }
}

class ActivityDeparturePresentation {
  static Map<String, Object?> details(
    ActivityDeparture departure, {
    required DateTime now,
    required int offsetMinutes,
    String locale = 'en',
  }) {
    ActivityGuard.record(departure.validate());
    if (offsetMinutes.abs() > 840)
      throw const FormatException('Invalid departure UTC offset');
    final local = departure.startsAt.toUtc().add(
      Duration(minutes: offsetMinutes),
    );
    String two(int n) => n.toString().padLeft(2, '0');
    final meeting = departure.meetingPoint, pickup = departure.pickup;
    final arrive = departure.startsAt.subtract(
      Duration(minutes: meeting?.arrivalMinutesBefore ?? 0),
    );
    final arriveLocal = arrive.toUtc().add(Duration(minutes: offsetMinutes));
    final warnings = <String>{...departure.warningCodes};
    if (!departure.startsAt.isAfter(now)) warnings.add('departureStarted');
    if (meeting?.confirmed != true)
      warnings.add('meetingPointNeedsConfirmation');
    if (pickup?.requiresSelection == true)
      warnings.add('verifyPickupSelection');
    return Map.unmodifiable({
      'productId': departure.productId,
      'optionId': departure.optionId,
      'slotId': departure.slotId,
      'date': ActivityCodec.calendarText(local),
      'startTime': '${two(local.hour)}:${two(local.minute)}',
      'arrivalTime': '${two(arriveLocal.hour)}:${two(arriveLocal.minute)}',
      'arrivalDate': ActivityCodec.calendarText(arriveLocal),
      'offsetMinutes': offsetMinutes,
      'languageCode': departure.languageCode,
      'requiresConfirmation': departure.requiresConfirmation,
      'statusLabel': locale.startsWith('tr')
          ? 'Onay gerekli'
          : 'Confirmation required',
      if (meeting != null)
        'meeting': {
          'name': meeting.name,
          'address': meeting.address?.formatted,
          'instructions': meeting.instructions,
          'confirmed': meeting.confirmed,
          'coordinate': meeting.coordinate?.toJson(),
        },
      if (pickup != null)
        'pickup': {
          'available': pickup.available,
          'included': pickup.included,
          'instructions': pickup.instructions,
          'requiresSelection': pickup.requiresSelection,
        },
      'warningCodes': warnings.toList()..sort(),
    });
  }

  static Map<String, Object?> accessibility(
    ActivityAccessibility? value, {
    String locale = 'en',
  }) {
    final tr = locale.startsWith('tr');
    if (value == null)
      return Map.unmodifiable({
        'confirmed': false,
        'label': tr ? 'Erişilebilirliği doğrulayın' : 'Confirm accessibility',
      });
    ActivityGuard.record(value.validate());
    String label(bool? flag) => flag == null
        ? (tr ? 'Bilinmiyor' : 'Unknown')
        : flag
        ? (tr ? 'Evet' : 'Yes')
        : (tr ? 'Hayır' : 'No');
    return Map.unmodifiable({
      'confirmed': value.confirmed,
      'wheelchair': label(value.wheelchairAccessible),
      'stroller': label(value.strollerAccessible),
      'serviceAnimals': label(value.serviceAnimalsAllowed),
      'minimumFitness': value.minimumFitness,
      'restrictions': value.restrictions,
      'requiresReview': !value.confirmed,
    });
  }
}
