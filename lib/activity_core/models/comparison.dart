// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'result_card.dart';

class ActivityComparison {
  ActivityComparison({
    required this.evaluatedAt,
    List<String> productIds = const [],
    List<ActivityResultCard> cards = const [],
    this.comparablePrices = false,
    this.currency,
    List<String> warningCodes = const [],
    this.revision = 1,
  }) : productIds = List.unmodifiable(productIds),
       cards = List.unmodifiable(cards),
       warningCodes = List.unmodifiable(warningCodes);

  final DateTime evaluatedAt;
  final List<String> productIds;
  final List<ActivityResultCard> cards;
  final bool comparablePrices;
  final String? currency;
  final List<String> warningCodes;
  final int revision;

  factory ActivityComparison.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "evaluatedAt",
      "productIds",
      "cards",
      "comparablePrices",
      "currency",
      "warningCodes",
      "revision",
    });
    final value = ActivityComparison(
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      productIds:
          ActivityCodec.list(json, 'productIds', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
      cards:
          ActivityCodec.list(
            json,
            'cards',
            (v) => ActivityResultCard.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      comparablePrices:
          ActivityCodec.boolean(json, 'comparablePrices') ?? false,
      currency: ActivityCodec.text(json, 'currency'),
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
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

  static ActivityResult<ActivityComparison> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityComparison.fromJson(ActivityCodec.object(input)),
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

  ActivityComparison copyWith({
    Set<String> clear = const {},
    DateTime? evaluatedAt,
    List<String>? productIds,
    List<ActivityResultCard>? cards,
    bool? comparablePrices,
    String? currency,
    List<String>? warningCodes,
    int? revision,
  }) {
    final clearableFields = <String>{"currency"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityComparison(
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      productIds: (productIds ?? this.productIds),
      cards: (cards ?? this.cards),
      comparablePrices: (comparablePrices ?? this.comparablePrices),
      currency: clear.contains('currency') ? null : (currency ?? this.currency),
      warningCodes: (warningCodes ?? this.warningCodes),
      revision: (revision ?? this.revision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (productIds.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'productIds',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (productIds.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'productIds',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    {
      if (cards.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'cards',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < cards.length; i++)
        for (final issue in cards[i].validate())
          validationIssues.add(
            ActivityIssue(
              'cards[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (currency != null) {
      if (currency!.trim().isEmpty || currency!.length > 4000)
        validationIssues.add(
          const ActivityIssue('currency', 'text', 'Use nonempty bounded text'),
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
        productIds.length > 4 ||
        productIds.toSet().length != productIds.length ||
        cards.length != productIds.length)
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
    "productIds": productIds,
    "cards": cards.map((item) => item.toJson()).toList(),
    "comparablePrices": comparablePrices,
    if (currency != null) "currency": currency,
    "warningCodes": warningCodes,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityComparison &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityComparison(redacted)';
}
