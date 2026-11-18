import 'dart:async';
import '../trippl_activities_mobile.dart';

/// Only saved content synchronizes here. Booking and cancellation intents use
/// their dedicated reconciliation flows and can never enter this outbox.
class ActivitySavedSync {
  ActivitySavedSync({
    required this.scope,
    required this.clock,
    required this.transport,
    this.timeout = const Duration(seconds: 30),
  }) {
    ActivityGuard.identity(scope);
    if (timeout <= Duration.zero || timeout > const Duration(minutes: 2))
      throw ArgumentError('Invalid saved sync timeout');
  }
  final String scope;
  final DateTime Function() clock;
  final ActivitySavedSyncTransport transport;
  final Duration timeout;
  final _mutations = <String, ActivitySyncMutation>{},
      _conflicts = <String, ActivitySyncConflict>{};
  int _generation = 1;
  bool _busy = false, _closed = false;
  String? _cursor;
  int get generation => _generation;
  List<ActivitySyncMutation> get mutations =>
      List.unmodifiable(_mutations.values);
  List<ActivitySyncConflict> get conflicts =>
      List.unmodifiable(_conflicts.values);
  int get pendingCount => _mutations.values
      .where((m) => m.state == 'pending' || m.state == 'sending')
      .length;
  static void resource(String id) {
    ActivityGuard.identity(id);
    if (!{
          'saved',
          'collection',
          'itinerary',
          'preference',
        }.contains(id.split(':').first) ||
        !id.contains(':'))
      throw StateError('Only saved activity content may synchronize');
  }

  ActivitySyncMutation enqueue({
    required String id,
    required String resourceId,
    required String kind,
    required Map<String, Object?> payload,
    required int expectedRevision,
  }) {
    if (_closed) throw StateError('Saved sync closed');
    resource(resourceId);
    ActivityGuard.inspect(payload);
    final value = ActivitySyncMutation(
      id: id,
      scope: scope,
      resourceId: resourceId,
      kind: kind,
      payloadDigest: ActivityCodec.digest(payload),
      expectedRevision: expectedRevision,
      createdAt: clock(),
    );
    ActivityGuard.record(value.validate());
    final old = _mutations[id];
    if (old != null) {
      if (old.payloadDigest != value.payloadDigest ||
          old.resourceId != value.resourceId ||
          old.kind != kind ||
          old.expectedRevision != expectedRevision)
        throw StateError('Sync idempotency identity reused');
      return old;
    }
    if (_mutations.length >= 100)
      throw StateError('Saved sync capacity reached');
    _mutations[id] = value;
    _generation++;
    return value;
  }

  Future<ActivitySyncAck?> flush({
    required String batchId,
    bool online = true,
  }) async {
    if (_closed || _busy) throw StateError('Saved sync unavailable');
    if (!online) return null;
    final resources = <String>{};
    final ordered =
        _mutations.values
            .where(
              (m) =>
                  m.state == 'pending' &&
                  (m.nextAttemptAt == null ||
                      !m.nextAttemptAt!.isAfter(clock())),
            )
            .toList()
          ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
    final chosen = <ActivitySyncMutation>[];
    for (final m in ordered) {
      if (chosen.length >= 20) break;
      if (resources.add(m.resourceId))
        chosen.add(
          m.copyWith(
            state: 'sending',
            attempts: m.attempts + 1,
            clear: {'nextAttemptAt'},
          ),
        );
    }
    if (chosen.isEmpty) return null;
    final batch = ActivitySyncBatch(
      id: batchId,
      scope: scope,
      createdAt: clock(),
      mutations: chosen,
      generation: _generation + 1,
      cursor: _cursor,
    );
    ActivityGuard.record(batch.validate());
    for (final m in chosen) _mutations[m.id] = m;
    _generation++;
    _busy = true;
    try {
      final ack = await transport.send(batch).timeout(timeout);
      if (_closed) return null;
      _accept(batch, ack);
      return ack;
    } catch (_) {
      if (!_closed)
        for (final m in chosen)
          if (_mutations[m.id] == m)
            _mutations[m.id] = m.copyWith(
              state: m.attempts >= 5 ? 'failed' : 'pending',
              nextAttemptAt: clock().add(Duration(seconds: 1 << m.attempts)),
            );
      if (_closed) return null;
      throw const ActivityOperationException(
        'savedSyncFailed',
        retryable: true,
      );
    } finally {
      _busy = false;
      _generation++;
    }
  }

