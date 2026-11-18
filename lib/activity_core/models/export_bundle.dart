// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityExportBundle {
  ActivityExportBundle({
    required this.id,
    required this.scope,
    required this.createdAt,
    required this.format,
    required this.content,
    required this.digest,
    required this.itemCount,
    List<String> warningCodes = const [],
    this.schemaVersion = 1,
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String id;
  final String scope;
  final DateTime createdAt;
  final String format;
  final String content;
  final String digest;
  final int itemCount;
  final List<String> warningCodes;
  final int schemaVersion;

  factory ActivityExportBundle.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "createdAt",
      "format",
      "content",
      "digest",
      "itemCount",
      "warningCodes",
      "schemaVersion",
    });
    final value = ActivityExportBundle(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      format: ActivityCodec.text(json, 'format', required: true)!,
      content: ActivityCodec.text(
        json,
        'content',
        required: true,
        maximum: 100000,
      )!,
      digest: ActivityCodec.text(json, 'digest', required: true)!,
      itemCount: ActivityCodec.integer(
        json,
        'itemCount',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
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

  static ActivityResult<ActivityExportBundle> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityExportBundle.fromJson(ActivityCodec.object(input)),
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

  ActivityExportBundle copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    DateTime? createdAt,
    String? format,
    String? content,
    String? digest,
    int? itemCount,
    List<String>? warningCodes,
    int? schemaVersion,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityExportBundle(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      createdAt: (createdAt ?? this.createdAt),
      format: (format ?? this.format),
      content: (content ?? this.content),
      digest: (digest ?? this.digest),
      itemCount: (itemCount ?? this.itemCount),
      warningCodes: (warningCodes ?? this.warningCodes),
      schemaVersion: (schemaVersion ?? this.schemaVersion),
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
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (format.trim().isEmpty || format.length > 4000)
        validationIssues.add(
          const ActivityIssue('format', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (content.trim().isEmpty || content.length > 100000)
        validationIssues.add(
          const ActivityIssue('content', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (digest.trim().isEmpty || digest.length > 4000)
        validationIssues.add(
          const ActivityIssue('digest', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (itemCount < 0 || itemCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'itemCount',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (warningCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (warningCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'text',
            'Use bounded nonempty list text',
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
        itemCount > 100 ||
        !{'json', 'csv', 'calendar'}.contains(format) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(digest))
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
    "scope": scope,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "format": format,
    "content": content,
    "digest": digest,
    "itemCount": itemCount,
    "warningCodes": warningCodes,
    "schemaVersion": schemaVersion,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityExportBundle &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityExportBundle(redacted)';
}
