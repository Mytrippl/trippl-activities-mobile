// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'address.dart';
import 'coordinate.dart';

class ActivityMeetingPoint {
  ActivityMeetingPoint({
    required this.id,
    required this.name,
    this.coordinate,
    this.address,
    this.instructions,
    this.arrivalMinutesBefore = 0,
    this.confirmed = false,
    this.optionId,
  });

  final String id;
  final String name;
  final ActivityCoordinate? coordinate;
  final ActivityAddress? address;
  final String? instructions;
  final int arrivalMinutesBefore;
  final bool confirmed;
  final String? optionId;

  factory ActivityMeetingPoint.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "name",
      "coordinate",
      "address",
      "instructions",
      "arrivalMinutesBefore",
      "confirmed",
      "optionId",
    });
    final value = ActivityMeetingPoint(
      id: ActivityCodec.text(json, 'id', required: true)!,
      name: ActivityCodec.text(json, 'name', required: true)!,
      coordinate: json['coordinate'] == null
          ? null
          : ActivityCoordinate.fromJson(
              ActivityCodec.object(json['coordinate']),
            ),
      address: json['address'] == null
          ? null
          : ActivityAddress.fromJson(ActivityCodec.object(json['address'])),
      instructions: ActivityCodec.text(json, 'instructions'),
      arrivalMinutesBefore:
          ActivityCodec.integer(
            json,
            'arrivalMinutesBefore',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      confirmed: ActivityCodec.boolean(json, 'confirmed') ?? false,
      optionId: ActivityCodec.text(json, 'optionId'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityMeetingPoint> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityMeetingPoint.fromJson(ActivityCodec.object(input)),
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

  ActivityMeetingPoint copyWith({
    Set<String> clear = const {},
    String? id,
    String? name,
    ActivityCoordinate? coordinate,
    ActivityAddress? address,
    String? instructions,
    int? arrivalMinutesBefore,
    bool? confirmed,
    String? optionId,
  }) {
    final clearableFields = <String>{
      "coordinate",
      "address",
      "instructions",
      "optionId",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityMeetingPoint(
      id: (id ?? this.id),
      name: (name ?? this.name),
      coordinate: clear.contains('coordinate')
          ? null
          : (coordinate ?? this.coordinate),
      address: clear.contains('address') ? null : (address ?? this.address),
      instructions: clear.contains('instructions')
          ? null
          : (instructions ?? this.instructions),
      arrivalMinutesBefore: (arrivalMinutesBefore ?? this.arrivalMinutesBefore),
      confirmed: (confirmed ?? this.confirmed),
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
      if (name.trim().isEmpty || name.length > 4000)
        validationIssues.add(
          const ActivityIssue('name', 'text', 'Use nonempty bounded text'),
        );
    }
    if (coordinate != null) {
      for (final issue in coordinate!.validate())
        validationIssues.add(
          ActivityIssue(
            'coordinate.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (address != null) {
      for (final issue in address!.validate())
        validationIssues.add(
          ActivityIssue(
            'address.${issue.field}',
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
      if (arrivalMinutesBefore < 0 || arrivalMinutesBefore > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'arrivalMinutesBefore',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (optionId != null) {
      if (optionId!.trim().isEmpty || optionId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (arrivalMinutesBefore > 1440)
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
    "name": name,
    if (coordinate != null) "coordinate": coordinate!.toJson(),
    if (address != null) "address": address!.toJson(),
    if (instructions != null) "instructions": instructions,
    "arrivalMinutesBefore": arrivalMinutesBefore,
    "confirmed": confirmed,
    if (optionId != null) "optionId": optionId,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityMeetingPoint &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityMeetingPoint(redacted)';
}
