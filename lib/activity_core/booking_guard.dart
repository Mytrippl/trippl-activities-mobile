import '../trippl_activities_mobile.dart';

class ActivityBookingGuard {
  static void scope(String expected, String actual) {
    ActivityGuard.identity(expected);
    ActivityGuard.identity(actual);
    if (expected != actual) throw StateError('Activity account scope mismatch');
  }

  static void clock(DateTime instant, DateTime now) {
    if (instant.isAfter(now))
      throw const FormatException('Activity event is in the future');
  }

  static String fingerprint(ActivityBookingDraft draft) {
    ActivityGuard.record(draft.validate());
    final json = draft.toJson()
      ..remove('state')
      ..remove('revision')
      ..remove('updatedAt');
    return ActivityCodec.digest(json);
  }

  static void draft(
    ActivityBookingDraft draft, {
    required String scope,
    required DateTime now,
  }) {
    ActivityGuard.record(draft.validate());
    ActivityBookingGuard.scope(scope, draft.scope);
    ActivityGuard.identity(draft.id);
    ActivityGuard.canonicalDay(draft.travelDate);
    clock(draft.updatedAt, now);
    final local = draft.slot.startsAt.toUtc().add(
      Duration(minutes: draft.offsetMinutes),
    );
    if (ActivityGuard.day(local) != draft.travelDate)
      throw const FormatException('Draft travel day and slot differ');
    final option = draft.product.options
        .where((o) => o.id == draft.optionId && o.active)
        .firstOrNull;
    if (option == null) throw StateError('Draft activity option unavailable');
    if (draft.slot.productId != draft.product.id ||
        draft.slot.optionId != option.id)
      throw StateError('Draft selected slot mismatch');
    ActivityGuard.distinct(draft.questions.map((q) => q.id));
    ActivityGuard.distinct(draft.travelerDetails.map((t) => t.travelerId));
    if (draft.answers != null && draft.answers!.draftId != draft.id)
      throw StateError('Draft answer set parent mismatch');
    if (draft.terms != null &&
        (draft.terms!.scope != scope || draft.terms!.draftId != draft.id))
      throw StateError('Draft terms parent mismatch');
    if (draft.quote != null &&
        (draft.quote!.productId != draft.product.id ||
            draft.quote!.optionId != draft.optionId ||
            draft.quote!.slotId != draft.slot.id))
      throw StateError('Draft quote selection mismatch');
  }

  static void receipt(
    ActivityBookingIntent intent,
    ActivityBookingReceipt receipt, {
    required DateTime now,
  }) {
    ActivityGuard.record(intent.validate());
    ActivityGuard.record(receipt.validate());
    scope(intent.scope, receipt.scope);
    if (receipt.intentId != intent.id ||
        receipt.draftFingerprint != intent.draftFingerprint ||
        receipt.receivedAt.isBefore(intent.createdAt) ||
        receipt.receivedAt.isAfter(now))
      throw StateError('Booking receipt identity or clock mismatch');
    if (receipt.total != null && receipt.total != intent.total)
      throw StateError('Booking receipt total differs from accepted quote');
    if (receipt.state == 'confirmed' &&
        (receipt.bookingId == null || receipt.total == null))
      throw StateError('Confirmation has no booking reference or total');
  }

  static String safeCode(String value) =>
      RegExp(r'^[A-Za-z0-9_-]{1,80}$').hasMatch(value)
      ? value
      : 'operationFailed';
}
