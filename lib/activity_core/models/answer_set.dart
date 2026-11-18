// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'answer.dart';

class ActivityAnswerSet {
  ActivityAnswerSet({
    required this.draftId,
    required this.updatedAt,
    List<ActivityAnswer> answers = const [],
    this.questionRevision = 1,
    this.revision = 1,
  }) : answers = List.unmodifiable(answers);

  final String draftId;
  final DateTime updatedAt;
  final List<ActivityAnswer> answers;
  final int questionRevision;
  final int revision;

  factory ActivityAnswerSet.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "draftId",
      "updatedAt",
      "answers",
      "questionRevision",
      "revision",
    });
    final value = ActivityAnswerSet(
      draftId: ActivityCodec.text(json, 'draftId', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      answers:
          ActivityCodec.list(
            json,
            'answers',
            (v) => ActivityAnswer.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      questionRevision:
          ActivityCodec.integer(
            json,
            'questionRevision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
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

  static ActivityResult<ActivityAnswerSet> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAnswerSet.fromJson(ActivityCodec.object(input)),
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

  ActivityAnswerSet copyWith({
    Set<String> clear = const {},
    String? draftId,
    DateTime? updatedAt,
    List<ActivityAnswer>? answers,
    int? questionRevision,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAnswerSet(
      draftId: (draftId ?? this.draftId),
      updatedAt: (updatedAt ?? this.updatedAt),
      answers: (answers ?? this.answers),
      questionRevision: (questionRevision ?? this.questionRevision),
      revision: (revision ?? this.revision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (draftId.trim().isEmpty || draftId.length > 4000)
        validationIssues.add(
          const ActivityIssue('draftId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (answers.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'answers',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < answers.length; i++)
        for (final issue in answers[i].validate())
          validationIssues.add(
            ActivityIssue(
              'answers[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (questionRevision < 0 || questionRevision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'questionRevision',
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
    if (revision < 1 || questionRevision < 1)
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
    "draftId": draftId,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "answers": answers.map((item) => item.toJson()).toList(),
    "questionRevision": questionRevision,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAnswerSet &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAnswerSet(redacted)';
}
