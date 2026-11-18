// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'cancellation_tier.dart';

class ActivityCancellationPolicy {
  ActivityCancellationPolicy({
    required this.id,
    this.kind = "unknown",
    List<ActivityCancellationTier> tiers = const [],
    this.observedAt,
    this.expiresAt,
    this.description,
    this.requiresReview = true,
  }) : tiers = List.unmodifiable(tiers);

  final String id;
  final String kind;
  final List<ActivityCancellationTier> tiers;
  final DateTime? observedAt;
  final DateTime? expiresAt;
  final String? description;
  final bool requiresReview;

  factory ActivityCancellationPolicy.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "kind",
      "tiers",
      "observedAt",
      "expiresAt",
      "description",
      "requiresReview",
    });
    final value = ActivityCancellationPolicy(
      id: ActivityCodec.text(json, 'id', required: true)!,
      kind: ActivityCodec.text(json, 'kind') ?? "unknown",
      tiers:
          ActivityCodec.list(
            json,
            'tiers',
            (v) => ActivityCancellationTier.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      observedAt: ActivityCodec.date(json, 'observedAt'),
      expiresAt: ActivityCodec.date(json, 'expiresAt'),
      description: ActivityCodec.text(json, 'description'),
      requiresReview: ActivityCodec.boolean(json, 'requiresReview') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityCancellationPolicy> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityCancellationPolicy.fromJson(ActivityCodec.object(input)),
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

  ActivityCancellationPolicy copyWith({
    Set<String> clear = const {},
    String? id,
    String? kind,
    List<ActivityCancellationTier>? tiers,
    DateTime? observedAt,
    DateTime? expiresAt,
    String? description,
    bool? requiresReview,
  }) {
    final clearableFields = <String>{"observedAt", "expiresAt", "description"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCancellationPolicy(
      id: (id ?? this.id),
      kind: (kind ?? this.kind),
      tiers: (tiers ?? this.tiers),
      observedAt: clear.contains('observedAt')
          ? null
          : (observedAt ?? this.observedAt),
      expiresAt: clear.contains('expiresAt')
          ? null
          : (expiresAt ?? this.expiresAt),
      description: clear.contains('description')
          ? null
          : (description ?? this.description),
      requiresReview: (requiresReview ?? this.requiresReview),
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
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (tiers.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'tiers',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < tiers.length; i++)
        for (final issue in tiers[i].validate())
          validationIssues.add(
            ActivityIssue(
              'tiers[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (description != null) {
      if (description!.trim().isEmpty || description!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'description',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (!{'unknown', 'standard', 'custom', 'nonRefundable'}.contains(kind) ||
        observedAt != null &&
            expiresAt != null &&
            !expiresAt!.isAfter(observedAt!) ||
        tiers.map((t) => t.id).toSet().length != tiers.length)
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
    "kind": kind,
    "tiers": tiers.map((item) => item.toJson()).toList(),
    if (observedAt != null) "observedAt": observedAt!.toUtc().toIso8601String(),
    if (expiresAt != null) "expiresAt": expiresAt!.toUtc().toIso8601String(),
    if (description != null) "description": description,
    "requiresReview": requiresReview,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCancellationPolicy &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCancellationPolicy(redacted)';
}
