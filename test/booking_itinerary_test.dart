import 'dart:convert';
import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';
import 'support.dart';
import 'booking_support.dart';

ActivityItineraries itinerary() => ActivityItineraries(
  ActivityItinerary(
    id: 'trip',
    scope: 'test-user',
    title: 'Weekend',
    startDate: DateTime.utc(2026, 11, 18),
    endDate: DateTime.utc(2026, 11, 20),
    createdAt: now,
    updatedAt: now,
  ),
  clock: () => now,
);
void main() {
  test('itinerary conflicts include transfer and arrival buffers', () {
    final trip = itinerary();
    trip.addDay(
      id: 'day',
      date: DateTime.utc(2026, 11, 18),
      offsetMinutes: 0,
      expectedRevision: 1,
    );
    trip.addStop(
      'day',
      product(),
      id: 'a',
      startsAt: now.add(const Duration(hours: 1)),
      endsAt: now.add(const Duration(hours: 2)),
      expectedRevision: 2,
    );
    trip.addStop(
      'day',
      product(id: 'other'),
      id: 'b',
      startsAt: now.add(const Duration(hours: 2, minutes: 10)),
      endsAt: now.add(const Duration(hours: 3)),
      arrivalBufferMinutes: 15,
      expectedRevision: 3,
    );
    expect(trip.conflicts().map((i) => i.code), contains('activityOverlap'));
    expect(
      () => trip.ready(expectedRevision: 4, acceptUnconfirmed: true),
      throwsStateError,
    );
  });
  test(
    'confirmed booking times cannot be changed as a local planning edit',
    () {
      final trip = itinerary();
      trip.addDay(
        id: 'day',
        date: DateTime.utc(2026, 11, 18),
        offsetMinutes: 0,
        expectedRevision: 1,
      );
      trip.addStop(
        'day',
        product(),
        id: 'a',
        startsAt: booking().startsAt,
        endsAt: booking().startsAt.add(const Duration(hours: 1)),
        booking: booking(),
        expectedRevision: 2,
      );
      expect(
        () => trip.editStop(
          'a',
          expectedRevision: 3,
          startsAt: now.add(const Duration(hours: 3)),
        ),
        throwsStateError,
      );
    },
  );
  test('itinerary snapshots validate graph references and owner scope', () {
    final trip = itinerary();
    trip.addDay(
      id: 'day',
      date: DateTime.utc(2026, 11, 18),
      offsetMinutes: 0,
      expectedRevision: 1,
    );
    trip.addStop(
      'day',
      product(),
      id: 'a',
      startsAt: now.add(const Duration(hours: 1)),
      endsAt: now.add(const Duration(hours: 2)),
      expectedRevision: 2,
    );
    final restored = ActivityItineraries.restore(
      trip.toJson(),
      scope: 'test-user',
      clock: () => now,
    );
    expect(restored.toJson(), trip.toJson());
    expect(
      () => ActivityItineraries.restore(
        trip.toJson(),
        scope: 'other',
        clock: () => now,
      ),
      throwsStateError,
    );
  });
  test('removing itinerary day removes its referenced activity stops', () {
    final trip = itinerary();
    trip.addDay(
      id: 'day',
      date: DateTime.utc(2026, 11, 18),
      offsetMinutes: 0,
      expectedRevision: 1,
    );
    trip.addStop(
      'day',
      product(),
      id: 'a',
      startsAt: now.add(const Duration(hours: 1)),
      endsAt: now.add(const Duration(hours: 2)),
      expectedRevision: 2,
    );
    trip.removeDay('day', expectedRevision: 3);
    expect(trip.days, isEmpty);
    expect(
      ActivityItineraries.restore(
        trip.toJson(),
        scope: 'test-user',
        clock: () => now,
      ).days,
      isEmpty,
    );
  });
  test('calendar export requires review and retains provider attribution', () {
    final trip = itinerary();
    trip.addDay(
      id: 'day',
      date: DateTime.utc(2026, 11, 18),
      offsetMinutes: 0,
      expectedRevision: 1,
    );
    trip.addStop(
      'day',
      product().copyWith(
        attributions: [
          ActivityAttribution(id: 'provider', displayName: 'Tour provider'),
        ],
      ),
      id: 'a',
      startsAt: now.add(const Duration(hours: 1)),
      endsAt: now.add(const Duration(hours: 2)),
      expectedRevision: 2,
    );
    expect(
      () => ActivityPortability.calendar(trip, id: 'e', now: now),
      throwsStateError,
    );
    final content = ActivityPortability.calendar(
      trip,
      id: 'e',
      now: now,
      acceptUnconfirmed: true,
    ).content;
    expect(content, contains('STATUS:TENTATIVE'));
    expect(content, contains('Tour provider'));
    expect(content, contains('DTSTART:20261118T130000Z'));
  });
  test('saved export defaults omit notes and coordinates', () async {
    final library = ActivitySavedLibrary(scope: 'test-user', clock: () => now);
    library.save(product(), id: 'p', note: 'Private note');
    final export = ActivityPortability.saved(
      library.checkpoint(),
      id: 'e',
      now: now,
    );
    final raw = (jsonDecode(export.content) as Map)['products'] as List;
    expect((raw.single as Map).containsKey('note'), isFalse);
    expect((raw.single as Map).containsKey('coordinate'), isFalse);
    await library.close();
  });
  test('CSV titles cannot execute spreadsheet formulas', () async {
    final library = ActivitySavedLibrary(scope: 'test-user', clock: () => now);
    library.save(product(title: '=HYPERLINK("unsafe")'), id: 'p');
    final export = ActivityPortability.saved(
      library.checkpoint(),
      id: 'e',
      now: now,
      policy: ActivityExportPolicy(format: 'csv'),
    );
    expect(export.content, contains("'=HYPERLINK"));
    await library.close();
  });
  test(
    'imports require confirmation and do not create booking records',
    () async {
      final library = ActivitySavedLibrary(
        scope: 'test-user',
        clock: () => now,
      );
      library.save(product(), id: 'p');
      final content = ActivityPortability.saved(
        library.checkpoint(),
        id: 'e',
        now: now,
      ).content;
      final preview = ActivityPortability.preview(
        content,
        id: 'preview',
        now: now,
      );
      final target = ActivityDeviceCheckpoint(
        scope: 'test-user',
        savedAt: now,
        revision: 1,
      );
      expect(
        () => ActivityPortability.apply(
          preview,
          target,
          confirmedByUser: false,
          expectedRevision: 1,
          now: now,
          idPrefix: 'import',
        ),
        throwsStateError,
      );
      final applied = ActivityPortability.apply(
        preview,
        target,
        confirmedByUser: true,
        expectedRevision: 1,
        now: now,
        idPrefix: 'import',
      );
      expect(applied.saved.single.product.id, 'product');
      expect(target.saved, isEmpty);
      await library.close();
    },
  );
}
