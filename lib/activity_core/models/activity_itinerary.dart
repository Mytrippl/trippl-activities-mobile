// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityItinerary {
  ActivityItinerary({
    required this.id,
    required this.scope,
    required this.title,
    required this.startDate,
    required this.endDate,
    required this.createdAt,
    required this.updatedAt,
    List<String> dayIds = const [],
    this.revision = 1,
    this.state = "draft",
  }) : dayIds = List.unmodifiable(dayIds);

  final String id;
  final String scope;
  final String title;
  final DateTime startDate;
  final DateTime endDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> dayIds;
  final int revision;
  final String state;

  factory ActivityItinerary.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "title",
      "startDate",
      "endDate",
      "createdAt",
      "updatedAt",
      "dayIds",
      "revision",
      "state",
    });
    final value = ActivityItinerary(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      title: ActivityCodec.text(json, 'title', required: true)!,
      startDate: ActivityCodec.date(
        json,
        'startDate',
        required: true,
        calendar: true,
      )!,
      endDate: ActivityCodec.date(
        json,
        'endDate',
        required: true,
        calendar: true,
      )!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      dayIds:
          ActivityCodec.list(json, 'dayIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      state: ActivityCodec.text(json, 'state') ?? "draft",
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityItinerary> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityItinerary.fromJson(ActivityCodec.object(input)),
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

  ActivityItinerary copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? title,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? dayIds,
    int? revision,
    String? state,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityItinerary(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      title: (title ?? this.title),
      startDate: (startDate ?? this.startDate),
      endDate: (endDate ?? this.endDate),
      createdAt: (createdAt ?? this.createdAt),
      updatedAt: (updatedAt ?? this.updatedAt),
      dayIds: (dayIds ?? this.dayIds),
      revision: (revision ?? this.revision),
      state: (state ?? this.state),
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
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (title.trim().isEmpty || title.length > 4000)
        validationIssues.add(
          const ActivityIssue('title', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (dayIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'dayIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (dayIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'dayIds',
            'text',
            'Use bounded nonempty list text',
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
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (revision < 1 ||
        updatedAt.isBefore(createdAt) ||
        endDate.isBefore(startDate) ||
        endDate.difference(startDate).inDays > 90 ||
        dayIds.toSet().length != dayIds.length ||
        !{'draft', 'ready', 'archived'}.contains(state))
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
    "scope": scope,
    "title": title,
    "startDate": ActivityCodec.calendarText(startDate),
    "endDate": ActivityCodec.calendarText(endDate),
    "createdAt": createdAt.toUtc().toIso8601String(),
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "dayIds": dayIds,
    "revision": revision,
    "state": state,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityItinerary &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityItinerary(redacted)';
}
