// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'product.dart';

class ActivitySearchResult {
  ActivitySearchResult({
    required this.evaluatedAt,
    required this.resultFingerprint,
    required this.matchedCount,
    List<ActivityProduct> products = const [],
    this.offset = 0,
    this.limit = 20,
    this.hasMore = false,
    this.incomplete = true,
    List<String> warningCodes = const [],
  }) : products = List.unmodifiable(products),
       warningCodes = List.unmodifiable(warningCodes);

  final DateTime evaluatedAt;
  final String resultFingerprint;
  final int matchedCount;
  final List<ActivityProduct> products;
  final int offset;
  final int limit;
  final bool hasMore;
  final bool incomplete;
  final List<String> warningCodes;

  factory ActivitySearchResult.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "evaluatedAt",
      "resultFingerprint",
      "matchedCount",
      "products",
      "offset",
      "limit",
      "hasMore",
      "incomplete",
      "warningCodes",
    });
    final value = ActivitySearchResult(
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      resultFingerprint: ActivityCodec.text(
        json,
        'resultFingerprint',
        required: true,
      )!,
      matchedCount: ActivityCodec.integer(
        json,
        'matchedCount',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      products:
          ActivityCodec.list(
            json,
            'products',
            (v) => ActivityProduct.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      offset:
          ActivityCodec.integer(
            json,
            'offset',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      limit:
          ActivityCodec.integer(
            json,
            'limit',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          20,
      hasMore: ActivityCodec.boolean(json, 'hasMore') ?? false,
      incomplete: ActivityCodec.boolean(json, 'incomplete') ?? true,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySearchResult> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySearchResult.fromJson(ActivityCodec.object(input)),
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

  ActivitySearchResult copyWith({
    Set<String> clear = const {},
    DateTime? evaluatedAt,
    String? resultFingerprint,
    int? matchedCount,
    List<ActivityProduct>? products,
    int? offset,
    int? limit,
    bool? hasMore,
    bool? incomplete,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySearchResult(
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      resultFingerprint: (resultFingerprint ?? this.resultFingerprint),
      matchedCount: (matchedCount ?? this.matchedCount),
      products: (products ?? this.products),
      offset: (offset ?? this.offset),
      limit: (limit ?? this.limit),
      hasMore: (hasMore ?? this.hasMore),
      incomplete: (incomplete ?? this.incomplete),
      warningCodes: (warningCodes ?? this.warningCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (resultFingerprint.trim().isEmpty || resultFingerprint.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'resultFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (matchedCount < 0 || matchedCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'matchedCount',
            'range',
            'Number is outside the activity limits',
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
      if (offset < 0 || offset > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'offset',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (limit < 0 || limit > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'limit',
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
    if (limit < 1 ||
        limit > 100 ||
        offset > 10000 ||
        products.length > limit ||
        matchedCount < products.length ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(resultFingerprint))
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
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "resultFingerprint": resultFingerprint,
    "matchedCount": matchedCount,
    "products": products.map((item) => item.toJson()).toList(),
    "offset": offset,
    "limit": limit,
    "hasMore": hasMore,
    "incomplete": incomplete,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySearchResult &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySearchResult(redacted)';
}
