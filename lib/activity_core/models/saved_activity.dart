// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'product.dart';

class ActivitySavedActivity {
  ActivitySavedActivity({
    required this.id,
    required this.scope,
    required this.product,
    required this.savedAt,
    required this.updatedAt,
    this.priority = 0,
    this.revision = 1,
    this.note,
  });

  final String id;
  final String scope;
  final ActivityProduct product;
  final DateTime savedAt;
  final DateTime updatedAt;
  final int priority;
  final int revision;
  final String? note;

  factory ActivitySavedActivity.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "product",
      "savedAt",
      "updatedAt",
      "priority",
      "revision",
      "note",
    });
    final value = ActivitySavedActivity(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      product: (json['product'] == null
          ? null
          : ActivityProduct.fromJson(ActivityCodec.object(json['product'])))!,
      savedAt: ActivityCodec.date(json, 'savedAt', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      priority:
          ActivityCodec.integer(
            json,
            'priority',
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
      note: ActivityCodec.text(json, 'note'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySavedActivity> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySavedActivity.fromJson(ActivityCodec.object(input)),
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

  ActivitySavedActivity copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    ActivityProduct? product,
    DateTime? savedAt,
    DateTime? updatedAt,
    int? priority,
    int? revision,
    String? note,
  }) {
    final clearableFields = <String>{"note"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySavedActivity(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      product: (product ?? this.product),
      savedAt: (savedAt ?? this.savedAt),
      updatedAt: (updatedAt ?? this.updatedAt),
      priority: (priority ?? this.priority),
      revision: (revision ?? this.revision),
      note: clear.contains('note') ? null : (note ?? this.note),
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
      for (final issue in product.validate())
        validationIssues.add(
          ActivityIssue(
            'product.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (priority < 0 || priority > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'priority',
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
    if (note != null) {
      if (note!.trim().isEmpty || note!.length > 4000)
        validationIssues.add(
          const ActivityIssue('note', 'text', 'Use nonempty bounded text'),
        );
    }
    if (revision < 1 ||
        priority > 5 ||
        updatedAt.isBefore(savedAt) ||
        note != null && note!.length > 2000)
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
    "product": product.toJson(),
    "savedAt": savedAt.toUtc().toIso8601String(),
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "priority": priority,
    "revision": revision,
    if (note != null) "note": note,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySavedActivity &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySavedActivity(redacted)';
}
