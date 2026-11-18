import 'dart:convert';
import '../trippl_activities_mobile.dart';

class ActivityAccountStore {
  ActivityAccountStore(
    this.storage, {
    required this.scope,
    required this.clock,
  }) {
    ActivityGuard.identity(scope);
  }
  final ActivityLocalStorage storage;
  final String scope;
  final DateTime Function() clock;
  Future<void> _pending = Future.value();
  bool _closed = false;
  String _key(String kind, String id) =>
      'tripplactivities.account.v1.${ActivityCodec.digest([scope, kind, id])}';
  Future<T> _serial<T>(Future<T> Function() action) {
    if (_closed) throw StateError('Activity account store closed');
    final result = _pending.then((_) => action());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }

  Map<String, Object?> _decode(String text, String kind, String id) {
    final envelope = ActivityCodec.decode(text);
    ActivityCodec.keys(envelope, {
      'schemaVersion',
      'scope',
      'kind',
      'id',
      'revision',
      'digest',
      'payload',
    });
    if (envelope['schemaVersion'] != 1 ||
        envelope['scope'] != scope ||
        envelope['kind'] != kind ||
        envelope['id'] != id ||
        envelope['digest'] != ActivityCodec.digest(envelope['payload']))
      throw const FormatException(
        'Activity account envelope identity or integrity mismatch',
      );
    ActivityCodec.integer(envelope, 'revision', required: true, minimum: 1);
    return envelope;
  }

  Future<void> _save(
    String kind,
    String id,
    int revision,
    Map<String, Object?> payload,
  ) {
    final text = jsonEncode({
      'schemaVersion': 1,
      'scope': scope,
      'kind': kind,
      'id': id,
      'revision': revision,
      'digest': ActivityCodec.digest(payload),
      'payload': payload,
    });
    if (utf8.encode(text).length > 1000000)
      throw const FormatException(
        'Activity account payload exceeds byte limit',
      );
    return _serial(() async {
      final old = await storage.read(_key(kind, id));
      if (old != null) {
        final envelope = _decode(old, kind, id),
            previous = ActivityCodec.integer(
              _decode(old, kind, id),
              'revision',
              required: true,
            )!;
        final oldPayload = ActivityCodec.object(envelope['payload'])
          ..remove('savedAt');
        final newPayload = Map<String, Object?>.from(payload)
          ..remove('savedAt');
        if (previous > revision ||
            previous == revision && !ActivityCodec.same(oldPayload, newPayload))
          throw StateError('Stored activity state would regress or diverge');
      }
      await storage.write(_key(kind, id), text);
    });
  }

  Future<Map<String, Object?>?> _load(String kind, String id) =>
      _serial(() async {
        final text = await storage.read(_key(kind, id));
        return text == null
            ? null
            : ActivityCodec.object(_decode(text, kind, id)['payload']);
      });
  Future<void> saveLibrary(ActivityDeviceCheckpoint checkpoint) {
    ActivitySavedLibrary.validateCheckpoint(
      checkpoint,
      scope: scope,
      now: clock(),
    );
    return _save('library', 'main', checkpoint.revision, checkpoint.toJson());
  }

  Future<ActivityDeviceCheckpoint?> loadLibrary() async {
    final payload = await _load('library', 'main');
    if (payload == null) return null;
    final value = ActivityDeviceCheckpoint.fromJson(payload);
    ActivitySavedLibrary.validateCheckpoint(value, scope: scope, now: clock());
    return value;
  }

  Future<void> savePreferences(ActivityPreference value) {
    ActivityGuard.record(value.validate());
    ActivityBookingGuard.scope(scope, value.scope);
    ActivityBookingGuard.clock(value.updatedAt, clock());
    return _save('preference', 'main', value.revision, value.toJson());
  }

  Future<ActivityPreference?> loadPreferences() async {
    final json = await _load('preference', 'main');
    if (json == null) return null;
    final value = ActivityPreference.fromJson(json);
    ActivityBookingGuard.scope(scope, value.scope);
    ActivityBookingGuard.clock(value.updatedAt, clock());
    return value;
  }

