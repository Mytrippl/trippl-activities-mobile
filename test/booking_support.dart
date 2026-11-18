import 'dart:async';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';
import 'support.dart';

final policy = ActivityConfirmationPolicy(termsVersion: 'v1');
ActivityBookingDrafts readyDraft({
  String id = 'draft',
  List<ActivityQuestion> questions = const [],
}) {
  final selection = availability(slotId: 'slot');
  final value = ActivityBookingDrafts.create(
    id: id,
    scope: 'test-user',
    product: product(),
    slot: slot(),
    selection: selection,
    offsetMinutes: 0,
    now: now,
    questions: questions,
  );
  final draft = ActivityBookingDrafts(value, clock: () => now);
  draft.contact(
    ActivityBookingContact(email: 'guest@example.com', updatedAt: now),
    expectedRevision: draft.value.revision,
  );
  final request = ActivityRequests(
    scope: 'test-user',
    clock: () => now,
  ).availability(selection, quote: true);
  final quote = ActivityPriceQuote(
    id: 'quote',
    productId: 'product',
    optionId: 'option',
    slotId: 'slot',
    requestFingerprint: ActivityRequests.fingerprint(request),
    observedAt: now,
    expiresAt: now.add(const Duration(minutes: 5)),
    total: money(1000),
    indicative: false,
  );
  draft.quote(quote, request, expectedRevision: draft.value.revision);
  draft.acceptTerms(
    id: 'terms',
    termsVersion: 'v1',
    accepted: true,
    expectedRevision: draft.value.revision,
  );
  return draft;
}

ActivityBookingReceipt receipt(
  ActivityBookingIntent intent, {
  String state = 'confirmed',
  int revision = 1,
  ActivityMoney? total,
}) => ActivityBookingReceipt(
  intentId: intent.id,
  scope: intent.scope,
  draftFingerprint: intent.draftFingerprint,
  receivedAt: now,
  state: state,
  bookingId: state == 'confirmed' ? 'booking' : null,
  total: state == 'confirmed' ? (total ?? intent.total) : null,
  revision: revision,
);
ActivityBookingRecord booking({String state = 'confirmed'}) =>
    ActivityBookingRecord(
      id: 'booking',
      scope: 'test-user',
      productId: 'product',
      optionId: 'option',
      slotId: 'slot',
      startsAt: now.add(const Duration(hours: 2)),
      createdAt: now,
      updatedAt: now,
      total: money(1000),
      state: state,
      intentId: 'intent',
    );

class BookingTransport implements ActivityBookingTransport {
  BookingTransport({this.onSubmit, this.onLookup, this.onStatus});
  final Future<ActivityBookingReceipt> Function(
    ActivityBookingIntent,
    ActivityBookingDraft,
  )?
  onSubmit;
  final Future<ActivityBookingReceipt> Function(ActivityBookingIntent)?
  onLookup;
  final Future<ActivityBookingStatus> Function(String, String)? onStatus;
  int submits = 0, lookups = 0;
  @override
  Future<ActivityBookingReceipt> submit(
    ActivityBookingIntent i,
    ActivityBookingDraft d,
  ) {
    submits++;
    return onSubmit?.call(i, d) ?? Future.value(receipt(i));
  }

  @override
  Future<ActivityBookingReceipt> lookupIntent(ActivityBookingIntent i) {
    lookups++;
    return onLookup?.call(i) ?? Future.value(receipt(i, revision: 2));
  }

  @override
  Future<ActivityBookingStatus> status(String s, String b) async =>
      onStatus == null
      ? ActivityBookingStatus(
          bookingId: b,
          scope: s,
          observedAt: now,
          state: 'confirmed',
        )
      : await onStatus!(s, b);
}

class CancelTransport implements ActivityCancellationTransport {
  CancelTransport({this.action, this.lookup});
  final Future<ActivityCancellationResult> Function(
    ActivityCancellationRequest,
  )? action,
      lookup;
  int calls = 0;
  @override
  Future<ActivityCancellationResult> cancel(ActivityCancellationRequest r) {
    calls++;
    return action?.call(r) ??
        Future.value(
          ActivityCancellationResult(
            requestId: r.id,
            scope: r.scope,
            bookingId: r.bookingId,
            receivedAt: now,
            state: 'cancelled',
          ),
        );
  }

  @override
  Future<ActivityCancellationResult> lookupCancellation(
    ActivityCancellationRequest r,
  ) =>
      lookup?.call(r) ??
      Future.value(
        ActivityCancellationResult(
          requestId: r.id,
          scope: r.scope,
          bookingId: r.bookingId,
          receivedAt: now,
          state: 'cancelled',
          revision: 2,
        ),
      );
}

class ProtectedMemory implements ActivityProtectedStorage {
  final values = <String, String>{};
  Future<void> Function()? beforeWrite, beforeRead;
  @override
  Future<String?> readProtected(String key) async {
    await beforeRead?.call();
    return values[key];
  }

  @override
  Future<void> writeProtected(String key, String value) async {
    await beforeWrite?.call();
    values[key] = value;
  }

  @override
  Future<void> removeProtected(String key) async {
    values.remove(key);
  }
}

class SavedTransport implements ActivitySavedSyncTransport {
  SavedTransport(this.action);
  final Future<ActivitySyncAck> Function(ActivitySyncBatch) action;
  @override
  Future<ActivitySyncAck> send(ActivitySyncBatch b) => action(b);
}
