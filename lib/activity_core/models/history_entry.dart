// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityHistoryEntry {
  ActivityHistoryEntry({
    required this.id,
    required this.scope,
    required this.kind,
    required this.resourceId,
    required this.occurredAt,
    this.text,
    this.count = 1,
    this.revision = 1,
  });

  final String id;
  final String scope;
  final String kind;
  final String resourceId;
  final DateTime occurredAt;
  final String? text;
  final int count;
  final int revision;

  factory ActivityHistoryEntry.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "kind",
      "resourceId",
      "occurredAt",
      "text",
      "count",
      "revision",
    });
    final value = ActivityHistoryEntry(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      kind: ActivityCodec.text(json, 'kind', required: true)!,
      resourceId: ActivityCodec.text(json, 'resourceId', required: true)!,
      occurredAt: ActivityCodec.date(json, 'occurredAt', required: true)!,
      text: ActivityCodec.text(json, 'text'),
      count:
          ActivityCodec.integer(
            json,
            'count',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
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

  static ActivityResult<ActivityHistoryEntry> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityHistoryEntry.fromJson(ActivityCodec.object(input)),
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

  ActivityHistoryEntry copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? kind,
    String? resourceId,
    DateTime? occurredAt,
    String? text,
    int? count,
    int? revision,
  }) {
    final clearableFields = <String>{"text"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityHistoryEntry(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      kind: (kind ?? this.kind),
      resourceId: (resourceId ?? this.resourceId),
      occurredAt: (occurredAt ?? this.occurredAt),
      text: clear.contains('text') ? null : (text ?? this.text),
      count: (count ?? this.count),
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
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
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
    if (text != null) {
      if (text!.trim().isEmpty || text!.length > 4000)
        validationIssues.add(
          const ActivityIssue('text', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (count < 0 || count > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'count',
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
    if (revision < 1 ||
        count < 1 ||
        count > 1000000 ||
        text != null && text!.length > 200 ||
        !{'search', 'view', 'save', 'booking'}.contains(kind))
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
    "kind": kind,
    "resourceId": resourceId,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    if (text != null) "text": text,
    "count": count,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityHistoryEntry &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityHistoryEntry(redacted)';
}
