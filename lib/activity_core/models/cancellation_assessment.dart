// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityCancellationAssessment {
  ActivityCancellationAssessment({
    required this.policyId,
    required this.evaluatedAt,
    this.state = "unknown",
    this.refund,
    this.fee,
    this.deadlineAt,
    this.requiresReview = true,
    List<String> warningCodes = const [],
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String policyId;
  final DateTime evaluatedAt;
  final String state;
  final ActivityMoney? refund;
  final ActivityMoney? fee;
  final DateTime? deadlineAt;
  final bool requiresReview;
  final List<String> warningCodes;

  factory ActivityCancellationAssessment.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "policyId",
      "evaluatedAt",
      "state",
      "refund",
      "fee",
      "deadlineAt",
      "requiresReview",
      "warningCodes",
    });
    final value = ActivityCancellationAssessment(
      policyId: ActivityCodec.text(json, 'policyId', required: true)!,
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      state: ActivityCodec.text(json, 'state') ?? "unknown",
      refund: json['refund'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['refund'])),
      fee: json['fee'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['fee'])),
      deadlineAt: ActivityCodec.date(json, 'deadlineAt'),
      requiresReview: ActivityCodec.boolean(json, 'requiresReview') ?? true,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityCancellationAssessment> tryDecode(
    Object? input,
  ) {
    try {
      return ActivityResult(
        value: ActivityCancellationAssessment.fromJson(
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

  ActivityCancellationAssessment copyWith({
    Set<String> clear = const {},
    String? policyId,
    DateTime? evaluatedAt,
    String? state,
    ActivityMoney? refund,
    ActivityMoney? fee,
    DateTime? deadlineAt,
    bool? requiresReview,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{"refund", "fee", "deadlineAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCancellationAssessment(
      policyId: (policyId ?? this.policyId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      state: (state ?? this.state),
      refund: clear.contains('refund') ? null : (refund ?? this.refund),
      fee: clear.contains('fee') ? null : (fee ?? this.fee),
      deadlineAt: clear.contains('deadlineAt')
          ? null
          : (deadlineAt ?? this.deadlineAt),
      requiresReview: (requiresReview ?? this.requiresReview),
      warningCodes: (warningCodes ?? this.warningCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (policyId.trim().isEmpty || policyId.length > 4000)
        validationIssues.add(
          const ActivityIssue('policyId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (refund != null) {
      for (final issue in refund!.validate())
        validationIssues.add(
          ActivityIssue(
            'refund.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (fee != null) {
      for (final issue in fee!.validate())
        validationIssues.add(
          ActivityIssue(
            'fee.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (warningCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (warningCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (!{
      'unknown',
      'free',
      'partial',
      'nonRefundable',
      'expired',
    }.contains(state))
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
    "policyId": policyId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "state": state,
    if (refund != null) "refund": refund!.toJson(),
    if (fee != null) "fee": fee!.toJson(),
    if (deadlineAt != null) "deadlineAt": deadlineAt!.toUtc().toIso8601String(),
    "requiresReview": requiresReview,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCancellationAssessment &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCancellationAssessment(redacted)';
}
