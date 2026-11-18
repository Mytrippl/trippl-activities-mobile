// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityCollectionItem {
  ActivityCollectionItem({
    required this.id,
    required this.collectionId,
    required this.savedActivityId,
    required this.addedAt,
    this.position = 0,
    this.revision = 1,
  });

  final String id;
  final String collectionId;
  final String savedActivityId;
  final DateTime addedAt;
  final int position;
  final int revision;

  factory ActivityCollectionItem.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "collectionId",
      "savedActivityId",
      "addedAt",
      "position",
      "revision",
    });
    final value = ActivityCollectionItem(
      id: ActivityCodec.text(json, 'id', required: true)!,
      collectionId: ActivityCodec.text(json, 'collectionId', required: true)!,
      savedActivityId: ActivityCodec.text(
        json,
        'savedActivityId',
        required: true,
      )!,
      addedAt: ActivityCodec.date(json, 'addedAt', required: true)!,
      position:
          ActivityCodec.integer(
            json,
            'position',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
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

  static ActivityResult<ActivityCollectionItem> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityCollectionItem.fromJson(ActivityCodec.object(input)),
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

  ActivityCollectionItem copyWith({
    Set<String> clear = const {},
    String? id,
    String? collectionId,
    String? savedActivityId,
    DateTime? addedAt,
    int? position,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCollectionItem(
      id: (id ?? this.id),
      collectionId: (collectionId ?? this.collectionId),
      savedActivityId: (savedActivityId ?? this.savedActivityId),
      addedAt: (addedAt ?? this.addedAt),
      position: (position ?? this.position),
      revision: (revision ?? this.revision),
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
      if (collectionId.trim().isEmpty || collectionId.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'collectionId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (savedActivityId.trim().isEmpty || savedActivityId.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'savedActivityId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (position < 0 || position > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'position',
            'range',
            'Number is outside the activity limits',
          ),
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
    if (revision < 1 || position > 100)
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
    "collectionId": collectionId,
    "savedActivityId": savedActivityId,
    "addedAt": addedAt.toUtc().toIso8601String(),
    "position": position,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCollectionItem &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCollectionItem(redacted)';
}
