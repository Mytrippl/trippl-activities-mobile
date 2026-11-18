// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityExportPolicy {
  ActivityExportPolicy({
    this.includeNotes = false,
    this.includeCoordinates = false,
    this.includeBookingReferences = false,
    this.includeAttribution = true,
    this.maximumItems = 100,
    this.format = "json",
    this.version = 1,
  });

  final bool includeNotes;
  final bool includeCoordinates;
  final bool includeBookingReferences;
  final bool includeAttribution;
  final int maximumItems;
  final String format;
  final int version;

  factory ActivityExportPolicy.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "includeNotes",
      "includeCoordinates",
      "includeBookingReferences",
      "includeAttribution",
      "maximumItems",
      "format",
      "version",
    });
    final value = ActivityExportPolicy(
      includeNotes: ActivityCodec.boolean(json, 'includeNotes') ?? false,
      includeCoordinates:
          ActivityCodec.boolean(json, 'includeCoordinates') ?? false,
      includeBookingReferences:
          ActivityCodec.boolean(json, 'includeBookingReferences') ?? false,
      includeAttribution:
          ActivityCodec.boolean(json, 'includeAttribution') ?? true,
      maximumItems:
          ActivityCodec.integer(
            json,
            'maximumItems',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          100,
      format: ActivityCodec.text(json, 'format') ?? "json",
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

  static ActivityResult<ActivityExportPolicy> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityExportPolicy.fromJson(ActivityCodec.object(input)),
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

  ActivityExportPolicy copyWith({
    Set<String> clear = const {},
    bool? includeNotes,
    bool? includeCoordinates,
    bool? includeBookingReferences,
    bool? includeAttribution,
    int? maximumItems,
    String? format,
    int? version,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityExportPolicy(
      includeNotes: (includeNotes ?? this.includeNotes),
      includeCoordinates: (includeCoordinates ?? this.includeCoordinates),
      includeBookingReferences:
          (includeBookingReferences ?? this.includeBookingReferences),
      includeAttribution: (includeAttribution ?? this.includeAttribution),
      maximumItems: (maximumItems ?? this.maximumItems),
      format: (format ?? this.format),
      version: (version ?? this.version),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (maximumItems < 0 || maximumItems > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumItems',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (format.trim().isEmpty || format.length > 4000)
        validationIssues.add(
          const ActivityIssue('format', 'text', 'Use nonempty bounded text'),
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
    if (version != 1 ||
        maximumItems < 1 ||
        maximumItems > 100 ||
        !includeAttribution ||
        !{'json', 'csv', 'calendar'}.contains(format))
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
    "includeNotes": includeNotes,
    "includeCoordinates": includeCoordinates,
    "includeBookingReferences": includeBookingReferences,
    "includeAttribution": includeAttribution,
    "maximumItems": maximumItems,
    "format": format,
    "version": version,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityExportPolicy &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityExportPolicy(redacted)';
}
