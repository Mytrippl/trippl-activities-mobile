// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'answer_set.dart';
import 'booking_contact.dart';
import 'booking_traveler.dart';
import 'pickup_choice.dart';
import 'price_quote.dart';
import 'product.dart';
import 'question.dart';
import 'slot.dart';
import 'terms_acceptance.dart';
import 'traveler_mix.dart';

class ActivityBookingDraft {
  ActivityBookingDraft({
    required this.id,
    required this.scope,
    required this.product,
    required this.optionId,
    required this.slot,
    required this.travelDate,
    required this.travelers,
    required this.createdAt,
    required this.updatedAt,
    this.contact,
    List<ActivityBookingTraveler> travelerDetails = const [],
    List<ActivityQuestion> questions = const [],
    this.answers,
    this.quote,
    this.pickup,
    this.terms,
    this.state = "editing",
    this.units = 1,
    this.revision = 1,
    required this.offsetMinutes,
    this.languageCode,
    this.quoteRequestFingerprint,
  }) : travelerDetails = List.unmodifiable(travelerDetails),
       questions = List.unmodifiable(questions);

  final String id;
  final String scope;
  final ActivityProduct product;
  final String optionId;
  final ActivitySlot slot;
  final DateTime travelDate;
  final ActivityTravelerMix travelers;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ActivityBookingContact? contact;
  final List<ActivityBookingTraveler> travelerDetails;
  final List<ActivityQuestion> questions;
  final ActivityAnswerSet? answers;
  final ActivityPriceQuote? quote;
  final ActivityPickupChoice? pickup;
  final ActivityTermsAcceptance? terms;
  final String state;
  final int units;
  final int revision;
  final int offsetMinutes;
  final String? languageCode;
  final String? quoteRequestFingerprint;

