// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityCancellationTier {
  ActivityCancellationTier({
    required this.id,
    required this.cutoffAt,
    required this.refundBasisPoints,
    this.fee,
    this.description,
  });

  final String id;
  final DateTime cutoffAt;
  final int refundBasisPoints;
  final ActivityMoney? fee;
  final String? description;

  factory ActivityCancellationTier.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "cutoffAt",
      "refundBasisPoints",
      "fee",
      "description",
    });
    final value = ActivityCancellationTier(
      id: ActivityCodec.text(json, 'id', required: true)!,
      cutoffAt: ActivityCodec.date(json, 'cutoffAt', required: true)!,
      refundBasisPoints: ActivityCodec.integer(
        json,
        'refundBasisPoints',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      fee: json['fee'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['fee'])),
      description: ActivityCodec.text(json, 'description'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityCancellationTier> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityCancellationTier.fromJson(ActivityCodec.object(input)),
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

  ActivityCancellationTier copyWith({
    Set<String> clear = const {},
    String? id,
    DateTime? cutoffAt,
    int? refundBasisPoints,
    ActivityMoney? fee,
    String? description,
  }) {
    final clearableFields = <String>{"fee", "description"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCancellationTier(
      id: (id ?? this.id),
      cutoffAt: (cutoffAt ?? this.cutoffAt),
      refundBasisPoints: (refundBasisPoints ?? this.refundBasisPoints),
      fee: clear.contains('fee') ? null : (fee ?? this.fee),
      description: clear.contains('description')
          ? null
          : (description ?? this.description),
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
      if (refundBasisPoints < 0 || refundBasisPoints > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'refundBasisPoints',
            'range',
            'Number is outside the activity limits',
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
    if (description != null) {
      if (description!.trim().isEmpty || description!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'description',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (refundBasisPoints > 10000)
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
    "cutoffAt": cutoffAt.toUtc().toIso8601String(),
    "refundBasisPoints": refundBasisPoints,
    if (fee != null) "fee": fee!.toJson(),
    if (description != null) "description": description,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCancellationTier &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCancellationTier(redacted)';
}
