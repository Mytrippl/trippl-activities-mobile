// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivitySearchSort {
  ActivitySearchSort({
    this.field = "recommended",
    this.descending = false,
    this.unknownLast = true,
    this.tieBreak = "id",
  });

  final String field;
  final bool descending;
  final bool unknownLast;
  final String tieBreak;

  factory ActivitySearchSort.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "field",
      "descending",
      "unknownLast",
      "tieBreak",
    });
    final value = ActivitySearchSort(
      field: ActivityCodec.text(json, 'field') ?? "recommended",
      descending: ActivityCodec.boolean(json, 'descending') ?? false,
      unknownLast: ActivityCodec.boolean(json, 'unknownLast') ?? true,
      tieBreak: ActivityCodec.text(json, 'tieBreak') ?? "id",
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySearchSort> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySearchSort.fromJson(ActivityCodec.object(input)),
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

  ActivitySearchSort copyWith({
    Set<String> clear = const {},
    String? field,
    bool? descending,
    bool? unknownLast,
    String? tieBreak,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySearchSort(
      field: (field ?? this.field),
      descending: (descending ?? this.descending),
      unknownLast: (unknownLast ?? this.unknownLast),
      tieBreak: (tieBreak ?? this.tieBreak),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (field.trim().isEmpty || field.length > 4000)
        validationIssues.add(
          const ActivityIssue('field', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (tieBreak.trim().isEmpty || tieBreak.length > 4000)
        validationIssues.add(
          const ActivityIssue('tieBreak', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!{
          'recommended',
          'price',
          'rating',
          'reviewCount',
          'duration',
          'distance',
          'title',
        }.contains(field) ||
        tieBreak != 'id')
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
    "field": field,
    "descending": descending,
    "unknownLast": unknownLast,
    "tieBreak": tieBreak,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySearchSort &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySearchSort(redacted)';
}
