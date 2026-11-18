// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityAgeBand {
  ActivityAgeBand({
    required this.id,
    required this.category,
    required this.startAge,
    required this.endAge,
    this.minimumTravelers = 0,
    this.maximumTravelers,
    this.countsTowardCapacity = true,
    this.requiresAdult = false,
  });

  final String id;
  final String category;
  final int startAge;
  final int endAge;
  final int minimumTravelers;
  final int? maximumTravelers;
  final bool countsTowardCapacity;
  final bool requiresAdult;

  factory ActivityAgeBand.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "category",
      "startAge",
      "endAge",
      "minimumTravelers",
      "maximumTravelers",
      "countsTowardCapacity",
      "requiresAdult",
    });
    final value = ActivityAgeBand(
      id: ActivityCodec.text(json, 'id', required: true)!,
      category: ActivityCodec.text(json, 'category', required: true)!,
      startAge: ActivityCodec.integer(
        json,
        'startAge',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      endAge: ActivityCodec.integer(
        json,
        'endAge',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      minimumTravelers:
          ActivityCodec.integer(
            json,
            'minimumTravelers',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      maximumTravelers: ActivityCodec.integer(
        json,
        'maximumTravelers',
        minimum: 0,
        maximum: 9000000000000,
      ),
      countsTowardCapacity:
          ActivityCodec.boolean(json, 'countsTowardCapacity') ?? true,
      requiresAdult: ActivityCodec.boolean(json, 'requiresAdult') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityAgeBand> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAgeBand.fromJson(ActivityCodec.object(input)),
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

  ActivityAgeBand copyWith({
    Set<String> clear = const {},
    String? id,
    String? category,
    int? startAge,
    int? endAge,
    int? minimumTravelers,
    int? maximumTravelers,
    bool? countsTowardCapacity,
    bool? requiresAdult,
  }) {
    final clearableFields = <String>{"maximumTravelers"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAgeBand(
      id: (id ?? this.id),
      category: (category ?? this.category),
      startAge: (startAge ?? this.startAge),
      endAge: (endAge ?? this.endAge),
      minimumTravelers: (minimumTravelers ?? this.minimumTravelers),
      maximumTravelers: clear.contains('maximumTravelers')
          ? null
          : (maximumTravelers ?? this.maximumTravelers),
      countsTowardCapacity: (countsTowardCapacity ?? this.countsTowardCapacity),
      requiresAdult: (requiresAdult ?? this.requiresAdult),
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
      if (category.trim().isEmpty || category.length > 4000)
        validationIssues.add(
          const ActivityIssue('category', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (startAge < 0 || startAge > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'startAge',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (endAge < 0 || endAge > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'endAge',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (minimumTravelers < 0 || minimumTravelers > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'minimumTravelers',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (maximumTravelers != null) {
      if (maximumTravelers! < 0 || maximumTravelers! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumTravelers',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (!{
          'adult',
          'senior',
          'youth',
          'child',
          'infant',
          'traveler',
        }.contains(category) ||
        startAge > 120 ||
        endAge > 120 ||
        endAge < startAge ||
        minimumTravelers > 100 ||
        maximumTravelers != null &&
            (maximumTravelers! > 100 || maximumTravelers! < minimumTravelers))
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
    "category": category,
    "startAge": startAge,
    "endAge": endAge,
    "minimumTravelers": minimumTravelers,
    if (maximumTravelers != null) "maximumTravelers": maximumTravelers,
    "countsTowardCapacity": countsTowardCapacity,
    "requiresAdult": requiresAdult,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAgeBand && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAgeBand(redacted)';
}
