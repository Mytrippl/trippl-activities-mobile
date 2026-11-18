// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityProviderFailure {
  ActivityProviderFailure({
    required this.code,
    required this.occurredAt,
    this.retryable = false,
    this.retryAfterSeconds,
    this.requiresReview = false,
    this.operation = "read",
  });

  final String code;
  final DateTime occurredAt;
  final bool retryable;
  final int? retryAfterSeconds;
  final bool requiresReview;
  final String operation;

  factory ActivityProviderFailure.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "code",
      "occurredAt",
      "retryable",
      "retryAfterSeconds",
      "requiresReview",
      "operation",
    });
    final value = ActivityProviderFailure(
      code: ActivityCodec.text(json, 'code', required: true)!,
      occurredAt: ActivityCodec.date(json, 'occurredAt', required: true)!,
      retryable: ActivityCodec.boolean(json, 'retryable') ?? false,
      retryAfterSeconds: ActivityCodec.integer(
        json,
        'retryAfterSeconds',
        minimum: 0,
        maximum: 9000000000000,
      ),
      requiresReview: ActivityCodec.boolean(json, 'requiresReview') ?? false,
      operation: ActivityCodec.text(json, 'operation') ?? "read",
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityProviderFailure> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityProviderFailure.fromJson(ActivityCodec.object(input)),
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

  ActivityProviderFailure copyWith({
    Set<String> clear = const {},
    String? code,
    DateTime? occurredAt,
    bool? retryable,
    int? retryAfterSeconds,
    bool? requiresReview,
    String? operation,
  }) {
    final clearableFields = <String>{"retryAfterSeconds"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityProviderFailure(
      code: (code ?? this.code),
      occurredAt: (occurredAt ?? this.occurredAt),
      retryable: (retryable ?? this.retryable),
      retryAfterSeconds: clear.contains('retryAfterSeconds')
          ? null
          : (retryAfterSeconds ?? this.retryAfterSeconds),
      requiresReview: (requiresReview ?? this.requiresReview),
      operation: (operation ?? this.operation),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (code.trim().isEmpty || code.length > 4000)
        validationIssues.add(
          const ActivityIssue('code', 'text', 'Use nonempty bounded text'),
        );
    }
    if (retryAfterSeconds != null) {
      if (retryAfterSeconds! < 0 || retryAfterSeconds! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'retryAfterSeconds',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (operation.trim().isEmpty || operation.length > 4000)
        validationIssues.add(
          const ActivityIssue('operation', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!RegExp(r'^[A-Za-z0-9_-]{1,80}$').hasMatch(code) ||
        operation != 'read' ||
        retryAfterSeconds != null && retryAfterSeconds! > 120)
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
    "code": code,
    "occurredAt": occurredAt.toUtc().toIso8601String(),
    "retryable": retryable,
    if (retryAfterSeconds != null) "retryAfterSeconds": retryAfterSeconds,
    "requiresReview": requiresReview,
    "operation": operation,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityProviderFailure &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityProviderFailure(redacted)';
}
