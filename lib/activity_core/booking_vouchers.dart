import 'dart:async';
import '../trippl_activities_mobile.dart';

class ActivityVouchers {
  static ActivityVoucherAccess assess(
    ActivityBookingRecord booking,
    ActivityVoucher voucher, {
    required String scope,
    required DateTime now,
    bool offline = false,
  }) {
    ActivityGuard.record(booking.validate());
    ActivityGuard.record(voucher.validate());
    ActivityBookingGuard.scope(scope, booking.scope);
    ActivityBookingGuard.scope(scope, voucher.scope);
    if (voucher.bookingId != booking.id)
      throw StateError('Voucher booking identity mismatch');
    final reasons = <String>[];
    if (booking.state != 'confirmed') reasons.add('bookingNotConfirmed');
    if (voucher.revoked) reasons.add('voucherRevoked');
    if (voucher.issuedAt.isAfter(now)) reasons.add('voucherIssuedInFuture');
    if (now.isBefore(voucher.validFrom)) reasons.add('voucherNotYetValid');
    if (!voucher.validUntil.isAfter(now)) reasons.add('voucherExpired');
    if (voucher.documents.isEmpty) reasons.add('voucherDocumentMissing');
    for (final document in voucher.documents) {
      if (document.uri != null) ActivityGuard.https(document.uri!);
      if (document.expiresAt != null && !document.expiresAt!.isAfter(now))
        reasons.add('voucherDocumentExpired');
    }
    return ActivityVoucherAccess(
      voucherId: voucher.id,
      bookingId: booking.id,
      evaluatedAt: now,
      allowed: reasons.isEmpty,
      reasonCodes: reasons.toSet().toList(),
      offline: offline,
      requiresProviderVerification: offline,
    );
  }

  static Map<String, Object?> display(
    ActivityBookingRecord booking,
    ActivityVoucher voucher, {
    required String scope,
    required DateTime now,
    bool offline = false,
  }) {
    final access = assess(
      booking,
      voucher,
      scope: scope,
      now: now,
      offline: offline,
    );
    if (!access.allowed)
      throw StateError('Voucher is not eligible for display');
    return Map.unmodifiable({
      'id': voucher.id,
      'bookingId': booking.id,
      'validUntil': voucher.validUntil.toIso8601String(),
      'documents': voucher.documents.map((d) => d.toJson()).toList(),
      'instructions': voucher.instructions,
      'offline': offline,
      'requiresProviderVerification': access.requiresProviderVerification,
    });
  }

  static ActivityVoucher replace(
    ActivityVoucher old,
    ActivityVoucher next, {
    required int expectedRevision,
  }) {
    ActivityGuard.revision(old.revision, expectedRevision);
    ActivityGuard.record(next.validate());
    if (next.id != old.id ||
        next.scope != old.scope ||
        next.bookingId != old.bookingId ||
        next.revision <= old.revision ||
        next.issuedAt.isBefore(old.issuedAt))
      throw StateError('Voucher identity or revision changed');
    return next;
  }
}

class ActivityVoucherController {
  ActivityVoucherController(
    this.transport, {
    required this.scope,
    required this.clock,
    this.timeout = const Duration(seconds: 15),
  }) {
    ActivityGuard.identity(scope);
    if (timeout <= Duration.zero || timeout > const Duration(minutes: 2))
      throw ArgumentError('Invalid voucher read timeout');
  }
  final ActivityVoucherTransport transport;
  final String scope;
  final DateTime Function() clock;
  final Duration timeout;
  ActivityVoucher? _voucher;
  bool _closed = false;
  int _generation = 0;
  ActivityVoucher? get voucher => _voucher;
  Future<ActivityVoucher?> load(ActivityBookingRecord booking) async {
    if (_closed) throw StateError('Voucher controller closed');
    ActivityBookingGuard.scope(scope, booking.scope);
    if (booking.state != 'confirmed')
      throw StateError('Voucher reads need a confirmed booking');
    final generation = ++_generation;
    try {
      final value = await transport
          .fetchVoucher(scope, booking.id)
          .timeout(timeout);
      if (_closed || generation != _generation) return null;
      ActivityVouchers.assess(booking, value, scope: scope, now: clock());
      if (_voucher == value) return value;
      if (_voucher != null && _voucher!.bookingId == booking.id)
        ActivityVouchers.replace(
          _voucher!,
          value,
          expectedRevision: _voucher!.revision,
        );
      _voucher = value;
      return value;
    } catch (_) {
      if (_closed || generation != _generation) return null;
      throw const ActivityOperationException(
        'voucherReadFailed',
        retryable: true,
      );
    }
  }

  void cancel() {
    _generation++;
  }

  void clear() {
    if (_closed) throw StateError('Voucher controller closed');
    _generation++;
    _voucher = null;
  }

  void close() {
    _generation++;
    _closed = true;
    _voucher = null;
  }
}
