// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityPickup {
  ActivityPickup({
    required this.id,
    this.available = false,
    this.included = false,
    this.requiresSelection = false,
    List<String> pointIds = const [],
    this.instructions,
    this.cutoffAt,
  }) : pointIds = List.unmodifiable(pointIds);

  final String id;
  final bool available;
  final bool included;
  final bool requiresSelection;
  final List<String> pointIds;
  final String? instructions;
  final DateTime? cutoffAt;

  factory ActivityPickup.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "available",
      "included",
      "requiresSelection",
      "pointIds",
      "instructions",
      "cutoffAt",
    });
    final value = ActivityPickup(
      id: ActivityCodec.text(json, 'id', required: true)!,
      available: ActivityCodec.boolean(json, 'available') ?? false,
      included: ActivityCodec.boolean(json, 'included') ?? false,
      requiresSelection:
          ActivityCodec.boolean(json, 'requiresSelection') ?? false,
      pointIds:
          ActivityCodec.list(json, 'pointIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      instructions: ActivityCodec.text(json, 'instructions'),
      cutoffAt: ActivityCodec.date(json, 'cutoffAt'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityPickup> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPickup.fromJson(ActivityCodec.object(input)),
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

  ActivityPickup copyWith({
    Set<String> clear = const {},
    String? id,
    bool? available,
    bool? included,
    bool? requiresSelection,
    List<String>? pointIds,
    String? instructions,
    DateTime? cutoffAt,
  }) {
    final clearableFields = <String>{"instructions", "cutoffAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPickup(
      id: (id ?? this.id),
      available: (available ?? this.available),
      included: (included ?? this.included),
      requiresSelection: (requiresSelection ?? this.requiresSelection),
      pointIds: (pointIds ?? this.pointIds),
      instructions: clear.contains('instructions')
          ? null
          : (instructions ?? this.instructions),
      cutoffAt: clear.contains('cutoffAt') ? null : (cutoffAt ?? this.cutoffAt),
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
      if (pointIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'pointIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (pointIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'pointIds',
            'text',
            'Use bounded nonempty list text',
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
    if (pointIds.toSet().length != pointIds.length || included && !available)
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
    "available": available,
    "included": included,
    "requiresSelection": requiresSelection,
    "pointIds": pointIds,
    if (instructions != null) "instructions": instructions,
    if (cutoffAt != null) "cutoffAt": cutoffAt!.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPickup && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPickup(redacted)';
}
