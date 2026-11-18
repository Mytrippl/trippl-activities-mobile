// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityItineraryDay {
  ActivityItineraryDay({
    required this.id,
    required this.itineraryId,
    required this.date,
    required this.offsetMinutes,
    List<String> stopIds = const [],
    this.startMinute = 480,
    this.endMinute = 1320,
    this.revision = 1,
  }) : stopIds = List.unmodifiable(stopIds);

  final String id;
  final String itineraryId;
  final DateTime date;
  final int offsetMinutes;
  final List<String> stopIds;
  final int startMinute;
  final int endMinute;
  final int revision;

  factory ActivityItineraryDay.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "itineraryId",
      "date",
      "offsetMinutes",
      "stopIds",
      "startMinute",
      "endMinute",
      "revision",
    });
    final value = ActivityItineraryDay(
      id: ActivityCodec.text(json, 'id', required: true)!,
      itineraryId: ActivityCodec.text(json, 'itineraryId', required: true)!,
      date: ActivityCodec.date(json, 'date', required: true, calendar: true)!,
      offsetMinutes: ActivityCodec.integer(
        json,
        'offsetMinutes',
        required: true,
        minimum: -840,
        maximum: 840,
      )!,
      stopIds:
          ActivityCodec.list(json, 'stopIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      startMinute:
          ActivityCodec.integer(
            json,
            'startMinute',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          480,
      endMinute:
          ActivityCodec.integer(
            json,
            'endMinute',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1320,
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

  static ActivityResult<ActivityItineraryDay> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityItineraryDay.fromJson(ActivityCodec.object(input)),
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

  ActivityItineraryDay copyWith({
    Set<String> clear = const {},
    String? id,
    String? itineraryId,
    DateTime? date,
    int? offsetMinutes,
    List<String>? stopIds,
    int? startMinute,
    int? endMinute,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityItineraryDay(
      id: (id ?? this.id),
      itineraryId: (itineraryId ?? this.itineraryId),
      date: (date ?? this.date),
      offsetMinutes: (offsetMinutes ?? this.offsetMinutes),
      stopIds: (stopIds ?? this.stopIds),
      startMinute: (startMinute ?? this.startMinute),
      endMinute: (endMinute ?? this.endMinute),
      revision: (revision ?? this.revision),
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
      if (itineraryId.trim().isEmpty || itineraryId.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'itineraryId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (offsetMinutes < -840 || offsetMinutes > 840)
        validationIssues.add(
          const ActivityIssue(
            'offsetMinutes',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (stopIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'stopIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (stopIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'stopIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (startMinute < 0 || startMinute > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'startMinute',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (endMinute < 0 || endMinute > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'endMinute',
            'range',
            'Number is outside the activity limits',
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
    if (revision < 1 ||
        startMinute > 1439 ||
        endMinute > 1440 ||
        endMinute <= startMinute ||
        stopIds.toSet().length != stopIds.length)
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
    "itineraryId": itineraryId,
    "date": ActivityCodec.calendarText(date),
    "offsetMinutes": offsetMinutes,
    "stopIds": stopIds,
    "startMinute": startMinute,
    "endMinute": endMinute,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityItineraryDay &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityItineraryDay(redacted)';
}
