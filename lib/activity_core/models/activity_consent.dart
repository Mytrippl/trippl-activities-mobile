// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityActivityConsent {
  ActivityActivityConsent({
    required this.id,
    required this.scope,
    required this.purpose,
    required this.policyVersion,
    required this.recordedAt,
    required this.granted,
    this.expiresAt,
    this.revision = 1,
  });

  final String id;
  final String scope;
  final String purpose;
  final String policyVersion;
  final DateTime recordedAt;
  final bool granted;
  final DateTime? expiresAt;
  final int revision;

  factory ActivityActivityConsent.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "purpose",
      "policyVersion",
      "recordedAt",
      "granted",
      "expiresAt",
      "revision",
    });
    final value = ActivityActivityConsent(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      purpose: ActivityCodec.text(json, 'purpose', required: true)!,
      policyVersion: ActivityCodec.text(json, 'policyVersion', required: true)!,
      recordedAt: ActivityCodec.date(json, 'recordedAt', required: true)!,
      granted: ActivityCodec.boolean(json, 'granted', required: true)!,
      expiresAt: ActivityCodec.date(json, 'expiresAt'),
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

  static ActivityResult<ActivityActivityConsent> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityActivityConsent.fromJson(ActivityCodec.object(input)),
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

  ActivityActivityConsent copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? purpose,
    String? policyVersion,
    DateTime? recordedAt,
    bool? granted,
    DateTime? expiresAt,
    int? revision,
  }) {
    final clearableFields = <String>{"expiresAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityActivityConsent(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      purpose: (purpose ?? this.purpose),
      policyVersion: (policyVersion ?? this.policyVersion),
      recordedAt: (recordedAt ?? this.recordedAt),
      granted: (granted ?? this.granted),
      expiresAt: clear.contains('expiresAt')
          ? null
          : (expiresAt ?? this.expiresAt),
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
      if (purpose.trim().isEmpty || purpose.length > 4000)
        validationIssues.add(
          const ActivityIssue('purpose', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (policyVersion.trim().isEmpty || policyVersion.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'policyVersion',
            'text',
            'Use nonempty bounded text',
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
          'history',
          'draftDetails',
          'analytics',
          'reminders',
        }.contains(purpose) ||
        expiresAt != null && !expiresAt!.isAfter(recordedAt))
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
    "purpose": purpose,
    "policyVersion": policyVersion,
    "recordedAt": recordedAt.toUtc().toIso8601String(),
    "granted": granted,
    if (expiresAt != null) "expiresAt": expiresAt!.toUtc().toIso8601String(),
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityActivityConsent &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityActivityConsent(redacted)';
}
