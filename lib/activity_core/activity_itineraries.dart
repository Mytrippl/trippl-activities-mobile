import '../trippl_activities_mobile.dart';

class ActivityItineraries {
  ActivityItineraries(ActivityItinerary itinerary, {required this.clock})
    : _value = itinerary {
    ActivityGuard.record(itinerary.validate());
    ActivityGuard.canonicalDay(itinerary.startDate);
    ActivityGuard.canonicalDay(itinerary.endDate);
    if (itinerary.dayIds.isNotEmpty)
      throw ArgumentError('Use restore for populated activity itineraries');
  }
  final DateTime Function() clock;
  ActivityItinerary _value;
  final _days = <String, ActivityItineraryDay>{},
      _stops = <String, ActivityItineraryStop>{};
  ActivityItinerary get value => _value;
  List<ActivityItineraryDay> get days =>
      List.unmodifiable(_value.dayIds.map((id) => _days[id]!));
  List<ActivityItineraryStop> stops(String dayId) {
    final day = _days[dayId] ?? (throw StateError('Itinerary day missing'));
    return List.unmodifiable(day.stopIds.map((id) => _stops[id]!));
  }

  void _edit(int revision) {
    ActivityGuard.revision(_value.revision, revision);
    if (_value.state == 'archived') throw StateError('Itinerary archived');
  }

  void _touch() {
    _value = _value.copyWith(
      updatedAt: clock(),
      revision: _value.revision + 1,
      state: 'draft',
    );
  }

  ActivityItineraryDay addDay({
    required String id,
    required DateTime date,
    required int offsetMinutes,
    required int expectedRevision,
    int startMinute = 480,
    int endMinute = 1320,
  }) {
    _edit(expectedRevision);
    ActivityGuard.canonicalDay(date);
    if (_days.length >= 91 ||
        _days.containsKey(id) ||
        _days.values.any((d) => d.date == date) ||
        date.isBefore(_value.startDate) ||
        date.isAfter(_value.endDate))
      throw StateError('Invalid itinerary day identity or date');
    final day = ActivityItineraryDay(
      id: id,
      itineraryId: _value.id,
      date: date,
      offsetMinutes: offsetMinutes,
      startMinute: startMinute,
      endMinute: endMinute,
    );
    ActivityGuard.record(day.validate());
    _days[id] = day;
    _value = _value.copyWith(dayIds: [..._value.dayIds, id]);
    _touch();
    return day;
  }

  ActivityItineraryStop addStop(
    String dayId,
    ActivityProduct product, {
    required String id,
    required DateTime startsAt,
    required DateTime endsAt,
    required int expectedRevision,
    int arrivalBufferMinutes = 0,
    int transferMinutes = 0,
    ActivityBookingRecord? booking,
  }) {
    _edit(expectedRevision);
    final day = _days[dayId] ?? (throw StateError('Itinerary day missing'));
    if (_stops.containsKey(id) || _stops.length >= 100)
      throw StateError('Itinerary stop identity or capacity conflict');
    if (booking != null &&
        (booking.scope != _value.scope ||
            booking.productId != product.id ||
            booking.state != 'confirmed' ||
            booking.startsAt != startsAt))
      throw StateError('Itinerary booking is not confirmed for this activity');
    final stop = ActivityItineraryStop(
      id: id,
      dayId: day.id,
      product: product,
      startsAt: startsAt,
      endsAt: endsAt,
      arrivalBufferMinutes: arrivalBufferMinutes,
      transferMinutes: transferMinutes,
      bookingId: booking?.id,
      confirmed: booking != null,
    );
    ActivityGuard.record(stop.validate());
    _stops[id] = stop;
    _days[day.id] = day.copyWith(
      stopIds: [...day.stopIds, id],
      revision: day.revision + 1,
    );
    _touch();
    return stop;
  }

  void removeStop(String id, {required int expectedRevision}) {
    _edit(expectedRevision);
    final stop = _stops[id] ?? (throw StateError('Itinerary stop missing')),
        day = _days[_stops[id]!.dayId]!;
    _stops.remove(id);
    _days[day.id] = day.copyWith(
      stopIds: day.stopIds.where((v) => v != stop.id).toList(),
      revision: day.revision + 1,
    );
    _touch();
  }

