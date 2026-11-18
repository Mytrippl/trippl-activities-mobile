// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityInclusion {
  ActivityInclusion({
    required this.id,
    required this.description,
    this.included = true,
    this.category = "other",
    this.optionId,
  });

  final String id;
  final String description;
  final bool included;
  final String category;
  final String? optionId;

  factory ActivityInclusion.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "description",
      "included",
      "category",
      "optionId",
    });
    final value = ActivityInclusion(
      id: ActivityCodec.text(json, 'id', required: true)!,
      description: ActivityCodec.text(json, 'description', required: true)!,
      included: ActivityCodec.boolean(json, 'included') ?? true,
      category: ActivityCodec.text(json, 'category') ?? "other",
      optionId: ActivityCodec.text(json, 'optionId'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityInclusion> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityInclusion.fromJson(ActivityCodec.object(input)),
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

  ActivityInclusion copyWith({
    Set<String> clear = const {},
    String? id,
    String? description,
    bool? included,
    String? category,
    String? optionId,
  }) {
    final clearableFields = <String>{"optionId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityInclusion(
      id: (id ?? this.id),
      description: (description ?? this.description),
      included: (included ?? this.included),
      category: (category ?? this.category),
      optionId: clear.contains('optionId') ? null : (optionId ?? this.optionId),
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
      if (description.trim().isEmpty || description.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'description',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (category.trim().isEmpty || category.length > 4000)
        validationIssues.add(
          const ActivityIssue('category', 'text', 'Use nonempty bounded text'),
        );
    }
    if (optionId != null) {
      if (optionId!.trim().isEmpty || optionId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!{
      'admission',
      'transport',
      'guide',
      'food',
      'equipment',
      'other',
    }.contains(category))
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
    "description": description,
    "included": included,
    "category": category,
    if (optionId != null) "optionId": optionId,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityInclusion &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityInclusion(redacted)';
}
