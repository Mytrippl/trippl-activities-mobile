import '../trippl_activities_mobile.dart';

class ActivityAccountHistory {
  ActivityAccountHistory({required this.scope, required this.clock}) {
    ActivityGuard.identity(scope);
  }
  final String scope;
  final DateTime Function() clock;
  final _entries = <String, ActivityHistoryEntry>{};
  final _audit = <String, ActivityAuditEvent>{};
  ActivityHistoryEntry? record({
    required String id,
    required String kind,
    required String resourceId,
    required ActivityAccountPrivacy privacy,
    String? text,
  }) {
    ActivityBookingGuard.scope(scope, privacy.scope);
    prune(privacy);
    if (!privacy.permitted('history')) return null;
    final previous = _entries[id];
    if (previous != null &&
        (previous.resourceId != resourceId || previous.kind != kind))
      throw StateError('History identity reused');
    final entry = ActivityHistoryEntry(
      id: id,
      scope: scope,
      kind: kind,
      resourceId: resourceId,
      text: text,
      occurredAt: clock(),
      count: (previous?.count ?? 0) + 1,
      revision: (previous?.revision ?? 0) + 1,
    );
    ActivityGuard.record(entry.validate());
    if (previous == null && _entries.length >= 100)
      _entries.remove(
        _entries.values
            .reduce((a, b) => a.occurredAt.isBefore(b.occurredAt) ? a : b)
            .id,
      );
    _entries[id] = entry;
    return entry;
  }

  bool audit(
    ActivityAuditEvent event, {
    required ActivityAccountPrivacy privacy,
  }) {
    ActivityBookingGuard.scope(scope, privacy.scope);
    ActivityBookingGuard.scope(scope, event.scope);
    prune(privacy);
    if (!privacy.permitted('analytics')) return false;
    ActivityGuard.record(event.validate());
    ActivityBookingGuard.clock(event.occurredAt, clock());
    final old = _audit[event.id];
    if (old != null) {
      if (old != event) throw StateError('Audit event identity reused');
      return false;
    }
    if (_audit.length >= 100)
      _audit.remove(
        _audit.values
            .reduce((a, b) => a.occurredAt.isBefore(b.occurredAt) ? a : b)
            .id,
      );
    _audit[event.id] = event;
    return true;
  }

  List<ActivityHistoryEntry> list(ActivityAccountPrivacy privacy) {
    ActivityBookingGuard.scope(scope, privacy.scope);
    prune(privacy);
    return List.unmodifiable(
      _entries.values.toList()
        ..sort((a, b) => b.occurredAt.compareTo(a.occurredAt)),
    );
  }

  List<ActivityAuditEvent> events(ActivityAccountPrivacy privacy) {
    ActivityBookingGuard.scope(scope, privacy.scope);
    prune(privacy);
    return List.unmodifiable(_audit.values);
  }

  void prune(ActivityAccountPrivacy privacy) {
    ActivityBookingGuard.scope(scope, privacy.scope);
    final cutoff = clock().subtract(
      Duration(days: privacy.value.retentionDays),
    );
    _entries.removeWhere(
      (_, e) => !privacy.permitted('history') || e.occurredAt.isBefore(cutoff),
    );
    _audit.removeWhere(
      (_, e) =>
          !privacy.permitted('analytics') || e.occurredAt.isBefore(cutoff),
    );
  }

  void clear() {
    _entries.clear();
    _audit.clear();
  }
}
