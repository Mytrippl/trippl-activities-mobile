Map<String, dynamic> activitySearchRequest(
  String? destinationId,
  String? productId,
  DateTime? startDate,
  DateTime? endDate,
  int? adults,
  int? children,
  int? infants,
  String? currency,
  String? language,
  int? page,
  int? pageSize,
  double? minPrice,
  double? maxPrice,
  double? minRating,
  bool? freeCancellation,
) {
  final body = <String, dynamic>{};

  _addActivityRequestString(
    body,
    'destinationId',
    destinationId,
  );

  _addActivityRequestString(
    body,
    'productId',
    productId,
  );

  if (startDate != null) {
    body['startDate'] = _activityDate(startDate);
  }

  if (endDate != null) {
    body['endDate'] = _activityDate(endDate);
  }

  final travelers = <String, dynamic>{};

  if (adults != null && adults > 0) {
    travelers['adults'] = adults;
  }

  if (children != null && children > 0) {
    travelers['children'] = children;
  }

  if (infants != null && infants > 0) {
    travelers['infants'] = infants;
  }

  if (travelers.isNotEmpty) {
    body['travelers'] = travelers;
    body['totalTravelers'] = travelers.values
        .whereType<int>()
        .fold<int>(0, (sum, value) => sum + value);
  }

  if (currency != null && currency.trim().isNotEmpty) {
    body['currency'] = currency.trim().toUpperCase();
  }

  if (language != null && language.trim().isNotEmpty) {
    body['language'] = language.trim().toLowerCase();
  }

  final pagination = <String, dynamic>{};

  if (page != null && page > 0) {
    pagination['page'] = page;
  }

  if (pageSize != null && pageSize > 0) {
    pagination['pageSize'] = pageSize.clamp(1, 100);
  }

  if (pagination.isNotEmpty) {
    body['pagination'] = pagination;
  }

  final filters = <String, dynamic>{};

  if (minPrice != null && minPrice >= 0) {
    filters['minPrice'] = minPrice;
  }

  if (maxPrice != null && maxPrice >= 0) {
    filters['maxPrice'] = maxPrice;
  }

  if (minPrice != null &&
      maxPrice != null &&
      minPrice > maxPrice) {
    filters['minPrice'] = maxPrice;
    filters['maxPrice'] = minPrice;
  }

  if (minRating != null) {
    filters['minRating'] = minRating.clamp(0, 5);
  }

  if (freeCancellation != null) {
    filters['freeCancellation'] = freeCancellation;
  }

  if (filters.isNotEmpty) {
    body['filters'] = filters;
  }

  return body;
}

void _addActivityRequestString(
  Map<String, dynamic> target,
  String key,
  String? value,
) {
  if (value == null) {
    return;
  }

  final normalized = value.trim();

  if (normalized.isNotEmpty) {
    target[key] = normalized;
  }
}

String _activityDate(DateTime date) {
  final year = date.year.toString().padLeft(4, '0');
  final month = date.month.toString().padLeft(2, '0');
  final day = date.day.toString().padLeft(2, '0');

  return '$year-$month-$day';
}
