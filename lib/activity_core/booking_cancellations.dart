import 'dart:async';
import '../trippl_activities_mobile.dart';

class ActivityCancellations {
  ActivityCancellations(
    this.transport, {
    required this.scope,
    required this.clock,
    this.timeout = const Duration(seconds: 30),
  }) {
    ActivityGuard.identity(scope);
    if (timeout <= Duration.zero || timeout > const Duration(minutes: 2))
      throw ArgumentError('Invalid cancellation timeout');
  }
  final ActivityCancellationTransport transport;
  final String scope;
  final DateTime Function() clock;
  final Duration timeout;
  ActivityCancellationRequest? _request;
  ActivityBookingRecord? _booking;
  ActivityCancellationResult? _result;
  bool _busy = false, _closed = false;
  int _generation = 0;
  ActivityCancellationResult? get result => _result;
  ActivityCancellationRequest? get request => _request;
  static ActivityCancellationRequest prepare(
    ActivityBookingRecord booking, {
    required String id,
    required String reasonCode,
    required bool confirmedByUser,
    required DateTime now,
    ActivityRefundEstimate? estimate,
  }) {
    ActivityGuard.record(booking.validate());
    if (!confirmedByUser || booking.state != 'confirmed')
      throw StateError(
        'Cancellation requires a confirmed booking and explicit user choice',
      );
    if (!booking.startsAt.isAfter(now))
      throw StateError('Past departure cancellation requires backend review');
    if (estimate != null &&
        (estimate.bookingId != booking.id || estimate.evaluatedAt.isAfter(now)))
      throw StateError('Cancellation estimate mismatch');
    final request = ActivityCancellationRequest(
      id: id,
      scope: booking.scope,
      bookingId: booking.id,
      expectedRevision: booking.revision,
      createdAt: now,
      idempotencyKey: ActivityCodec.digest({
        'scope': booking.scope,
        'booking': booking.id,
        'request': id,
      }),
      reasonCode: reasonCode,
      confirmedByUser: true,
      assessmentDigest: estimate == null
          ? null
          : ActivityCodec.digest(estimate.toJson()),
    );
    ActivityGuard.record(request.validate());
    return request;
  }

  Future<ActivityCancellationResult?> submit(
    ActivityCancellationRequest request,
    ActivityBookingRecord booking,
  ) async {
    if (_closed || _busy)
      throw StateError('Cancellation controller unavailable');
    if (_request != null)
      throw StateError('Reconcile the existing cancellation first');
    ActivityBookingGuard.scope(scope, request.scope);
    ActivityBookingGuard.scope(scope, booking.scope);
    ActivityGuard.record(request.validate());
    ActivityGuard.record(booking.validate());
    if (!booking.startsAt.isAfter(clock()))
      throw StateError('Past departure needs backend review');
    if (!request.confirmedByUser ||
        request.bookingId != booking.id ||
        request.expectedRevision != booking.revision ||
        booking.state != 'confirmed' ||
        request.createdAt.isAfter(clock()))
      throw StateError(
        'Cancellation confirmation or booking revision mismatch',
      );
    _request = request;
    _booking = booking;
    final epoch = ++_generation;
    _busy = true;
    try {
      final response = await transport.cancel(request).timeout(timeout);
      if (!_closed && epoch == _generation) _accept(response);
    } catch (_) {
      if (!_closed && epoch == _generation)
        _result = ActivityCancellationResult(
          requestId: request.id,
          scope: scope,
          bookingId: request.bookingId,
          receivedAt: clock(),
          state: 'unknown',
        );
    } finally {
      _busy = false;
    }
    return _result;
  }

  void _accept(ActivityCancellationResult response) {
    ActivityTransportContracts.cancellation(_request!, response, now: clock());
    if (_result != null &&
        (response.revision < _result!.revision ||
            response.revision == _result!.revision &&
                response != _result &&
                _result!.state != 'unknown'))
      throw StateError('Cancellation result regressed or diverged');
    if (_result?.state == 'cancelled' && response.state != 'cancelled')
      throw StateError('Cancelled booking cannot regress');
    if (response.refund != null) {
      if (_booking == null)
        throw StateError(
          'Refund response requires the accepted booking amount',
        );
      ActivityAmounts.compatible(_booking!.total, response.refund!);
      if (response.refund!.amountMinor > _booking!.total.amountMinor)
        throw StateError('Cancellation refund exceeds paid amount');
    }
    _result = response;
  }

  Future<ActivityCancellationResult?> reconcile() async {
    if (_closed || _busy || _request == null)
      throw StateError('No idle cancellation to reconcile');
    if (_result?.state == 'cancelled' || _result?.state == 'rejected')
      return _result;
    final epoch = ++_generation;
    _busy = true;
    try {
      final result = await transport
          .lookupCancellation(_request!)
          .timeout(timeout);
      if (!_closed && epoch == _generation) _accept(result);
    } catch (_) {
      if (!_closed && epoch == _generation)
        _result = ActivityCancellationResult(
          requestId: _request!.id,
          scope: scope,
          bookingId: _request!.bookingId,
          receivedAt: clock(),
          state: 'unknown',
        );
    } finally {
      _busy = false;
    }
    return _result;
  }

  void restore(
    ActivityCancellationRequest request,
    ActivityCancellationResult? result, {
    ActivityBookingRecord? booking,
  }) {
    if (_closed || _busy || _request != null)
      throw StateError('Cancellation controller already initialized');
    ActivityBookingGuard.scope(scope, request.scope);
    ActivityGuard.record(request.validate());
    if (result != null)
      ActivityTransportContracts.cancellation(request, result, now: clock());
    if (booking != null) {
      ActivityGuard.record(booking.validate());
      if (booking.scope != scope || booking.id != request.bookingId)
        throw StateError('Recovered cancellation booking mismatch');
    }
    _request = request;
    _booking = booking;
    if (result?.refund != null) {
      if (booking == null)
        throw StateError('Recovered refund needs booking evidence');
      ActivityAmounts.compatible(booking.total, result!.refund!);
      if (result.refund!.amountMinor > booking.total.amountMinor)
        throw StateError('Recovered refund exceeds booking amount');
    }
    _result = result;
  }

  void close() {
    _closed = true;
    _generation++;
  }
}
