// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityTermsAcceptance {
  ActivityTermsAcceptance({
    required this.id,
    required this.scope,
    required this.draftId,
    required this.termsVersion,
    required this.acceptedAt,
    required this.quoteDigest,
    this.accepted = false,
    this.revision = 1,
  });

  final String id;
  final String scope;
  final String draftId;
  final String termsVersion;
  final DateTime acceptedAt;
  final String quoteDigest;
  final bool accepted;
  final int revision;

  factory ActivityTermsAcceptance.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "draftId",
      "termsVersion",
      "acceptedAt",
      "quoteDigest",
      "accepted",
      "revision",
    });
    final value = ActivityTermsAcceptance(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      draftId: ActivityCodec.text(json, 'draftId', required: true)!,
      termsVersion: ActivityCodec.text(json, 'termsVersion', required: true)!,
      acceptedAt: ActivityCodec.date(json, 'acceptedAt', required: true)!,
      quoteDigest: ActivityCodec.text(json, 'quoteDigest', required: true)!,
      accepted: ActivityCodec.boolean(json, 'accepted') ?? false,
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

  static ActivityResult<ActivityTermsAcceptance> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityTermsAcceptance.fromJson(ActivityCodec.object(input)),
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

  ActivityTermsAcceptance copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? draftId,
    String? termsVersion,
    DateTime? acceptedAt,
    String? quoteDigest,
    bool? accepted,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityTermsAcceptance(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      draftId: (draftId ?? this.draftId),
      termsVersion: (termsVersion ?? this.termsVersion),
      acceptedAt: (acceptedAt ?? this.acceptedAt),
      quoteDigest: (quoteDigest ?? this.quoteDigest),
      accepted: (accepted ?? this.accepted),
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
      if (draftId.trim().isEmpty || draftId.length > 4000)
        validationIssues.add(
          const ActivityIssue('draftId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (termsVersion.trim().isEmpty || termsVersion.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'termsVersion',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (quoteDigest.trim().isEmpty || quoteDigest.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'quoteDigest',
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
    if (revision < 1 || !RegExp(r'^[a-f0-9]{64}$').hasMatch(quoteDigest))
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
    "draftId": draftId,
    "termsVersion": termsVersion,
    "acceptedAt": acceptedAt.toUtc().toIso8601String(),
    "quoteDigest": quoteDigest,
    "accepted": accepted,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityTermsAcceptance &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityTermsAcceptance(redacted)';
}
