// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityPriceRule {
  ActivityPriceRule({
    required this.id,
    required this.money,
    this.basis = "perPerson",
    this.category,
    this.minimumTravelers = 1,
    this.maximumTravelers = 100,
    this.minimumUnits = 1,
    this.maximumUnits,
    this.priority = 0,
  });

  final String id;
  final ActivityMoney money;
  final String basis;
  final String? category;
  final int minimumTravelers;
  final int maximumTravelers;
  final int minimumUnits;
  final int? maximumUnits;
  final int priority;

  factory ActivityPriceRule.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "money",
      "basis",
      "category",
      "minimumTravelers",
      "maximumTravelers",
      "minimumUnits",
      "maximumUnits",
      "priority",
    });
    final value = ActivityPriceRule(
      id: ActivityCodec.text(json, 'id', required: true)!,
      money: (json['money'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['money'])))!,
      basis: ActivityCodec.text(json, 'basis') ?? "perPerson",
      category: ActivityCodec.text(json, 'category'),
      minimumTravelers:
          ActivityCodec.integer(
            json,
            'minimumTravelers',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      maximumTravelers:
          ActivityCodec.integer(
            json,
            'maximumTravelers',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          100,
      minimumUnits:
          ActivityCodec.integer(
            json,
            'minimumUnits',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      maximumUnits: ActivityCodec.integer(
        json,
        'maximumUnits',
        minimum: 0,
        maximum: 9000000000000,
      ),
      priority:
          ActivityCodec.integer(
            json,
            'priority',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityPriceRule> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPriceRule.fromJson(ActivityCodec.object(input)),
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

  ActivityPriceRule copyWith({
    Set<String> clear = const {},
    String? id,
    ActivityMoney? money,
    String? basis,
    String? category,
    int? minimumTravelers,
    int? maximumTravelers,
    int? minimumUnits,
    int? maximumUnits,
    int? priority,
  }) {
    final clearableFields = <String>{"category", "maximumUnits"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPriceRule(
      id: (id ?? this.id),
      money: (money ?? this.money),
      basis: (basis ?? this.basis),
      category: clear.contains('category') ? null : (category ?? this.category),
      minimumTravelers: (minimumTravelers ?? this.minimumTravelers),
      maximumTravelers: (maximumTravelers ?? this.maximumTravelers),
      minimumUnits: (minimumUnits ?? this.minimumUnits),
      maximumUnits: clear.contains('maximumUnits')
          ? null
          : (maximumUnits ?? this.maximumUnits),
      priority: (priority ?? this.priority),
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
      for (final issue in money.validate())
        validationIssues.add(
          ActivityIssue(
            'money.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (basis.trim().isEmpty || basis.length > 4000)
        validationIssues.add(
          const ActivityIssue('basis', 'text', 'Use nonempty bounded text'),
        );
    }
    if (category != null) {
      if (category!.trim().isEmpty || category!.length > 4000)
        validationIssues.add(
          const ActivityIssue('category', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (minimumTravelers < 0 || minimumTravelers > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'minimumTravelers',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (maximumTravelers < 0 || maximumTravelers > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumTravelers',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (minimumUnits < 0 || minimumUnits > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'minimumUnits',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (maximumUnits != null) {
      if (maximumUnits! < 0 || maximumUnits! > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'maximumUnits',
            'range',
            'Number is outside the activity limits',
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
    if (!{'perPerson', 'perGroup', 'perUnit'}.contains(basis) ||
        minimumTravelers < 1 ||
        maximumTravelers > 100 ||
        minimumTravelers > maximumTravelers ||
        minimumUnits < 1 ||
        minimumUnits > 100 ||
        maximumUnits != null &&
            (maximumUnits! > 100 || maximumUnits! < minimumUnits) ||
        priority > 1000)
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
    "money": money.toJson(),
    "basis": basis,
    if (category != null) "category": category,
    "minimumTravelers": minimumTravelers,
    "maximumTravelers": maximumTravelers,
    "minimumUnits": minimumUnits,
    if (maximumUnits != null) "maximumUnits": maximumUnits,
    "priority": priority,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPriceRule &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPriceRule(redacted)';
}
