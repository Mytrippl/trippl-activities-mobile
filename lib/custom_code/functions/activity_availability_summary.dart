Map<String, dynamic> activityAvailabilitySummary(
  dynamic availability,
  int? requestedTravelers,
) {
  final travelerCount =
      requestedTravelers != null && requestedTravelers > 0
          ? requestedTravelers
          : 1;

  if (availability is! Map) {
    return {
      'available': false,
      'bookable': false,
      'travelerCount': travelerCount,
      'remainingCapacity': null,
      'earliestTime': null,
      'slotCount': 0,
      'status': 'unavailable',
    };
  }

  final map = Map<String, dynamic>.from(availability);

  final explicitlyAvailable = _availabilityBool(
    map,
    ['available', 'isAvailable', 'bookable'],
  );

  final remainingCapacity = _availabilityInt(
    map,
    [
      'remainingCapacity',
      'availableSpots',
      'remaining',
      'capacity',
    ],
  );

  final slots = _availabilitySlots(map);

  String? earliestTime;

  if (slots.isNotEmpty) {
    final times = <DateTime>[];

    for (final slot in slots) {
      if (slot is String) {
        final parsed = DateTime.tryParse(slot);

        if (parsed != null) {
          times.add(parsed);
        }
      } else if (slot is Map) {
        final rawTime =
            slot['startTime'] ??
            slot['start'] ??
            slot['dateTime'] ??
            slot['time'];

        if (rawTime is String) {
          final parsed = DateTime.tryParse(rawTime);

          if (parsed != null) {
            times.add(parsed);
          }
        }
      }
    }

    if (times.isNotEmpty) {
      times.sort();
      earliestTime = times.first.toIso8601String();
    }
  }

  final enoughCapacity =
      remainingCapacity == null ||
      remainingCapacity >= travelerCount;

  final hasSlots =
      slots.isNotEmpty ||
      explicitlyAvailable == true;

  final available =
      explicitlyAvailable != false &&
      enoughCapacity &&
      hasSlots;

  String status;

  if (!enoughCapacity) {
    status = 'insufficient_capacity';
  } else if (explicitlyAvailable == false) {
    status = 'unavailable';
  } else if (slots.isEmpty && explicitlyAvailable != true) {
    status = 'no_slots';
  } else {
    status = 'available';
  }

  return {
    'available': available,
    'bookable': available,
    'travelerCount': travelerCount,
    'remainingCapacity': remainingCapacity,
    'earliestTime': earliestTime,
    'slotCount': slots.length,
    'status': status,
  };
}

List<dynamic> _availabilitySlots(
  Map<String, dynamic> map,
) {
  final possibleValues = [
    map['slots'],
    map['timeslots'],
    map['timeSlots'],
    map['availability'],
  ];

  for (final value in possibleValues) {
    if (value is List) {
      return List<dynamic>.from(value);
    }
  }

  return [];
}

int? _availabilityInt(
  Map<String, dynamic> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = map[key];

    if (value is int) {
      return value;
    }

    if (value is num) {
      return value.round();
    }

    if (value is String) {
      final parsed = int.tryParse(value.trim());

      if (parsed != null) {
        return parsed;
      }
    }
  }

  return null;
}

bool? _availabilityBool(
  Map<String, dynamic> map,
  List<String> keys,
) {
  for (final key in keys) {
    final value = map[key];

    if (value is bool) {
      return value;
    }

    if (value is String) {
      switch (value.trim().toLowerCase()) {
        case 'true':
        case 'yes':
        case 'available':
          return true;

        case 'false':
        case 'no':
        case 'unavailable':
        case 'sold_out':
          return false;
      }
    }
  }

  return null;
}
