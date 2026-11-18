import '../trippl_activities_mobile.dart';

class ActivityRequests {
  ActivityRequests({
    required this.scope,
    required this.clock,
    this.maximumPageSize = 100,
  }) {
    ActivityGuard.identity(scope);
    if (scope.length > 120 || maximumPageSize < 1 || maximumPageSize > 100)
      throw ArgumentError('Invalid activity request policy');
  }
  final String scope;
  final DateTime Function() clock;
  final int maximumPageSize;
  int _sequence = 0;
  String _id() => 'activity-${clock().microsecondsSinceEpoch}-${++_sequence}';
  static String fingerprint(ActivityProviderRequest request) {
    validate(request);
    final payload = request.toJson()
      ..remove('id')
      ..remove('createdAt')
      ..remove('cursor');
    return ActivityCodec.digest(payload);
  }

  static void validate(ActivityProviderRequest request) {
    ActivityGuard.record(request.validate());
    ActivityGuard.identity(request.scope);
    ActivityGuard.identity(request.id);
    if (request.cursor != null &&
        (request.cursor!.length > 200 || request.cursor!.trim().isEmpty))
      throw const FormatException('Invalid activity continuation cursor');
    final query = request.query;
    if (query != null) {
      ActivityGuard.language(query.language);
      if (query.startDate != null) ActivityGuard.canonicalDay(query.startDate!);
      if (query.endDate != null) ActivityGuard.canonicalDay(query.endDate!);
      if (query.startDate != null &&
          query.endDate != null &&
          query.endDate!.difference(query.startDate!).inDays > 365)
        throw const FormatException(
          'Activity search date range exceeds one year',
        );
      if (query.text.trim().isEmpty || query.text.length > 500)
        throw const FormatException('Invalid activity search text');
    }
    final availability = request.availability;
    if (availability != null &&
        (request.productId != null &&
                request.productId != availability.productId ||
            request.optionId != null &&
                request.optionId != availability.optionId ||
            request.slotId != null &&
                request.slotId != availability.selectedSlotId)) {
      throw const FormatException(
        'Activity request contains conflicting selection identities',
      );
    }

    if (availability != null) {
      ActivityGuard.canonicalDay(availability.travelDate);
      ActivityGuard.language(availability.language);
      ActivityGuard.identity(availability.productId);
      ActivityGuard.identity(availability.optionId);
      if (availability.selectedSlotId != null)
        ActivityGuard.identity(availability.selectedSlotId!);
      if (availability.selectedLanguage != null)
        ActivityGuard.language(availability.selectedLanguage!);

      if (availability.travelers.travelers.isEmpty)
        throw const FormatException('Activity availability needs travelers');
    }
    if (request.mode == 'quote' &&
        (request.slotId == null ||
            availability?.selectedSlotId != request.slotId))
      throw const FormatException('Quote requires an exact slot selection');
  }

  ActivityProviderRequest search(
    ActivitySearchQuery query, {
    ActivityFieldMask? mask,
  }) {
    final request = ActivityProviderRequest(
      id: _id(),
      scope: scope,
      createdAt: clock(),
      mode: 'search',
      query: query,
      limit: query.limit > maximumPageSize ? maximumPageSize : query.limit,
      fieldMask: mask?.fields ?? const [],
    );
    validate(request);
    return request;
  }

  ActivityProviderRequest details(String productId, {ActivityFieldMask? mask}) {
    ActivityGuard.identity(productId);
    final request = ActivityProviderRequest(
      id: _id(),
      scope: scope,
      createdAt: clock(),
      mode: 'details',
      productId: productId,
      fieldMask: mask?.fields ?? const [],
    );
    validate(request);
    return request;
  }

  ActivityProviderRequest availability(
    ActivityAvailabilityRequest value, {
    bool quote = false,
  }) {
    final request = ActivityProviderRequest(
      id: _id(),
      scope: scope,
      createdAt: clock(),
      mode: quote ? 'quote' : 'availability',
      availability: value,
      productId: value.productId,
      optionId: value.optionId,
      slotId: value.selectedSlotId,
      limit: 100,
    );
    validate(request);
    return request;
  }

  ActivityProviderRequest next(ActivityProviderRequest root, String cursor) {
    if (root.scope != scope) throw StateError('Activity query scope mismatch');
    final result = root.copyWith(id: _id(), createdAt: clock(), cursor: cursor);
    validate(result);
    return result;
  }

  static Map<String, Object?> backendAvailability(
    ActivityAvailabilityRequest request,
    ActivityOption option, {
    required DateTime now,
  }) {
    ActivityGuard.record(request.validate());
    ActivityGuard.canonicalDay(request.travelDate);
    if (request.productId != option.productId || request.optionId != option.id)
      throw const FormatException('Availability option mismatch');
    final eligible = ActivityTravelers.assess(
      request.travelers,
      option.ageBands,
      now: now,
      minimumTravelers: option.minimumTravelers,
      maximumTravelers: option.maximumTravelers,
    );
    return {
      'productCode': request.productId,
      'productOptionCode': request.optionId,
      'travelDate': ActivityCodec.calendarText(request.travelDate),
      'currency': request.currency,
      'paxMix': ActivityTravelers.paxMix(eligible),
      if (request.selectedLanguage != null)
        'language': request.selectedLanguage,
    };
  }
}
