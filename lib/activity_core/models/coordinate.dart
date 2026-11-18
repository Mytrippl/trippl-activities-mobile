// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityCoordinate {
  ActivityCoordinate({required this.latitude, required this.longitude});

  final double latitude;
  final double longitude;

  factory ActivityCoordinate.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {"latitude", "longitude"});
    final value = ActivityCoordinate(
      latitude: ActivityCodec.decimal(json, 'latitude', required: true)!,
      longitude: ActivityCodec.decimal(json, 'longitude', required: true)!,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityCoordinate> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityCoordinate.fromJson(ActivityCodec.object(input)),
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

  ActivityCoordinate copyWith({
    Set<String> clear = const {},
    double? latitude,
    double? longitude,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCoordinate(
      latitude: (latitude ?? this.latitude),
      longitude: (longitude ?? this.longitude),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (!latitude.isFinite)
        validationIssues.add(
          const ActivityIssue(
            'latitude',
            'finite',
            'Use a finite coordinate or weight',
          ),
        );
    }
    {
      if (!longitude.isFinite)
        validationIssues.add(
          const ActivityIssue(
            'longitude',
            'finite',
            'Use a finite coordinate or weight',
          ),
        );
    }
    if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180)
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
    "latitude": latitude,
    "longitude": longitude,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCoordinate &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCoordinate(redacted)';
}
