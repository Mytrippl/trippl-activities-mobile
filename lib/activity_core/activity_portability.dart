import 'dart:convert';
import '../trippl_activities_mobile.dart';

class ActivityPortability {
  static ActivityExportBundle saved(
    ActivityDeviceCheckpoint checkpoint, {
    required String id,
    required DateTime now,
    ActivityExportPolicy? policy,
  }) {
    ActivitySavedLibrary.validateCheckpoint(
      checkpoint,
      scope: checkpoint.scope,
      now: now,
    );
    final rules = policy ?? ActivityExportPolicy();
    ActivityGuard.record(rules.validate());
    if (rules.format == 'calendar' ||
        checkpoint.saved.length > rules.maximumItems)
      throw const FormatException('Invalid saved export format or item count');
    final rows = <Map<String, Object?>>[];
    for (final saved in checkpoint.saved) {
      final product = saved.product;
      rows.add({
        'id': product.id,
        'title': product.title,
        'attributions': ActivityDetails.credits(
          provider: product.attributions,
          photos: product.photos,
          reviews: product.reviews,
        ).map((a) => a.toJson()).toList(),
        if (rules.includeCoordinates && product.coordinate != null)
          'coordinate': product.coordinate!.toJson(),
        if (rules.includeNotes && saved.note != null) 'note': saved.note,
      });
    }
    final content = rules.format == 'csv'
        ? _csv(rows)
        : jsonEncode({'schemaVersion': 1, 'products': rows});
    final result = ActivityExportBundle(
      id: id,
      scope: checkpoint.scope,
      createdAt: now,
      format: rules.format,
      content: content,
      digest: ActivityCodec.digest(content),
      itemCount: rows.length,
      warningCodes: [
        if (!rules.includeNotes) 'notesOmitted',
        if (!rules.includeCoordinates) 'coordinatesOmitted',
      ],
    );
    ActivityGuard.record(result.validate());
    return result;
  }

  static String _cell(Object? value) {
    var text = value?.toString() ?? '';
    if (RegExp(r'^\s*[=+@-]').hasMatch(text)) text = "'" + text;
    return '"' + text.replaceAll('"', '""') + '"';
  }

  static String _csv(List<Map<String, Object?>> rows) =>
      [
        'id,title,latitude,longitude,note,attributions',
        for (final row in rows)
          [
            row['id'],
            row['title'],
            (row['coordinate'] as Map?)?['latitude'],
            (row['coordinate'] as Map?)?['longitude'],
            row['note'],
            jsonEncode(row['attributions']),
          ].map(_cell).join(','),
      ].join('\r\n') +
      '\r\n';
  static ActivityImportPreview preview(
    String text, {
    required String id,
    required DateTime now,
    Set<String> existingIds = const {},
  }) {
    final root = ActivityCodec.decode(text, maximumBytes: 100000);
    ActivityCodec.keys(root, {'schemaVersion', 'products'});
    if (root['schemaVersion'] != 1 ||
        root['products'] is! List ||
        (root['products'] as List).length > 100)
      throw const FormatException('Unsupported activity import');
    final products = <ActivityProduct>[],
        duplicates = <String>{},
        warnings = <String>{},
        seen = {...existingIds};
    var rejected = 0;
    for (final raw in root['products'] as List) {
      try {
        final row = ActivityGuard.object(raw);
        ActivityCodec.keys(row, {
          'id',
          'title',
          'coordinate',
          'attributions',
          'note',
        });
        final product = ActivityProduct.fromJson({
          'id': row['id'],
          'title': row['title'],
          if (row['coordinate'] != null) 'coordinate': row['coordinate'],
          'attributions': row['attributions'] ?? [],
        });
        if (!seen.add(product.id)) {
          duplicates.add(product.id);
          continue;
        }
        products.add(product);
        if (row['note'] != null) warnings.add('importedNotesOmitted');
      } catch (_) {
        rejected++;
        warnings.add('invalidImportedActivity');
      }
    }
    return ActivityImportPreview(
      id: id,
      evaluatedAt: now,
      sourceDigest: ActivityCodec.digest(root),
      products: products,
      duplicateIds: duplicates.toList(),
      rejectedCount: rejected,
      warningCodes: warnings.toList(),
    );
  }

