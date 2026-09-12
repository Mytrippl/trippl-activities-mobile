Map<String, dynamic> activityPriceSummary(
  dynamic activity,
  int? travelerCount,
) {
  if (activity is! Map) {
    return {
      'valid': false,
      'currency': null,
      'unitPrice': null,
      'originalPrice': null,
      'totalPrice': null,
      'discountPercent': 0,
      'pricingType': 'unknown',
      'travelerCount': travelerCount ?? 1,
    };
  }

  final map = Map<String, dynamic>.from(activity);
  final count = travelerCount != null && travelerCount > 0
      ? travelerCount
      : 1;

  final currency = _priceString(
    map,
    ['currency', 'currencyCode', 'priceCurrency'],
  );

  final currentPrice = _priceNumber(
    map,
    ['price', 'amount', 'fromPrice', 'startingPrice'],
  );

  final originalPrice = _priceNumber(
    map,
    ['originalPrice', 'retailPrice', 'wasPrice'],
  );

  final rawPricingType = _priceString(
    map,
    ['pricingType', 'priceType', 'unit'],
  );

  final pricingType = _normalizePricingType(rawPricingType);

  double? totalPrice;

  if (currentPrice != null) {
    if (pricingType == 'per_person') {
      totalPrice = currentPrice * count;
    } else {
      totalPrice = currentPrice;
    }
  }

  var discountPercent = 0.0;

  if (currentPrice != null &&
      originalPrice != null &&
      originalPrice > 0 &&
      originalPrice > currentPrice) {
    discountPercent =
        ((originalPrice - currentPrice) / originalPrice) * 100;
  }

  return {
    'valid': currentPrice != null,
    'currency': currency,
    'unitPrice': currentPrice,
    'originalPrice': originalPrice,
    'totalPrice': totalPrice,
    'discountPercent': discountPercent.round(),
    'hasDiscount': discountPercent > 0,
    'pricingType': pricingType,
    'travelerCount': count,
  };
}

String _normalizePricingType(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'unknown';
  }

  final normalized = value
      .trim()
      .toLowerCase()
      .replaceAll('-', '_')
      .replaceAll(' ', '_');

  if (normalized.contains('person') ||
      normalized.contains('traveler') ||
      normalized.contains('participant')) {
    return 'per_person';
  }

  if (normalized.contains('group') ||
      normalized.contains('booking')) {
    return 'per_group';
  }

  return normalized;
}

double? _priceNumber(
  Map<String, dynamic> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = map[key];

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      final cleaned = value
          .replaceAll(',', '')
          .replaceAll(RegExp(r'[^0-9.\-]'), '');

      final parsed = double.tryParse(cleaned);

      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}

String? _priceString(
  Map<String, dynamic> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = map[key];

    if (value is String && value.trim().isNotEmpty) {
      return value.trim();
    }
  }

  return null;
}
