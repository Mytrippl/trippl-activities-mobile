// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivitySyncMutation {
  ActivitySyncMutation({
    required this.id,
    required this.scope,
    required this.resourceId,
    required this.kind,
    required this.payloadDigest,
    required this.expectedRevision,
    required this.createdAt,
    this.attempts = 0,
    this.state = "pending",
    this.nextAttemptAt,
  });

  final String id;
  final String scope;
  final String resourceId;
  final String kind;
  final String payloadDigest;
  final int expectedRevision;
  final DateTime createdAt;
  final int attempts;
  final String state;
  final DateTime? nextAttemptAt;

  factory ActivitySyncMutation.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "resourceId",
      "kind",
      "payloadDigest",
      "expectedRevision",
      "createdAt",
      "attempts",
      "state",
      "nextAttemptAt",
    });
    final value = ActivitySyncMutation(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      resourceId: ActivityCodec.text(json, 'resourceId', required: true)!,
      kind: ActivityCodec.text(json, 'kind', required: true)!,
      payloadDigest: ActivityCodec.text(json, 'payloadDigest', required: true)!,
      expectedRevision: ActivityCodec.integer(
        json,
        'expectedRevision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      attempts:
          ActivityCodec.integer(
            json,
            'attempts',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      state: ActivityCodec.text(json, 'state') ?? "pending",
      nextAttemptAt: ActivityCodec.date(json, 'nextAttemptAt'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySyncMutation> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySyncMutation.fromJson(ActivityCodec.object(input)),
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

  ActivitySyncMutation copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? resourceId,
    String? kind,
    String? payloadDigest,
    int? expectedRevision,
    DateTime? createdAt,
    int? attempts,
    String? state,
    DateTime? nextAttemptAt,
  }) {
    final clearableFields = <String>{"nextAttemptAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySyncMutation(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      resourceId: (resourceId ?? this.resourceId),
      kind: (kind ?? this.kind),
      payloadDigest: (payloadDigest ?? this.payloadDigest),
      expectedRevision: (expectedRevision ?? this.expectedRevision),
      createdAt: (createdAt ?? this.createdAt),
      attempts: (attempts ?? this.attempts),
      state: (state ?? this.state),
      nextAttemptAt: clear.contains('nextAttemptAt')
          ? null
          : (nextAttemptAt ?? this.nextAttemptAt),
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
      if (payloadDigest.trim().isEmpty || payloadDigest.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'payloadDigest',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (expectedRevision < 0 || expectedRevision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'expectedRevision',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (attempts < 0 || attempts > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'attempts',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (expectedRevision < 1 ||
        attempts > 5 ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(payloadDigest) ||
        !{'upsert', 'delete'}.contains(kind) ||
        !{'pending', 'sending', 'acknowledged', 'failed'}.contains(state))
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
    "payloadDigest": payloadDigest,
    "expectedRevision": expectedRevision,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "attempts": attempts,
    "state": state,
    if (nextAttemptAt != null)
      "nextAttemptAt": nextAttemptAt!.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySyncMutation &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySyncMutation(redacted)';
}