  void editStop(
    String id, {
    required int expectedRevision,
    DateTime? startsAt,
    DateTime? endsAt,
    int? arrivalBufferMinutes,
    int? transferMinutes,
  }) {
    _edit(expectedRevision);
    final old = _stops[id] ?? (throw StateError('Itinerary stop missing'));
    if (old.confirmed &&
        (startsAt != null && startsAt != old.startsAt ||
            endsAt != null && endsAt != old.endsAt))
      throw StateError('Confirmed booking times require a backend update');
    final next = old.copyWith(
      startsAt: startsAt,
      endsAt: endsAt,
      arrivalBufferMinutes: arrivalBufferMinutes,
      transferMinutes: transferMinutes,
      revision: old.revision + 1,
    );
    ActivityGuard.record(next.validate());
    _stops[id] = next;
    _touch();
  }

  void reorder(
    String dayId,
    List<String> ids, {
    required int expectedRevision,
  }) {
    _edit(expectedRevision);
    final day = _days[dayId] ?? (throw StateError('Itinerary day missing'));
    if (ids.length != day.stopIds.length ||
        ids.toSet().length != ids.length ||
        ids.any((id) => !day.stopIds.contains(id)))
      throw const FormatException(
        'Itinerary reorder must contain every stop once',
      );
    _days[dayId] = day.copyWith(stopIds: ids, revision: day.revision + 1);
    _touch();
  }

  void removeDay(String id, {required int expectedRevision}) {
    _edit(expectedRevision);
    final day = _days[id] ?? (throw StateError('Itinerary day missing'));
    _stops.removeWhere((_, s) => s.dayId == day.id);
    _days.remove(id);
    _value = _value.copyWith(
      dayIds: _value.dayIds.where((d) => d != id).toList(),
    );
    _touch();
  }

  void moveStop(
    String id,
    String targetDayId, {
    required int expectedRevision,
  }) {
    _edit(expectedRevision);
    final old = _stops[id] ?? (throw StateError('Itinerary stop missing'));
    final source = _days[old.dayId]!,
        target =
            _days[targetDayId] ??
            (throw StateError('Target itinerary day missing'));
    if (source.id == target.id) return;
    final local = old.startsAt.toUtc().add(
      Duration(minutes: target.offsetMinutes),
    );
    if (ActivityGuard.day(local) != target.date)
      throw StateError('Move would put this departure on the wrong local day');
    final next = old.copyWith(dayId: target.id, revision: old.revision + 1);
    ActivityGuard.record(next.validate());
    _days[source.id] = source.copyWith(
      stopIds: source.stopIds.where((s) => s != id).toList(),
      revision: source.revision + 1,
    );
    _days[target.id] = target.copyWith(
      stopIds: [...target.stopIds, id],
      revision: target.revision + 1,
    );
    _stops[id] = next;
    _touch();
  }

  List<ActivityItineraryConflict> conflicts({
    Map<String, ActivityBookingRecord> bookings = const {},
  }) {
    final issues = <ActivityItineraryConflict>[];
    for (final day in days) {
      final rows = stops(day.id).toList()
        ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
      for (var i = 0; i < rows.length; i++) {
        final stop = rows[i],
            localStart = rows[i].startsAt.toUtc().add(
              Duration(minutes: day.offsetMinutes),
            ),
            localEnd = rows[i].endsAt.toUtc().add(
              Duration(minutes: day.offsetMinutes),
            );
        if (ActivityGuard.day(localStart) != day.date ||
            ActivityGuard.day(
                  localEnd.subtract(const Duration(microseconds: 1)),
                ) !=
                day.date)
          issues.add(
            _issue(
              'outsidePlanningDay',
              day.id,
              stop.id,
              'Activity falls outside the planning date',
            ),
          );
        final start =
                localStart.hour * 60 +
                localStart.minute -
                stop.arrivalBufferMinutes,
            end = localEnd.hour * 60 + localEnd.minute;
        if (start < day.startMinute || end > day.endMinute)
          issues.add(
            _issue(
              'outsideDayWindow',
              day.id,
              stop.id,
              'Activity or arrival buffer exceeds the day window',
            ),
          );
        if (i > 0 &&
            rows[i - 1].endsAt.isAfter(
              stop.startsAt.subtract(
                Duration(
                  minutes: stop.arrivalBufferMinutes + stop.transferMinutes,
                ),
              ),
            ))
          issues.add(
            _issue(
              'activityOverlap',
              day.id,
              stop.id,
              'Activities overlap including transfer and arrival buffers',
              related: rows[i - 1].id,
            ),
          );
        if (!stop.confirmed)
          issues.add(
            _issue(
              'unconfirmedActivity',
              day.id,
              stop.id,
              'Activity has no confirmed booking',
              severity: 'warning',
            ),
          );
        if (stop.bookingId != null && bookings.containsKey(stop.bookingId)) {
          final record = bookings[stop.bookingId]!;
          if (record.scope != _value.scope ||
              record.productId != stop.product.id ||
              record.state != 'confirmed')
            issues.add(
              _issue(
                'bookingStatusChanged',
                day.id,
                stop.id,
                'Linked booking needs review',
              ),
            );
        }
      }
    }
    return List.unmodifiable(issues);
  }

