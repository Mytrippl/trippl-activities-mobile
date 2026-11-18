// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityPrivacy {
  ActivityPrivacy({
    required this.scope,
    required this.updatedAt,
    this.retainHistory = false,
    this.persistDraftDetails = false,
    this.allowAnalytics = false,
    this.retentionDays = 30,
    this.revision = 1,
  });

  final String scope;
  final DateTime updatedAt;
  final bool retainHistory;
  final bool persistDraftDetails;
  final bool allowAnalytics;
  final int retentionDays;
  final int revision;

  factory ActivityPrivacy.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "scope",
      "updatedAt",
      "retainHistory",
      "persistDraftDetails",
      "allowAnalytics",
      "retentionDays",
      "revision",
    });
    final value = ActivityPrivacy(
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      retainHistory: ActivityCodec.boolean(json, 'retainHistory') ?? false,
      persistDraftDetails:
          ActivityCodec.boolean(json, 'persistDraftDetails') ?? false,
      allowAnalytics: ActivityCodec.boolean(json, 'allowAnalytics') ?? false,
      retentionDays:
          ActivityCodec.integer(
            json,
            'retentionDays',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          30,
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

  static ActivityResult<ActivityPrivacy> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPrivacy.fromJson(ActivityCodec.object(input)),
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

  ActivityPrivacy copyWith({
    Set<String> clear = const {},
    String? scope,
    DateTime? updatedAt,
    bool? retainHistory,
    bool? persistDraftDetails,
    bool? allowAnalytics,
    int? retentionDays,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPrivacy(
      scope: (scope ?? this.scope),
      updatedAt: (updatedAt ?? this.updatedAt),
      retainHistory: (retainHistory ?? this.retainHistory),
      persistDraftDetails: (persistDraftDetails ?? this.persistDraftDetails),
      allowAnalytics: (allowAnalytics ?? this.allowAnalytics),
      retentionDays: (retentionDays ?? this.retentionDays),
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
      if (retentionDays < 0 || retentionDays > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'retentionDays',
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
    if (revision < 1 || retentionDays < 1 || retentionDays > 365)
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
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "retainHistory": retainHistory,
    "persistDraftDetails": persistDraftDetails,
    "allowAnalytics": allowAnalytics,
    "retentionDays": retentionDays,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPrivacy && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPrivacy(redacted)';
}
