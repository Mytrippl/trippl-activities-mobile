import 'dart:async';
import '../trippl_activities_mobile.dart';

class ActivityLifecycleWorkspace {
  ActivityLifecycleWorkspace({
    required this.discovery,
    required this.saved,
    required this.preferences,
    required this.privacy,
    required this.history,
    required this.reminders,
    required this.clock,
  }) {
    final scope = saved.scope;
    if ([
      discovery.controller.scope,
      preferences.scope,
      privacy.scope,
      history.scope,
      reminders.scope,
    ].any((s) => s != scope))
      throw ArgumentError('Activity lifecycle workspace mixes accounts');
    _subscriptions.add(discovery.changes.listen((_) => _emit()));
    _subscriptions.add(saved.changes.listen((_) => _emit()));
  }
  final ActivityWorkspace discovery;
  final ActivitySavedLibrary saved;
  final ActivityPreferences preferences;
  final ActivityAccountPrivacy privacy;
  final ActivityAccountHistory history;
  final ActivityReminderCenter reminders;
  final DateTime Function() clock;
  final _subscriptions = <StreamSubscription<Object?>>[];
  final _changes = StreamController<ActivityDashboard>.broadcast();
  final _bookings = <String, ActivityBookingRecord>{};
  int _revision = 1;
  bool _closed = false, _submitting = false;
  ActivityBookingDrafts? _draft;
  ActivityBookingController? _booking;
  final _warningCodes = <String>{};
  int get revision => _revision;
  Stream<ActivityDashboard> get changes => _changes.stream;
  List<ActivityBookingRecord> get bookings =>
      List.unmodifiable(_bookings.values);
  ActivityBookingDraft? get draft => _draft?.value;
  void _open() {
    if (_closed) throw StateError('Activity lifecycle workspace closed');
  }

  ActivityDashboard dashboard() {
    _open();
    return ActivityDashboard(
      scope: saved.scope,
      evaluatedAt: clock(),
      revision: _revision,
      savedCount: saved.saved.length,
      collectionCount: saved.collections.length,
      pendingBookingCount:
          _bookings.values
              .where((b) => b.state == 'pending' || b.state == 'cancelPending')
              .length +
          (_booking?.outcome.requiresReconciliation == true ? 1 : 0),
      confirmedBookingCount: _bookings.values
          .where((b) => b.state == 'confirmed')
          .length,
      unreadNotificationCount: reminders.notifications(unreadOnly: true).length,
    );
  }

  void _emit() {
    if (_closed) return;
    _revision++;
    _changes.add(dashboard());
  }

  ActivitySavedActivity save(
    String productId, {
    required String id,
    required int expectedRevision,
  }) {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    final product =
        discovery
            .snapshot()
            .result
            .products
            .where((p) => p.id == productId)
            .firstOrNull ??
        (throw StateError('Activity not in current discovery result'));
    final result = saved.save(product, id: id);
    _emit();
    return result;
  }

  void attachBooking(
    ActivityBookingDrafts draft,
    ActivityBookingController controller, {
    required int expectedRevision,
  }) {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    if (_submitting ||
        _booking?.outcome.requiresReconciliation == true ||
        _booking?.outcome.busy == true)
      throw StateError('Resolve the active booking before switching drafts');
    ActivityBookingGuard.scope(saved.scope, draft.value.scope);
    ActivityBookingGuard.scope(saved.scope, controller.scope);
    _draft = draft;
    _booking = controller;
    _emit();
  }

