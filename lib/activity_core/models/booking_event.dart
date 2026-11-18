// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityBookingEvent {
  ActivityBookingEvent({
    required this.id,
    required this.scope,
    required this.bookingId,
    required this.kind,
    required this.occurredAt,
    this.revision = 1,
    List<String> reasonCodes = const [],
    this.intentId,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String id;
  final String scope;
  final String bookingId;
  final String kind;
  final DateTime occurredAt;
  final int revision;
  final List<String> reasonCodes;
  final String? intentId;

  factory ActivityBookingEvent.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "bookingId",
      "kind",
      "occurredAt",
      "revision",
      "reasonCodes",
      "intentId",
    });
    final value = ActivityBookingEvent(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      kind: ActivityCodec.text(json, 'kind', required: true)!,
      occurredAt: ActivityCodec.date(json, 'occurredAt', required: true)!,
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      reasonCodes:
          ActivityCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      intentId: ActivityCodec.text(json, 'intentId'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityBookingEvent> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityBookingEvent.fromJson(ActivityCodec.object(input)),
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

  ActivityBookingEvent copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? bookingId,
    String? kind,
    DateTime? occurredAt,
    int? revision,
    List<String>? reasonCodes,
    String? intentId,
  }) {
    final clearableFields = <String>{"intentId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityBookingEvent(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      bookingId: (bookingId ?? this.bookingId),
      kind: (kind ?? this.kind),
      occurredAt: (occurredAt ?? this.occurredAt),
      revision: (revision ?? this.revision),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      intentId: clear.contains('intentId') ? null : (intentId ?? this.intentId),
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
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (bookingId.trim().isEmpty || bookingId.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
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
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (intentId != null) {
      if (intentId!.trim().isEmpty || intentId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (revision < 1 ||
        !{
          'submitted',
          'pending',
          'confirmed',
          'rejected',
          'cancelRequested',
          'cancelled',
          'reconciled',
          'unknown',
        }.contains(kind))
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
    "scope": scope,
    "bookingId": bookingId,
    "kind": kind,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "revision": revision,
    "reasonCodes": reasonCodes,
    if (intentId != null) "intentId": intentId,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityBookingEvent &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityBookingEvent(redacted)';
}
