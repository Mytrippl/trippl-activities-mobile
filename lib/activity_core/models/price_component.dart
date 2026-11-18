// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityPriceComponent {
  ActivityPriceComponent({
    required this.id,
    required this.label,
    required this.unit,
    this.quantity = 1,
    this.kind = "base",
    this.category,
    this.included = true,
  });

  final String id;
  final String label;
  final ActivityMoney unit;
  final int quantity;
  final String kind;
  final String? category;
  final bool included;

  factory ActivityPriceComponent.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "label",
      "unit",
      "quantity",
      "kind",
      "category",
      "included",
    });
    final value = ActivityPriceComponent(
      id: ActivityCodec.text(json, 'id', required: true)!,
      label: ActivityCodec.text(json, 'label', required: true)!,
      unit: (json['unit'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['unit'])))!,
      quantity:
          ActivityCodec.integer(
            json,
            'quantity',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      kind: ActivityCodec.text(json, 'kind') ?? "base",
      category: ActivityCodec.text(json, 'category'),
      included: ActivityCodec.boolean(json, 'included') ?? true,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityPriceComponent> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPriceComponent.fromJson(ActivityCodec.object(input)),
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

  ActivityPriceComponent copyWith({
    Set<String> clear = const {},
    String? id,
    String? label,
    ActivityMoney? unit,
    int? quantity,
    String? kind,
    String? category,
    bool? included,
  }) {
    final clearableFields = <String>{"category"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPriceComponent(
      id: (id ?? this.id),
      label: (label ?? this.label),
      unit: (unit ?? this.unit),
      quantity: (quantity ?? this.quantity),
      kind: (kind ?? this.kind),
      category: clear.contains('category') ? null : (category ?? this.category),
      included: (included ?? this.included),
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
      if (label.trim().isEmpty || label.length > 4000)
        validationIssues.add(
          const ActivityIssue('label', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in unit.validate())
        validationIssues.add(
          ActivityIssue(
            'unit.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (quantity < 0 || quantity > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'quantity',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (kind.trim().isEmpty || kind.length > 4000)
        validationIssues.add(
          const ActivityIssue('kind', 'text', 'Use nonempty bounded text'),
        );
    }
    if (category != null) {
      if (category!.trim().isEmpty || category!.length > 4000)
        validationIssues.add(
          const ActivityIssue('category', 'text', 'Use nonempty bounded text'),
        );
    }
    if (quantity < 1 ||
        quantity > 100 ||
        !{'base', 'tax', 'fee', 'discount'}.contains(kind))
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
    "label": label,
    "unit": unit.toJson(),
    "quantity": quantity,
    "kind": kind,
    if (category != null) "category": category,
    "included": included,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPriceComponent &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPriceComponent(redacted)';
}
