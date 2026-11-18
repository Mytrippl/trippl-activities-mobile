// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';
import 'price_component.dart';

class ActivityPriceBreakdown {
  ActivityPriceBreakdown({
    required this.evaluatedAt,
    required this.total,
    List<ActivityPriceComponent> components = const [],
    required this.travelerCount,
    this.basis = "unknown",
    this.complete = false,
    List<String> warningCodes = const [],
  }) : components = List.unmodifiable(components),
       warningCodes = List.unmodifiable(warningCodes);

  final DateTime evaluatedAt;
  final ActivityMoney total;
  final List<ActivityPriceComponent> components;
  final int travelerCount;
  final String basis;
  final bool complete;
  final List<String> warningCodes;

  factory ActivityPriceBreakdown.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "evaluatedAt",
      "total",
      "components",
      "travelerCount",
      "basis",
      "complete",
      "warningCodes",
    });
    final value = ActivityPriceBreakdown(
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      total: (json['total'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['total'])))!,
      components:
          ActivityCodec.list(
            json,
            'components',
            (v) => ActivityPriceComponent.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      travelerCount: ActivityCodec.integer(
        json,
        'travelerCount',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      basis: ActivityCodec.text(json, 'basis') ?? "unknown",
      complete: ActivityCodec.boolean(json, 'complete') ?? false,
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

  static ActivityResult<ActivityPriceBreakdown> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityPriceBreakdown.fromJson(ActivityCodec.object(input)),
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

  ActivityPriceBreakdown copyWith({
    Set<String> clear = const {},
    DateTime? evaluatedAt,
    ActivityMoney? total,
    List<ActivityPriceComponent>? components,
    int? travelerCount,
    String? basis,
    bool? complete,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityPriceBreakdown(
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      total: (total ?? this.total),
      components: (components ?? this.components),
      travelerCount: (travelerCount ?? this.travelerCount),
      basis: (basis ?? this.basis),
      complete: (complete ?? this.complete),
      warningCodes: (warningCodes ?? this.warningCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      for (final issue in total.validate())
        validationIssues.add(
          ActivityIssue(
            'total.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (components.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'components',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < components.length; i++)
        for (final issue in components[i].validate())
          validationIssues.add(
            ActivityIssue(
              'components[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (travelerCount < 0 || travelerCount > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'travelerCount',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (basis.trim().isEmpty || basis.length > 4000)
        validationIssues.add(
          const ActivityIssue('basis', 'text', 'Use nonempty bounded text'),
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
    if (travelerCount < 1 ||
        travelerCount > 100 ||
        !{'perPerson', 'perGroup', 'perUnit', 'unknown'}.contains(basis))
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
    "total": total.toJson(),
    "components": components.map((item) => item.toJson()).toList(),
    "travelerCount": travelerCount,
    "basis": basis,
    "complete": complete,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityPriceBreakdown &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityPriceBreakdown(redacted)';
}
