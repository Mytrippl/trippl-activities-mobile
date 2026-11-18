// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'meeting_point.dart';

class ActivityPickupChoice {
  ActivityPickupChoice({
    required this.pickupId,
    required this.pointId,
    this.meetingPoint,
    this.instructions,
    this.selectedAt,
    this.confirmed = false,
    this.revision = 1,
  });

  final String pickupId;
  final String pointId;
  final ActivityMeetingPoint? meetingPoint;
  final String? instructions;
  final DateTime? selectedAt;
  final bool confirmed;
  final int revision;

  factory ActivityPickupChoice.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "pickupId",
      "pointId",
      "meetingPoint",
      "instructions",
      "selectedAt",
      "confirmed",
      "revision",
    });
    final value = ActivityPickupChoice(
      pickupId: ActivityCodec.text(json, 'pickupId', required: true)!,
      pointId: ActivityCodec.text(json, 'pointId', required: true)!,
      meetingPoint: json['meetingPoint'] == null
          ? null
          : ActivityMeetingPoint.fromJson(
              ActivityCodec.object(json['meetingPoint']),
            ),
      instructions: ActivityCodec.text(json, 'instructions'),
      selectedAt: ActivityCodec.date(json, 'selectedAt'),
      confirmed: ActivityCodec.boolean(json, 'confirmed') ?? false,
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

  static ActivityResult<ActivityPickupChoice> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPickupChoice.fromJson(ActivityCodec.object(input)),
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

  ActivityPickupChoice copyWith({
    Set<String> clear = const {},
    String? pickupId,
    String? pointId,
    ActivityMeetingPoint? meetingPoint,
    String? instructions,
    DateTime? selectedAt,
    bool? confirmed,
    int? revision,
  }) {
    final clearableFields = <String>{
      "meetingPoint",
      "instructions",
      "selectedAt",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPickupChoice(
      pickupId: (pickupId ?? this.pickupId),
      pointId: (pointId ?? this.pointId),
      meetingPoint: clear.contains('meetingPoint')
          ? null
          : (meetingPoint ?? this.meetingPoint),
      instructions: clear.contains('instructions')
          ? null
          : (instructions ?? this.instructions),
      selectedAt: clear.contains('selectedAt')
          ? null
          : (selectedAt ?? this.selectedAt),
      confirmed: (confirmed ?? this.confirmed),
      revision: (revision ?? this.revision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (pickupId.trim().isEmpty || pickupId.length > 4000)
        validationIssues.add(
          const ActivityIssue('pickupId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (pointId.trim().isEmpty || pointId.length > 4000)
        validationIssues.add(
          const ActivityIssue('pointId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (meetingPoint != null) {
      for (final issue in meetingPoint!.validate())
        validationIssues.add(
          ActivityIssue(
            'meetingPoint.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (instructions != null) {
      if (instructions!.trim().isEmpty || instructions!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'instructions',
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
    if (revision < 1 || meetingPoint != null && meetingPoint!.id != pointId)
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
    "pickupId": pickupId,
    "pointId": pointId,
    if (meetingPoint != null) "meetingPoint": meetingPoint!.toJson(),
    if (instructions != null) "instructions": instructions,
    if (selectedAt != null) "selectedAt": selectedAt!.toUtc().toIso8601String(),
    "confirmed": confirmed,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPickupChoice &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPickupChoice(redacted)';
}
