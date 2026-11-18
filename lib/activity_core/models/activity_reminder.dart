// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityReminder {
  ActivityReminder({
    required this.id,
    required this.scope,
    required this.resourceId,
    required this.dueAt,
    required this.createdAt,
    this.leadMinutes = 30,
    this.enabled = false,
    this.delivered = false,
    this.revision = 1,
  });

  final String id;
  final String scope;
  final String resourceId;
  final DateTime dueAt;
  final DateTime createdAt;
  final int leadMinutes;
  final bool enabled;
  final bool delivered;
  final int revision;

  factory ActivityReminder.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "resourceId",
      "dueAt",
      "createdAt",
      "leadMinutes",
      "enabled",
      "delivered",
      "revision",
    });
    final value = ActivityReminder(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      resourceId: ActivityCodec.text(json, 'resourceId', required: true)!,
      dueAt: ActivityCodec.date(json, 'dueAt', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      leadMinutes:
          ActivityCodec.integer(
            json,
            'leadMinutes',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          30,
      enabled: ActivityCodec.boolean(json, 'enabled') ?? false,
      delivered: ActivityCodec.boolean(json, 'delivered') ?? false,
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

  static ActivityResult<ActivityReminder> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityReminder.fromJson(ActivityCodec.object(input)),
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

  ActivityReminder copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? resourceId,
    DateTime? dueAt,
    DateTime? createdAt,
    int? leadMinutes,
    bool? enabled,
    bool? delivered,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityReminder(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      resourceId: (resourceId ?? this.resourceId),
      dueAt: (dueAt ?? this.dueAt),
      createdAt: (createdAt ?? this.createdAt),
      leadMinutes: (leadMinutes ?? this.leadMinutes),
      enabled: (enabled ?? this.enabled),
      delivered: (delivered ?? this.delivered),
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
      if (leadMinutes < 0 || leadMinutes > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'leadMinutes',
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
    if (revision < 1 || leadMinutes > 10080 || dueAt.isBefore(createdAt))
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
    "dueAt": dueAt.toUtc().toIso8601String(),
    "createdAt": createdAt.toUtc().toIso8601String(),
    "leadMinutes": leadMinutes,
    "enabled": enabled,
    "delivered": delivered,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityReminder && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityReminder(redacted)';
}