  void _accept(ActivitySyncBatch batch, ActivitySyncAck ack) {
    ActivityGuard.record(ack.validate());
    ActivityBookingGuard.scope(scope, ack.scope);
    final ids = batch.mutations.map((m) => m.id).toSet(),
        resources = batch.mutations.map((m) => m.resourceId).toSet();
    if (ack.batchId != batch.id ||
        ack.receivedAt.isBefore(batch.createdAt) ||
        ack.receivedAt.isAfter(clock()) ||
        ack.acknowledgedIds.any((id) => !ids.contains(id)) ||
        ack.retryIds.any((id) => !ids.contains(id)) ||
        ack.conflicts.any((c) => !resources.contains(c.resourceId)) ||
        _conflicts.length + ack.conflicts.length > 100)
      throw StateError('Saved sync response identity or capacity mismatch');
    final conflicting = ack.conflicts.map((c) => c.resourceId).toSet();
    if (batch.mutations.any(
      (m) =>
          ack.acknowledgedIds.contains(m.id) &&
          conflicting.contains(m.resourceId),
    ))
      throw StateError('Sync operation both acknowledged and conflicted');
    for (final m in batch.mutations)
      if (_mutations[m.id] != m)
        throw StateError('Sync mutation changed while sending');
    for (final m in batch.mutations) {
      final state = ack.acknowledgedIds.contains(m.id)
          ? 'acknowledged'
          : conflicting.contains(m.resourceId) || m.attempts >= 5
          ? 'failed'
          : 'pending';
      _mutations[m.id] = m.copyWith(
        state: state,
        nextAttemptAt: state == 'pending'
            ? clock().add(Duration(seconds: 1 << m.attempts))
            : null,
      );
    }
    for (final conflict in ack.conflicts) _conflicts[conflict.id] = conflict;
    _cursor = ack.cursor;
  }

  ActivitySyncConflict resolve(
    String id,
    String resolution, {
    required String expectedLocalDigest,
    required String expectedRemoteDigest,
  }) {
    final old =
        _conflicts[id] ?? (throw StateError('Saved sync conflict missing'));
    if (old.resolution != 'unresolved' ||
        old.localDigest != expectedLocalDigest ||
        old.remoteDigest != expectedRemoteDigest ||
        !{'keepLocal', 'keepRemote', 'manual'}.contains(resolution))
      throw StateError('Conflict changed or invalid resolution');
    final next = old.copyWith(resolution: resolution);
    _conflicts[id] = next;
    _generation++;
    return next;
  }

  Map<String, Object?> snapshot() => {
    'scope': scope,
    'generation': _generation,
    'mutations': mutations.map((m) => m.toJson()).toList(),
    'conflicts': conflicts.map((c) => c.toJson()).toList(),
    if (_cursor != null) 'cursor': _cursor,
  };
  void restore(Map<String, Object?> json, {required int expectedGeneration}) {
    if (_busy || _closed) throw StateError('Cannot restore active saved sync');
    ActivityGuard.revision(_generation, expectedGeneration);
    ActivityCodec.keys(json, {
      'scope',
      'generation',
      'mutations',
      'conflicts',
      'cursor',
    });
    if (json['scope'] != scope) throw StateError('Saved sync scope mismatch');
    final rows = ActivityCodec.list(
      json,
      'mutations',
      (v) => ActivitySyncMutation.fromJson(ActivityCodec.object(v)),
      required: true,
    )!;
    final conflicts = ActivityCodec.list(
      json,
      'conflicts',
      (v) => ActivitySyncConflict.fromJson(ActivityCodec.object(v)),
      required: true,
    )!;
    final generation = ActivityCodec.integer(
      json,
      'generation',
      required: true,
      minimum: 1,
      maximum: 9000000000000,
    )!;
    ActivityGuard.distinct(rows.map((m) => m.id));
    ActivityGuard.distinct(conflicts.map((c) => c.id));
    for (final m in rows) {
      resource(m.resourceId);
      if (m.scope != scope || m.createdAt.isAfter(clock()))
        throw StateError('Saved sync mutation scope or clock mismatch');
    }
    final cursor = ActivityCodec.text(json, 'cursor');
    _mutations
      ..clear()
      ..addEntries(
        rows.map(
          (m) => MapEntry(
            m.id,
            m.state == 'sending'
                ? m.copyWith(state: m.attempts >= 5 ? 'failed' : 'pending')
                : m,
          ),
        ),
      );
    _conflicts
      ..clear()
      ..addEntries(conflicts.map((c) => MapEntry(c.id, c)));
    _cursor = cursor;
    _generation = (_generation > generation ? _generation : generation) + 1;
  }

  void purgeAcknowledged() {
    if (_busy) throw StateError('Saved sync busy');
    _mutations.removeWhere((_, m) => m.state == 'acknowledged');
    _generation++;
  }

  void clear() {
    if (_busy) throw StateError('Saved sync busy');
    _mutations.clear();
    _conflicts.clear();
    _cursor = null;
    _generation++;
  }

  void close() {
    _closed = true;
    _generation++;
  }
}
