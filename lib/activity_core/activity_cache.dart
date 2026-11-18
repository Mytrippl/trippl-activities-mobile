import 'dart:convert';
import '../trippl_activities_mobile.dart';

abstract interface class ActivityLocalStorage {
  Future<String?> read(String key);
  Future<void> write(String key, String value);
  Future<void> remove(String key);
}

class ActivityDiscoveryCache {
  ActivityDiscoveryCache(
    this.storage, {
    required this.scope,
    this.maximumEntries = 10,
  }) {
    ActivityGuard.identity(scope);
    if (maximumEntries < 1 || maximumEntries > 20)
      throw ArgumentError('Invalid activity cache capacity');
  }
  final ActivityLocalStorage storage;
  final String scope;
  final int maximumEntries;
  bool _closed = false;
  Future<void> _pending = Future.value();
  String get key =>
      'tripplactivities.discovery.v1.${ActivityCodec.digest(scope)}';
  Future<T> _serial<T>(Future<T> Function() action) {
    if (_closed) throw StateError('Activity cache closed');
    final result = _pending.then((_) => action());
    _pending = result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }

  Future<List<ActivityCacheEntry>> _read(DateTime now) async {
    final text = await storage.read(key);
    if (text == null) return [];
    final envelope = ActivityCodec.decode(text);
    ActivityCodec.keys(envelope, {
      'schemaVersion',
      'scope',
      'digest',
      'entries',
    });
    final raw = envelope['entries'];
    if (envelope['schemaVersion'] != 1 ||
        envelope['scope'] != ActivityCodec.digest(scope) ||
        raw is! List ||
        raw.length > maximumEntries ||
        envelope['digest'] != ActivityCodec.digest(raw))
      throw const FormatException('Activity cache integrity or scope mismatch');
    final rows = raw
        .map((r) => ActivityCacheEntry.fromJson(ActivityCodec.object(r)))
        .toList();
    ActivityGuard.distinct(rows.map((r) => r.requestFingerprint));
    for (final e in rows)
      if (e.scopeFingerprint != ActivityCodec.digest(scope) ||
          e.savedAt.isAfter(now) ||
          e.page.observedAt.isAfter(e.savedAt) ||
          e.expiresAt.difference(e.savedAt) > const Duration(days: 7))
        throw const FormatException('Activity cache time or account mismatch');
    return rows.where((e) => e.expiresAt.isAfter(now)).toList();
  }

  Future<void> save(
    ActivityProviderRequest request,
    ActivityProviderPage page, {
    required DateTime now,
    Duration retention = const Duration(days: 1),
  }) {
    ActivityDiscoveryController.validateResponse(request, page, now: now);
    if (request.scope != scope ||
        request.cursor != null ||
        request.mode != 'search' && request.mode != 'details' ||
        retention <= Duration.zero ||
        retention > const Duration(days: 7))
      throw const FormatException('Only bounded discovery pages may be cached');
    final entry = ActivityCacheEntry(
      scopeFingerprint: ActivityCodec.digest(scope),
      requestFingerprint: ActivityRequests.fingerprint(request),
      savedAt: now,
      expiresAt: now.add(retention),
      page: page,
    );
    ActivityGuard.record(entry.validate());
    return _serial(() async {
      final values = await _read(now),
          old = values
              .where((e) => e.requestFingerprint == entry.requestFingerprint)
              .firstOrNull;
      if (old != null &&
          (old.page.observedAt.isAfter(page.observedAt) ||
              old.page.observedAt == page.observedAt && old.page != page))
        throw StateError('Activity cached page would regress or diverge');
      final next = [
        ...values.where(
          (e) => e.requestFingerprint != entry.requestFingerprint,
        ),
        entry,
      ];
      while (next.length > maximumEntries) next.removeAt(0);
      final entries = next.map((e) => e.toJson()).toList();
      final text = jsonEncode({
        'schemaVersion': 1,
        'scope': ActivityCodec.digest(scope),
        'digest': ActivityCodec.digest(entries),
        'entries': entries,
      });
      if (utf8.encode(text).length > 1000000)
        throw const FormatException('Activity cache exceeds byte capacity');
      await storage.write(key, text);
    });
  }

  Future<ActivityCacheEntry?> load(
    ActivityProviderRequest request, {
    required DateTime now,
    bool allowStale = false,
  }) {
    ActivityRequests.validate(request);
    if (request.scope != scope ||
        request.cursor != null ||
        !{'search', 'details'}.contains(request.mode))
      throw const FormatException('Invalid activity cache query');
    return _serial(() async {
      final rows = await _read(now),
          entry = rows
              .where(
                (e) =>
                    e.requestFingerprint ==
                    ActivityRequests.fingerprint(request),
              )
              .firstOrNull;
      if (entry == null || !allowStale && !entry.page.expiresAt.isAfter(now))
        return null;
      return entry.copyWith(offline: true);
    });
  }

  Future<void> clear() => _serial(() => storage.remove(key));
  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _pending;
  }
}
