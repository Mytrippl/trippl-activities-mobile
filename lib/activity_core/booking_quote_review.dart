import '../trippl_activities_mobile.dart';

class ActivityQuoteReview {
  static ActivityQuoteChange compare(
    ActivityBookingDraft draft,
    ActivityPriceQuote next, {
    required DateTime now,
  }) {
    ActivityGuard.record(next.validate());
    final old = draft.quote;
    return ActivityQuoteChange(
      draftId: draft.id,
      evaluatedAt: now,
      oldTotal: old?.total ?? next.total,
      newTotal: next.total,
      amountChanged:
          old != null && old.total.amountMinor != next.total.amountMinor,
      currencyChanged:
          old != null &&
          (old.total.currency != next.total.currency ||
              old.total.decimals != next.total.decimals),
      selectionChanged:
          next.productId != draft.product.id ||
          next.optionId != draft.optionId ||
          next.slotId != draft.slot.id,
      requiresAcceptance: old != next,
      reasonCodes: [
        if (old == null) 'initialQuote',
        if (old != null && old != next) 'quoteChanged',
      ],
    );
  }

  static ActivityBookingDraft bind(
    ActivityBookingDraft draft,
    ActivityPriceQuote quote,
    ActivityProviderRequest request, {
    required DateTime now,
  }) {
    ActivityBookingGuard.draft(draft, scope: draft.scope, now: now);
    ActivityRequests.validate(request);
    ActivityBookingGuard.clock(request.createdAt, now);
    final selection = request.availability;
    if (request.mode != 'quote' ||
        request.scope != draft.scope ||
        selection == null ||
        selection.productId != draft.product.id ||
        selection.optionId != draft.optionId ||
        request.slotId != draft.slot.id ||
        selection.travelers != draft.travelers ||
        selection.travelDate != draft.travelDate ||
        selection.units != draft.units ||
        selection.selectedLanguage != draft.languageCode)
      throw StateError('Quote request differs from booking draft');
    ActivityPricing.validateQuote(
      quote,
      request: ActivityQuoteRequest(
        productId: draft.product.id,
        optionId: draft.optionId,
        slotId: draft.slot.id,
        travelers: draft.travelers,
        currency: selection.currency,
        createdAt: request.createdAt,
        languageCode: draft.languageCode,
        units: draft.units,
      ),
      requestFingerprint: ActivityRequests.fingerprint(request),
      now: now,
    );
    return draft.copyWith(
      quote: quote,
      quoteRequestFingerprint: ActivityRequests.fingerprint(request),
      clear: draft.quote == quote ? {} : {'terms'},
    );
  }

  static List<String> review(
    ActivityBookingDraft draft,
    ActivityConfirmationPolicy policy, {
    required DateTime now,
  }) {
    final reasons = <String>[], quote = draft.quote;
    if (quote == null) return const ['quoteMissing'];
    if (!ActivityGuard.fresh(quote.observedAt, quote.expiresAt, now))
      reasons.add('quoteExpired');
    if (now.difference(quote.observedAt).inSeconds >
        policy.maximumQuoteAgeSeconds)
      reasons.add('quoteNeedsRevalidation');
    if (quote.indicative) reasons.add('quoteIndicative');
    if (draft.quoteRequestFingerprint == null ||
        quote.requestFingerprint != draft.quoteRequestFingerprint)
      reasons.add('quoteRequestNotBound');
    if (quote.productId != draft.product.id ||
        quote.optionId != draft.optionId ||
        quote.slotId != draft.slot.id)
      reasons.add('quoteSelectionChanged');
    return List.unmodifiable(reasons);
  }
}
