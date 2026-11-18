// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';

class ActivityMoney {
  ActivityMoney({
    required this.currency,
    required this.amountMinor,
    this.decimals = 2,
  });

  final String currency;
  final int amountMinor;
  final int decimals;

  factory ActivityMoney.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {"currency", "amountMinor", "decimals"});
    final value = ActivityMoney(
      currency: ActivityCodec.text(json, 'currency', required: true)!,
      amountMinor: ActivityCodec.integer(
        json,
        'amountMinor',
        required: true,
        minimum: 0,
        maximum: 9000000000000,
      )!,
      decimals:
          ActivityCodec.integer(
            json,
            'decimals',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          2,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityMoney> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityMoney.fromJson(ActivityCodec.object(input)),
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

  ActivityMoney copyWith({
    Set<String> clear = const {},
    String? currency,
    int? amountMinor,
    int? decimals,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityMoney(
      currency: (currency ?? this.currency),
      amountMinor: (amountMinor ?? this.amountMinor),
      decimals: (decimals ?? this.decimals),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (currency.trim().isEmpty || currency.length > 4000)
        validationIssues.add(
          const ActivityIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (amountMinor < 0 || amountMinor > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'amountMinor',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (decimals < 0 || decimals > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'decimals',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    if (!RegExp(r'^[A-Z]{3}$').hasMatch(currency) || decimals > 4)
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
    "currency": currency,
    "amountMinor": amountMinor,
    "decimals": decimals,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityMoney && ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityMoney(redacted)';
}
