// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'attribution.dart';

class ActivityReview {
  ActivityReview({
    required this.id,
    required this.authorName,
    this.rating,
    this.text,
    this.language,
    this.publishedAt,
    this.observedAt,
    this.verified = false,
    List<ActivityAttribution> attributions = const [],
  }) : attributions = List.unmodifiable(attributions);

  final String id;
  final String authorName;
  final double? rating;
  final String? text;
  final String? language;
  final DateTime? publishedAt;
  final DateTime? observedAt;
  final bool verified;
  final List<ActivityAttribution> attributions;

  factory ActivityReview.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "authorName",
      "rating",
      "text",
      "language",
      "publishedAt",
      "observedAt",
      "verified",
      "attributions",
    });
    final value = ActivityReview(
      id: ActivityCodec.text(json, 'id', required: true)!,
      authorName: ActivityCodec.text(json, 'authorName', required: true)!,
      rating: ActivityCodec.decimal(json, 'rating'),
      text: ActivityCodec.text(json, 'text'),
      language: ActivityCodec.text(json, 'language'),
      publishedAt: ActivityCodec.date(json, 'publishedAt'),
      observedAt: ActivityCodec.date(json, 'observedAt'),
      verified: ActivityCodec.boolean(json, 'verified') ?? false,
      attributions:
          ActivityCodec.list(
            json,
            'attributions',
            (v) => ActivityAttribution.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityReview> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityReview.fromJson(ActivityCodec.object(input)),
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

  ActivityReview copyWith({
    Set<String> clear = const {},
    String? id,
    String? authorName,
    double? rating,
    String? text,
    String? language,
    DateTime? publishedAt,
    DateTime? observedAt,
    bool? verified,
    List<ActivityAttribution>? attributions,
  }) {
    final clearableFields = <String>{
      "rating",
      "text",
      "language",
      "publishedAt",
      "observedAt",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityReview(
      id: (id ?? this.id),
      authorName: (authorName ?? this.authorName),
      rating: clear.contains('rating') ? null : (rating ?? this.rating),
      text: clear.contains('text') ? null : (text ?? this.text),
      language: clear.contains('language') ? null : (language ?? this.language),
      publishedAt: clear.contains('publishedAt')
          ? null
          : (publishedAt ?? this.publishedAt),
      observedAt: clear.contains('observedAt')
          ? null
          : (observedAt ?? this.observedAt),
      verified: (verified ?? this.verified),
      attributions: (attributions ?? this.attributions),
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
      if (authorName.trim().isEmpty || authorName.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'authorName',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (rating != null) {
      if (!rating!.isFinite)
        validationIssues.add(
          const ActivityIssue(
            'rating',
            'finite',
            'Use a finite coordinate or weight',
          ),
        );
    }
    if (text != null) {
      if (text!.trim().isEmpty || text!.length > 4000)
        validationIssues.add(
          const ActivityIssue('text', 'text', 'Use nonempty bounded text'),
        );
    }
    if (language != null) {
      if (language!.trim().isEmpty || language!.length > 4000)
        validationIssues.add(
          const ActivityIssue('language', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (attributions.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'attributions',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < attributions.length; i++)
        for (final issue in attributions[i].validate())
          validationIssues.add(
            ActivityIssue(
              'attributions[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (rating != null && (rating! < 0 || rating! > 5))
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
    "authorName": authorName,
    if (rating != null) "rating": rating,
    if (text != null) "text": text,
    if (language != null) "language": language,
    if (publishedAt != null)
      "publishedAt": publishedAt!.toUtc().toIso8601String(),
    if (observedAt != null) "observedAt": observedAt!.toUtc().toIso8601String(),
    "verified": verified,
    "attributions": attributions.map((item) => item.toJson()).toList(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityReview && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityReview(redacted)';
}