  Future<void> saveItinerary(ActivityItineraries itinerary) {
    final snapshot = itinerary.toJson();
    ActivityItineraries.restore(snapshot, scope: scope, clock: clock);
    return _save(
      'itinerary',
      itinerary.value.id,
      itinerary.value.revision,
      snapshot,
    );
  }

  Future<ActivityItineraries?> loadItinerary(String id) async {
    final json = await _load('itinerary', id);
    if (json == null) return null;
    final value = ActivityItineraries.restore(json, scope: scope, clock: clock);
    if (value.value.id != id)
      throw StateError('Stored itinerary identity mismatch');
    return value;
  }

  Future<void> saveSync(ActivitySavedSync sync) {
    ActivityBookingGuard.scope(scope, sync.scope);
    return _save('savedSync', 'main', sync.generation, sync.snapshot());
  }

  Future<bool> restoreSync(
    ActivitySavedSync sync, {
    required int expectedGeneration,
  }) async {
    ActivityBookingGuard.scope(scope, sync.scope);
    final json = await _load('savedSync', 'main');
    if (json == null) return false;
    sync.restore(json, expectedGeneration: expectedGeneration);
    return true;
  }

  Future<void> removeItinerary(String id) =>
      _serial(() => storage.remove(_key('itinerary', id)));
  Future<void> clear({List<String> itineraryIds = const []}) =>
      _serial(() async {
        if (itineraryIds.length > 100)
          throw const FormatException('Too many itinerary deletion targets');
        for (final pair in [
          ['library', 'main'],
          ['preference', 'main'],
          ['savedSync', 'main'],
          for (final id in itineraryIds) ['itinerary', id],
        ])
          await storage.remove(_key(pair[0], pair[1]));
      });
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _pending;
  }
}

/// The host must implement protected device storage. There is deliberately no
/// plaintext fallback for contact data, traveler names or supplier answers.
abstract interface class ActivityProtectedStorage {
  Future<String?> readProtected(String key);
  Future<void> writeProtected(String key, String value);
  Future<void> removeProtected(String key);
}

class ActivityBookingRecoveryStore {
  ActivityBookingRecoveryStore(
    this.storage, {
    required this.scope,
    required this.clock,
  }) {
    ActivityGuard.identity(scope);
  }
  final ActivityProtectedStorage storage;
  final String scope;
  final DateTime Function() clock;
  Future<void> _pending = Future.value();
  bool _closed = false;
  String _key(String id) =>
      'tripplactivities.booking.v1.${ActivityCodec.digest([scope, id])}';
  Future<T> _serial<T>(Future<T> Function() action) {
    if (_closed) throw StateError('Booking recovery store closed');
    final next = _pending.then((_) => action());
    _pending = next.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return next;
  }

  Future<void> save(
    ActivityBookingDraft draft, {
    required ActivityAccountPrivacy privacy,
    ActivityBookingIntent? intent,
    ActivityBookingReceipt? receipt,
  }) {
    ActivityBookingGuard.scope(scope, privacy.scope);
    ActivityBookingGuard.draft(draft, scope: scope, now: clock());
    if (!privacy.permitted('draftDetails'))
      throw StateError('Protected booking detail retention not enabled');
    if (intent != null &&
        (intent.scope != scope ||
            intent.draftId != draft.id ||
            intent.draftFingerprint != ActivityBookingGuard.fingerprint(draft)))
      throw StateError('Recovery booking intent mismatch');
    if (receipt != null) {
      if (intent == null) throw StateError('Receipt requires an intent');
      ActivityBookingGuard.receipt(intent, receipt, now: clock());
    }
    final payload = {
      'scope': scope,
      'savedAt': clock().toUtc().toIso8601String(),
      'draft': draft.toJson(),
      if (intent != null) 'intent': intent.toJson(),
      if (receipt != null) 'receipt': receipt.toJson(),
    };
    final text = jsonEncode({
      'schemaVersion': 1,
      'digest': ActivityCodec.digest(payload),
      'payload': payload,
    });
    if (utf8.encode(text).length > 1000000)
      throw const FormatException(
        'Protected booking snapshot exceeds byte limit',
      );
    return _serial(() async {
      if (!privacy.permitted('draftDetails')) {
        await storage.removeProtected(_key(draft.id));
        return;
      }
      final previous = await storage.readProtected(_key(draft.id));
      if (previous != null) {
        final envelope = ActivityCodec.decode(previous);
        if (envelope['schemaVersion'] != 1 ||
            envelope['digest'] != ActivityCodec.digest(envelope['payload']))
          throw const FormatException('Previous protected draft is corrupt');
        final oldPayload = ActivityCodec.object(envelope['payload']);
        final oldDraft = ActivityBookingDraft.fromJson(
          ActivityCodec.object(oldPayload['draft']),
        );
        if (oldDraft.scope != scope ||
            oldDraft.id != draft.id ||
            oldDraft.revision > draft.revision ||
            oldDraft.revision == draft.revision && oldDraft != draft)
          throw StateError('Protected draft would regress or diverge');
        final oldReceipt = oldPayload['receipt'] == null
            ? null
            : ActivityBookingReceipt.fromJson(
                ActivityCodec.object(oldPayload['receipt']),
              );
        if (oldReceipt?.state == 'confirmed' && receipt?.state != 'confirmed')
          throw StateError('Protected booking confirmation cannot regress');
      }
      if (!privacy.permitted('draftDetails')) {
        await storage.removeProtected(_key(draft.id));
        return;
      }
      await storage.writeProtected(_key(draft.id), text);
      if (!privacy.permitted('draftDetails'))
        await storage.removeProtected(_key(draft.id));
    });
  }

