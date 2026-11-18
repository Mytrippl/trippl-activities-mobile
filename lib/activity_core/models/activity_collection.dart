// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityCollection {
  ActivityCollection({
    required this.id,
    required this.scope,
    required this.title,
    required this.createdAt,
    required this.updatedAt,
    List<String> itemIds = const [],
    this.archived = false,
    this.revision = 1,
    this.description,
  }) : itemIds = List.unmodifiable(itemIds);

  final String id;
  final String scope;
  final String title;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<String> itemIds;
  final bool archived;
  final int revision;
  final String? description;

  factory ActivityCollection.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "title",
      "createdAt",
      "updatedAt",
      "itemIds",
      "archived",
      "revision",
      "description",
    });
    final value = ActivityCollection(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      title: ActivityCodec.text(json, 'title', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      itemIds:
          ActivityCodec.list(json, 'itemIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      archived: ActivityCodec.boolean(json, 'archived') ?? false,
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      description: ActivityCodec.text(json, 'description'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityCollection> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityCollection.fromJson(ActivityCodec.object(input)),
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

  ActivityCollection copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? title,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<String>? itemIds,
    bool? archived,
    int? revision,
    String? description,
  }) {
    final clearableFields = <String>{"description"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityCollection(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      title: (title ?? this.title),
      createdAt: (createdAt ?? this.createdAt),
      updatedAt: (updatedAt ?? this.updatedAt),
      itemIds: (itemIds ?? this.itemIds),
      archived: (archived ?? this.archived),
      revision: (revision ?? this.revision),
      description: clear.contains('description')
          ? null
          : (description ?? this.description),
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
      if (title.trim().isEmpty || title.length > 4000)
        validationIssues.add(
          const ActivityIssue('title', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (itemIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'itemIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (itemIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'itemIds',
            'text',
            'Use bounded nonempty list text',
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
    if (revision < 1 ||
        updatedAt.isBefore(createdAt) ||
        itemIds.toSet().length != itemIds.length)
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
    "title": title,
    "createdAt": createdAt.toUtc().toIso8601String(),
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "itemIds": itemIds,
    "archived": archived,
    "revision": revision,
    if (description != null) "description": description,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityCollection &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityCollection(redacted)';
}
