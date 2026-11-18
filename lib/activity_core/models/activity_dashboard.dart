// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityActivityDashboard {
  ActivityActivityDashboard({
    required this.scope,
    required this.evaluatedAt,
    this.savedCount = 0,
    this.collectionCount = 0,
    this.pendingBookingCount = 0,
    this.confirmedBookingCount = 0,
    this.unreadNotificationCount = 0,
    this.syncPendingCount = 0,
    this.revision = 1,
  });

  final String scope;
  final DateTime evaluatedAt;
  final int savedCount;
  final int collectionCount;
  final int pendingBookingCount;
  final int confirmedBookingCount;
  final int unreadNotificationCount;
  final int syncPendingCount;
  final int revision;

  factory ActivityActivityDashboard.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "scope",
      "evaluatedAt",
      "savedCount",
      "collectionCount",
      "pendingBookingCount",
      "confirmedBookingCount",
      "unreadNotificationCount",
      "syncPendingCount",
      "revision",
    });
    final value = ActivityActivityDashboard(
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      savedCount:
          ActivityCodec.integer(
            json,
            'savedCount',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      collectionCount:
          ActivityCodec.integer(
            json,
            'collectionCount',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      pendingBookingCount:
          ActivityCodec.integer(
            json,
            'pendingBookingCount',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      confirmedBookingCount:
          ActivityCodec.integer(
            json,
            'confirmedBookingCount',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      unreadNotificationCount:
          ActivityCodec.integer(
            json,
            'unreadNotificationCount',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      syncPendingCount:
          ActivityCodec.integer(
            json,
            'syncPendingCount',
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
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityActivityDashboard> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityActivityDashboard.fromJson(ActivityCodec.object(input)),
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

  ActivityActivityDashboard copyWith({
    Set<String> clear = const {},
    String? scope,
    DateTime? evaluatedAt,
    int? savedCount,
    int? collectionCount,
    int? pendingBookingCount,
    int? confirmedBookingCount,
    int? unreadNotificationCount,
    int? syncPendingCount,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityActivityDashboard(
      scope: (scope ?? this.scope),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      savedCount: (savedCount ?? this.savedCount),
      collectionCount: (collectionCount ?? this.collectionCount),
      pendingBookingCount: (pendingBookingCount ?? this.pendingBookingCount),
      confirmedBookingCount:
          (confirmedBookingCount ?? this.confirmedBookingCount),
      unreadNotificationCount:
          (unreadNotificationCount ?? this.unreadNotificationCount),
      syncPendingCount: (syncPendingCount ?? this.syncPendingCount),
      revision: (revision ?? this.revision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (savedCount < 0 || savedCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'savedCount',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (collectionCount < 0 || collectionCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'collectionCount',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (pendingBookingCount < 0 || pendingBookingCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'pendingBookingCount',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (confirmedBookingCount < 0 || confirmedBookingCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'confirmedBookingCount',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (unreadNotificationCount < 0 ||
          unreadNotificationCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'unreadNotificationCount',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (syncPendingCount < 0 || syncPendingCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'syncPendingCount',
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
    if (revision < 1)
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
    "scope": scope,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "savedCount": savedCount,
    "collectionCount": collectionCount,
    "pendingBookingCount": pendingBookingCount,
    "confirmedBookingCount": confirmedBookingCount,
    "unreadNotificationCount": unreadNotificationCount,
    "syncPendingCount": syncPendingCount,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityActivityDashboard &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityActivityDashboard(redacted)';
}
