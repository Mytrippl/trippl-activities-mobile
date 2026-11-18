// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityEligibility {
  ActivityEligibility({
    required this.evaluatedAt,
    required this.eligible,
    required this.totalTravelers,
    List<String> unsupportedTravelerIds = const [],
    List<String> reasonCodes = const [],
    List<String> assignedCategories = const [],
    this.capacityTravelers = 0,
    this.requiresReview = false,
  }) : unsupportedTravelerIds = List.unmodifiable(unsupportedTravelerIds),
       reasonCodes = List.unmodifiable(reasonCodes),
       assignedCategories = List.unmodifiable(assignedCategories);

  final DateTime evaluatedAt;
  final bool eligible;
  final int totalTravelers;
  final List<String> unsupportedTravelerIds;
  final List<String> reasonCodes;
  final List<String> assignedCategories;
  final int capacityTravelers;
  final bool requiresReview;

  factory ActivityEligibility.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "evaluatedAt",
      "eligible",
      "totalTravelers",
      "unsupportedTravelerIds",
      "reasonCodes",
      "assignedCategories",
      "capacityTravelers",
      "requiresReview",
    });
    final value = ActivityEligibility(
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      eligible: ActivityCodec.boolean(json, 'eligible', required: true)!,
      totalTravelers: ActivityCodec.integer(
        json,
        'totalTravelers',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      unsupportedTravelerIds:
          ActivityCodec.list(json, 'unsupportedTravelerIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      reasonCodes:
          ActivityCodec.list(json, 'reasonCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      assignedCategories:
          ActivityCodec.list(json, 'assignedCategories', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      capacityTravelers:
          ActivityCodec.integer(
            json,
            'capacityTravelers',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      requiresReview: ActivityCodec.boolean(json, 'requiresReview') ?? false,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityEligibility> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityEligibility.fromJson(ActivityCodec.object(input)),
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

  ActivityEligibility copyWith({
    Set<String> clear = const {},
    DateTime? evaluatedAt,
    bool? eligible,
    int? totalTravelers,
    List<String>? unsupportedTravelerIds,
    List<String>? reasonCodes,
    List<String>? assignedCategories,
    int? capacityTravelers,
    bool? requiresReview,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityEligibility(
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      eligible: (eligible ?? this.eligible),
      totalTravelers: (totalTravelers ?? this.totalTravelers),
      unsupportedTravelerIds:
          (unsupportedTravelerIds ?? this.unsupportedTravelerIds),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
      assignedCategories: (assignedCategories ?? this.assignedCategories),
      capacityTravelers: (capacityTravelers ?? this.capacityTravelers),
      requiresReview: (requiresReview ?? this.requiresReview),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (totalTravelers < 0 || totalTravelers > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'totalTravelers',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (unsupportedTravelerIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'unsupportedTravelerIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (unsupportedTravelerIds.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const ActivityIssue(
            'unsupportedTravelerIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (assignedCategories.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'assignedCategories',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (assignedCategories.any(
        (item) => item.trim().isEmpty || item.length > 200,
      ))
        validationIssues.add(
          const ActivityIssue(
            'assignedCategories',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (capacityTravelers < 0 || capacityTravelers > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'capacityTravelers',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (totalTravelers > 100 ||
        capacityTravelers > totalTravelers ||
        assignedCategories.length > totalTravelers)
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
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "eligible": eligible,
    "totalTravelers": totalTravelers,
    "unsupportedTravelerIds": unsupportedTravelerIds,
    "reasonCodes": reasonCodes,
    "assignedCategories": assignedCategories,
    "capacityTravelers": capacityTravelers,
    "requiresReview": requiresReview,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityEligibility &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityEligibility(redacted)';
}