  static ActivityItineraryConflict _issue(
    String code,
    String day,
    String stop,
    String message, {
    String? related,
    String severity = 'error',
  }) => ActivityItineraryConflict(
    code: code,
    dayId: day,
    stopId: stop,
    message: message,
    relatedStopId: related,
    severity: severity,
  );
  void ready({required int expectedRevision, bool acceptUnconfirmed = false}) {
    _edit(expectedRevision);
    final issues = conflicts();
    if (_stops.isEmpty ||
        issues.any((i) => i.severity == 'error') ||
        !acceptUnconfirmed && issues.isNotEmpty)
      throw StateError('Itinerary review incomplete');
    _value = _value.copyWith(
      state: 'ready',
      updatedAt: clock(),
      revision: _value.revision + 1,
    );
  }

  Map<String, Object?> toJson() => {
    'schemaVersion': 1,
    'itinerary': _value.toJson(),
    'days': days.map((d) => d.toJson()).toList(),
    'stops': _stops.values.map((s) => s.toJson()).toList(),
  };
  static ActivityItineraries restore(
    Map<String, Object?> json, {
    required String scope,
    required DateTime Function() clock,
  }) {
    ActivityCodec.keys(json, {'schemaVersion', 'itinerary', 'days', 'stops'});
    if (json['schemaVersion'] != 1)
      throw const FormatException('Unsupported itinerary schema');
    final itinerary = ActivityItinerary.fromJson(
      ActivityCodec.object(json['itinerary']),
    );
    ActivityBookingGuard.scope(scope, itinerary.scope);
    if (itinerary.updatedAt.isAfter(clock()))
      throw const FormatException('Itinerary timestamp in future');
    final days = ActivityCodec.list(
      json,
      'days',
      (v) => ActivityItineraryDay.fromJson(ActivityCodec.object(v)),
      required: true,
    )!;
    final stops = ActivityCodec.list(
      json,
      'stops',
      (v) => ActivityItineraryStop.fromJson(ActivityCodec.object(v)),
      required: true,
    )!;
    ActivityGuard.distinct(days.map((d) => d.id));
    ActivityGuard.distinct(stops.map((s) => s.id));
    if (days.length != itinerary.dayIds.length ||
        itinerary.dayIds.any((id) => !days.any((d) => d.id == id)))
      throw StateError('Itinerary day references mismatch');
    final dates = <String>{};
    for (final day in days) {
      ActivityGuard.canonicalDay(day.date);
      if (day.itineraryId != itinerary.id ||
          day.date.isBefore(itinerary.startDate) ||
          day.date.isAfter(itinerary.endDate) ||
          !dates.add(ActivityCodec.calendarText(day.date)))
        throw StateError('Itinerary day date or parent mismatch');
      final rows = stops.where((s) => s.dayId == day.id).toList();
      if (rows.length != day.stopIds.length ||
          day.stopIds.any((id) => !rows.any((s) => s.id == id)))
        throw StateError('Itinerary stop references mismatch');
    }
    if (stops.any(
      (s) =>
          !days.any((d) => d.id == s.dayId) ||
          s.confirmed && s.bookingId == null,
    ))
      throw StateError('Orphan or unbound confirmed itinerary stop');
    final result = ActivityItineraries(
      itinerary.copyWith(dayIds: []),
      clock: clock,
    );
    result._value = itinerary;
    result._days.addEntries(days.map((d) => MapEntry(d.id, d)));
    result._stops.addEntries(stops.map((s) => MapEntry(s.id, s)));
    return result;
  }
}

