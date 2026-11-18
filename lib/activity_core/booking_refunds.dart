import '../trippl_activities_mobile.dart';

class ActivityRefunds {
  static ActivityRefundEstimate estimate(
    ActivityBookingRecord booking, {
    required DateTime now,
  }) {
    ActivityGuard.record(booking.validate());
    final policy = booking.cancellation;
    final assessment = policy == null
        ? ActivityCancellationAssessment(
            policyId: 'unknown',
            evaluatedAt: now,
            state: 'unknown',
            warningCodes: ['cancellationPolicyMissing'],
          )
        : ActivityCancellation.assess(policy, booking.total, now: now);
    return ActivityRefundEstimate(
      bookingId: booking.id,
      evaluatedAt: now,
      assessment: assessment,
      paid: booking.total,
      reasonCodes: [
        if (assessment.requiresReview) 'policyRequiresReview',
        'providerRefundConfirmationRequired',
      ],
    );
  }

  static void validate(
    ActivityBookingRecord booking,
    ActivityRefundRecord refund, {
    required DateTime now,
  }) {
    ActivityGuard.record(booking.validate());
    ActivityGuard.record(refund.validate());
    ActivityBookingGuard.scope(booking.scope, refund.scope);
    if (refund.bookingId != booking.id ||
        refund.observedAt.isAfter(now) ||
        refund.completedAt?.isAfter(now) == true)
      throw StateError('Refund booking or observation mismatch');
    ActivityAmounts.compatible(booking.total, refund.amount);
    if (refund.amount.amountMinor > booking.total.amountMinor)
      throw StateError('Refund exceeds accepted booking amount');
    if (refund.completedAt != null &&
        refund.completedAt!.isBefore(booking.createdAt))
      throw StateError('Refund predates the booking');
  }

  static ActivityRefundRecord replace(
    ActivityBookingRecord booking,
    ActivityRefundRecord old,
    ActivityRefundRecord next, {
    required int expectedRevision,
    required DateTime now,
  }) {
    validate(booking, old, now: now);
    validate(booking, next, now: now);
    ActivityGuard.revision(old.revision, expectedRevision);
    if (next.id != old.id ||
        next.revision <= old.revision ||
        next.observedAt.isBefore(old.observedAt) ||
        old.state == 'processed' && next.state != 'processed')
      throw StateError('Refund state regressed or identity changed');
    return next;
  }

  static Map<String, Object?> summary(
    ActivityBookingRecord booking,
    List<ActivityRefundRecord> records, {
    required DateTime now,
  }) {
    if (records.length > 100)
      throw const FormatException('Refund records exceed capacity');
    ActivityGuard.distinct(records.map((r) => r.id));
    var processed = 0, pending = 0;
    for (final record in records) {
      validate(booking, record, now: now);
      if (record.state == 'processed') processed += record.amount.amountMinor;
      if (record.state == 'pending') pending += record.amount.amountMinor;
    }
    if (processed > booking.total.amountMinor ||
        processed + pending > booking.total.amountMinor)
      throw StateError(
        'Refund observations exceed the accepted booking amount',
      );
    return Map.unmodifiable({
      'bookingId': booking.id,
      'currency': booking.total.currency,
      'decimals': booking.total.decimals,
      'processedMinor': processed,
      'pendingMinor': pending,
      'providerReported': true,
      'bankSettlementConfirmed': false,
    });
  }
}
