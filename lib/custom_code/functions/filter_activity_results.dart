List<dynamic> filterActivityResults(
  List<dynamic>? activities,
  double? minPrice,
  double? maxPrice,
  double? minRating,
  bool? freeCancellationOnly,
  bool? instantConfirmationOnly,
  int? minDurationMinutes,
  int? maxDurationMinutes,
  String? guideLanguage,
) {
  if (activities == null || activities.isEmpty) {
    return [];
  }

  final normalizedLanguage = guideLanguage?.trim().toLowerCase();

  return activities.where((activity) {
    if (activity is! Map) {
      return false;
    }

    final map = Map<String, dynamic>.from(activity);

    final price = _activityNumber(
      map,
      ['price', 'amount', 'fromPrice', 'startingPrice', 'totalPrice'],
    );

    if (minPrice != null && price != null && price < minPrice) {
      return false;
    }

    if (maxPrice != null && price != null && price > maxPrice) {
      return false;
    }

    if ((minPrice != null || maxPrice != null) && price == null) {
      return false;
    }

    final rating = _activityNumber(
      map,
      ['rating', 'averageRating', 'reviewRating'],
    );

    if (minRating != null) {
      if (rating == null || rating < minRating) {
        return false;
      }
    }

    if (freeCancellationOnly == true) {
      final freeCancellation = _activityBool(
        map,
        [
          'freeCancellation',
          'hasFreeCancellation',
          'refundable',
          'isRefundable',
        ],
      );

      if (freeCancellation != true) {
        return false;
      }
    }

    if (instantConfirmationOnly == true) {
      final instantConfirmation = _activityBool(
        map,
        [
          'instantConfirmation',
          'isInstantConfirmation',
          'instantConfirm',
        ],
      );

      if (instantConfirmation != true) {
        return false;
      }
    }

    final duration = _activityInt(
      map,
      [
        'durationMinutes',
        'duration',
        'totalDurationMinutes',
      ],
    );

    if (minDurationMinutes != null) {
      if (duration == null || duration < minDurationMinutes) {
        return false;
      }
    }

    if (maxDurationMinutes != null) {
      if (duration == null || duration > maxDurationMinutes) {
        return false;
      }
    }

    if (normalizedLanguage != null && normalizedLanguage.isNotEmpty) {
      final languages = _activityLanguages(map);

      if (!languages.contains(normalizedLanguage)) {
        return false;
      }
    }

    final available = _activityBool(
      map,
      ['available', 'isAvailable', 'bookable'],
    );

    if (available == false) {
      return false;
    }

    return true;
  }).toList();
}

double? _activityNumber(
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

int? _activityInt(
  Map<String, dynamic> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = map[key];

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.round();
    }

    if (value is String) {
      final parsed = int.tryParse(value.trim());

      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}

bool? _activityBool(
  Map<String, dynamic> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = map[key];

    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();

      if (normalized == 'true' ||
          normalized == 'yes' ||
          normalized == '1') {
        return true;
      }

      if (normalized == 'false' ||
          normalized == 'no' ||
          normalized == '0') {
        return false;
      }
    }
  }

  return null;
}

Set<String> _activityLanguages(
  Map<String, dynamic> map,
) {
  final result = <String>{};

  final possibleValues = [
    map['languages'],
    map['guideLanguages'],
    map['availableLanguages'],
  ];

  for (final value in possibleValues) {
    if (value is List) {
      for (final language in value) {
        if (language is String) {
          result.add(language.trim().toLowerCase());
        } else if (language is Map) {
          final code = language['code'];
          final name = language['name'];

          if (code is String) {
            result.add(code.trim().toLowerCase());
          }

          if (name is String) {
            result.add(name.trim().toLowerCase());
          }
        }
      }
    }
  }

  return result;
}
