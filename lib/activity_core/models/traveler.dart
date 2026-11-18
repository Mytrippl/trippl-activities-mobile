// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityTraveler {
  ActivityTraveler({
    required this.id,
    required this.age,
    this.category,
    this.requiresAssistance = false,
    this.ageAtDate,
  });

  final String id;
  final int age;
  final String? category;
  final bool requiresAssistance;
  final DateTime? ageAtDate;

  factory ActivityTraveler.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "age",
      "category",
      "requiresAssistance",
      "ageAtDate",
    });
    final value = ActivityTraveler(
      id: ActivityCodec.text(json, 'id', required: true)!,
      age: ActivityCodec.integer(
        json,
        'age',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      category: ActivityCodec.text(json, 'category'),
      requiresAssistance:
          ActivityCodec.boolean(json, 'requiresAssistance') ?? false,
      ageAtDate: ActivityCodec.date(json, 'ageAtDate', calendar: true),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityTraveler> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityTraveler.fromJson(ActivityCodec.object(input)),
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

  ActivityTraveler copyWith({
    Set<String> clear = const {},
    String? id,
    int? age,
    String? category,
    bool? requiresAssistance,
    DateTime? ageAtDate,
  }) {
    final clearableFields = <String>{"category", "ageAtDate"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityTraveler(
      id: (id ?? this.id),
      age: (age ?? this.age),
      category: clear.contains('category') ? null : (category ?? this.category),
      requiresAssistance: (requiresAssistance ?? this.requiresAssistance),
      ageAtDate: clear.contains('ageAtDate')
          ? null
          : (ageAtDate ?? this.ageAtDate),
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
      if (age < 0 || age > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'age',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (category != null) {
      if (category!.trim().isEmpty || category!.length > 4000)
        validationIssues.add(
          const ActivityIssue('category', 'text', 'Use nonempty bounded text'),
        );
    }
    if (age > 120)
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
    "age": age,
    if (category != null) "category": category,
    "requiresAssistance": requiresAssistance,
    if (ageAtDate != null) "ageAtDate": ActivityCodec.calendarText(ageAtDate!),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityTraveler && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityTraveler(redacted)';
}
