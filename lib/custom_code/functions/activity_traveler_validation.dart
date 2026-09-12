Map<String, dynamic> activityTravelerValidation(
  List<dynamic>? ageBands,
  List<int>? travelerAges,
  int? minimumTravelers,
  int? maximumTravelers,
) {
  final ages = travelerAges ?? [];

  if (ages.isEmpty) {
    return {
      'valid': false,
      'totalTravelers': 0,
      'reason': 'no_travelers',
      'unsupportedAges': <int>[],
      'travelerGroups': <String, int>{},
    };
  }

  if (minimumTravelers != null &&
      ages.length < minimumTravelers) {
    return {
      'valid': false,
      'totalTravelers': ages.length,
      'reason': 'below_minimum_travelers',
      'unsupportedAges': <int>[],
      'travelerGroups': <String, int>{},
    };
  }

  if (maximumTravelers != null &&
      ages.length > maximumTravelers) {
    return {
      'valid': false,
      'totalTravelers': ages.length,
      'reason': 'above_maximum_travelers',
      'unsupportedAges': <int>[],
      'travelerGroups': <String, int>{},
    };
  }

  final normalizedBands = _normalizeAgeBands(ageBands);
  final unsupportedAges = <int>[];
  final groups = <String, int>{};

  for (final age in ages) {
    Map<String, dynamic>? matchingBand;

    for (final band in normalizedBands) {
      final minimum = band['minAge'] as int?;
      final maximum = band['maxAge'] as int?;

      final aboveMinimum =
          minimum == null || age >= minimum;

      final belowMaximum =
          maximum == null || age <= maximum;

      if (aboveMinimum && belowMaximum) {
        matchingBand = band;
        break;
      }
    }

    if (matchingBand == null) {
      unsupportedAges.add(age);
      continue;
    }

    final category =
        matchingBand['category'] as String? ?? 'traveler';

    groups[category] = (groups[category] ?? 0) + 1;
  }

  if (unsupportedAges.isNotEmpty) {
    return {
      'valid': false,
      'totalTravelers': ages.length,
      'reason': 'unsupported_age',
      'unsupportedAges': unsupportedAges,
      'travelerGroups': groups,
    };
  }

  return {
    'valid': true,
    'totalTravelers': ages.length,
    'reason': null,
    'unsupportedAges': <int>[],
    'travelerGroups': groups,
  };
}

List<Map<String, dynamic>> _normalizeAgeBands(
  List<dynamic>? ageBands,
) {
  if (ageBands == null || ageBands.isEmpty) {
    return [
      {
        'category': 'adult',
        'minAge': 18,
        'maxAge': null,
      },
      {
        'category': 'child',
        'minAge': 3,
        'maxAge': 17,
      },
      {
        'category': 'infant',
        'minAge': 0,
        'maxAge': 2,
      },
    ];
  }

  final result = <Map<String, dynamic>>[];

  for (final item in ageBands) {
    if (item is! Map) {
      continue;
    }

    final map = Map<String, dynamic>.from(item);

    final category =
        map['category'] ??
        map['name'] ??
        map['type'] ??
        map['ageBand'];

    result.add({
      'category': category?.toString().toLowerCase() ??
          'traveler',
      'minAge': _travelerAge(
        map['minAge'] ?? map['minimumAge'] ?? map['from'],
      ),
      'maxAge': _travelerAge(
        map['maxAge'] ?? map['maximumAge'] ?? map['to'],
      ),
    });
  }

  return result;
}

int? _travelerAge(dynamic value) {
  if (value is int) {
    return value;
  }

  if (value is num) {
    return value.round();
  }

  if (value is String) {
    return int.tryParse(value.trim());
  }

  return null;
}
