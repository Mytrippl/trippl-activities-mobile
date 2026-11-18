import '../trippl_activities_mobile.dart';

class ActivityPickupChoices {
  static List<String> review(
    ActivityPickup? pickup,
    ActivityPickupChoice? choice, {
    required String optionId,
    required DateTime now,
    bool requireConfirmation = true,
  }) {
    if (pickup == null) {
      if (choice != null)
        throw StateError('Unexpected activity pickup selection');
      return const [];
    }
    ActivityGuard.record(pickup.validate());
    if (!pickup.available) {
      if (choice != null) throw StateError('Pickup is not available');
      return const [];
    }
    if (pickup.cutoffAt != null && !pickup.cutoffAt!.isAfter(now))
      return ['pickupDeadlinePassed'];
    if (choice == null)
      return pickup.requiresSelection ? ['pickupSelectionRequired'] : [];
    ActivityGuard.record(choice.validate());
    if (choice.pickupId != pickup.id ||
        !pickup.pointIds.contains(choice.pointId))
      throw StateError('Pickup identity or point mismatch');
    if (choice.selectedAt != null)
      ActivityBookingGuard.clock(choice.selectedAt!, now);
    if (choice.meetingPoint?.optionId != null &&
        choice.meetingPoint!.optionId != optionId)
      throw StateError('Pickup belongs to a different option');
    return [
      if (requireConfirmation && !choice.confirmed)
        'pickupConfirmationRequired',
    ];
  }

  static ActivityPickupChoice select(
    ActivityPickup pickup,
    ActivityMeetingPoint point, {
    required String optionId,
    required DateTime now,
    bool confirmed = false,
  }) {
    final choice = ActivityPickupChoice(
      pickupId: pickup.id,
      pointId: point.id,
      meetingPoint: point,
      selectedAt: now,
      confirmed: confirmed,
    );
    review(
      pickup,
      choice,
      optionId: optionId,
      now: now,
      requireConfirmation: false,
    );
    return choice;
  }

  static Map<String, Object?> summary(
    ActivityPickup pickup,
    ActivityPickupChoice? choice,
  ) {
    ActivityGuard.record(pickup.validate());
    return Map.unmodifiable({
      'available': pickup.available,
      'included': pickup.included,
      'requiresSelection': pickup.requiresSelection,
      'selectedPointId': choice?.pointId,
      'pointName': choice?.meetingPoint?.name,
      'instructions': choice?.instructions ?? pickup.instructions,
      'confirmed': choice?.confirmed ?? false,
    });
  }
}
