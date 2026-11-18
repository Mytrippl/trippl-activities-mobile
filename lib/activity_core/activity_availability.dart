import '../trippl_activities_mobile.dart';

class ActivityInventory {
  static ActivityAvailability assess(
    ActivityOption option,
    ActivityAvailabilityRequest request,
    Iterable<ActivitySlot> input, {
    required DateTime now,
    required int offsetMinutes,
  }) {
    ActivityGuard.record(option.validate());
    ActivityGuard.record(request.validate());
    ActivityGuard.canonicalDay(request.travelDate);
    if (request.travelers.travelers.isEmpty) {
      throw const FormatException(
        'Availability requires at least one traveler',
      );
    }
    if (offsetMinutes.abs() > 840)
      throw const FormatException('Invalid activity UTC offset');
    if (request.productId != option.productId || request.optionId != option.id)
      throw const FormatException('Availability option identity mismatch');
    final eligibility = ActivityTravelers.assess(
      request.travelers,
      option.ageBands,
      now: now,
      minimumTravelers: option.minimumTravelers,
      maximumTravelers: option.maximumTravelers,
    );
    final rows = input.toList();
    if (rows.length > 100)
      throw const FormatException('Activity slots exceed capacity');
    ActivityGuard.distinct(rows.map((s) => s.id));
    final warnings = <String>{};
    var stale = false, capacity = false, unknown = false;
    final available = <ActivitySlot>[];
    for (final slot in rows) {
      ActivityGuard.record(slot.validate());
      if (slot.productId != option.productId || slot.optionId != option.id)
        throw const FormatException('Slot selection identity mismatch');
      if (!ActivityGuard.fresh(slot.observedAt, slot.expiresAt, now)) {
        stale = true;
        continue;
      }
      if (!slot.startsAt.isAfter(now)) continue;
      final local = slot.startsAt.toUtc().add(Duration(minutes: offsetMinutes));
      if (ActivityGuard.day(local) != request.travelDate) continue;
      if (request.selectedSlotId != null && slot.id != request.selectedSlotId)
        continue;
      if (request.selectedLanguage != null &&
          (!slot.languageCodes.contains(request.selectedLanguage) ||
              !option.languages.any(
                (l) => l.available && l.code == request.selectedLanguage,
              )))
        continue;
      if (slot.state == 'unknown' || slot.remainingCapacity == null) {
        unknown = true;
        continue;
      }
      if (slot.state != 'available') continue;
      if (slot.remainingCapacity! < eligibility.capacityTravelers) {
        capacity = true;
        continue;
      }
      available.add(slot);
    }
    available.sort((a, b) {
      final c = a.startsAt.compareTo(b.startsAt);
      return c == 0 ? a.id.compareTo(b.id) : c;
    });
    if (!eligibility.eligible) warnings.addAll(eligibility.reasonCodes);
    if (stale) warnings.add('availabilityDataStale');
    if (unknown) warnings.add('capacityOrStatusUnknown');
    if (!option.active) warnings.add('optionInactive');
    final bookable =
        option.active && eligibility.eligible && available.isNotEmpty;
    final state = bookable
        ? 'available'
        : stale
        ? 'stale'
        : unknown
        ? 'unknown'
        : capacity
        ? 'insufficientCapacity'
        : 'unavailable';
    return ActivityAvailability(
      productId: option.productId,
      optionId: option.id,
      evaluatedAt: now,
      slots: available,
      bookable: bookable,
      state: state,
      travelerCount: request.travelers.travelers.length,
      earliestAt: bookable ? available.first.startsAt : null,
      warningCodes: warnings.toList()..sort(),
    );
  }

  static ActivityDeparture departure(
    ActivityOption option,
    ActivityAvailability availability,
    ActivitySelection selection, {
    required DateTime now,
    ActivityMeetingPoint? meeting,
    ActivityPickup? pickup,
  }) {
    ActivityGuard.record(option.validate());
    ActivityGuard.record(availability.validate());
    ActivityGuard.record(selection.validate());
    if (!availability.bookable ||
        selection.productId != option.productId ||
        selection.optionId != option.id ||
        availability.productId != option.productId ||
        availability.optionId != option.id)
      throw StateError('Activity selection is not bookable');
    final slot = availability.slots
        .where((s) => s.id == selection.slotId)
        .firstOrNull;
    if (slot == null ||
        !slot.startsAt.isAfter(now) ||
        !ActivityGuard.fresh(slot.observedAt, slot.expiresAt, now))
      throw StateError('Selected activity slot expired');
    if (selection.languageCode != null &&
        !slot.languageCodes.contains(selection.languageCode))
      throw StateError('Selected slot language unavailable');
    if (meeting != null) {
      ActivityGuard.record(meeting.validate());
      if (meeting.optionId != null && meeting.optionId != option.id)
        throw StateError('Meeting point belongs to another option');
    }
    if (pickup != null) {
      ActivityGuard.record(pickup.validate());
      if (pickup.requiresSelection &&
          (selection.pickupPointId == null ||
              !pickup.pointIds.contains(selection.pickupPointId)))
        throw StateError('Pickup selection required');
      if (pickup.cutoffAt != null && !pickup.cutoffAt!.isAfter(now))
        throw StateError('Pickup selection deadline passed');
    }
    final result = ActivityDeparture(
      productId: option.productId,
      optionId: option.id,
      slotId: slot.id,
      startsAt: slot.startsAt,
      endsAt: slot.endsAt,
      languageCode: selection.languageCode,
      meetingPoint: meeting,
      pickup: pickup,
      requiresConfirmation: true,
      warningCodes: [
        'providerBookingConfirmationRequired',
        if (meeting?.confirmed != true) 'meetingPointNeedsConfirmation',
      ],
    );
    ActivityGuard.record(result.validate());
    return result;
  }
}
