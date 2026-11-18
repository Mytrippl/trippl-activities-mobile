import '../trippl_activities_mobile.dart';

/// The host supplies authenticated backend operations. Implementations must
/// authorize account scope and enforce idempotency and supplier-side revisions.
abstract interface class ActivityBookingTransport {
  Future<ActivityBookingReceipt> submit(
    ActivityBookingIntent intent,
    ActivityBookingDraft draft,
  );
  Future<ActivityBookingReceipt> lookupIntent(ActivityBookingIntent intent);
  Future<ActivityBookingStatus> status(String scope, String bookingId);
}

abstract interface class ActivityCancellationTransport {
  Future<ActivityCancellationResult> cancel(
    ActivityCancellationRequest request,
  );
  Future<ActivityCancellationResult> lookupCancellation(
    ActivityCancellationRequest request,
  );
}

abstract interface class ActivityVoucherTransport {
  Future<ActivityVoucher> fetchVoucher(String scope, String bookingId);
}

abstract interface class ActivitySavedSyncTransport {
  Future<ActivitySyncAck> send(ActivitySyncBatch batch);
}

class ActivityOperationException implements Exception {
  const ActivityOperationException(
    this.code, {
    this.retryable = false,
    this.uncertain = false,
  });
  final String code;
  final bool retryable, uncertain;
  @override
  String toString() => 'Activity operation failed';
}

class ActivityTransportContracts {
  static void status(
    ActivityBookingRecord record,
    ActivityBookingStatus value, {
    required DateTime now,
  }) {
    ActivityGuard.record(record.validate());
    ActivityGuard.record(value.validate());
    ActivityBookingGuard.scope(record.scope, value.scope);
    if (value.bookingId != record.id || value.observedAt.isAfter(now))
      throw StateError('Activity status response identity or clock mismatch');
    if (value.total != null && value.total != record.total)
      throw StateError('Activity status response total changed');
  }

  static void cancellation(
    ActivityCancellationRequest request,
    ActivityCancellationResult result, {
    required DateTime now,
  }) {
    ActivityGuard.record(request.validate());
    ActivityGuard.record(result.validate());
    ActivityBookingGuard.scope(request.scope, result.scope);
    if (result.requestId != request.id ||
        result.bookingId != request.bookingId ||
        result.receivedAt.isBefore(request.createdAt) ||
        result.receivedAt.isAfter(now))
      throw StateError('Cancellation response identity or clock mismatch');
  }
}
