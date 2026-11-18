// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityPreference {
  ActivityPreference({
    required this.scope,
    required this.updatedAt,
    this.language = "en",
    this.currency = "USD",
    this.hideSaved = false,
    this.offlineEnabled = false,
    this.sortField = "recommended",
    this.revision = 1,
  });

  final String scope;
  final DateTime updatedAt;
  final String language;
  final String currency;
  final bool hideSaved;
  final bool offlineEnabled;
  final String sortField;
  final int revision;

  factory ActivityPreference.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "scope",
      "updatedAt",
      "language",
      "currency",
      "hideSaved",
      "offlineEnabled",
      "sortField",
      "revision",
    });
    final value = ActivityPreference(
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      language: ActivityCodec.text(json, 'language') ?? "en",
      currency: ActivityCodec.text(json, 'currency') ?? "USD",
      hideSaved: ActivityCodec.boolean(json, 'hideSaved') ?? false,
      offlineEnabled: ActivityCodec.boolean(json, 'offlineEnabled') ?? false,
      sortField: ActivityCodec.text(json, 'sortField') ?? "recommended",
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

  static ActivityResult<ActivityPreference> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPreference.fromJson(ActivityCodec.object(input)),
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

  ActivityPreference copyWith({
    Set<String> clear = const {},
    String? scope,
    DateTime? updatedAt,
    String? language,
    String? currency,
    bool? hideSaved,
    bool? offlineEnabled,
    String? sortField,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPreference(
      scope: (scope ?? this.scope),
      updatedAt: (updatedAt ?? this.updatedAt),
      language: (language ?? this.language),
      currency: (currency ?? this.currency),
      hideSaved: (hideSaved ?? this.hideSaved),
      offlineEnabled: (offlineEnabled ?? this.offlineEnabled),
      sortField: (sortField ?? this.sortField),
      revision: (revision ?? this.revision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (language.trim().isEmpty || language.length > 4000)
        validationIssues.add(
          const ActivityIssue('language', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (currency.trim().isEmpty || currency.length > 4000)
        validationIssues.add(
          const ActivityIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (sortField.trim().isEmpty || sortField.length > 4000)
        validationIssues.add(
          const ActivityIssue('sortField', 'text', 'Use nonempty bounded text'),
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
        !RegExp(r'^[A-Z]{3}$').hasMatch(currency) ||
        !{
          'recommended',
          'price',
          'rating',
          'duration',
          'distance',
          'title',
          'reviewCount',
        }.contains(sortField))
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
    "scope": scope,
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "language": language,
    "currency": currency,
    "hideSaved": hideSaved,
    "offlineEnabled": offlineEnabled,
    "sortField": sortField,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPreference &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPreference(redacted)';
}
