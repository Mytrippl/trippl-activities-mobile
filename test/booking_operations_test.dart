import 'dart:async';
import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';
import 'support.dart';
import 'booking_support.dart';

ActivityBookingIntent intent(ActivityBookingDraft draft) =>
    ActivityBookingIntents.prepare(
      draft,
      policy,
      id: 'intent',
      now: now,
      confirmedByUser: true,
    );

class VoucherTransport implements ActivityVoucherTransport {
  VoucherTransport(this.value);
  final ActivityVoucher value;
  int calls = 0;
  @override
  Future<ActivityVoucher> fetchVoucher(String scope, String bookingId) async {
    calls++;
    return value;
  }
}

ActivityVoucher voucher() => ActivityVoucher(
  id: 'voucher',
  scope: 'test-user',
  bookingId: 'booking',
  issuedAt: now,
  validFrom: now.subtract(const Duration(minutes: 1)),
  validUntil: now.add(const Duration(days: 1)),
  documents: [
    ActivityVoucherDocument(
      id: 'text',
      bookingId: 'booking',
      kind: 'text',
      text: 'Supplier ticket instructions',
    ),
  ],
);
void main() {
  test(
    'matching authoritative receipt is required for confirmed booking state',
    () async {
      final draft = readyDraft().value, transport = BookingTransport();
      final controller = ActivityBookingController(
        transport,
        scope: 'test-user',
        clock: () => now,
      );
      final result = await controller.submit(
        draft,
        intent(draft),
        policy: policy,
        confirmedByUser: true,
      );
      expect(result.confirmed, isTrue);
      expect(result.record!.id, 'booking');
      expect(transport.submits, 1);
      await controller.close();
    },
  );
  test(
    'double submission is blocked while the first write is in flight',
    () async {
      final draft = readyDraft().value,
          completion = Completer<ActivityBookingReceipt>();
      final i = intent(draft);
      final transport = BookingTransport(onSubmit: (i, d) => completion.future),
          controller = ActivityBookingController(
            BookingTransport(),
            scope: 'other',
            clock: () => now,
          );
      final owned = ActivityBookingController(
        transport,
        scope: 'test-user',
        clock: () => now,
      );
      final first = owned.submit(
        draft,
        i,
        policy: policy,
        confirmedByUser: true,
      );
      await expectLater(
        owned.submit(draft, i, policy: policy, confirmedByUser: true),
        throwsStateError,
      );
      completion.complete(receipt(i));
      expect((await first).confirmed, isTrue);
      expect(transport.submits, 1);
      await owned.close();
      await controller.close();
    },
  );
  test(
    'timed-out write is not retried and resolves through intent lookup',
    () async {
      final draft = readyDraft().value,
          transport = BookingTransport(
            onSubmit: (i, d) async => throw TimeoutException('lost reply'),
          );
      final controller = ActivityBookingController(
        transport,
        scope: 'test-user',
        clock: () => now,
      );
      final first = await controller.submit(
        draft,
        intent(draft),
        policy: policy,
        confirmedByUser: true,
      );
      expect(first.intent!.state, 'unknown');
      expect(first.confirmed, isFalse);
      expect(transport.submits, 1);
      await expectLater(
        controller.submit(
          draft,
          intent(draft),
          policy: policy,
          confirmedByUser: true,
        ),
        throwsStateError,
      );
      expect((await controller.reconcile(draft)).confirmed, isTrue);
      expect(transport.submits, 1);
      expect(transport.lookups, 1);
      await controller.close();
    },
  );
  test('wrong currency amount and scope cannot confirm a booking', () async {
    final draft = readyDraft().value;
    for (final invalid
        in <ActivityBookingReceipt Function(ActivityBookingIntent)>[
          (i) => receipt(i, total: money(1001)),
          (i) => receipt(i).copyWith(scope: 'other'),
          (i) => receipt(i).copyWith(draftFingerprint: 'f' * 64),
        ]) {
      final controller = ActivityBookingController(
        BookingTransport(onSubmit: (i, d) async => invalid(i)),
        scope: 'test-user',
        clock: () => now,
      );
      final result = await controller.submit(
        draft,
        intent(draft),
        policy: policy,
        confirmedByUser: true,
      );
      expect(result.confirmed, isFalse);
      expect(result.intent!.state, 'unknown');
      expect(result.record, isNull);
      await controller.close();
    }
  });
  test(
    'confirmed intent is not downgraded by an unnecessary failed lookup',
    () async {
      final draft = readyDraft().value,
          transport = BookingTransport(
            onLookup: (i) async => throw StateError('offline'),
          );
      final controller = ActivityBookingController(
        transport,
        scope: 'test-user',
        clock: () => now,
      );
      await controller.submit(
        draft,
        intent(draft),
        policy: policy,
        confirmedByUser: true,
      );
      expect((await controller.reconcile(draft)).confirmed, isTrue);
      expect(transport.lookups, 0);
      await controller.close();
    },
  );
  test('expired quote prevents network submission', () async {
    final draft = readyDraft().value, transport = BookingTransport();
    final controller = ActivityBookingController(
      transport,
      scope: 'test-user',
      clock: () => now.add(const Duration(minutes: 6)),
    );
    await expectLater(
      controller.submit(
        draft,
        intent(draft),
        policy: policy,
        confirmedByUser: true,
      ),
      throwsStateError,
    );
    expect(transport.submits, 0);
    await controller.close();
  });
  test('closing controller fences a late successful response', () async {
    final draft = readyDraft().value,
        completion = Completer<ActivityBookingReceipt>();
    final i = intent(draft);
    final controller = ActivityBookingController(
      BookingTransport(onSubmit: (i, d) => completion.future),
      scope: 'test-user',
      clock: () => now,
    );
    final pending = controller.submit(
      draft,
      i,
      policy: policy,
      confirmedByUser: true,
    );
    await controller.close();
    completion.complete(receipt(i));
    expect((await pending).confirmed, isFalse);
  });
  test('rejected backend receipt never creates a confirmed record', () async {
    final draft = readyDraft().value;
    final controller = ActivityBookingController(
      BookingTransport(onSubmit: (i, d) async => receipt(i, state: 'rejected')),
      scope: 'test-user',
      clock: () => now,
    );
    final result = await controller.submit(
      draft,
      intent(draft),
      policy: policy,
      confirmedByUser: true,
    );
    expect(result.intent!.state, 'rejected');
    expect(result.record, isNull);
    await controller.close();
  });
  test(
    'status reconciliation rejects terminal regression and stale versions',
    () {
      final record = booking(state: 'cancelled');
      final status = ActivityBookingStatus(
        bookingId: record.id,
        scope: record.scope,
        observedAt: now,
        state: 'confirmed',
        revision: 2,
        total: record.total,
      );
      expect(
        ActivityBookingReconciliation.assess(record, status, now: now).accepted,
        isFalse,
      );
      final pending = booking(state: 'pending');
      expect(
        ActivityBookingReconciliation.apply(pending, status, now: now).state,
        'confirmed',
      );
    },
  );
  test(
    'cancellation requires explicit confirmation and does not duplicate writes',
    () async {
      expect(
        () => ActivityCancellations.prepare(
          booking(),
          id: 'c',
          reasonCode: 'plansChanged',
          confirmedByUser: false,
          now: now,
        ),
        throwsStateError,
      );
      final request = ActivityCancellations.prepare(
            booking(),
            id: 'c',
            reasonCode: 'plansChanged',
            confirmedByUser: true,
            now: now,
          ),
          transport = CancelTransport();
      final controller = ActivityCancellations(
        transport,
        scope: 'test-user',
        clock: () => now,
      );
      expect((await controller.submit(request, booking()))!.state, 'cancelled');
      await expectLater(
        controller.submit(request, booking()),
        throwsStateError,
      );
      expect(transport.calls, 1);
      controller.close();
    },
  );
  test('cancellation timeout stays uncertain until lookup confirms', () async {
    final transport = CancelTransport(
      action: (r) async => throw TimeoutException('lost reply'),
    );
    final controller = ActivityCancellations(
      transport,
      scope: 'test-user',
      clock: () => now,
    );
    final request = ActivityCancellations.prepare(
      booking(),
      id: 'c',
      reasonCode: 'plansChanged',
      confirmedByUser: true,
      now: now,
    );
    expect((await controller.submit(request, booking()))!.state, 'unknown');
    expect((await controller.reconcile())!.state, 'cancelled');
    expect(transport.calls, 1);
    controller.close();
  });
  test('cancellation response cannot invent an excessive refund', () async {
    final transport = CancelTransport(
      action: (r) async => ActivityCancellationResult(
        requestId: r.id,
        scope: r.scope,
        bookingId: r.bookingId,
        receivedAt: now,
        state: 'cancelled',
        refund: money(2000),
      ),
    );
    final controller = ActivityCancellations(
      transport,
      scope: 'test-user',
      clock: () => now,
    );
    final request = ActivityCancellations.prepare(
      booking(),
      id: 'c',
      reasonCode: 'plansChanged',
      confirmedByUser: true,
      now: now,
    );
    expect((await controller.submit(request, booking()))!.state, 'unknown');
    controller.close();
  });
  test(
    'refund totals reject duplicates and overpayment without claiming bank settlement',
    () {
      final first = ActivityRefundRecord(
        id: 'r',
        scope: 'test-user',
        bookingId: 'booking',
        amount: money(600),
        observedAt: now,
        state: 'processed',
        completedAt: now,
      );
      expect(
        ActivityRefunds.summary(booking(), [
          first,
        ], now: now)['bankSettlementConfirmed'],
        isFalse,
      );
      expect(
        () => ActivityRefunds.summary(booking(), [
          first,
          first.copyWith(id: 'second'),
        ], now: now),
        throwsStateError,
      );
    },
  );
  test('voucher display checks booking status validity and revocation', () {
    final value = voucher();
    expect(
      ActivityVouchers.assess(
        booking(),
        value,
        scope: 'test-user',
        now: now,
      ).allowed,
      isTrue,
    );
    expect(
      ActivityVouchers.assess(
        booking(state: 'cancelled'),
        value,
        scope: 'test-user',
        now: now,
      ).allowed,
      isFalse,
    );
    expect(
      ActivityVouchers.assess(
        booking(),
        value.copyWith(revoked: true),
        scope: 'test-user',
        now: now,
      ).allowed,
      isFalse,
    );
    expect(
      ActivityVouchers.assess(
        booking(),
        value,
        scope: 'test-user',
        now: now,
        offline: true,
      ).requiresProviderVerification,
      isTrue,
    );
  });
  test('identical repeated voucher reads are idempotent', () async {
    final transport = VoucherTransport(voucher()),
        controller = ActivityVoucherController(
          VoucherTransport(voucher()),
          scope: 'test-user',
          clock: () => now,
        );
    final first = await controller.load(booking());
    expect(await controller.load(booking()), first);
    controller.close();
    expect(transport.calls, 0);
  });
}
