// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityAuditEvent {
  ActivityAuditEvent({
    required this.id,
    required this.scope,
    required this.resourceId,
    required this.kind,
    required this.occurredAt,
    List<String> reasonCodes = const [],
    this.revision = 1,
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String id;
  final String scope;
  final String resourceId;
  final String kind;
  final DateTime occurredAt;
  final List<String> reasonCodes;
  final int revision;

  factory ActivityAuditEvent.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "resourceId",
      "kind",
      "occurredAt",
      "reasonCodes",
      "revision",
    });
    final value = ActivityAuditEvent(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      resourceId: ActivityCodec.text(json, 'resourceId', required: true)!,
      kind: ActivityCodec.text(json, 'kind', required: true)!,
      occurredAt: ActivityCodec.date(json, 'occurredAt', required: true)!,
      reasonCodes:
          ActivityCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityAuditEvent> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAuditEvent.fromJson(ActivityCodec.object(input)),
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

  ActivityAuditEvent copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? resourceId,
    String? kind,
    DateTime? occurredAt,
    List<String>? reasonCodes,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAuditEvent(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      resourceId: (resourceId ?? this.resourceId),
      kind: (kind ?? this.kind),
      occurredAt: (occurredAt ?? this.occurredAt),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      revision: (revision ?? this.revision),
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
      if (resourceId.trim().isEmpty || resourceId.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'resourceId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
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
    if (revision < 1 ||
        !{
          'draft',
          'submitted',
          'reconciled',
          'saved',
          'removed',
          'exported',
          'erased',
          'failure',
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
    "resourceId": resourceId,
    "kind": kind,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "reasonCodes": reasonCodes,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAuditEvent &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAuditEvent(redacted)';
}
