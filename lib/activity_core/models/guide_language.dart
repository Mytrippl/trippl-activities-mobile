// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityGuideLanguage {
  ActivityGuideLanguage({
    required this.code,
    this.name,
    this.kind = "guide",
    this.available = true,
    this.requiresSelection = false,
    this.optionId,
  });

  final String code;
  final String? name;
  final String kind;
  final bool available;
  final bool requiresSelection;
  final String? optionId;

  factory ActivityGuideLanguage.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "code",
      "name",
      "kind",
      "available",
      "requiresSelection",
      "optionId",
    });
    final value = ActivityGuideLanguage(
      code: ActivityCodec.text(json, 'code', required: true)!,
      name: ActivityCodec.text(json, 'name'),
      kind: ActivityCodec.text(json, 'kind') ?? "guide",
      available: ActivityCodec.boolean(json, 'available') ?? true,
      requiresSelection:
          ActivityCodec.boolean(json, 'requiresSelection') ?? false,
      optionId: ActivityCodec.text(json, 'optionId'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityGuideLanguage> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityGuideLanguage.fromJson(ActivityCodec.object(input)),
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

  ActivityGuideLanguage copyWith({
    Set<String> clear = const {},
    String? code,
    String? name,
    String? kind,
    bool? available,
    bool? requiresSelection,
    String? optionId,
  }) {
    final clearableFields = <String>{"name", "optionId"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityGuideLanguage(
      code: (code ?? this.code),
      name: clear.contains('name') ? null : (name ?? this.name),
      kind: (kind ?? this.kind),
      available: (available ?? this.available),
      requiresSelection: (requiresSelection ?? this.requiresSelection),
      optionId: clear.contains('optionId') ? null : (optionId ?? this.optionId),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (code.trim().isEmpty || code.length > 4000)
        validationIssues.add(
          const ActivityIssue('code', 'text', 'Use nonempty bounded text'),
        );
    }
    if (name != null) {
      if (name!.trim().isEmpty || name!.length > 4000)
        validationIssues.add(
          const ActivityIssue('name', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    if (optionId != null) {
      if (optionId!.trim().isEmpty || optionId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (!RegExp(r'^[a-z]{2,3}(?:-[A-Za-z]{2,4})?$').hasMatch(code) ||
        !{'guide', 'audio', 'written'}.contains(kind))
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
    "code": code,
    if (name != null) "name": name,
    "kind": kind,
    "available": available,
    "requiresSelection": requiresSelection,
    if (optionId != null) "optionId": optionId,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityGuideLanguage &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityGuideLanguage(redacted)';
}
