// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityAccessibility {
  ActivityAccessibility({
    this.wheelchairAccessible,
    this.strollerAccessible,
    this.serviceAnimalsAllowed,
    this.minimumFitness,
    List<String> restrictions = const [],
    this.confirmed = false,
    this.observedAt,
  }) : restrictions = List.unmodifiable(restrictions);

  final bool? wheelchairAccessible;
  final bool? strollerAccessible;
  final bool? serviceAnimalsAllowed;
  final String? minimumFitness;
  final List<String> restrictions;
  final bool confirmed;
  final DateTime? observedAt;

  factory ActivityAccessibility.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "wheelchairAccessible",
      "strollerAccessible",
      "serviceAnimalsAllowed",
      "minimumFitness",
      "restrictions",
      "confirmed",
      "observedAt",
    });
    final value = ActivityAccessibility(
      wheelchairAccessible: ActivityCodec.boolean(json, 'wheelchairAccessible'),
      strollerAccessible: ActivityCodec.boolean(json, 'strollerAccessible'),
      serviceAnimalsAllowed: ActivityCodec.boolean(
        json,
        'serviceAnimalsAllowed',
      ),
      minimumFitness: ActivityCodec.text(json, 'minimumFitness'),
      restrictions:
          ActivityCodec.list(json, 'restrictions', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      confirmed: ActivityCodec.boolean(json, 'confirmed') ?? false,
      observedAt: ActivityCodec.date(json, 'observedAt'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityAccessibility> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAccessibility.fromJson(ActivityCodec.object(input)),
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

  ActivityAccessibility copyWith({
    Set<String> clear = const {},
    bool? wheelchairAccessible,
    bool? strollerAccessible,
    bool? serviceAnimalsAllowed,
    String? minimumFitness,
    List<String>? restrictions,
    bool? confirmed,
    DateTime? observedAt,
  }) {
    final clearableFields = <String>{
      "wheelchairAccessible",
      "strollerAccessible",
      "serviceAnimalsAllowed",
      "minimumFitness",
      "observedAt",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAccessibility(
      wheelchairAccessible: clear.contains('wheelchairAccessible')
          ? null
          : (wheelchairAccessible ?? this.wheelchairAccessible),
      strollerAccessible: clear.contains('strollerAccessible')
          ? null
          : (strollerAccessible ?? this.strollerAccessible),
      serviceAnimalsAllowed: clear.contains('serviceAnimalsAllowed')
          ? null
          : (serviceAnimalsAllowed ?? this.serviceAnimalsAllowed),
      minimumFitness: clear.contains('minimumFitness')
          ? null
          : (minimumFitness ?? this.minimumFitness),
      restrictions: (restrictions ?? this.restrictions),
      confirmed: (confirmed ?? this.confirmed),
      observedAt: clear.contains('observedAt')
          ? null
          : (observedAt ?? this.observedAt),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    if (minimumFitness != null) {
      if (minimumFitness!.trim().isEmpty || minimumFitness!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'minimumFitness',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (restrictions.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'restrictions',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (restrictions.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'restrictions',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    if (wheelchairAccessible != null)
      "wheelchairAccessible": wheelchairAccessible,
    if (strollerAccessible != null) "strollerAccessible": strollerAccessible,
    if (serviceAnimalsAllowed != null)
      "serviceAnimalsAllowed": serviceAnimalsAllowed,
    if (minimumFitness != null) "minimumFitness": minimumFitness,
    "restrictions": restrictions,
    "confirmed": confirmed,
    if (observedAt != null) "observedAt": observedAt!.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAccessibility &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAccessibility(redacted)';
}
