// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityQuoteChange {
  ActivityQuoteChange({
    required this.draftId,
    required this.evaluatedAt,
    required this.oldTotal,
    required this.newTotal,
    this.amountChanged = false,
    this.currencyChanged = false,
    this.selectionChanged = false,
    this.requiresAcceptance = true,
    List<String> reasonCodes = const [],
  }) : reasonCodes = List.unmodifiable(reasonCodes);

  final String draftId;
  final DateTime evaluatedAt;
  final ActivityMoney oldTotal;
  final ActivityMoney newTotal;
  final bool amountChanged;
  final bool currencyChanged;
  final bool selectionChanged;
  final bool requiresAcceptance;
  final List<String> reasonCodes;

  factory ActivityQuoteChange.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "draftId",
      "evaluatedAt",
      "oldTotal",
      "newTotal",
      "amountChanged",
      "currencyChanged",
      "selectionChanged",
      "requiresAcceptance",
      "reasonCodes",
    });
    final value = ActivityQuoteChange(
      draftId: ActivityCodec.text(json, 'draftId', required: true)!,
      evaluatedAt: ActivityCodec.date(json, 'evaluatedAt', required: true)!,
      oldTotal: (json['oldTotal'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['oldTotal'])))!,
      newTotal: (json['newTotal'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['newTotal'])))!,
      amountChanged: ActivityCodec.boolean(json, 'amountChanged') ?? false,
      currencyChanged: ActivityCodec.boolean(json, 'currencyChanged') ?? false,
      selectionChanged:
          ActivityCodec.boolean(json, 'selectionChanged') ?? false,
      requiresAcceptance:
          ActivityCodec.boolean(json, 'requiresAcceptance') ?? true,
      reasonCodes:
          ActivityCodec.list(json, 'reasonCodes', (v) {
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

  static ActivityResult<ActivityQuoteChange> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityQuoteChange.fromJson(ActivityCodec.object(input)),
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

  ActivityQuoteChange copyWith({
    Set<String> clear = const {},
    String? draftId,
    DateTime? evaluatedAt,
    ActivityMoney? oldTotal,
    ActivityMoney? newTotal,
    bool? amountChanged,
    bool? currencyChanged,
    bool? selectionChanged,
    bool? requiresAcceptance,
    List<String>? reasonCodes,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityQuoteChange(
      draftId: (draftId ?? this.draftId),
      evaluatedAt: (evaluatedAt ?? this.evaluatedAt),
      oldTotal: (oldTotal ?? this.oldTotal),
      newTotal: (newTotal ?? this.newTotal),
      amountChanged: (amountChanged ?? this.amountChanged),
      currencyChanged: (currencyChanged ?? this.currencyChanged),
      selectionChanged: (selectionChanged ?? this.selectionChanged),
      requiresAcceptance: (requiresAcceptance ?? this.requiresAcceptance),
      reasonCodes: (reasonCodes ?? this.reasonCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (draftId.trim().isEmpty || draftId.length > 4000)
        validationIssues.add(
          const ActivityIssue('draftId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in oldTotal.validate())
        validationIssues.add(
          ActivityIssue(
            'oldTotal.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      for (final issue in newTotal.validate())
        validationIssues.add(
          ActivityIssue(
            'newTotal.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (reasonCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (reasonCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'reasonCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "draftId": draftId,
    "evaluatedAt": evaluatedAt.toUtc().toIso8601String(),
    "oldTotal": oldTotal.toJson(),
    "newTotal": newTotal.toJson(),
    "amountChanged": amountChanged,
    "currencyChanged": currencyChanged,
    "selectionChanged": selectionChanged,
    "requiresAcceptance": requiresAcceptance,
    "reasonCodes": reasonCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityQuoteChange &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityQuoteChange(redacted)';
}
