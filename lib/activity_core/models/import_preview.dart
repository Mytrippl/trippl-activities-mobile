// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'product.dart';

class ActivityImportPreview {
  ActivityImportPreview({
    required this.id,
    required this.evaluatedAt,
    required this.sourceDigest,
    List<ActivityProduct> products = const [],
    List<String> duplicateIds = const [],
    this.rejectedCount = 0,
    List<String> warningCodes = const [],
    this.requiresConfirmation = true,
  }) : products = List.unmodifiable(products),
       duplicateIds = List.unmodifiable(duplicateIds),
       warningCodes = List.unmodifiable(warningCodes);

  final String id;
  final DateTime evaluatedAt;
  final String sourceDigest;
  final List<ActivityProduct> products;
  final List<String> duplicateIds;
  final int rejectedCount;
  final List<String> warningCodes;
  final bool requiresConfirmation;

  factory ActivityImportPreview.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "evaluatedAt",
      "sourceDigest",
      "products",
      "duplicateIds",
      "rejectedCount",
      "warningCodes",
      "requiresConfirmation",
    });
    final value = ActivityImportPreview(
      id: ActivityCodec.text(json, 'id', required: true)!,
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      sourceDigest: ActivityCodec.text(json, 'sourceDigest', required: true)!,
      products:
          ActivityCodec.list(
            json,
            'products',
            (v) => ActivityProduct.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      duplicateIds:
          ActivityCodec.list(json, 'duplicateIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      rejectedCount:
          ActivityCodec.integer(
            json,
            'rejectedCount',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      requiresConfirmation:
          ActivityCodec.boolean(json, 'requiresConfirmation') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityImportPreview> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityImportPreview.fromJson(ActivityCodec.object(input)),
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

  ActivityImportPreview copyWith({
    Set<String> clear = const {},
    String? id,
    DateTime? evaluatedAt,
    String? sourceDigest,
    List<ActivityProduct>? products,
    List<String>? duplicateIds,
    int? rejectedCount,
    List<String>? warningCodes,
    bool? requiresConfirmation,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityImportPreview(
      id: (id ?? this.id),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      sourceDigest: (sourceDigest ?? this.sourceDigest),
      products: (products ?? this.products),
      duplicateIds: (duplicateIds ?? this.duplicateIds),
      rejectedCount: (rejectedCount ?? this.rejectedCount),
      warningCodes: (warningCodes ?? this.warningCodes),
      requiresConfirmation: (requiresConfirmation ?? this.requiresConfirmation),
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
      if (sourceDigest.trim().isEmpty || sourceDigest.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'sourceDigest',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (products.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'products',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < products.length; i++)
        for (final issue in products[i].validate())
          validationIssues.add(
            ActivityIssue(
              'products[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (duplicateIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'duplicateIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (duplicateIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'duplicateIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (rejectedCount < 0 || rejectedCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'rejectedCount',
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
    if (rejectedCount > 100 ||
        products.map((p) => p.id).toSet().length != products.length ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(sourceDigest))
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
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "sourceDigest": sourceDigest,
    "products": products.map((item) => item.toJson()).toList(),
    "duplicateIds": duplicateIds,
    "rejectedCount": rejectedCount,
    "warningCodes": warningCodes,
    "requiresConfirmation": requiresConfirmation,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityImportPreview &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityImportPreview(redacted)';
}
