// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityFieldMask {
  ActivityFieldMask({
    this.includePhotos = true,
    this.includeReviews = false,
    this.includeOptions = true,
    this.includeCancellation = true,
    this.maximumPhotos = 5,
    this.maximumReviews = 5,
    List<String> fields = const [],
    this.version = 1,
  }) : fields = List.unmodifiable(fields);

  final bool includePhotos;
  final bool includeReviews;
  final bool includeOptions;
  final bool includeCancellation;
  final int maximumPhotos;
  final int maximumReviews;
  final List<String> fields;
  final int version;

  factory ActivityFieldMask.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "includePhotos",
      "includeReviews",
      "includeOptions",
      "includeCancellation",
      "maximumPhotos",
      "maximumReviews",
      "fields",
      "version",
    });
    final value = ActivityFieldMask(
      includePhotos: ActivityCodec.boolean(json, 'includePhotos') ?? true,
      includeReviews: ActivityCodec.boolean(json, 'includeReviews') ?? false,
      includeOptions: ActivityCodec.boolean(json, 'includeOptions') ?? true,
      includeCancellation:
          ActivityCodec.boolean(json, 'includeCancellation') ?? true,
      maximumPhotos:
          ActivityCodec.integer(
            json,
            'maximumPhotos',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          5,
      maximumReviews:
          ActivityCodec.integer(
            json,
            'maximumReviews',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          5,
      fields:
          ActivityCodec.list(json, 'fields', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      version:
          ActivityCodec.integer(
            json,
            'version',
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

  static ActivityResult<ActivityFieldMask> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityFieldMask.fromJson(ActivityCodec.object(input)),
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

  ActivityFieldMask copyWith({
    Set<String> clear = const {},
    bool? includePhotos,
    bool? includeReviews,
    bool? includeOptions,
    bool? includeCancellation,
    int? maximumPhotos,
    int? maximumReviews,
    List<String>? fields,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityFieldMask(
      includePhotos: (includePhotos ?? this.includePhotos),
      includeReviews: (includeReviews ?? this.includeReviews),
      includeOptions: (includeOptions ?? this.includeOptions),
      includeCancellation: (includeCancellation ?? this.includeCancellation),
      maximumPhotos: (maximumPhotos ?? this.maximumPhotos),
      maximumReviews: (maximumReviews ?? this.maximumReviews),
      fields: (fields ?? this.fields),
      version: (version ?? this.version),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (maximumPhotos < 0 || maximumPhotos > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumPhotos',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (maximumReviews < 0 || maximumReviews > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumReviews',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (fields.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'fields',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (fields.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'fields',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (version < 0 || version > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'version',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (version != 1 || maximumPhotos > 20 || maximumReviews > 20)
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
    "includePhotos": includePhotos,
    "includeReviews": includeReviews,
    "includeOptions": includeOptions,
    "includeCancellation": includeCancellation,
    "maximumPhotos": maximumPhotos,
    "maximumReviews": maximumReviews,
    "fields": fields,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityFieldMask &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityFieldMask(redacted)';
}