  Future<ActivityBookingOutcome> submit({
    required String intentId,
    required ActivityConfirmationPolicy policy,
    required bool confirmedByUser,
    required int expectedRevision,
    ActivityPickup? pickupPolicy,
  }) async {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    final draft = _draft, controller = _booking;
    if (draft == null || controller == null || _submitting)
      throw StateError('No idle activity booking draft attached');
    final snapshot = draft.value;
    final intent = ActivityBookingIntents.prepare(
      snapshot,
      policy,
      id: intentId,
      now: clock(),
      confirmedByUser: confirmedByUser,
      pickupPolicy: pickupPolicy,
    );
    if (controller.outcome.intent != null)
      throw StateError('Booking controller already owns a submission intent');
    _submitting = true;
    draft.state('submitting', expectedRevision: snapshot.revision);
    _emit();
    try {
      final outcome = await controller.submit(
        snapshot,
        intent,
        policy: policy,
        confirmedByUser: confirmedByUser,
        pickupPolicy: pickupPolicy,
      );
      if (_closed) return outcome;
      final state = outcome.intent?.state ?? 'unknown';
      draft.state(
        {'pending', 'confirmed', 'rejected', 'unknown'}.contains(state)
            ? state
            : 'unknown',
        expectedRevision: draft.value.revision,
      );
      if (outcome.record != null)
        _bookings[outcome.record!.id] = outcome.record!;
      if (outcome.confirmed) {
        try {
          reminders.notify(
            id: 'booking-${intent.id}',
            resourceId: outcome.record!.id,
            kind: 'booking',
          );
        } catch (_) {
          _warningCodes.add('bookingNotificationUnavailable');
        }
      }
      _emit();
      return outcome;
    } finally {
      _submitting = false;
    }
  }

  Future<ActivityBookingOutcome> reconcile() async {
    _open();
    final draft = _draft, controller = _booking;
    if (draft == null || controller == null || _submitting)
      throw StateError('No idle booking to reconcile');
    final outcome = await controller.reconcile(draft.value);
    if (_closed) return outcome;
    final state = outcome.intent?.state;
    if (state != null &&
        state != draft.value.state &&
        {'pending', 'confirmed', 'rejected', 'unknown'}.contains(state))
      draft.state(state, expectedRevision: draft.value.revision);
    if (outcome.record != null) _bookings[outcome.record!.id] = outcome.record!;
    _emit();
    return outcome;
  }

  ActivityReconciliation status(
    ActivityBookingStatus status, {
    required int expectedRevision,
  }) {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    final old =
        _bookings[status.bookingId] ??
        (throw StateError('Booking not in this workspace'));
    final assessment = ActivityBookingReconciliation.assess(
      old,
      status,
      now: clock(),
    );
    if (assessment.accepted) {
      _bookings[old.id] = ActivityBookingReconciliation.apply(
        old,
        status,
        now: clock(),
      );
      if (status.state == 'cancelled') reminders.cancelResource(old.id);
      _emit();
    }
    return assessment;
  }

  Map<String, Object?> screenState() {
    final dashboard = this.dashboard();
    final state = discovery.snapshot();
    return Map.unmodifiable({
      'dashboard': dashboard.toJson(),
      'warningCodes': _warningCodes.toList(),
      'discoveryRevision': state.revision,
      'cards': state.cards.map((c) => c.toJson()).toList(),
      'offline': state.offline,
      'loading': state.loading,
      'savedProductIds': saved.saved.map((s) => s.product.id).toList(),
      'bookings': bookings
          .map(
            (b) => {
              'id': b.id,
              'productId': b.productId,
              'state': b.state,
              'startsAt': b.startsAt.toIso8601String(),
            },
          )
          .toList(),
      if (_draft != null)
        'draft': {
          'id': _draft!.value.id,
          'state': _draft!.value.state,
          'revision': _draft!.value.revision,
          if (_draft!.value.contact != null)
            'contact': ActivityContacts.masked(_draft!.value.contact!),
        },
    });
  }

  Future<void> persist(ActivityAccountStore store) async {
    _open();
    ActivityBookingGuard.scope(saved.scope, store.scope);
    await store.saveLibrary(saved.checkpoint());
    await store.savePreferences(preferences.value);
  }

