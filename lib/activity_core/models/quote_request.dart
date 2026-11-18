// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'traveler_mix.dart';

class ActivityQuoteRequest {
  ActivityQuoteRequest({
    required this.productId,
    required this.optionId,
    required this.slotId,
    required this.travelers,
    required this.currency,
    required this.createdAt,
    this.languageCode,
    this.units = 1,
    this.revision = 1,
  });

  final String productId;
  final String optionId;
  final String slotId;
  final ActivityTravelerMix travelers;
  final String currency;
  final DateTime createdAt;
  final String? languageCode;
  final int units;
  final int revision;

  factory ActivityQuoteRequest.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "productId",
      "optionId",
      "slotId",
      "travelers",
      "currency",
      "createdAt",
      "languageCode",
      "units",
      "revision",
    });
    final value = ActivityQuoteRequest(
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      optionId: ActivityCodec.text(json, 'optionId', required: true)!,
      slotId: ActivityCodec.text(json, 'slotId', required: true)!,
      travelers: (json['travelers'] == null
          ? null
          : ActivityTravelerMix.fromJson(
              ActivityCodec.object(json['travelers']),
            ))!,
      currency: ActivityCodec.text(json, 'currency', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      languageCode: ActivityCodec.text(json, 'languageCode'),
      units:
          ActivityCodec.integer(
            json,
            'units',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
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

  static ActivityResult<ActivityQuoteRequest> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityQuoteRequest.fromJson(ActivityCodec.object(input)),
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

  ActivityQuoteRequest copyWith({
    Set<String> clear = const {},
    String? productId,
    String? optionId,
    String? slotId,
    ActivityTravelerMix? travelers,
    String? currency,
    DateTime? createdAt,
    String? languageCode,
    int? units,
    int? revision,
  }) {
    final clearableFields = <String>{"languageCode"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityQuoteRequest(
      productId: (productId ?? this.productId),
      optionId: (optionId ?? this.optionId),
      slotId: (slotId ?? this.slotId),
      travelers: (travelers ?? this.travelers),
      currency: (currency ?? this.currency),
      createdAt: (createdAt ?? this.createdAt),
      languageCode: clear.contains('languageCode')
          ? null
          : (languageCode ?? this.languageCode),
      units: (units ?? this.units),
      revision: (revision ?? this.revision),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (productId.trim().isEmpty || productId.length > 4000)
        validationIssues.add(
          const ActivityIssue('productId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (optionId.trim().isEmpty || optionId.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (slotId.trim().isEmpty || slotId.length > 4000)
        validationIssues.add(
          const ActivityIssue('slotId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in travelers.validate())
        validationIssues.add(
          ActivityIssue(
            'travelers.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (currency.trim().isEmpty || currency.length > 4000)
        validationIssues.add(
          const ActivityIssue('currency', 'text', 'Use nonempty bounded text'),
        );
    }
    if (languageCode != null) {
      if (languageCode!.trim().isEmpty || languageCode!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'languageCode',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (units < 0 || units > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'units',
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
    if (revision < 1 ||
        units < 1 ||
        units > 100 ||
        !RegExp(r'^[A-Z]{3}$').hasMatch(currency))
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
    "productId": productId,
    "optionId": optionId,
    "slotId": slotId,
    "travelers": travelers.toJson(),
    "currency": currency,
    "createdAt": createdAt.toUtc().toIso8601String(),
    if (languageCode != null) "languageCode": languageCode,
    "units": units,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityQuoteRequest &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityQuoteRequest(redacted)';
}