class ActivityItineraryPresentation {
  static Map<String, Object?> overview(
    ActivityItineraries itinerary, {
    required DateTime now,
    Map<String, ActivityBookingRecord> bookings = const {},
  }) {
    final conflicts = itinerary.conflicts(bookings: bookings);
    var count = 0,
        confirmed = 0,
        minutes = 0,
        arrivalMinutes = 0,
        transfers = 0;
    final includedBookings = <String>{};
    final costs = <String, ActivityMoney>{};
    final days = <Map<String, Object?>>[];
    for (final day in itinerary.days) {
      final stops = itinerary.stops(day.id);
      count += stops.length;
      confirmed += stops.where((stop) => stop.confirmed).length;
      for (final stop in stops) {
        minutes += stop.endsAt.difference(stop.startsAt).inMinutes;
        arrivalMinutes += stop.arrivalBufferMinutes;
        transfers += stop.transferMinutes;
        final booking = bookings[stop.bookingId];
        if (booking == null || !includedBookings.add(booking.id)) continue;
        ActivityGuard.record(booking.validate());
        if (booking.scope != itinerary.value.scope ||
            booking.productId != stop.product.id) {
          throw StateError('Itinerary cost booking identity mismatch');
        }
        if (booking.state != 'confirmed') continue;
        final key = '${booking.total.currency}:${booking.total.decimals}';
        costs[key] = costs.containsKey(key)
            ? ActivityAmounts.add(costs[key]!, booking.total)
            : booking.total;
      }
      days.add(
        Map.unmodifiable({
          'id': day.id,
          'date': ActivityCodec.calendarText(day.date),
          'offsetMinutes': day.offsetMinutes,
          'stopCount': stops.length,
          'errorCount': conflicts
              .where(
                (issue) => issue.dayId == day.id && issue.severity == 'error',
              )
              .length,
          'reviewCount': conflicts
              .where((issue) => issue.dayId == day.id && issue.requiresReview)
              .length,
        }),
      );
    }
    return Map.unmodifiable({
      'id': itinerary.value.id,
      'title': itinerary.value.title,
      'revision': itinerary.value.revision,
      'state': itinerary.value.state,
      'evaluatedAt': now.toUtc().toIso8601String(),
      'days': List.unmodifiable(days),
      'stopCount': count,
      'confirmedStopCount': confirmed,
      'activityMinutes': minutes,
      'arrivalBufferMinutes': arrivalMinutes,
      'transferMinutes': transfers,
      'bookingCostsByCurrency': costs.values
          .map((money) => money.toJson())
          .toList(),
      'currencyConversionApplied': false,
      'conflicts': conflicts.map((issue) => issue.toJson()).toList(),
    });
  }

  static List<Map<String, Object?>> agenda(
    ActivityItineraries itinerary,
    String dayId, {
    required DateTime now,
    required String currency,
    String locale = 'en',
    Map<String, ActivityBookingRecord> bookings = const {},
  }) {
    final day = itinerary.days.where((day) => day.id == dayId).firstOrNull;
    if (day == null) throw StateError('Itinerary day missing');
    final issues = itinerary.conflicts(bookings: bookings);
    final stops = itinerary.stops(dayId).toList()
      ..sort((a, b) => a.startsAt.compareTo(b.startsAt));
    String time(DateTime instant) {
      final local = instant.toUtc().add(Duration(minutes: day.offsetMinutes));
      return '${local.hour.toString().padLeft(2, '0')}:${local.minute.toString().padLeft(2, '0')}';
    }

    return List.unmodifiable([
      for (final stop in stops)
        Map<String, Object?>.unmodifiable({
          'stopId': stop.id,
          'productId': stop.product.id,
          'startTime': time(stop.startsAt),
          'endTime': time(stop.endsAt),
          'arriveBy': time(
            stop.startsAt.subtract(
              Duration(minutes: stop.arrivalBufferMinutes),
            ),
          ),
          'confirmed': stop.confirmed,
          'bookingState': bookings[stop.bookingId]?.state,
          'card': ActivityPresentation.card(
            stop.product,
            now: now,
            currency: currency,
            locale: locale,
          ).toJson(),
          'issues': issues
              .where((issue) => issue.stopId == stop.id)
              .map((issue) => issue.toJson())
              .toList(),
        }),
    ]);
  }
}