  Future<bool> restore(
    ActivityAccountStore store, {
    required int expectedRevision,
  }) async {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    ActivityBookingGuard.scope(saved.scope, store.scope);
    final libraryRevision = saved.revision,
        checkpoint = await store.loadLibrary();
    if (_closed ||
        _revision != expectedRevision ||
        saved.revision != libraryRevision ||
        checkpoint == null)
      return false;
    saved.restore(checkpoint, expectedRevision: libraryRevision);
    _emit();
    return true;
  }

  Future<Map<String, bool>> erase({
    required ActivityAccountStore store,
    ActivityBookingRecoveryStore? recovery,
    List<String> draftIds = const [],
    List<String> itineraryIds = const [],
  }) async {
    _open();
    if (_submitting ||
        _booking?.outcome.busy == true ||
        _booking?.outcome.requiresReconciliation == true)
      throw StateError(
        'Resolve the active operation before erasing recovery data',
      );
    ActivityBookingGuard.scope(saved.scope, store.scope);
    if (recovery != null)
      ActivityBookingGuard.scope(saved.scope, recovery.scope);
    privacy.reset();
    history.clear();
    reminders.clear();
    saved.clear();
    final result = <String, bool>{};
    try {
      await store.clear(itineraryIds: itineraryIds);
      result['account'] = true;
    } catch (_) {
      result['account'] = false;
    }
    if (recovery != null)
      for (final id in draftIds) {
        try {
          await recovery.clear(id);
          result['draft:$id'] = true;
        } catch (_) {
          result['draft:$id'] = false;
        }
      }
    _draft = null;
    _booking = null;
    _bookings.clear();
    _emit();
    return Map.unmodifiable(result);
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    for (final subscription in _subscriptions) await subscription.cancel();
    await _changes.close();
    // Supplied discovery, booking and storage dependencies remain host-owned.
  }
}

/// Simple FlutterFlow command bridge for reversible local actions. Financial
/// operations remain explicit typed methods with their own reviewed intents.
class ActivityLifecycleCommands {
  ActivityLifecycleCommands(this.workspace);
  final ActivityLifecycleWorkspace workspace;
  Map<String, Object?> execute(Map<String, Object?> input) {
    final command = ActivityGuard.object(input);
    final type = ActivityCodec.text(command, 'type', required: true)!;
    final expectedRevision = ActivityCodec.integer(
      command,
      'expectedRevision',
      required: true,
      minimum: 1,
    )!;
    ActivityGuard.revision(workspace.revision, expectedRevision);
    switch (type) {
      case 'save':
        ActivityCodec.keys(command, {
          'type',
          'expectedRevision',
          'id',
          'productId',
        });
        workspace.save(
          ActivityCodec.text(command, 'productId', required: true)!,
          id: ActivityCodec.text(command, 'id', required: true)!,
          expectedRevision: expectedRevision,
        );
      case 'markNotificationRead':
        ActivityCodec.keys(command, {
          'type',
          'expectedRevision',
          'id',
          'notificationRevision',
        });
        workspace.reminders.update(
          ActivityCodec.text(command, 'id', required: true)!,
          expectedRevision: ActivityCodec.integer(
            command,
            'notificationRevision',
            required: true,
            minimum: 1,
          )!,
          read: true,
        );
      case 'preferences':
        ActivityCodec.keys(command, {
          'type',
          'expectedRevision',
          'preferenceRevision',
          'currency',
          'language',
          'hideSaved',
          'offlineEnabled',
          'sortField',
        });
        workspace.preferences.update(
          expectedRevision: ActivityCodec.integer(
            command,
            'preferenceRevision',
            required: true,
            minimum: 1,
          )!,
          currency: ActivityCodec.text(command, 'currency'),
          language: ActivityCodec.text(command, 'language'),
          hideSaved: ActivityCodec.boolean(command, 'hideSaved'),
          offlineEnabled: ActivityCodec.boolean(command, 'offlineEnabled'),
          sortField: ActivityCodec.text(command, 'sortField'),
        );
      default:
        throw const FormatException(
          'Unknown or unsupported local activity command',
        );
    }
    return workspace.screenState();
  }
}
