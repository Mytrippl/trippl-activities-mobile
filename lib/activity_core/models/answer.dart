// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityAnswer {
  ActivityAnswer({
    required this.questionId,
    List<String> values = const [],
    this.travelerId,
    this.revision = 1,
    required this.updatedAt,
  }) : values = List.unmodifiable(values);

  final String questionId;
  final List<String> values;
  final String? travelerId;
  final int revision;
  final DateTime updatedAt;

  factory ActivityAnswer.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "questionId",
      "values",
      "travelerId",
      "revision",
      "updatedAt",
    });
    final value = ActivityAnswer(
      questionId: ActivityCodec.text(json, 'questionId', required: true)!,
      values:
          ActivityCodec.list(json, 'values', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      travelerId: ActivityCodec.text(json, 'travelerId'),
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityAnswer> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAnswer.fromJson(ActivityCodec.object(input)),
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

  ActivityAnswer copyWith({
    Set<String> clear = const {},
    String? questionId,
    List<String>? values,
    String? travelerId,
    int? revision,
    DateTime? updatedAt,
  }) {
    final clearableFields = <String>{"travelerId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAnswer(
      questionId: (questionId ?? this.questionId),
      values: (values ?? this.values),
      travelerId: clear.contains('travelerId')
          ? null
          : (travelerId ?? this.travelerId),
      revision: (revision ?? this.revision),
      updatedAt: (updatedAt ?? this.updatedAt),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (questionId.trim().isEmpty || questionId.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'questionId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (values.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'values',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (values.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'values',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (travelerId != null) {
      if (travelerId!.trim().isEmpty || travelerId!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'travelerId',
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
    if (revision < 1 || values.toSet().length != values.length)
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
    "questionId": questionId,
    "values": values,
    if (travelerId != null) "travelerId": travelerId,
    "revision": revision,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAnswer && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAnswer(redacted)';
}
