// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'cancellation_assessment.dart';
import 'money.dart';

class ActivityRefundEstimate {
  ActivityRefundEstimate({
    required this.bookingId,
    required this.evaluatedAt,
    required this.assessment,
    required this.paid,
    this.indicative = true,
    this.requiresProviderConfirmation = true,
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String bookingId;
  final DateTime evaluatedAt;
  final ActivityCancellationAssessment assessment;
  final ActivityMoney paid;
  final bool indicative;
  final bool requiresProviderConfirmation;
  final List<String> reasonCodes;

  factory ActivityRefundEstimate.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "bookingId",
      "evaluatedAt",
      "assessment",
      "paid",
      "indicative",
      "requiresProviderConfirmation",
      "reasonCodes",
    });
    final value = ActivityRefundEstimate(
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      assessment: (json['assessment'] == null
          ? null
          : ActivityCancellationAssessment.fromJson(
              ActivityCodec.object(json['assessment']),
            ))!,
      paid: (json['paid'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['paid'])))!,
      indicative: ActivityCodec.boolean(json, 'indicative') ?? true,
      requiresProviderConfirmation:
          ActivityCodec.boolean(json, 'requiresProviderConfirmation') ?? true,
      reasonCodes:
          ActivityCodec.list(json, 'reasonCodes', (v) {
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

  static ActivityResult<ActivityRefundEstimate> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityRefundEstimate.fromJson(ActivityCodec.object(input)),
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

  ActivityRefundEstimate copyWith({
    Set<String> clear = const {},
    String? bookingId,
    DateTime? evaluatedAt,
    ActivityCancellationAssessment? assessment,
    ActivityMoney? paid,
    bool? indicative,
    bool? requiresProviderConfirmation,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityRefundEstimate(
      bookingId: (bookingId ?? this.bookingId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      assessment: (assessment ?? this.assessment),
      paid: (paid ?? this.paid),
      indicative: (indicative ?? this.indicative),
      requiresProviderConfirmation:
          (requiresProviderConfirmation ?? this.requiresProviderConfirmation),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (bookingId.trim().isEmpty || bookingId.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in assessment.validate())
        validationIssues.add(
          ActivityIssue(
            'assessment.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in paid.validate())
        validationIssues.add(
          ActivityIssue(
            'paid.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "bookingId": bookingId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "assessment": assessment.toJson(),
    "paid": paid.toJson(),
    "indicative": indicative,
    "requiresProviderConfirmation": requiresProviderConfirmation,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityRefundEstimate &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityRefundEstimate(redacted)';
}
