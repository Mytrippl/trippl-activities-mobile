import '../trippl_activities_mobile.dart';

/// Local intents only. The host requests platform permission and acknowledges
/// delivery after the operating-system notification service accepts the intent.
class ActivityReminderCenter {
  ActivityReminderCenter({required this.scope, required this.clock}) {
    ActivityGuard.identity(scope);
  }
  final String scope;
  final DateTime Function() clock;
  final _reminders = <String, ActivityReminder>{},
      _notifications = <String, ActivityNotification>{};
  List<ActivityReminder> get reminders => List.unmodifiable(_reminders.values);
  ActivityReminder schedule({
    required String id,
    required String resourceId,
    required DateTime dueAt,
    required bool enabled,
    int leadMinutes = 30,
  }) {
    if (_reminders.containsKey(id) || _reminders.length >= 100)
      throw StateError('Reminder identity or capacity conflict');
    final value = ActivityReminder(
      id: id,
      scope: scope,
      resourceId: resourceId,
      dueAt: dueAt,
      createdAt: clock(),
      enabled: enabled,
      leadMinutes: leadMinutes,
    );
    ActivityGuard.record(value.validate());
    _reminders[id] = value;
    return value;
  }

  List<ActivityReminder> due() {
    final now = clock(),
        rows =
            _reminders.values
                .where(
                  (r) =>
                      r.enabled &&
                      !r.delivered &&
                      !r.dueAt.isBefore(now) &&
                      !r.dueAt
                          .subtract(Duration(minutes: r.leadMinutes))
                          .isAfter(now),
                )
                .toList()
              ..sort((a, b) => a.dueAt.compareTo(b.dueAt));
    return List.unmodifiable(rows);
  }

  ActivityReminder delivered(String id, {required int expectedRevision}) {
    final old = _reminders[id] ?? (throw StateError('Reminder missing'));
    ActivityGuard.revision(old.revision, expectedRevision);
    if (!due().any((r) => r.id == id)) throw StateError('Reminder not due');
    final next = old.copyWith(delivered: true, revision: old.revision + 1);
    _reminders[id] = next;
    return next;
  }

  void cancelResource(String resourceId) {
    for (final r in reminders.where((r) => r.resourceId == resourceId))
      _reminders[r.id] = r.copyWith(enabled: false, revision: r.revision + 1);
  }

  ActivityNotification notify({
    required String id,
    required String resourceId,
    required String kind,
    Duration lifetime = const Duration(days: 7),
  }) {
    if (_notifications.containsKey(id) ||
        _notifications.length >= 100 ||
        lifetime <= Duration.zero ||
        lifetime > const Duration(days: 30))
      throw StateError('Notification identity capacity or lifetime conflict');
    final value = ActivityNotification(
      id: id,
      scope: scope,
      resourceId: resourceId,
      kind: kind,
      createdAt: clock(),
      expiresAt: clock().add(lifetime),
    );
    ActivityGuard.record(value.validate());
    _notifications[id] = value;
    return value;
  }

  List<ActivityNotification> notifications({bool unreadOnly = false}) {
    _notifications.removeWhere((_, n) => !n.expiresAt.isAfter(clock()));
    final rows =
        _notifications.values
            .where((n) => !n.dismissed && (!unreadOnly || !n.read))
            .toList()
          ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(rows);
  }

  ActivityNotification update(
    String id, {
    required int expectedRevision,
    bool? read,
    bool? dismissed,
  }) {
    final old =
        _notifications[id] ?? (throw StateError('Notification missing'));
    ActivityGuard.revision(old.revision, expectedRevision);
    final next = old.copyWith(
      read: read,
      dismissed: dismissed,
      revision: old.revision + 1,
    );
    _notifications[id] = next;
    return next;
  }

  void restore(
    List<ActivityReminder> reminders,
    List<ActivityNotification> notifications,
  ) {
    if (reminders.length > 100 || notifications.length > 100)
      throw const FormatException('Reminder restore exceeds capacity');
    ActivityGuard.distinct(reminders.map((r) => r.id));
    ActivityGuard.distinct(notifications.map((n) => n.id));
    for (final r in reminders) {
      ActivityGuard.record(r.validate());
      if (r.scope != scope || r.createdAt.isAfter(clock()))
        throw StateError('Reminder scope or timestamp mismatch');
    }
    for (final n in notifications) {
      ActivityGuard.record(n.validate());
      if (n.scope != scope || n.createdAt.isAfter(clock()))
        throw StateError('Notification scope or timestamp mismatch');
    }
    _reminders
      ..clear()
      ..addEntries(reminders.map((r) => MapEntry(r.id, r)));
    _notifications
      ..clear()
      ..addEntries(notifications.map((n) => MapEntry(n.id, n)));
  }

  void clear() {
    _reminders.clear();
    _notifications.clear();
  }
}
