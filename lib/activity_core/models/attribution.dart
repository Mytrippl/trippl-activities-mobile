// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityAttribution {
  ActivityAttribution({
    required this.id,
    required this.displayName,
    this.uri,
    this.kind = "provider",
    this.required = true,
    this.license,
    this.observedAt,
  });

  final String id;
  final String displayName;
  final String? uri;
  final String kind;
  final bool required;
  final String? license;
  final DateTime? observedAt;

  factory ActivityAttribution.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "displayName",
      "uri",
      "kind",
      "required",
      "license",
      "observedAt",
    });
    final value = ActivityAttribution(
      id: ActivityCodec.text(json, 'id', required: true)!,
      displayName: ActivityCodec.text(json, 'displayName', required: true)!,
      uri: ActivityCodec.text(json, 'uri'),
      kind: ActivityCodec.text(json, 'kind') ?? "provider",
      required: ActivityCodec.boolean(json, 'required') ?? true,
      license: ActivityCodec.text(json, 'license'),
      observedAt: ActivityCodec.date(json, 'observedAt'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityAttribution> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAttribution.fromJson(ActivityCodec.object(input)),
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

  ActivityAttribution copyWith({
    Set<String> clear = const {},
    String? id,
    String? displayName,
    String? uri,
    String? kind,
    bool? required,
    String? license,
    DateTime? observedAt,
  }) {
    final clearableFields = <String>{"uri", "license", "observedAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAttribution(
      id: (id ?? this.id),
      displayName: (displayName ?? this.displayName),
      uri: clear.contains('uri') ? null : (uri ?? this.uri),
      kind: (kind ?? this.kind),
      required: (required ?? this.required),
      license: clear.contains('license') ? null : (license ?? this.license),
      observedAt: clear.contains('observedAt')
          ? null
          : (observedAt ?? this.observedAt),
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
      if (displayName.trim().isEmpty || displayName.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'displayName',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (uri != null) {
      if (uri!.trim().isEmpty || uri!.length > 4000)
        validationIssues.add(
          const ActivityIssue('uri', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    if (license != null) {
      if (license!.trim().isEmpty || license!.length > 4000)
        validationIssues.add(
          const ActivityIssue('license', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!{'provider', 'photo', 'review', 'author', 'license'}.contains(kind) ||
        uri != null &&
            (Uri.tryParse(uri!)?.scheme != 'https' ||
                Uri.tryParse(uri!)!.host.isEmpty ||
                Uri.tryParse(uri!)!.userInfo.isNotEmpty))
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
    "displayName": displayName,
    if (uri != null) "uri": uri,
    "kind": kind,
    "required": required,
    if (license != null) "license": license,
    if (observedAt != null) "observedAt": observedAt!.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAttribution &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAttribution(redacted)';
}
