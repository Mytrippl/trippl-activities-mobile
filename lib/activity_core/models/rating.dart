// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityRating {
  ActivityRating({
    this.value,
    this.count,
    this.maximum = 5,
    this.observedAt,
    this.source,
  });

  final double? value;
  final int? count;
  final int maximum;
  final DateTime? observedAt;
  final String? source;

  factory ActivityRating.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "value",
      "count",
      "maximum",
      "observedAt",
      "source",
    });
    final value = ActivityRating(
      value: ActivityCodec.decimal(json, 'value'),
      count: ActivityCodec.integer(
        json,
        'count',
        minimum: 0,
        maximum: 9000000000000,
      ),
      maximum:
          ActivityCodec.integer(
            json,
            'maximum',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          5,
      observedAt: ActivityCodec.date(json, 'observedAt'),
      source: ActivityCodec.text(json, 'source'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityRating> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityRating.fromJson(ActivityCodec.object(input)),
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

  ActivityRating copyWith({
    Set<String> clear = const {},
    double? value,
    int? count,
    int? maximum,
    DateTime? observedAt,
    String? source,
  }) {
    final clearableFields = <String>{"value", "count", "observedAt", "source"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityRating(
      value: clear.contains('value') ? null : (value ?? this.value),
      count: clear.contains('count') ? null : (count ?? this.count),
      maximum: (maximum ?? this.maximum),
      observedAt: clear.contains('observedAt')
          ? null
          : (observedAt ?? this.observedAt),
      source: clear.contains('source') ? null : (source ?? this.source),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    if (value != null) {
      if (!value!.isFinite)
        validationIssues.add(
          const ActivityIssue(
            'value',
            'finite',
            'Use a finite coordinate or weight',
          ),
        );
    }
    if (count != null) {
      if (count! < 0 || count! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'count',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (maximum < 0 || maximum > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximum',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (source != null) {
      if (source!.trim().isEmpty || source!.length > 4000)
        validationIssues.add(
          const ActivityIssue('source', 'text', 'Use nonempty bounded text'),
        );
    }
    if (maximum != 5 || value != null && (value! < 0 || value! > 5))
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
    if (value != null) "value": value,
    if (count != null) "count": count,
    "maximum": maximum,
    if (observedAt != null) "observedAt": observedAt!.toUtc().toIso8601String(),
    if (source != null) "source": source,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityRating && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityRating(redacted)';
}
