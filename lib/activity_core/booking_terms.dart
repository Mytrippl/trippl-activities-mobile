import '../trippl_activities_mobile.dart';

class ActivityBookingTerms {
  static ActivityTermsAcceptance accept(
    ActivityBookingDraft draft, {
    required String id,
    required String termsVersion,
    required bool accepted,
    required DateTime now,
  }) {
    ActivityBookingGuard.draft(draft, scope: draft.scope, now: now);
    final quote = draft.quote;
    if (quote == null ||
        !ActivityGuard.fresh(quote.observedAt, quote.expiresAt, now))
      throw StateError('Review a fresh quote before accepting terms');
    ActivityGuard.identity(id);
    ActivityGuard.identity(termsVersion);
    return ActivityTermsAcceptance(
      id: id,
      scope: draft.scope,
      draftId: draft.id,
      termsVersion: termsVersion,
      acceptedAt: now,
      quoteDigest: ActivityCodec.digest(quote.toJson()),
      accepted: accepted,
      revision: (draft.terms?.revision ?? 0) + 1,
    );
  }

  static List<String> review(
    ActivityBookingDraft draft,
    ActivityConfirmationPolicy policy, {
    required DateTime now,
  }) {
    ActivityGuard.record(policy.validate());
    final terms = draft.terms, quote = draft.quote;
    if (terms == null || !terms.accepted) return const ['termsNotAccepted'];
    ActivityGuard.record(terms.validate());
    if (terms.scope != draft.scope || terms.draftId != draft.id)
      throw StateError('Accepted terms parent mismatch');
    ActivityBookingGuard.clock(terms.acceptedAt, now);
    return [
      if (terms.termsVersion != policy.termsVersion) 'termsVersionChanged',
      if (quote == null ||
          terms.quoteDigest != ActivityCodec.digest(quote.toJson()))
        'acceptedQuoteChanged',
    ];
  }
}
