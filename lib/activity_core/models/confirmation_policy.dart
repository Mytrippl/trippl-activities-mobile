// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityConfirmationPolicy {
  ActivityConfirmationPolicy({
    required this.termsVersion,
    this.requireNames = false,
    this.requirePhone = false,
    this.requirePickupConfirmation = true,
    this.maximumQuoteAgeSeconds = 900,
    this.maximumAttempts = 2,
    this.version = 1,
  });

  final String termsVersion;
  final bool requireNames;
  final bool requirePhone;
  final bool requirePickupConfirmation;
  final int maximumQuoteAgeSeconds;
  final int maximumAttempts;
  final int version;

  factory ActivityConfirmationPolicy.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "termsVersion",
      "requireNames",
      "requirePhone",
      "requirePickupConfirmation",
      "maximumQuoteAgeSeconds",
      "maximumAttempts",
      "version",
    });
    final value = ActivityConfirmationPolicy(
      termsVersion: ActivityCodec.text(json, 'termsVersion', required: true)!,
      requireNames: ActivityCodec.boolean(json, 'requireNames') ?? false,
      requirePhone: ActivityCodec.boolean(json, 'requirePhone') ?? false,
      requirePickupConfirmation:
          ActivityCodec.boolean(json, 'requirePickupConfirmation') ?? true,
      maximumQuoteAgeSeconds:
          ActivityCodec.integer(
            json,
            'maximumQuoteAgeSeconds',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          900,
      maximumAttempts:
          ActivityCodec.integer(
            json,
            'maximumAttempts',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          2,
      version:
          ActivityCodec.integer(
            json,
            'version',
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

  static ActivityResult<ActivityConfirmationPolicy> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityConfirmationPolicy.fromJson(ActivityCodec.object(input)),
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

  ActivityConfirmationPolicy copyWith({
    Set<String> clear = const {},
    String? termsVersion,
    bool? requireNames,
    bool? requirePhone,
    bool? requirePickupConfirmation,
    int? maximumQuoteAgeSeconds,
    int? maximumAttempts,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityConfirmationPolicy(
      termsVersion: (termsVersion ?? this.termsVersion),
      requireNames: (requireNames ?? this.requireNames),
      requirePhone: (requirePhone ?? this.requirePhone),
      requirePickupConfirmation:
          (requirePickupConfirmation ?? this.requirePickupConfirmation),
      maximumQuoteAgeSeconds:
          (maximumQuoteAgeSeconds ?? this.maximumQuoteAgeSeconds),
      maximumAttempts: (maximumAttempts ?? this.maximumAttempts),
      version: (version ?? this.version),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
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
      if (maximumQuoteAgeSeconds < 0 || maximumQuoteAgeSeconds > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumQuoteAgeSeconds',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (maximumAttempts < 0 || maximumAttempts > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumAttempts',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (version < 0 || version > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'version',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (version != 1 ||
        maximumQuoteAgeSeconds < 1 ||
        maximumQuoteAgeSeconds > 3600 ||
        maximumAttempts < 1 ||
        maximumAttempts > 5)
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
    "termsVersion": termsVersion,
    "requireNames": requireNames,
    "requirePhone": requirePhone,
    "requirePickupConfirmation": requirePickupConfirmation,
    "maximumQuoteAgeSeconds": maximumQuoteAgeSeconds,
    "maximumAttempts": maximumAttempts,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityConfirmationPolicy &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityConfirmationPolicy(redacted)';
}
