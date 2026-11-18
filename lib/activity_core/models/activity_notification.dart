// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityActivityNotification {
  ActivityActivityNotification({
    required this.id,
    required this.scope,
    required this.resourceId,
    required this.kind,
    required this.createdAt,
    required this.expiresAt,
    this.read = false,
    this.dismissed = false,
    this.revision = 1,
  });

  final String id;
  final String scope;
  final String resourceId;
  final String kind;
  final DateTime createdAt;
  final DateTime expiresAt;
  final bool read;
  final bool dismissed;
  final int revision;

  factory ActivityActivityNotification.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "resourceId",
      "kind",
      "createdAt",
      "expiresAt",
      "read",
      "dismissed",
      "revision",
    });
    final value = ActivityActivityNotification(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      resourceId: ActivityCodec.text(json, 'resourceId', required: true)!,
      kind: ActivityCodec.text(json, 'kind', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      expiresAt: ActivityCodec.date(json, 'expiresAt', required: true)!,
      read: ActivityCodec.boolean(json, 'read') ?? false,
      dismissed: ActivityCodec.boolean(json, 'dismissed') ?? false,
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

  static ActivityResult<ActivityActivityNotification> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityActivityNotification.fromJson(
          ActivityCodec.object(input),
        ),
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

  ActivityActivityNotification copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? resourceId,
    String? kind,
    DateTime? createdAt,
    DateTime? expiresAt,
    bool? read,
    bool? dismissed,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityActivityNotification(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      resourceId: (resourceId ?? this.resourceId),
      kind: (kind ?? this.kind),
      createdAt: (createdAt ?? this.createdAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      read: (read ?? this.read),
      dismissed: (dismissed ?? this.dismissed),
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
        !expiresAt.isAfter(createdAt) ||
        !{
          'booking',
          'voucher',
          'cancellation',
          'refund',
          'reminder',
          'conflict',
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
    "createdAt": createdAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "read": read,
    "dismissed": dismissed,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityActivityNotification &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityActivityNotification(redacted)';
}
