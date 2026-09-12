List<dynamic> sortActivityResults(
  List<dynamic>? activities,
  String? sortType,
) {
  if (activities == null || activities.isEmpty) {
    return [];
  }

  final results = List<dynamic>.from(activities);
  final normalizedSort = sortType?.trim().toLowerCase() ?? 'recommended';

  if (normalizedSort == 'recommended' ||
      normalizedSort == 'default') {
    return results;
  }

  results.sort((a, b) {
    if (a is! Map || b is! Map) {
      return 0;
    }

    final first = Map<String, dynamic>.from(a);
    final second = Map<String, dynamic>.from(b);

    switch (normalizedSort) {
      case 'price_low':
      case 'price_low_to_high':
      case 'lowest_price':
        return _sortActivityNumber(
          first,
          second,
          ['price', 'amount', 'fromPrice', 'startingPrice'],
          ascending: true,
        );

      case 'price_high':
      case 'price_high_to_low':
      case 'highest_price':
        return _sortActivityNumber(
          first,
          second,
          ['price', 'amount', 'fromPrice', 'startingPrice'],
          ascending: false,
        );

      case 'rating':
      case 'highest_rating':
        return _sortActivityNumber(
          first,
          second,
          ['rating', 'averageRating', 'reviewRating'],
          ascending: false,
        );

      case 'reviews':
      case 'review_count':
      case 'most_reviewed':
        return _sortActivityNumber(
          first,
          second,
          ['reviewCount', 'reviews', 'numberOfReviews'],
          ascending: false,
        );

      case 'duration_short':
      case 'shortest':
        return _sortActivityNumber(
          first,
          second,
          ['durationMinutes', 'duration', 'totalDurationMinutes'],
          ascending: true,
        );

      case 'duration_long':
      case 'longest':
        return _sortActivityNumber(
          first,
          second,
          ['durationMinutes', 'duration', 'totalDurationMinutes'],
          ascending: false,
        );

      default:
        return 0;
    }
  });

  return results;
}

int _sortActivityNumber(
  Map<String, dynamic> first,
  Map<String, dynamic> second,
  List<String> keys, {
  required bool ascending,
}) {
  final firstValue = _sortValue(first, keys);
  final secondValue = _sortValue(second, keys);

  if (firstValue == null && secondValue == null) {
    return 0;
  }

  if (firstValue == null) {
    return 1;
  }

  if (secondValue == null) {
    return -1;
  }

  final comparison = firstValue.compareTo(secondValue);

  return ascending ? comparison : -comparison;
}

double? _sortValue(
  Map<String, dynamic> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = map[key];

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      final parsed = double.tryParse(
        value.replaceAll(',', '').trim(),
      );

      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}
