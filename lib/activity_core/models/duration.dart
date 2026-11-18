// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityDuration {
  ActivityDuration({
    this.minimumMinutes,
    this.maximumMinutes,
    this.fixedMinutes,
    this.approximate = true,
    this.flexible = false,
    this.description,
  });

  final int? minimumMinutes;
  final int? maximumMinutes;
  final int? fixedMinutes;
  final bool approximate;
  final bool flexible;
  final String? description;

  factory ActivityDuration.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "minimumMinutes",
      "maximumMinutes",
      "fixedMinutes",
      "approximate",
      "flexible",
      "description",
    });
    final value = ActivityDuration(
      minimumMinutes: ActivityCodec.integer(
        json,
        'minimumMinutes',
        minimum: 0,
        maximum: 9000000000000,
      ),
      maximumMinutes: ActivityCodec.integer(
        json,
        'maximumMinutes',
        minimum: 0,
        maximum: 9000000000000,
      ),
      fixedMinutes: ActivityCodec.integer(
        json,
        'fixedMinutes',
        minimum: 0,
        maximum: 9000000000000,
      ),
      approximate: ActivityCodec.boolean(json, 'approximate') ?? true,
      flexible: ActivityCodec.boolean(json, 'flexible') ?? false,
      description: ActivityCodec.text(json, 'description'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityDuration> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityDuration.fromJson(ActivityCodec.object(input)),
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

  ActivityDuration copyWith({
    Set<String> clear = const {},
    int? minimumMinutes,
    int? maximumMinutes,
    int? fixedMinutes,
    bool? approximate,
    bool? flexible,
    String? description,
  }) {
    final clearableFields = <String>{
      "minimumMinutes",
      "maximumMinutes",
      "fixedMinutes",
      "description",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityDuration(
      minimumMinutes: clear.contains('minimumMinutes')
          ? null
          : (minimumMinutes ?? this.minimumMinutes),
      maximumMinutes: clear.contains('maximumMinutes')
          ? null
          : (maximumMinutes ?? this.maximumMinutes),
      fixedMinutes: clear.contains('fixedMinutes')
          ? null
          : (fixedMinutes ?? this.fixedMinutes),
      approximate: (approximate ?? this.approximate),
      flexible: (flexible ?? this.flexible),
      description: clear.contains('description')
          ? null
          : (description ?? this.description),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    if (minimumMinutes != null) {
      if (minimumMinutes! < 0 || minimumMinutes! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'minimumMinutes',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (maximumMinutes != null) {
      if (maximumMinutes! < 0 || maximumMinutes! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumMinutes',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (fixedMinutes != null) {
      if (fixedMinutes! < 0 || fixedMinutes! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'fixedMinutes',
            'range',
            'Number is outside the activity limits',
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
    if (minimumMinutes != null && minimumMinutes! > 43200 ||
        maximumMinutes != null && maximumMinutes! > 43200 ||
        fixedMinutes != null && (fixedMinutes! < 1 || fixedMinutes! > 43200) ||
        minimumMinutes != null &&
            maximumMinutes != null &&
            minimumMinutes! > maximumMinutes!)
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
    if (minimumMinutes != null) "minimumMinutes": minimumMinutes,
    if (maximumMinutes != null) "maximumMinutes": maximumMinutes,
    if (fixedMinutes != null) "fixedMinutes": fixedMinutes,
    "approximate": approximate,
    "flexible": flexible,
    if (description != null) "description": description,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityDuration && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityDuration(redacted)';
}
