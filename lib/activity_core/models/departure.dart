// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'meeting_point.dart';
import 'pickup.dart';

class ActivityDeparture {
  ActivityDeparture({
    required this.productId,
    required this.optionId,
    required this.slotId,
    required this.startsAt,
    this.endsAt,
    this.meetingPoint,
    this.pickup,
    this.languageCode,
    this.requiresConfirmation = true,
    List<String> warningCodes = const [],
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String productId;
  final String optionId;
  final String slotId;
  final DateTime startsAt;
  final DateTime? endsAt;
  final ActivityMeetingPoint? meetingPoint;
  final ActivityPickup? pickup;
  final String? languageCode;
  final bool requiresConfirmation;
  final List<String> warningCodes;

  factory ActivityDeparture.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "productId",
      "optionId",
      "slotId",
      "startsAt",
      "endsAt",
      "meetingPoint",
      "pickup",
      "languageCode",
      "requiresConfirmation",
      "warningCodes",
    });
    final value = ActivityDeparture(
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      optionId: ActivityCodec.text(json, 'optionId', required: true)!,
      slotId: ActivityCodec.text(json, 'slotId', required: true)!,
      startsAt: ActivityCodec.date(json, 'startsAt', required: true)!,
      endsAt: ActivityCodec.date(json, 'endsAt'),
      meetingPoint: json['meetingPoint'] == null
          ? null
          : ActivityMeetingPoint.fromJson(
              ActivityCodec.object(json['meetingPoint']),
            ),
      pickup: json['pickup'] == null
          ? null
          : ActivityPickup.fromJson(ActivityCodec.object(json['pickup'])),
      languageCode: ActivityCodec.text(json, 'languageCode'),
      requiresConfirmation:
          ActivityCodec.boolean(json, 'requiresConfirmation') ?? true,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityDeparture> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityDeparture.fromJson(ActivityCodec.object(input)),
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

  ActivityDeparture copyWith({
    Set<String> clear = const {},
    String? productId,
    String? optionId,
    String? slotId,
    DateTime? startsAt,
    DateTime? endsAt,
    ActivityMeetingPoint? meetingPoint,
    ActivityPickup? pickup,
    String? languageCode,
    bool? requiresConfirmation,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{
      "endsAt",
      "meetingPoint",
      "pickup",
      "languageCode",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityDeparture(
      productId: (productId ?? this.productId),
      optionId: (optionId ?? this.optionId),
      slotId: (slotId ?? this.slotId),
      startsAt: (startsAt ?? this.startsAt),
      endsAt: clear.contains('endsAt') ? null : (endsAt ?? this.endsAt),
      meetingPoint: clear.contains('meetingPoint')
          ? null
          : (meetingPoint ?? this.meetingPoint),
      pickup: clear.contains('pickup') ? null : (pickup ?? this.pickup),
      languageCode: clear.contains('languageCode')
          ? null
          : (languageCode ?? this.languageCode),
      requiresConfirmation: (requiresConfirmation ?? this.requiresConfirmation),
      warningCodes: (warningCodes ?? this.warningCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (productId.trim().isEmpty || productId.length > 4000)
        validationIssues.add(
          const ActivityIssue('productId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (optionId.trim().isEmpty || optionId.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (slotId.trim().isEmpty || slotId.length > 4000)
        validationIssues.add(
          const ActivityIssue('slotId', 'text', 'Use nonempty bounded text'),
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
    if (pickup != null) {
      for (final issue in pickup!.validate())
        validationIssues.add(
          ActivityIssue(
            'pickup.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (languageCode != null) {
      if (languageCode!.trim().isEmpty || languageCode!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'languageCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (warningCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (warningCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (endsAt != null && !endsAt!.isAfter(startsAt))
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
    "productId": productId,
    "optionId": optionId,
    "slotId": slotId,
    "startsAt": startsAt.toUtc().toIso8601String(),
    if (endsAt != null) "endsAt": endsAt!.toUtc().toIso8601String(),
    if (meetingPoint != null) "meetingPoint": meetingPoint!.toJson(),
    if (pickup != null) "pickup": pickup!.toJson(),
    if (languageCode != null) "languageCode": languageCode,
    "requiresConfirmation": requiresConfirmation,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityDeparture &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityDeparture(redacted)';
}
