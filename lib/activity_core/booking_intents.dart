import '../trippl_activities_mobile.dart';

class ActivityBookingReview {
  ActivityBookingReview({
    required this.draftId,
    required this.evaluatedAt,
    required List<String> reasons,
  }) : reasonCodes = List.unmodifiable(reasons);
  final String draftId;
  final DateTime evaluatedAt;
  final List<String> reasonCodes;
  bool get ready => reasonCodes.isEmpty;
}

class ActivityBookingIntents {
  static ActivityBookingReview review(
    ActivityBookingDraft draft,
    ActivityConfirmationPolicy policy, {
    required DateTime now,
    ActivityPickup? pickupPolicy,
  }) {
    ActivityBookingGuard.draft(draft, scope: draft.scope, now: now);
    ActivityGuard.record(policy.validate());
    final reasons = <String>[];
    if (!{'editing', 'review'}.contains(draft.state))
      reasons.add('draftAlreadySubmitted');
    if (!ActivityGuard.fresh(
      draft.product.observedAt,
      draft.product.expiresAt,
      now,
    ))
      reasons.add('productNeedsRefresh');
    final option = draft.product.options.firstWhere(
      (o) => o.id == draft.optionId,
    );
    final inventory = ActivityInventory.assess(
      option,
      ActivityAvailabilityRequest(
        productId: draft.product.id,
        optionId: draft.optionId,
        travelDate: draft.travelDate,
        travelers: draft.travelers,
        currency: draft.quote?.total.currency ?? 'USD',
        selectedSlotId: draft.slot.id,
        selectedLanguage: draft.languageCode,
        units: draft.units,
      ),
      [draft.slot],
      now: now,
      offsetMinutes: draft.offsetMinutes,
    );
    if (!inventory.bookable) reasons.add('availabilityNeedsRefresh');
    reasons.addAll(ActivityContacts.review(draft.contact, policy, now: now));
    reasons.addAll(
      ActivityBookingTravelers.review(
        draft.travelers,
        draft.travelerDetails,
        travelDate: draft.travelDate,
        requireNames: policy.requireNames,
      ),
    );
    reasons.addAll(
      ActivityQuestions.assess(
        draft.questions,
        draft.answers,
        draft.travelers,
        draftId: draft.id,
        now: now,
      ).reasonCodes,
    );
    reasons.addAll(
      ActivityPickupChoices.review(
        pickupPolicy,
        draft.pickup,
        optionId: draft.optionId,
        now: now,
        requireConfirmation: policy.requirePickupConfirmation,
      ),
    );
    reasons.addAll(ActivityQuoteReview.review(draft, policy, now: now));
    reasons.addAll(ActivityBookingTerms.review(draft, policy, now: now));
    return ActivityBookingReview(
      draftId: draft.id,
      evaluatedAt: now,
      reasons: reasons.toSet().toList()..sort(),
    );
  }

  static ActivityBookingIntent prepare(
    ActivityBookingDraft draft,
    ActivityConfirmationPolicy policy, {
    required String id,
    required DateTime now,
    required bool confirmedByUser,
    ActivityPickup? pickupPolicy,
  }) {
    if (!confirmedByUser)
      throw StateError('Booking submission requires user confirmation');
    final readiness = review(
      draft,
      policy,
      now: now,
      pickupPolicy: pickupPolicy,
    );
    if (!readiness.ready)
      throw StateError('Activity booking review incomplete');
    ActivityGuard.identity(id);
    final fingerprint = ActivityBookingGuard.fingerprint(draft);
    final result = ActivityBookingIntent(
      id: id,
      scope: draft.scope,
      draftId: draft.id,
      draftFingerprint: fingerprint,
      quoteId: draft.quote!.id,
      total: draft.quote!.total,
      createdAt: now,
      expiresAt: draft.quote!.expiresAt,
      idempotencyKey: ActivityCodec.digest({
        'scope': draft.scope,
        'intentId': id,
        'draft': fingerprint,
      }),
    );
    ActivityGuard.record(result.validate());
    return result;
  }

  static void bind(
    ActivityBookingIntent intent,
    ActivityBookingDraft draft, {
    required DateTime now,
  }) {
    ActivityGuard.record(intent.validate());
    ActivityBookingGuard.draft(draft, scope: intent.scope, now: now);
    if (intent.draftId != draft.id ||
        intent.draftFingerprint != ActivityBookingGuard.fingerprint(draft) ||
        intent.quoteId != draft.quote?.id ||
        intent.total != draft.quote?.total ||
        !intent.expiresAt.isAfter(now))
      throw StateError('Booking intent changed or expired');
  }
}
