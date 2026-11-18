import '../trippl_activities_mobile.dart';

class ActivityBookingTravelers {
  static int ageOn(DateTime birth, DateTime travelDate) {
    ActivityGuard.canonicalDay(birth);
    ActivityGuard.canonicalDay(travelDate);
    if (birth.isAfter(travelDate))
      throw const FormatException('Traveler birth date is after travel');
    var age = travelDate.year - birth.year;
    if (travelDate.month < birth.month ||
        travelDate.month == birth.month && travelDate.day < birth.day)
      age--;
    if (age > 120)
      throw const FormatException('Traveler age exceeds supported range');
    return age;
  }

  static List<String> review(
    ActivityTravelerMix party,
    List<ActivityBookingTraveler> details, {
    required DateTime travelDate,
    bool requireNames = false,
  }) {
    ActivityGuard.record(party.validate());
    ActivityGuard.canonicalDay(travelDate);
    if (details.length > 100)
      throw const FormatException('Traveler detail count exceeds capacity');
    ActivityGuard.distinct(details.map((d) => d.travelerId));
    final reasons = <String>[];
    if (details.where((d) => d.lead).length > 1)
      throw const FormatException('More than one lead traveler');
    for (final detail in details) {
      ActivityGuard.record(detail.validate());
      final traveler = party.travelers
          .where((t) => t.id == detail.travelerId)
          .firstOrNull;
      if (traveler == null || traveler.age != detail.age)
        throw StateError('Booking traveler does not match validated party');
      if (detail.dateOfBirth != null &&
          ageOn(detail.dateOfBirth!, travelDate) != traveler.age)
        reasons.add('travelerAgeChanged:${traveler.id}');
      if (detail.givenName != null) ActivityContacts.name(detail.givenName!);
      if (detail.familyName != null) ActivityContacts.name(detail.familyName!);
    }
    if (requireNames)
      for (final traveler in party.travelers) {
        final detail = details
            .where((d) => d.travelerId == traveler.id)
            .firstOrNull;
        if (detail?.givenName == null || detail?.familyName == null)
          reasons.add('travelerNamesRequired:${traveler.id}');
      }
    return List.unmodifiable(reasons);
  }

  static List<ActivityBookingTraveler> replace(
    List<ActivityBookingTraveler> rows,
    ActivityBookingTraveler value, {
    required ActivityTravelerMix party,
    required DateTime travelDate,
    required int expectedRevision,
  }) {
    final old = rows.where((d) => d.travelerId == value.travelerId).firstOrNull;
    ActivityGuard.revision(old?.revision ?? 0, expectedRevision);
    if (value.revision != expectedRevision + 1)
      throw StateError('Traveler details revision mismatch');
    final result = [
      ...rows.where((d) => d.travelerId != value.travelerId),
      value,
    ];
    review(party, result, travelDate: travelDate);
    return List.unmodifiable(result);
  }
}
