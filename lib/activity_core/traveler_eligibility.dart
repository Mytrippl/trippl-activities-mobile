import '../trippl_activities_mobile.dart';

class ActivityTravelers {
  static List<ActivityAgeBand> normalizeBands(Object? input) {
    final rows = input is List
        ? input
        : throw const FormatException('Age bands must be a list');
    if (rows.length > 20)
      throw const FormatException('Age bands exceed capacity');
    final result = <ActivityAgeBand>[];
    for (var i = 0; i < rows.length; i++) {
      final row = ActivityGuard.object(rows[i]);
      final category =
          (row['category'] ?? row['ageBand'] ?? row['name'] ?? row['type'])
              ?.toString()
              .toLowerCase();
      int? number(Object? value) => value is int
          ? value
          : value is String
          ? int.tryParse(value)
          : null;
      final start = number(
        row['startAge'] ?? row['minAge'] ?? row['minimumAge'] ?? row['from'],
      );
      final end = number(
        row['endAge'] ?? row['maxAge'] ?? row['maximumAge'] ?? row['to'],
      );
      if (category == null || start == null || end == null)
        throw const FormatException('Supplier age band has no explicit bounds');
      final band = ActivityAgeBand(
        id: row['id']?.toString() ?? 'band-$i',
        category: category,
        startAge: start,
        endAge: end,
        minimumTravelers:
            number(row['minimumTravelers'] ?? row['minTravelersPerBooking']) ??
            0,
        maximumTravelers: number(
          row['maximumTravelers'] ?? row['maxTravelersPerBooking'],
        ),
        countsTowardCapacity: row['countsTowardCapacity'] != false,
        requiresAdult: row['requiresAdult'] == true,
      );
      ActivityGuard.record(band.validate());
      result.add(band);
    }
    validateBands(result);
    return List.unmodifiable(result);
  }

  static void validateBands(List<ActivityAgeBand> bands) {
    if (bands.length > 20) throw const FormatException('Too many age bands');
    ActivityGuard.distinct(bands.map((b) => b.id));
    ActivityGuard.distinct(bands.map((b) => b.category));
    for (var i = 0; i < bands.length; i++) {
      ActivityGuard.record(bands[i].validate());
      for (var j = i + 1; j < bands.length; j++) {
        if (bands[i].startAge <= bands[j].endAge &&
            bands[j].startAge <= bands[i].endAge)
          throw const FormatException('Supplier age bands overlap');
      }
    }
  }

  static ActivityEligibility assess(
    ActivityTravelerMix mix,
    List<ActivityAgeBand> bands, {
    required DateTime now,
    int? minimumTravelers,
    int? maximumTravelers,
  }) {
    ActivityGuard.record(mix.validate());
    validateBands(bands);
    final reasons = <String>[],
        unsupported = <String>[],
        categories = <String>[];
    final counts = <String, int>{};
    var capacity = 0;
    final min = minimumTravelers ?? mix.minimumTravelers,
        max = maximumTravelers ?? mix.maximumTravelers;
    if (min < 1 || max > 100 || min > max)
      throw const FormatException('Invalid traveler count bounds');
    if (mix.travelers.length < min) reasons.add('belowMinimumTravelers');
    if (mix.travelers.length > max) reasons.add('aboveMaximumTravelers');
    if (bands.isEmpty) reasons.add('ageBandsUnknown');
    for (final traveler in mix.travelers) {
      ActivityGuard.identity(traveler.id);
      final band = bands
          .where((b) => traveler.age >= b.startAge && traveler.age <= b.endAge)
          .firstOrNull;
      if (band == null) {
        unsupported.add(traveler.id);
        categories.add('unknown');
        continue;
      }
      if (traveler.category != null && traveler.category != band.category)
        reasons.add('travelerCategoryMismatch');
      categories.add(band.category);
      counts[band.category] = (counts[band.category] ?? 0) + 1;
      if (band.countsTowardCapacity) capacity++;
    }
    if (unsupported.isNotEmpty) reasons.add('unsupportedTravelerAge');
    final adultPresent = mix.travelers.any((t) => t.age >= 18);
    for (final band in bands) {
      final count = counts[band.category] ?? 0;
      if (count < band.minimumTravelers)
        reasons.add('belowBandMinimum:${band.category}');
      if (band.maximumTravelers != null && count > band.maximumTravelers!)
        reasons.add('aboveBandMaximum:${band.category}');
      if (count > 0 && band.requiresAdult && !adultPresent)
        reasons.add('adultRequired');
    }
    return ActivityEligibility(
      evaluatedAt: now,
      eligible: reasons.isEmpty,
      totalTravelers: mix.travelers.length,
      unsupportedTravelerIds: unsupported,
      reasonCodes: reasons.toSet().toList(),
      assignedCategories: categories,
      capacityTravelers: capacity,
      requiresReview: bands.isEmpty,
    );
  }

  static List<Map<String, Object?>> paxMix(ActivityEligibility result) {
    ActivityGuard.record(result.validate());
    if (!result.eligible)
      throw StateError('Traveler eligibility must be resolved');
    final counts = <String, int>{};
    for (final category in result.assignedCategories)
      counts[category] = (counts[category] ?? 0) + 1;
    return List.unmodifiable([
      for (final e in counts.entries)
        {'ageBand': e.key.toUpperCase(), 'numberOfTravelers': e.value},
    ]);
  }
}
