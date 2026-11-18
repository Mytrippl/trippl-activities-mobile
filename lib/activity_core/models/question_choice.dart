// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityQuestionChoice {
  ActivityQuestionChoice({
    required this.id,
    required this.label,
    required this.value,
    this.active = true,
    this.description,
    this.revision = 1,
  });

  final String id;
  final String label;
  final String value;
  final bool active;
  final String? description;
  final int revision;

  factory ActivityQuestionChoice.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "label",
      "value",
      "active",
      "description",
      "revision",
    });
    final value = ActivityQuestionChoice(
      id: ActivityCodec.text(json, 'id', required: true)!,
      label: ActivityCodec.text(json, 'label', required: true)!,
      value: ActivityCodec.text(json, 'value', required: true)!,
      active: ActivityCodec.boolean(json, 'active') ?? true,
      description: ActivityCodec.text(json, 'description'),
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

  static ActivityResult<ActivityQuestionChoice> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityQuestionChoice.fromJson(ActivityCodec.object(input)),
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

  ActivityQuestionChoice copyWith({
    Set<String> clear = const {},
    String? id,
    String? label,
    String? value,
    bool? active,
    String? description,
    int? revision,
  }) {
    final clearableFields = <String>{"description"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityQuestionChoice(
      id: (id ?? this.id),
      label: (label ?? this.label),
      value: (value ?? this.value),
      active: (active ?? this.active),
      description: clear.contains('description')
          ? null
          : (description ?? this.description),
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
      if (value.trim().isEmpty || value.length > 4000)
        validationIssues.add(
          const ActivityIssue('value', 'text', 'Use nonempty bounded text'),
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
    if (revision < 1 || value.length > 200)
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
    "value": value,
    "active": active,
    if (description != null) "description": description,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityQuestionChoice &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityQuestionChoice(redacted)';
}