  Future<ActivityBookingRecovery?> load(
    String id, {
    required ActivityAccountPrivacy privacy,
  }) => _serial(() async {
    ActivityBookingGuard.scope(scope, privacy.scope);
    if (!privacy.permitted('draftDetails')) {
      await storage.removeProtected(_key(id));
      return null;
    }
    final text = await storage.readProtected(_key(id));
    if (text == null) return null;
    if (!privacy.permitted('draftDetails')) {
      await storage.removeProtected(_key(id));
      return null;
    }
    final envelope = ActivityCodec.decode(text);
    ActivityCodec.keys(envelope, {'schemaVersion', 'digest', 'payload'});
    if (envelope['schemaVersion'] != 1 ||
        envelope['digest'] != ActivityCodec.digest(envelope['payload']))
      throw const FormatException(
        'Protected booking snapshot integrity mismatch',
      );
    final payload = ActivityCodec.object(envelope['payload']);
    ActivityCodec.keys(payload, {
      'scope',
      'savedAt',
      'draft',
      'intent',
      'receipt',
    });
    final saved = ActivityCodec.date(payload, 'savedAt', required: true)!;
    if (payload['scope'] != scope || saved.isAfter(clock()))
      throw StateError('Protected booking account or timestamp mismatch');
    if (clock().difference(saved) >
        Duration(days: privacy.value.retentionDays)) {
      await storage.removeProtected(_key(id));
      return null;
    }
    final draft = ActivityBookingDraft.fromJson(
      ActivityCodec.object(payload['draft']),
    );
    ActivityBookingGuard.draft(draft, scope: scope, now: clock());
    if (draft.id != id)
      throw StateError('Recovered booking draft identity mismatch');
    final intent = payload['intent'] == null
        ? null
        : ActivityBookingIntent.fromJson(
            ActivityCodec.object(payload['intent']),
          );
    final receipt = payload['receipt'] == null
        ? null
        : ActivityBookingReceipt.fromJson(
            ActivityCodec.object(payload['receipt']),
          );
    if (intent != null &&
        (intent.scope != scope ||
            intent.draftId != id ||
            intent.draftFingerprint != ActivityBookingGuard.fingerprint(draft)))
      throw StateError('Recovered booking intent mismatch');
    if (receipt != null) {
      if (intent == null) throw StateError('Recovered receipt has no intent');
      ActivityBookingGuard.receipt(intent, receipt, now: clock());
    }
    return ActivityBookingRecovery(
      draft: draft,
      intent: intent,
      receipt: receipt,
    );
  });
  Future<void> clear(String id) =>
      _serial(() => storage.removeProtected(_key(id)));
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _pending;
  }
}

class ActivityBookingRecovery {
  ActivityBookingRecovery({required this.draft, this.intent, this.receipt});
  final ActivityBookingDraft draft;
  final ActivityBookingIntent? intent;
  final ActivityBookingReceipt? receipt;
}