  static ActivityDeviceCheckpoint apply(
    ActivityImportPreview preview,
    ActivityDeviceCheckpoint checkpoint, {
    required bool confirmedByUser,
    required int expectedRevision,
    required DateTime now,
    required String idPrefix,
  }) {
    if (!confirmedByUser)
      throw StateError('Activity import requires confirmation');
    ActivityGuard.revision(checkpoint.revision, expectedRevision);
    ActivitySavedLibrary.validateCheckpoint(
      checkpoint,
      scope: checkpoint.scope,
      now: now,
    );
    ActivityGuard.record(preview.validate());
    final saved = checkpoint.saved.toList(),
        ids = saved.map((s) => s.product.id).toSet();
    for (final product in preview.products) {
      if (!ids.add(product.id)) continue;
      final id =
          '$idPrefix-${ActivityCodec.digest(product.id).substring(0, 16)}';
      if (saved.any((s) => s.id == id))
        throw StateError('Imported saved activity identity conflict');
      saved.add(
        ActivitySavedActivity(
          id: id,
          scope: checkpoint.scope,
          product: product,
          savedAt: now,
          updatedAt: now,
        ),
      );
    }
    final next = checkpoint.copyWith(
      saved: saved,
      savedAt: now,
      revision: checkpoint.revision + 1,
    );
    ActivitySavedLibrary.validateCheckpoint(
      next,
      scope: checkpoint.scope,
      now: now,
    );
    return next;
  }

  static ActivityExportBundle calendar(
    ActivityItineraries itinerary, {
    required String id,
    required DateTime now,
    ActivityExportPolicy? policy,
    bool acceptUnconfirmed = false,
  }) {
    final rules = policy ?? ActivityExportPolicy(format: 'calendar');
    ActivityGuard.record(rules.validate());
    if (rules.format != 'calendar')
      throw const FormatException('Calendar export policy required');
    final conflicts = itinerary.conflicts();
    if (conflicts.any((c) => c.severity == 'error') ||
        !acceptUnconfirmed && conflicts.isNotEmpty)
      throw StateError('Itinerary export needs schedule review');
    final lines = <String>[
      'BEGIN:VCALENDAR',
      'VERSION:2.0',
      'PRODID:-//Mytrippl//Activities//EN',
      'CALSCALE:GREGORIAN',
    ];
    var count = 0;
    String stamp(DateTime date) =>
        date
            .toUtc()
            .toIso8601String()
            .replaceAll('-', '')
            .replaceAll(':', '')
            .split('.')
            .first +
        'Z';
    String plain(String value) => value
        .replaceAll('\\', '\\\\')
        .replaceAll(';', '\\;')
        .replaceAll(',', '\\,')
        .replaceAll('\r', '')
        .replaceAll('\n', '\\n');
    for (final day in itinerary.days)
      for (final stop in itinerary.stops(day.id)) {
        count++;
        if (count > rules.maximumItems)
          throw const FormatException('Calendar export exceeds stop capacity');
        final credits = ActivityDetails.credits(
          provider: stop.product.attributions,
          photos: stop.product.photos,
          reviews: stop.product.reviews,
        );
        final description = [
          for (final credit in credits) credit.displayName,
          if (rules.includeBookingReferences && stop.bookingId != null)
            stop.bookingId!,
        ].join('\n');
        lines.addAll([
          'BEGIN:VEVENT',
          'UID:${ActivityCodec.digest([itinerary.value.id, stop.id])}@mytrippl',
          'DTSTAMP:${stamp(now)}',
          'DTSTART:${stamp(stop.startsAt)}',
          'DTEND:${stamp(stop.endsAt)}',
          'SUMMARY:${plain(stop.product.title)}',
          'STATUS:${stop.confirmed ? 'CONFIRMED' : 'TENTATIVE'}',
          if (description.isNotEmpty) 'DESCRIPTION:${plain(description)}',
          if (rules.includeCoordinates && stop.product.coordinate != null)
            'GEO:${stop.product.coordinate!.latitude};${stop.product.coordinate!.longitude}',
          'END:VEVENT',
        ]);
      }
    lines.add('END:VCALENDAR');
    final folded = <String>[];
    for (final line in lines) {
      var chunk = '', size = 0;
      for (final rune in line.runes) {
        final char = String.fromCharCode(rune),
            bytes = utf8.encode(char).length;
        if (size + bytes > 73) {
          folded.add(chunk);
          chunk = ' ';
          size = 1;
        }
        chunk += char;
        size += bytes;
      }
      folded.add(chunk);
    }
    final content = folded.join('\r\n') + '\r\n';
    final result = ActivityExportBundle(
      id: id,
      scope: itinerary.value.scope,
      createdAt: now,
      format: 'calendar',
      content: content,
      digest: ActivityCodec.digest(content),
      itemCount: count,
      warningCodes: [
        if (!rules.includeBookingReferences) 'bookingReferencesOmitted',
      ],
    );
    ActivityGuard.record(result.validate());
    return result;
  }
}
