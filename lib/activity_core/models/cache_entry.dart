// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'provider_page.dart';

class ActivityCacheEntry {
  ActivityCacheEntry({
    required this.scopeFingerprint,
    required this.requestFingerprint,
    required this.savedAt,
    required this.expiresAt,
    required this.page,
    this.offline = false,
    this.schemaVersion = 1,
  });

  final String scopeFingerprint;
  final String requestFingerprint;
  final DateTime savedAt;
  final DateTime expiresAt;
  final ActivityProviderPage page;
  final bool offline;
  final int schemaVersion;

  factory ActivityCacheEntry.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "scopeFingerprint",
      "requestFingerprint",
      "savedAt",
      "expiresAt",
      "page",
      "offline",
      "schemaVersion",
    });
    final value = ActivityCacheEntry(
      scopeFingerprint: ActivityCodec.text(
        json,
        'scopeFingerprint',
        required: true,
      )!,
      requestFingerprint: ActivityCodec.text(
        json,
        'requestFingerprint',
        required: true,
      )!,
      savedAt: ActivityCodec.date(json, 'savedAt', required: true)!,
      expiresAt: ActivityCodec.date(json, 'expiresAt', required: true)!,
      page: (json['page'] == null
          ? null
          : ActivityProviderPage.fromJson(ActivityCodec.object(json['page'])))!,
      offline: ActivityCodec.boolean(json, 'offline') ?? false,
      schemaVersion:
          ActivityCodec.integer(
            json,
            'schemaVersion',
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

  static ActivityResult<ActivityCacheEntry> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityCacheEntry.fromJson(ActivityCodec.object(input)),
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

  ActivityCacheEntry copyWith({
    Set<String> clear = const {},
    String? scopeFingerprint,
    String? requestFingerprint,
    DateTime? savedAt,
    DateTime? expiresAt,
    ActivityProviderPage? page,
    bool? offline,
    int? schemaVersion,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCacheEntry(
      scopeFingerprint: (scopeFingerprint ?? this.scopeFingerprint),
      requestFingerprint: (requestFingerprint ?? this.requestFingerprint),
      savedAt: (savedAt ?? this.savedAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      page: (page ?? this.page),
      offline: (offline ?? this.offline),
      schemaVersion: (schemaVersion ?? this.schemaVersion),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (scopeFingerprint.trim().isEmpty || scopeFingerprint.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'scopeFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (requestFingerprint.trim().isEmpty || requestFingerprint.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'requestFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      for (final issue in page.validate())
        validationIssues.add(
          ActivityIssue(
            'page.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (schemaVersion < 0 || schemaVersion > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'schemaVersion',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (schemaVersion != 1 ||
        !expiresAt.isAfter(savedAt) ||
        requestFingerprint != page.requestFingerprint ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(scopeFingerprint))
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
    "scopeFingerprint": scopeFingerprint,
    "requestFingerprint": requestFingerprint,
    "savedAt": savedAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "page": page.toJson(),
    "offline": offline,
    "schemaVersion": schemaVersion,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCacheEntry &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCacheEntry(redacted)';
}
