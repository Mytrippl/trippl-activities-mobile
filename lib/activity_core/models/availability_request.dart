// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'traveler_mix.dart';

class ActivityAvailabilityRequest {
  ActivityAvailabilityRequest({
    required this.productId,
    required this.optionId,
    required this.travelDate,
    required this.travelers,
    required this.currency,
    this.language = "en",
    this.selectedSlotId,
    this.selectedLanguage,
    this.revision = 1,
  });

  final String productId;
  final String optionId;
  final DateTime travelDate;
  final ActivityTravelerMix travelers;
  final String currency;
  final String language;
  final String? selectedSlotId;
  final String? selectedLanguage;
  final int revision;

  factory ActivityAvailabilityRequest.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "productId",
      "optionId",
      "travelDate",
      "travelers",
      "currency",
      "language",
      "selectedSlotId",
      "selectedLanguage",
      "revision",
    });
    final value = ActivityAvailabilityRequest(
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      optionId: ActivityCodec.text(json, 'optionId', required: true)!,
      travelDate: ActivityCodec.date(
        json,
        'travelDate',
        required: true,
        calendar: true,
      )!,
      travelers: (json['travelers'] == null
          ? null
          : ActivityTravelerMix.fromJson(
              ActivityCodec.object(json['travelers']),
            ))!,
      currency: ActivityCodec.text(json, 'currency', required: true)!,
      language: ActivityCodec.text(json, 'language') ?? "en",
      selectedSlotId: ActivityCodec.text(json, 'selectedSlotId'),
      selectedLanguage: ActivityCodec.text(json, 'selectedLanguage'),
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

  static ActivityResult<ActivityAvailabilityRequest> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityAvailabilityRequest.fromJson(
          ActivityCodec.object(input),
        ),
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

  ActivityAvailabilityRequest copyWith({
    Set<String> clear = const {},
    String? productId,
    String? optionId,
    DateTime? travelDate,
    ActivityTravelerMix? travelers,
    String? currency,
    String? language,
    String? selectedSlotId,
    String? selectedLanguage,
    int? revision,
  }) {
    final clearableFields = <String>{"selectedSlotId", "selectedLanguage"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityAvailabilityRequest(
      productId: (productId ?? this.productId),
      optionId: (optionId ?? this.optionId),
      travelDate: (travelDate ?? this.travelDate),
      travelers: (travelers ?? this.travelers),
      currency: (currency ?? this.currency),
      language: (language ?? this.language),
      selectedSlotId: clear.contains('selectedSlotId')
          ? null
          : (selectedSlotId ?? this.selectedSlotId),
      selectedLanguage: clear.contains('selectedLanguage')
          ? null
          : (selectedLanguage ?? this.selectedLanguage),
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
    {
      if (language.trim().isEmpty || language.length > 4000)
        validationIssues.add(
          const ActivityIssue('language', 'text', 'Use nonempty bounded text'),
        );
    }
    if (selectedSlotId != null) {
      if (selectedSlotId!.trim().isEmpty || selectedSlotId!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'selectedSlotId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (selectedLanguage != null) {
      if (selectedLanguage!.trim().isEmpty || selectedLanguage!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'selectedLanguage',
            'text',
            'Use nonempty bounded text',
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
        !RegExp(r'^[A-Z]{3}$').hasMatch(currency) ||
        language.length > 20)
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
    "travelDate": ActivityCodec.calendarText(travelDate),
    "travelers": travelers.toJson(),
    "currency": currency,
    "language": language,
    if (selectedSlotId != null) "selectedSlotId": selectedSlotId,
    if (selectedLanguage != null) "selectedLanguage": selectedLanguage,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityAvailabilityRequest &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityAvailabilityRequest(redacted)';
}
