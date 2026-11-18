// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityItineraryConflict {
  ActivityItineraryConflict({
    required this.code,
    required this.dayId,
    required this.stopId,
    required this.message,
    this.relatedStopId,
    this.severity = "warning",
    this.requiresReview = true,
  });

  final String code;
  final String dayId;
  final String stopId;
  final String message;
  final String? relatedStopId;
  final String severity;
  final bool requiresReview;

  factory ActivityItineraryConflict.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "code",
      "dayId",
      "stopId",
      "message",
      "relatedStopId",
      "severity",
      "requiresReview",
    });
    final value = ActivityItineraryConflict(
      code: ActivityCodec.text(json, 'code', required: true)!,
      dayId: ActivityCodec.text(json, 'dayId', required: true)!,
      stopId: ActivityCodec.text(json, 'stopId', required: true)!,
      message: ActivityCodec.text(json, 'message', required: true)!,
      relatedStopId: ActivityCodec.text(json, 'relatedStopId'),
      severity: ActivityCodec.text(json, 'severity') ?? "warning",
      requiresReview: ActivityCodec.boolean(json, 'requiresReview') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityItineraryConflict> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityItineraryConflict.fromJson(ActivityCodec.object(input)),
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

  ActivityItineraryConflict copyWith({
    Set<String> clear = const {},
    String? code,
    String? dayId,
    String? stopId,
    String? message,
    String? relatedStopId,
    String? severity,
    bool? requiresReview,
  }) {
    final clearableFields = <String>{"relatedStopId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityItineraryConflict(
      code: (code ?? this.code),
      dayId: (dayId ?? this.dayId),
      stopId: (stopId ?? this.stopId),
      message: (message ?? this.message),
      relatedStopId: clear.contains('relatedStopId')
          ? null
          : (relatedStopId ?? this.relatedStopId),
      severity: (severity ?? this.severity),
      requiresReview: (requiresReview ?? this.requiresReview),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (code.trim().isEmpty || code.length > 4000)
        validationIssues.add(
          const ActivityIssue('code', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (dayId.trim().isEmpty || dayId.length > 4000)
        validationIssues.add(
          const ActivityIssue('dayId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (stopId.trim().isEmpty || stopId.length > 4000)
        validationIssues.add(
          const ActivityIssue('stopId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (message.trim().isEmpty || message.length > 4000)
        validationIssues.add(
          const ActivityIssue('message', 'text', 'Use nonempty bounded text'),
        );
    }
    if (relatedStopId != null) {
      if (relatedStopId!.trim().isEmpty || relatedStopId!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'relatedStopId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (severity.trim().isEmpty || severity.length > 4000)
        validationIssues.add(
          const ActivityIssue('severity', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!{'information', 'warning', 'error'}.contains(severity))
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
    "code": code,
    "dayId": dayId,
    "stopId": stopId,
    "message": message,
    if (relatedStopId != null) "relatedStopId": relatedStopId,
    "severity": severity,
    "requiresReview": requiresReview,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityItineraryConflict &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityItineraryConflict(redacted)';
}
