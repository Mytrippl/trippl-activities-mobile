// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'traveler_mix.dart';

class ActivitySearchQuery {
  ActivitySearchQuery({
    this.text = "all",
    this.destinationId,
    this.productId,
    this.startDate,
    this.endDate,
    this.currency = "USD",
    this.language = "en",
    this.offset = 0,
    this.limit = 20,
    this.travelerMix,
  });

  final String text;
  final String? destinationId;
  final String? productId;
  final DateTime? startDate;
  final DateTime? endDate;
  final String currency;
  final String language;
  final int offset;
  final int limit;
  final ActivityTravelerMix? travelerMix;

  factory ActivitySearchQuery.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "text",
      "destinationId",
      "productId",
      "startDate",
      "endDate",
      "currency",
      "language",
      "offset",
      "limit",
      "travelerMix",
    });
    final value = ActivitySearchQuery(
      text: ActivityCodec.text(json, 'text') ?? "all",
      destinationId: ActivityCodec.text(json, 'destinationId'),
      productId: ActivityCodec.text(json, 'productId'),
      startDate: ActivityCodec.date(json, 'startDate', calendar: true),
      endDate: ActivityCodec.date(json, 'endDate', calendar: true),
      currency: ActivityCodec.text(json, 'currency') ?? "USD",
      language: ActivityCodec.text(json, 'language') ?? "en",
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
      travelerMix: json['travelerMix'] == null
          ? null
          : ActivityTravelerMix.fromJson(
              ActivityCodec.object(json['travelerMix']),
            ),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivitySearchQuery> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivitySearchQuery.fromJson(ActivityCodec.object(input)),
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

  ActivitySearchQuery copyWith({
    Set<String> clear = const {},
    String? text,
    String? destinationId,
    String? productId,
    DateTime? startDate,
    DateTime? endDate,
    String? currency,
    String? language,
    int? offset,
    int? limit,
    ActivityTravelerMix? travelerMix,
  }) {
    final clearableFields = <String>{
      "destinationId",
      "productId",
      "startDate",
      "endDate",
      "travelerMix",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivitySearchQuery(
      text: (text ?? this.text),
      destinationId: clear.contains('destinationId')
          ? null
          : (destinationId ?? this.destinationId),
      productId: clear.contains('productId')
          ? null
          : (productId ?? this.productId),
      startDate: clear.contains('startDate')
          ? null
          : (startDate ?? this.startDate),
      endDate: clear.contains('endDate') ? null : (endDate ?? this.endDate),
      currency: (currency ?? this.currency),
      language: (language ?? this.language),
      offset: (offset ?? this.offset),
      limit: (limit ?? this.limit),
      travelerMix: clear.contains('travelerMix')
          ? null
          : (travelerMix ?? this.travelerMix),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (text.trim().isEmpty || text.length > 4000)
        validationIssues.add(
          const ActivityIssue('text', 'text', 'Use nonempty bounded text'),
        );
    }
    if (destinationId != null) {
      if (destinationId!.trim().isEmpty || destinationId!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'destinationId',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (productId != null) {
      if (productId!.trim().isEmpty || productId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('productId', 'text', 'Use nonempty bounded text'),
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
    if (travelerMix != null) {
      for (final issue in travelerMix!.validate())
        validationIssues.add(
          ActivityIssue(
            'travelerMix.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (limit < 1 ||
        limit > 100 ||
        offset > 10000 ||
        startDate != null && endDate != null && endDate!.isBefore(startDate!) ||
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
    "text": text,
    if (destinationId != null) "destinationId": destinationId,
    if (productId != null) "productId": productId,
    if (startDate != null) "startDate": ActivityCodec.calendarText(startDate!),
    if (endDate != null) "endDate": ActivityCodec.calendarText(endDate!),
    "currency": currency,
    "language": language,
    "offset": offset,
    "limit": limit,
    if (travelerMix != null) "travelerMix": travelerMix!.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivitySearchQuery &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivitySearchQuery(redacted)';
}
