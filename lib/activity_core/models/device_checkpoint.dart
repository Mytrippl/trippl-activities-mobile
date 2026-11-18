// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'activity_collection.dart';
import 'collection_item.dart';
import 'saved_activity.dart';

class ActivityDeviceCheckpoint {
  ActivityDeviceCheckpoint({
    required this.scope,
    required this.savedAt,
    required this.revision,
    List<ActivitySavedActivity> saved = const [],
    List<ActivityCollection> collections = const [],
    List<ActivityCollectionItem> items = const [],
    this.schemaVersion = 1,
  }) : saved = List.unmodifiable(saved),
       collections = List.unmodifiable(collections),
       items = List.unmodifiable(items);

  final String scope;
  final DateTime savedAt;
  final int revision;
  final List<ActivitySavedActivity> saved;
  final List<ActivityCollection> collections;
  final List<ActivityCollectionItem> items;
  final int schemaVersion;

  factory ActivityDeviceCheckpoint.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "scope",
      "savedAt",
      "revision",
      "saved",
      "collections",
      "items",
      "schemaVersion",
    });
    final value = ActivityDeviceCheckpoint(
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      savedAt: ActivityCodec.date(json, 'savedAt', required: true)!,
      revision: ActivityCodec.integer(
        json,
        'revision',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      saved:
          ActivityCodec.list(
            json,
            'saved',
            (v) => ActivitySavedActivity.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      collections:
          ActivityCodec.list(
            json,
            'collections',
            (v) => ActivityCollection.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      items:
          ActivityCodec.list(
            json,
            'items',
            (v) => ActivityCollectionItem.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
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

  static ActivityResult<ActivityDeviceCheckpoint> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityDeviceCheckpoint.fromJson(ActivityCodec.object(input)),
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

  ActivityDeviceCheckpoint copyWith({
    Set<String> clear = const {},
    String? scope,
    DateTime? savedAt,
    int? revision,
    List<ActivitySavedActivity>? saved,
    List<ActivityCollection>? collections,
    List<ActivityCollectionItem>? items,
    int? schemaVersion,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityDeviceCheckpoint(
      scope: (scope ?? this.scope),
      savedAt: (savedAt ?? this.savedAt),
      revision: (revision ?? this.revision),
      saved: (saved ?? this.saved),
      collections: (collections ?? this.collections),
      items: (items ?? this.items),
      schemaVersion: (schemaVersion ?? this.schemaVersion),
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
      if (revision < 0 || revision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'revision',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (saved.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'saved',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < saved.length; i++)
        for (final issue in saved[i].validate())
          validationIssues.add(
            ActivityIssue(
              'saved[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (collections.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'collections',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < collections.length; i++)
        for (final issue in collections[i].validate())
          validationIssues.add(
            ActivityIssue(
              'collections[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (items.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'items',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < items.length; i++)
        for (final issue in items[i].validate())
          validationIssues.add(
            ActivityIssue(
              'items[$i].${issue.field}',
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
    if (revision < 1 || schemaVersion != 1)
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
    "savedAt": savedAt.toUtc().toIso8601String(),
    "revision": revision,
    "saved": saved.map((item) => item.toJson()).toList(),
    "collections": collections.map((item) => item.toJson()).toList(),
    "items": items.map((item) => item.toJson()).toList(),
    "schemaVersion": schemaVersion,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityDeviceCheckpoint &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityDeviceCheckpoint(redacted)';
}
