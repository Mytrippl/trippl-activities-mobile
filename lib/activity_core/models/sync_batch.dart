// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'sync_mutation.dart';

class ActivitySyncBatch {
  ActivitySyncBatch({
    required this.id,
    required this.scope,
    required this.createdAt,
    List<ActivitySyncMutation> mutations = const [],
    this.generation = 1,
    this.cursor,
  }) : mutations = List.unmodifiable(mutations);

  final String id;
  final String scope;
  final DateTime createdAt;
  final List<ActivitySyncMutation> mutations;
  final int generation;
  final String? cursor;

  factory ActivitySyncBatch.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "createdAt",
      "mutations",
      "generation",
      "cursor",
    });
    final value = ActivitySyncBatch(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      mutations:
          ActivityCodec.list(
            json,
            'mutations',
            (v) => ActivitySyncMutation.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      generation:
          ActivityCodec.integer(
            json,
            'generation',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      cursor: ActivityCodec.text(json, 'cursor'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySyncBatch> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySyncBatch.fromJson(ActivityCodec.object(input)),
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

  ActivitySyncBatch copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    DateTime? createdAt,
    List<ActivitySyncMutation>? mutations,
    int? generation,
    String? cursor,
  }) {
    final clearableFields = <String>{"cursor"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySyncBatch(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      createdAt: (createdAt ?? this.createdAt),
      mutations: (mutations ?? this.mutations),
      generation: (generation ?? this.generation),
      cursor: clear.contains('cursor') ? null : (cursor ?? this.cursor),
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
      if (mutations.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'mutations',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < mutations.length; i++)
        for (final issue in mutations[i].validate())
          validationIssues.add(
            ActivityIssue(
              'mutations[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (generation < 0 || generation > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'generation',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (cursor != null) {
      if (cursor!.trim().isEmpty || cursor!.length > 4000)
        validationIssues.add(
          const ActivityIssue('cursor', 'text', 'Use nonempty bounded text'),
        );
    }
    if (generation < 1 ||
        mutations.map((m) => m.id).toSet().length != mutations.length ||
        mutations.any((m) => m.scope != scope))
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
    "createdAt": createdAt.toUtc().toIso8601String(),
    "mutations": mutations.map((item) => item.toJson()).toList(),
    "generation": generation,
    if (cursor != null) "cursor": cursor,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySyncBatch &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySyncBatch(redacted)';
}
