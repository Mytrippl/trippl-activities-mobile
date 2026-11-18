import '../trippl_activities_mobile.dart';

class ActivityBookingReconciliation {
  static const transitions = {
    'pending': {'pending', 'confirmed', 'rejected', 'unknown'},
    'unknown': {
      'pending',
      'confirmed',
      'rejected',
      'cancelPending',
      'cancelled',
      'unknown',
    },
    'confirmed': {'confirmed', 'cancelPending', 'cancelled'},
    'cancelPending': {'cancelPending', 'confirmed', 'cancelled'},
    'cancelled': {'cancelled'},
    'rejected': {'rejected'},
  };
  static ActivityReconciliation assess(
    ActivityBookingRecord record,
    ActivityBookingStatus status, {
    required DateTime now,
  }) {
    ActivityTransportContracts.status(record, status, now: now);
    final reasons = <String>[];
    if (status.revision < record.revision)
      reasons.add('remoteRevisionRegressed');
    if (status.observedAt.isBefore(record.updatedAt))
      reasons.add('statusObservationRegressed');
    if (!(transitions[record.state] ?? {}).contains(status.state))
      reasons.add('invalidStatusTransition');
    if (status.revision == record.revision &&
        (status.state != record.state ||
            status.providerReference != null &&
                record.providerReference != null &&
                status.providerReference != record.providerReference))
      reasons.add('sameRevisionDiverged');
    if (record.providerReference != null &&
        status.providerReference != null &&
        record.providerReference != status.providerReference)
      reasons.add('providerReferenceChanged');
    return ActivityReconciliation(
      bookingId: record.id,
      evaluatedAt: now,
      previousState: record.state,
      nextState: status.state,
      accepted: reasons.isEmpty,
      reasonCodes: reasons,
      requiresReview: reasons.isNotEmpty || status.state == 'unknown',
      remoteRevision: status.revision,
    );
  }

  static ActivityBookingRecord apply(
    ActivityBookingRecord record,
    ActivityBookingStatus status, {
    required DateTime now,
  }) {
    final assessment = assess(record, status, now: now);
    if (!assessment.accepted)
      throw StateError('Booking status requires reconciliation review');
    final next = record.copyWith(
      state: status.state,
      updatedAt: status.observedAt,
      revision: status.revision,
      providerReference: status.providerReference,
    );
    ActivityGuard.record(next.validate());
    return next;
  }

  static ActivityBookingEvent event(
    ActivityBookingRecord previous,
    ActivityBookingRecord next, {
    required String id,
    required DateTime now,
  }) {
    if (previous.id != next.id || previous.scope != next.scope)
      throw StateError('Booking event identity mismatch');
    final kind = switch (next.state) {
      'confirmed' => 'confirmed',
      'cancelled' => 'cancelled',
      'rejected' => 'rejected',
      'pending' => 'pending',
      _ => 'reconciled',
    };
    return ActivityBookingEvent(
      id: id,
      scope: next.scope,
      bookingId: next.id,
      kind: kind,
      occurredAt: now,
      revision: next.revision,
      intentId: next.intentId,
    );
  }
}