  factory ActivityBookingDraft.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "product",
      "optionId",
      "slot",
      "travelDate",
      "travelers",
      "createdAt",
      "updatedAt",
      "contact",
      "travelerDetails",
      "questions",
      "answers",
      "quote",
      "pickup",
      "terms",
      "state",
      "units",
      "revision",
      "offsetMinutes",
      "languageCode",
      "quoteRequestFingerprint",
    });
    final value = ActivityBookingDraft(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      product: (json['product'] == null
          ? null
          : ActivityProduct.fromJson(ActivityCodec.object(json['product'])))!,
      optionId: ActivityCodec.text(json, 'optionId', required: true)!,
      slot: (json['slot'] == null
          ? null
          : ActivitySlot.fromJson(ActivityCodec.object(json['slot'])))!,
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
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      contact: json['contact'] == null
          ? null
          : ActivityBookingContact.fromJson(
              ActivityCodec.object(json['contact']),
            ),
      travelerDetails:
          ActivityCodec.list(
            json,
            'travelerDetails',
            (v) => ActivityBookingTraveler.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      questions:
          ActivityCodec.list(
            json,
            'questions',
            (v) => ActivityQuestion.fromJson(ActivityCodec.object(v)),
            maximum: 100,
          ) ??
          [],
      answers: json['answers'] == null
          ? null
          : ActivityAnswerSet.fromJson(ActivityCodec.object(json['answers'])),
      quote: json['quote'] == null
          ? null
          : ActivityPriceQuote.fromJson(ActivityCodec.object(json['quote'])),
      pickup: json['pickup'] == null
          ? null
          : ActivityPickupChoice.fromJson(ActivityCodec.object(json['pickup'])),
      terms: json['terms'] == null
          ? null
          : ActivityTermsAcceptance.fromJson(
              ActivityCodec.object(json['terms']),
            ),
      state: ActivityCodec.text(json, 'state') ?? "editing",
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
      offsetMinutes: ActivityCodec.integer(
        json,
        'offsetMinutes',
        required: true,
        minimum: -840,
        maximum: 840,
      )!,
      languageCode: ActivityCodec.text(json, 'languageCode'),
      quoteRequestFingerprint: ActivityCodec.text(
        json,
        'quoteRequestFingerprint',
      ),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityBookingDraft> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityBookingDraft.fromJson(ActivityCodec.object(input)),
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

  ActivityBookingDraft copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    ActivityProduct? product,
    String? optionId,
    ActivitySlot? slot,
    DateTime? travelDate,
    ActivityTravelerMix? travelers,
    DateTime? createdAt,
    DateTime? updatedAt,
    ActivityBookingContact? contact,
    List<ActivityBookingTraveler>? travelerDetails,
    List<ActivityQuestion>? questions,
    ActivityAnswerSet? answers,
    ActivityPriceQuote? quote,
    ActivityPickupChoice? pickup,
    ActivityTermsAcceptance? terms,
    String? state,
    int? units,
    int? revision,
    int? offsetMinutes,
    String? languageCode,
    String? quoteRequestFingerprint,
  }) {
    final clearableFields = <String>{
      "contact",
      "answers",
      "quote",
      "pickup",
      "terms",
      "languageCode",
      "quoteRequestFingerprint",
    };
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityBookingDraft(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      product: (product ?? this.product),
      optionId: (optionId ?? this.optionId),
      slot: (slot ?? this.slot),
      travelDate: (travelDate ?? this.travelDate),
      travelers: (travelers ?? this.travelers),
      createdAt: (createdAt ?? this.createdAt),
      updatedAt: (updatedAt ?? this.updatedAt),
      contact: clear.contains('contact') ? null : (contact ?? this.contact),
      travelerDetails: (travelerDetails ?? this.travelerDetails),
      questions: (questions ?? this.questions),
      answers: clear.contains('answers') ? null : (answers ?? this.answers),
      quote: clear.contains('quote') ? null : (quote ?? this.quote),
      pickup: clear.contains('pickup') ? null : (pickup ?? this.pickup),
      terms: clear.contains('terms') ? null : (terms ?? this.terms),
      state: (state ?? this.state),
      units: (units ?? this.units),
      revision: (revision ?? this.revision),
      offsetMinutes: (offsetMinutes ?? this.offsetMinutes),
      languageCode: clear.contains('languageCode')
          ? null
          : (languageCode ?? this.languageCode),
      quoteRequestFingerprint: clear.contains('quoteRequestFingerprint')
          ? null
          : (quoteRequestFingerprint ?? this.quoteRequestFingerprint),
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
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in product.validate())
        validationIssues.add(
          ActivityIssue(
            'product.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (optionId.trim().isEmpty || optionId.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in slot.validate())
        validationIssues.add(
          ActivityIssue(
            'slot.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
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
    if (contact != null) {
      for (final issue in contact!.validate())
        validationIssues.add(
          ActivityIssue(
            'contact.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (travelerDetails.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'travelerDetails',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < travelerDetails.length; i++)
        for (final issue in travelerDetails[i].validate())
          validationIssues.add(
            ActivityIssue(
              'travelerDetails[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    {
      if (questions.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'questions',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      for (var i = 0; i < questions.length; i++)
        for (final issue in questions[i].validate())
          validationIssues.add(
            ActivityIssue(
              'questions[$i].${issue.field}',
              issue.code,
              issue.message,
              severity: issue.severity,
            ),
          );
    }
    if (answers != null) {
      for (final issue in answers!.validate())
        validationIssues.add(
          ActivityIssue(
            'answers.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (quote != null) {
      for (final issue in quote!.validate())
        validationIssues.add(
          ActivityIssue(
            'quote.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (pickup != null) {
      for (final issue in pickup!.validate())
        validationIssues.add(
          ActivityIssue(
            'pickup.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (terms != null) {
      for (final issue in terms!.validate())
        validationIssues.add(
          ActivityIssue(
            'terms.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
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
    {
      if (offsetMinutes < -840 || offsetMinutes > 840)
        validationIssues.add(
          const ActivityIssue(
            'offsetMinutes',
            'range',
            'Number is outside the activity limits',
          ),
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
    if (quoteRequestFingerprint != null) {
      if (quoteRequestFingerprint!.trim().isEmpty ||
          quoteRequestFingerprint!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'quoteRequestFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (revision < 1 ||
        units < 1 ||
        units > 100 ||
        updatedAt.isBefore(createdAt) ||
        slot.productId != product.id ||
        slot.optionId != optionId ||
        !{
          'editing',
          'review',
          'submitting',
          'pending',
          'confirmed',
          'rejected',
          'unknown',
          'abandoned',
        }.contains(state))
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
    "scope": scope,
    "product": product.toJson(),
    "optionId": optionId,
    "slot": slot.toJson(),
    "travelDate": ActivityCodec.calendarText(travelDate),
    "travelers": travelers.toJson(),
    "createdAt": createdAt.toUtc().toIso8601String(),
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    if (contact != null) "contact": contact!.toJson(),
    "travelerDetails": travelerDetails.map((item) => item.toJson()).toList(),
    "questions": questions.map((item) => item.toJson()).toList(),
    if (answers != null) "answers": answers!.toJson(),
    if (quote != null) "quote": quote!.toJson(),
    if (pickup != null) "pickup": pickup!.toJson(),
    if (terms != null) "terms": terms!.toJson(),
    "state": state,
    "units": units,
    "revision": revision,
    "offsetMinutes": offsetMinutes,
    if (languageCode != null) "languageCode": languageCode,
    if (quoteRequestFingerprint != null)
      "quoteRequestFingerprint": quoteRequestFingerprint,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityBookingDraft &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityBookingDraft(redacted)';
}
