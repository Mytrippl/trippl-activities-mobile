// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'question_choice.dart';

class ActivityQuestion {
  ActivityQuestion({
    required this.id,
    required this.label,
    this.kind = "text",
    this.isRequired = false,
    this.travelerScoped = false,
    this.sensitive = false,
    List<ActivityQuestionChoice> choices = const [],
    this.maximumLength = 500,
    this.minimumNumber,
    this.maximumNumber,
    this.revision = 1,
  }) : choices = List.unmodifiable(choices);

  final String id;
  final String label;
  final String kind;
  final bool isRequired;
  final bool travelerScoped;
  final bool sensitive;
  final List<ActivityQuestionChoice> choices;
  final int maximumLength;
  final int? minimumNumber;
  final int? maximumNumber;
  final int revision;

  factory ActivityQuestion.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "label",
      "kind",
      "isRequired",
      "travelerScoped",
      "sensitive",
      "choices",
      "maximumLength",
      "minimumNumber",
      "maximumNumber",
      "revision",
    });
    final value = ActivityQuestion(
      id: ActivityCodec.text(json, 'id', required: true)!,
      label: ActivityCodec.text(json, 'label', required: true)!,
      kind: ActivityCodec.text(json, 'kind') ?? "text",
      isRequired: ActivityCodec.boolean(json, 'isRequired') ?? false,
      travelerScoped: ActivityCodec.boolean(json, 'travelerScoped') ?? false,
      sensitive: ActivityCodec.boolean(json, 'sensitive') ?? false,
      choices:
          ActivityCodec.list(
            json,
            'choices',
            (v) => ActivityQuestionChoice.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      maximumLength:
          ActivityCodec.integer(
            json,
            'maximumLength',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          500,
      minimumNumber: ActivityCodec.integer(
        json,
        'minimumNumber',
        minimum: 0,
        maximum: 9000000000000,
      ),
      maximumNumber: ActivityCodec.integer(
        json,
        'maximumNumber',
        minimum: 0,
        maximum: 9000000000000,
      ),
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

  static ActivityResult<ActivityQuestion> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityQuestion.fromJson(ActivityCodec.object(input)),
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

  ActivityQuestion copyWith({
    Set<String> clear = const {},
    String? id,
    String? label,
    String? kind,
    bool? isRequired,
    bool? travelerScoped,
    bool? sensitive,
    List<ActivityQuestionChoice>? choices,
    int? maximumLength,
    int? minimumNumber,
    int? maximumNumber,
    int? revision,
  }) {
    final clearableFields = <String>{"minimumNumber", "maximumNumber"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityQuestion(
      id: (id ?? this.id),
      label: (label ?? this.label),
      kind: (kind ?? this.kind),
      isRequired: (isRequired ?? this.isRequired),
      travelerScoped: (travelerScoped ?? this.travelerScoped),
      sensitive: (sensitive ?? this.sensitive),
      choices: (choices ?? this.choices),
      maximumLength: (maximumLength ?? this.maximumLength),
      minimumNumber: clear.contains('minimumNumber')
          ? null
          : (minimumNumber ?? this.minimumNumber),
      maximumNumber: clear.contains('maximumNumber')
          ? null
          : (maximumNumber ?? this.maximumNumber),
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
      if (label.trim().isEmpty || label.length > 4000)
        validationIssues.add(
          const ActivityIssue('label', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (choices.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'choices',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < choices.length; i++)
        for (final issue in choices[i].validate())
          validationIssues.add(
            ActivityIssue(
              'choices[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (maximumLength < 0 || maximumLength > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumLength',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (minimumNumber != null) {
      if (minimumNumber! < 0 || minimumNumber! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'minimumNumber',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (maximumNumber != null) {
      if (maximumNumber! < 0 || maximumNumber! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumNumber',
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
    if (revision < 1 ||
        maximumLength < 1 ||
        maximumLength > 2000 ||
        !{
          'text',
          'choice',
          'multiChoice',
          'integer',
          'boolean',
          'date',
        }.contains(kind) ||
        minimumNumber != null &&
            maximumNumber != null &&
            minimumNumber! > maximumNumber! ||
        choices.map((c) => c.id).toSet().length != choices.length)
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
    "label": label,
    "kind": kind,
    "isRequired": isRequired,
    "travelerScoped": travelerScoped,
    "sensitive": sensitive,
    "choices": choices.map((item) => item.toJson()).toList(),
    "maximumLength": maximumLength,
    if (minimumNumber != null) "minimumNumber": minimumNumber,
    if (maximumNumber != null) "maximumNumber": maximumNumber,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityQuestion && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityQuestion(redacted)';
}
