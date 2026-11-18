// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'product.dart';

class ActivityItineraryStop {
  ActivityItineraryStop({
    required this.id,
    required this.dayId,
    required this.product,
    required this.startsAt,
    required this.endsAt,
    this.arrivalBufferMinutes = 0,
    this.transferMinutes = 0,
    this.revision = 1,
    this.bookingId,
    this.confirmed = false,
  });

  final String id;
  final String dayId;
  final ActivityProduct product;
  final DateTime startsAt;
  final DateTime endsAt;
  final int arrivalBufferMinutes;
  final int transferMinutes;
  final int revision;
  final String? bookingId;
  final bool confirmed;

  factory ActivityItineraryStop.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "dayId",
      "product",
      "startsAt",
      "endsAt",
      "arrivalBufferMinutes",
      "transferMinutes",
      "revision",
      "bookingId",
      "confirmed",
    });
    final value = ActivityItineraryStop(
      id: ActivityCodec.text(json, 'id', required: true)!,
      dayId: ActivityCodec.text(json, 'dayId', required: true)!,
      product: (json['product'] == null
          ? null
          : ActivityProduct.fromJson(ActivityCodec.object(json['product'])))!,
      startsAt: ActivityCodec.date(json, 'startsAt', required: true)!,
      endsAt: ActivityCodec.date(json, 'endsAt', required: true)!,
      arrivalBufferMinutes:
          ActivityCodec.integer(
            json,
            'arrivalBufferMinutes',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      transferMinutes:
          ActivityCodec.integer(
            json,
            'transferMinutes',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      bookingId: ActivityCodec.text(json, 'bookingId'),
      confirmed: ActivityCodec.boolean(json, 'confirmed') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityItineraryStop> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityItineraryStop.fromJson(ActivityCodec.object(input)),
      );
    } on ActivityValidationException catch (e) {
      return ActivityResult(issues: e.issues);
    } on FormatException {
      return ActivityResult(
        issues: const [
          ActivityIssue(
            'record',
            'format',
            'Activity record has invalid fields or values',
          ),
        ],
      );
    }
  }

  ActivityItineraryStop copyWith({
    Set<String> clear = const {},
    String? id,
    String? dayId,
    ActivityProduct? product,
    DateTime? startsAt,
    DateTime? endsAt,
    int? arrivalBufferMinutes,
    int? transferMinutes,
    int? revision,
    String? bookingId,
    bool? confirmed,
  }) {
    final clearableFields = <String>{"bookingId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityItineraryStop(
      id: (id ?? this.id),
      dayId: (dayId ?? this.dayId),
      product: (product ?? this.product),
      startsAt: (startsAt ?? this.startsAt),
      endsAt: (endsAt ?? this.endsAt),
      arrivalBufferMinutes: (arrivalBufferMinutes ?? this.arrivalBufferMinutes),
      transferMinutes: (transferMinutes ?? this.transferMinutes),
      revision: (revision ?? this.revision),
      bookingId: clear.contains('bookingId')
          ? null
          : (bookingId ?? this.bookingId),
      confirmed: (confirmed ?? this.confirmed),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (id.trim().isEmpty || id.length > 4000)
        validationIssues.add(
          const ActivityIssue('id', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (dayId.trim().isEmpty || dayId.length > 4000)
        validationIssues.add(
          const ActivityIssue('dayId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in product.validate())
        validationIssues.add(
          ActivityIssue(
            'product.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (arrivalBufferMinutes < 0 || arrivalBufferMinutes > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'arrivalBufferMinutes',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (transferMinutes < 0 || transferMinutes > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'transferMinutes',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (revision < 0 || revision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'revision',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (bookingId != null) {
      if (bookingId!.trim().isEmpty || bookingId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (revision < 1 ||
        !endsAt.isAfter(startsAt) ||
        arrivalBufferMinutes > 1440 ||
        transferMinutes > 1440)
      validationIssues.add(
        const ActivityIssue(
          'record',
          'contract',
          'Record violates its domain constraints',
        ),
      );
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "id": id,
    "dayId": dayId,
    "product": product.toJson(),
    "startsAt": startsAt.toUtc().toIso8601String(),
    "endsAt": endsAt.toUtc().toIso8601String(),
    "arrivalBufferMinutes": arrivalBufferMinutes,
    "transferMinutes": transferMinutes,
    "revision": revision,
    if (bookingId != null) "bookingId": bookingId,
    "confirmed": confirmed,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityItineraryStop &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityItineraryStop(redacted)';
}
