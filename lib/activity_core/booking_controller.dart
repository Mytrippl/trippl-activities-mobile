import 'dart:async';
import '../trippl_activities_mobile.dart';

class ActivityBookingController {
  ActivityBookingController(
    this.transport, {
    required this.scope,
    required this.clock,
    this.timeout = const Duration(seconds: 30),
  }) {
    ActivityGuard.identity(scope);
    if (timeout <= Duration.zero || timeout > const Duration(minutes: 2))
      throw ArgumentError('Invalid booking timeout');
  }
  final ActivityBookingTransport transport;
  final String scope;
  final DateTime Function() clock;
  final Duration timeout;
  ActivityBookingIntent? _intent;
  ActivityBookingReceipt? _receipt;
  ActivityBookingRecord? _record;
  bool _busy = false, _closed = false;
  int _generation = 0;
  final _changes = StreamController<ActivityBookingOutcome>.broadcast();
  Stream<ActivityBookingOutcome> get changes => _changes.stream;
  ActivityBookingOutcome get outcome => ActivityBookingOutcome(
    intent: _intent,
    receipt: _receipt,
    record: _record,
    busy: _busy,
    generation: _generation,
  );
  void _open() {
    if (_closed) throw StateError('Booking controller closed');
  }

  void _emit() {
    if (!_closed) _changes.add(outcome);
  }

  Future<ActivityBookingOutcome> submit(
    ActivityBookingDraft draft,
    ActivityBookingIntent intent, {
    required ActivityConfirmationPolicy policy,
    required bool confirmedByUser,
    ActivityPickup? pickupPolicy,
  }) async {
    _open();
    if (_busy) throw StateError('Booking submission already in progress');
    ActivityBookingGuard.scope(scope, draft.scope);
    ActivityBookingIntents.bind(intent, draft, now: clock());
    if (!confirmedByUser ||
        !ActivityBookingIntents.review(
          draft,
          policy,
          now: clock(),
          pickupPolicy: pickupPolicy,
        ).ready)
      throw StateError('Booking needs explicit completed review');
    if (_intent != null)
      throw StateError(
        'Reconcile the existing booking intent before creating another',
      );
    final epoch = ++_generation;
    _intent = intent.copyWith(
      state: 'sending',
      attempts: 1,
      revision: intent.revision + 1,
    );
    _busy = true;
    _emit();
    try {
      final receipt = await transport.submit(intent, draft).timeout(timeout);
      if (_closed || epoch != _generation) return outcome;
      _accept(receipt, draft: draft);
    } catch (_) {
      if (!_closed && epoch == _generation)
        _intent = _intent!.copyWith(
          state: 'unknown',
          revision: _intent!.revision + 1,
        );
      // No automatic second write: a timeout may still have created a booking.
    } finally {
      if (!_closed && epoch == _generation) {
        _busy = false;
        _emit();
      }
    }
    return outcome;
  }

  void _accept(ActivityBookingReceipt receipt, {ActivityBookingDraft? draft}) {
    final intent = _intent!;
    ActivityBookingGuard.receipt(intent, receipt, now: clock());
    if (_receipt != null &&
        (receipt.revision < _receipt!.revision ||
            receipt.revision == _receipt!.revision && receipt != _receipt))
      throw StateError('Booking receipt regressed or diverged');
    if (_receipt?.state == 'confirmed' && receipt.state != 'confirmed')
      throw StateError('Confirmation cannot regress through intent lookup');
    ActivityBookingRecord? record = _record;
    if (receipt.state == 'confirmed' && draft != null)
      record = ActivityBookingRecord(
        id: receipt.bookingId!,
        scope: scope,
        productId: draft.product.id,
        optionId: draft.optionId,
        slotId: draft.slot.id,
        startsAt: draft.slot.startsAt,
        createdAt: receipt.receivedAt,
        updatedAt: receipt.receivedAt,
        total: receipt.total!,
        state: 'confirmed',
        intentId: intent.id,
        providerReference: receipt.providerReference,
        cancellation: draft.product.cancellation,
      );
    if (record != null) ActivityGuard.record(record.validate());
    _receipt = receipt;
    _record = record;
    _intent = intent.copyWith(
      state: receipt.state,
      revision: intent.revision + 1,
    );
  }

  Future<ActivityBookingOutcome> reconcile(ActivityBookingDraft draft) async {
    _open();
    if (_busy || _intent == null)
      throw StateError('No idle booking intent to reconcile');
    ActivityBookingGuard.scope(scope, draft.scope);
    if (_intent!.draftFingerprint != ActivityBookingGuard.fingerprint(draft))
      throw StateError('Reconciliation draft changed');
    if (_receipt?.state == 'confirmed' || _receipt?.state == 'rejected')
      return outcome;
    final epoch = ++_generation;
    _busy = true;
    _emit();
    try {
      final receipt = await transport.lookupIntent(_intent!).timeout(timeout);
      if (!_closed && epoch == _generation) _accept(receipt, draft: draft);
    } catch (_) {
      if (!_closed && epoch == _generation)
        _intent = _intent!.copyWith(
          state: 'unknown',
          revision: _intent!.revision + 1,
        );
    } finally {
      if (!_closed && epoch == _generation) {
        _busy = false;
        _emit();
      }
    }
    return outcome;
  }

  void restore(
    ActivityBookingIntent intent, {
    ActivityBookingReceipt? receipt,
    ActivityBookingRecord? record,
  }) {
    _open();
    if (_busy || _intent != null)
      throw StateError('Booking controller already has an intent');
    ActivityGuard.record(intent.validate());
    ActivityBookingGuard.scope(scope, intent.scope);
    if (receipt != null)
      ActivityBookingGuard.receipt(intent, receipt, now: clock());
    if (record != null) {
      ActivityGuard.record(record.validate());
      if (record.scope != scope ||
          record.intentId != intent.id ||
          receipt?.bookingId != record.id)
        throw StateError('Restored booking record identity mismatch');
    }
    _intent = intent.state == 'sending'
        ? intent.copyWith(state: 'unknown')
        : intent;
    _receipt = receipt;
    _record = record;
    _generation++;
    _emit();
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _generation++;
    await _changes.close();
  }
}

class ActivityBookingOutcome {
  ActivityBookingOutcome({
    required this.intent,
    required this.receipt,
    required this.record,
    required this.busy,
    required this.generation,
  });
  final ActivityBookingIntent? intent;
  final ActivityBookingReceipt? receipt;
  final ActivityBookingRecord? record;
  final bool busy;
  final int generation;
  bool get confirmed =>
      receipt?.state == 'confirmed' && record?.state == 'confirmed';
  bool get requiresReconciliation =>
      intent?.state == 'unknown' || intent?.state == 'pending';
}
