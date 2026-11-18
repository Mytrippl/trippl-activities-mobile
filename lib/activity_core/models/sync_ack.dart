// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'sync_conflict.dart';

class ActivitySyncAck {
  ActivitySyncAck({
    required this.batchId,
    required this.scope,
    required this.receivedAt,
    List<String> acknowledgedIds = const [],
    List<String> retryIds = const [],
    List<ActivitySyncConflict> conflicts = const [],
    this.cursor,
    this.complete = false,
  }) : acknowledgedIds = List.unmodifiable(acknowledgedIds),
       retryIds = List.unmodifiable(retryIds),
       conflicts = List.unmodifiable(conflicts);

  final String batchId;
  final String scope;
  final DateTime receivedAt;
  final List<String> acknowledgedIds;
  final List<String> retryIds;
  final List<ActivitySyncConflict> conflicts;
  final String? cursor;
  final bool complete;

  factory ActivitySyncAck.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "batchId",
      "scope",
      "receivedAt",
      "acknowledgedIds",
      "retryIds",
      "conflicts",
      "cursor",
      "complete",
    });
    final value = ActivitySyncAck(
      batchId: ActivityCodec.text(json, 'batchId', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      receivedAt: ActivityCodec.date(json, 'receivedAt', required: true)!,
      acknowledgedIds:
          ActivityCodec.list(json, 'acknowledgedIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      retryIds:
          ActivityCodec.list(json, 'retryIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      conflicts:
          ActivityCodec.list(
            json,
            'conflicts',
            (v) => ActivitySyncConflict.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      cursor: ActivityCodec.text(json, 'cursor'),
      complete: ActivityCodec.boolean(json, 'complete') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySyncAck> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySyncAck.fromJson(ActivityCodec.object(input)),
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

  ActivitySyncAck copyWith({
    Set<String> clear = const {},
    String? batchId,
    String? scope,
    DateTime? receivedAt,
    List<String>? acknowledgedIds,
    List<String>? retryIds,
    List<ActivitySyncConflict>? conflicts,
    String? cursor,
    bool? complete,
  }) {
    final clearableFields = <String>{"cursor"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySyncAck(
      batchId: (batchId ?? this.batchId),
      scope: (scope ?? this.scope),
      receivedAt: (receivedAt ?? this.receivedAt),
      acknowledgedIds: (acknowledgedIds ?? this.acknowledgedIds),
      retryIds: (retryIds ?? this.retryIds),
      conflicts: (conflicts ?? this.conflicts),
      cursor: clear.contains('cursor') ? null : (cursor ?? this.cursor),
      complete: (complete ?? this.complete),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (batchId.trim().isEmpty || batchId.length > 4000)
        validationIssues.add(
          const ActivityIssue('batchId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (acknowledgedIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'acknowledgedIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (acknowledgedIds.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const ActivityIssue(
            'acknowledgedIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (retryIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'retryIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (retryIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'retryIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (conflicts.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'conflicts',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < conflicts.length; i++)
        for (final issue in conflicts[i].validate())
          validationIssues.add(
            ActivityIssue(
              'conflicts[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (cursor != null) {
      if (cursor!.trim().isEmpty || cursor!.length > 4000)
        validationIssues.add(
          const ActivityIssue('cursor', 'text', 'Use nonempty bounded text'),
        );
    }
    if (acknowledgedIds.toSet().length != acknowledgedIds.length ||
        retryIds.toSet().length != retryIds.length ||
        acknowledgedIds.any(retryIds.contains))
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
    "batchId": batchId,
    "scope": scope,
    "receivedAt": receivedAt.toUtc().toIso8601String(),
    "acknowledgedIds": acknowledgedIds,
    "retryIds": retryIds,
    "conflicts": conflicts.map((item) => item.toJson()).toList(),
    if (cursor != null) "cursor": cursor,
    "complete": complete,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySyncAck && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySyncAck(redacted)';
}
