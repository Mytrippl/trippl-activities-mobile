// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityBookingTraveler {
  ActivityBookingTraveler({
    required this.travelerId,
    required this.age,
    this.givenName,
    this.familyName,
    this.dateOfBirth,
    this.lead = false,
    this.revision = 1,
  });

  final String travelerId;
  final int age;
  final String? givenName;
  final String? familyName;
  final DateTime? dateOfBirth;
  final bool lead;
  final int revision;

  factory ActivityBookingTraveler.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "travelerId",
      "age",
      "givenName",
      "familyName",
      "dateOfBirth",
      "lead",
      "revision",
    });
    final value = ActivityBookingTraveler(
      travelerId: ActivityCodec.text(json, 'travelerId', required: true)!,
      age: ActivityCodec.integer(
        json,
        'age',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      givenName: ActivityCodec.text(json, 'givenName'),
      familyName: ActivityCodec.text(json, 'familyName'),
      dateOfBirth: ActivityCodec.date(json, 'dateOfBirth', calendar: true),
      lead: ActivityCodec.boolean(json, 'lead') ?? false,
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

  static ActivityResult<ActivityBookingTraveler> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityBookingTraveler.fromJson(ActivityCodec.object(input)),
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

  ActivityBookingTraveler copyWith({
    Set<String> clear = const {},
    String? travelerId,
    int? age,
    String? givenName,
    String? familyName,
    DateTime? dateOfBirth,
    bool? lead,
    int? revision,
  }) {
    final clearableFields = <String>{"givenName", "familyName", "dateOfBirth"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityBookingTraveler(
      travelerId: (travelerId ?? this.travelerId),
      age: (age ?? this.age),
      givenName: clear.contains('givenName')
          ? null
          : (givenName ?? this.givenName),
      familyName: clear.contains('familyName')
          ? null
          : (familyName ?? this.familyName),
      dateOfBirth: clear.contains('dateOfBirth')
          ? null
          : (dateOfBirth ?? this.dateOfBirth),
      lead: (lead ?? this.lead),
      revision: (revision ?? this.revision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (travelerId.trim().isEmpty || travelerId.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'travelerId',
            'text',
            'Use nonempty bounded text',
          ),
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
    if (givenName != null) {
      if (givenName!.trim().isEmpty || givenName!.length > 4000)
        validationIssues.add(
          const ActivityIssue('givenName', 'text', 'Use nonempty bounded text'),
        );
    }
    if (familyName != null) {
      if (familyName!.trim().isEmpty || familyName!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'familyName',
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
    if (revision < 1 || age > 120)
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
    "travelerId": travelerId,
    "age": age,
    if (givenName != null) "givenName": givenName,
    if (familyName != null) "familyName": familyName,
    if (dateOfBirth != null)
      "dateOfBirth": ActivityCodec.calendarText(dateOfBirth!),
    "lead": lead,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityBookingTraveler &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityBookingTraveler(redacted)';
}
