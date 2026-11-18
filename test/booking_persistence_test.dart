import 'dart:async';
import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';
import 'support.dart';
import 'booking_support.dart';

ActivityAccountPrivacy privacy() => ActivityAccountPrivacy(
  scope: 'test-user',
  clock: () => now,
  policyVersion: 'v1',
);
void main() {
  test(
    'private booking retention defaults off and has no plaintext fallback',
    () async {
      final protected = ProtectedMemory(),
          controls = privacy(),
          store = ActivityBookingRecoveryStore(
            ProtectedMemory(),
            scope: 'test-user',
            clock: () => now,
          );
      expect(
        () => store.save(readyDraft().value, privacy: controls),
        throwsStateError,
      );
      expect(protected.values, isEmpty);
      await store.close();
    },
  );
  test(
    'protected draft recovery preserves intent identity and denies other accounts',
    () async {
      final protected = ProtectedMemory(), controls = privacy();
      controls.decide(
        id: 'c',
        purpose: 'draftDetails',
        granted: true,
        expectedRevision: 1,
      );
      final store = ActivityBookingRecoveryStore(
            protected,
            scope: 'test-user',
            clock: () => now,
          ),
          draft = readyDraft().value;
      final intent = ActivityBookingIntents.prepare(
        draft,
        policy,
        id: 'intent',
        now: now,
        confirmedByUser: true,
      );
      await store.save(draft, privacy: controls, intent: intent);
      final recovery = await store.load(draft.id, privacy: controls);
      expect(recovery!.draft, draft);
      expect(recovery.intent, intent);
      final other = ActivityAccountPrivacy(
        scope: 'other',
        clock: () => now,
        policyVersion: 'v1',
      );
      await expectLater(store.load(draft.id, privacy: other), throwsStateError);
      await store.close();
    },
  );
  test(
    'withdrawing retention while a protected write waits removes its payload',
    () async {
      final protected = ProtectedMemory(), controls = privacy();
      controls.decide(
        id: 'c',
        purpose: 'draftDetails',
        granted: true,
        expectedRevision: 1,
      );
      final blocked = Completer<void>();
      protected.beforeWrite = () => blocked.future;
      final store = ActivityBookingRecoveryStore(
        protected,
        scope: 'test-user',
        clock: () => now,
      );
      final saving = store.save(readyDraft().value, privacy: controls);
      await Future<void>.delayed(Duration.zero);
      controls.decide(
        id: 'c',
        purpose: 'draftDetails',
        granted: false,
        expectedRevision: controls.value.revision,
      );
      blocked.complete();
      await saving;
      expect(protected.values, isEmpty);
      await store.close();
    },
  );
  test(
    'protected recovery detects corruption and refuses stale draft overwrite',
    () async {
      final protected = ProtectedMemory(), controls = privacy();
      controls.decide(
        id: 'c',
        purpose: 'draftDetails',
        granted: true,
        expectedRevision: 1,
      );
      final store = ActivityBookingRecoveryStore(
            protected,
            scope: 'test-user',
            clock: () => now,
          ),
          draft = readyDraft();
      final original = draft.value;
      await store.save(original, privacy: controls);
      draft.contact(
        ActivityBookingContact(email: 'updated@example.com', updatedAt: now),
        expectedRevision: draft.value.revision,
      );
      await store.save(draft.value, privacy: controls);
      await expectLater(
        store.save(original, privacy: controls),
        throwsStateError,
      );
      final key = protected.values.keys.single;
      protected.values[key] = protected.values[key]!.replaceFirst(
        'updated@example.com',
        'other@example.com',
      );
      await expectLater(
        store.load(original.id, privacy: controls),
        throwsFormatException,
      );
      await store.close();
    },
  );
  test(
    'saved collection reorder and removal preserve graph integrity',
    () async {
      final library = ActivitySavedLibrary(
        scope: 'test-user',
        clock: () => now,
      );
      library.save(product(), id: 'a');
      library.save(product(id: 'other'), id: 'b');
      library.createCollection(id: 'c', title: 'Weekend');
      library.add('c', 'a', id: 'ia', expectedRevision: 1);
      library.add('c', 'b', id: 'ib', expectedRevision: 2);
      library.reorder('c', ['ib', 'ia'], expectedRevision: 3);
      expect(library.items('c').map((i) => i.id), ['ib', 'ia']);
      library.removeSaved('b', expectedRevision: 1);
      expect(library.items('c').single.position, 0);
      ActivitySavedLibrary.validateCheckpoint(
        library.checkpoint(),
        scope: 'test-user',
        now: now,
      );
      await library.close();
    },
  );
  test('saved checkpoint restore rejects orphan items atomically', () async {
    final library = ActivitySavedLibrary(scope: 'test-user', clock: () => now);
    library.save(product(), id: 'a');
    final previous = library.checkpoint();
    final bad = previous.copyWith(
      items: [
        ActivityCollectionItem(
          id: 'i',
          collectionId: 'missing',
          savedActivityId: 'a',
          addedAt: now,
        ),
      ],
    );
    expect(
      () => library.restore(bad, expectedRevision: library.revision),
      throwsStateError,
    );
    expect(library.checkpoint(), previous);
    await library.close();
  });
  test(
    'account store round trip rejects stale writes and checksum tampering',
    () async {
      final storage = MemoryStorage(),
          store = ActivityAccountStore(
            MemoryStorage(),
            scope: 'other',
            clock: () => now,
          );
      final own = ActivityAccountStore(
            storage,
            scope: 'test-user',
            clock: () => now,
          ),
          library = ActivitySavedLibrary(scope: 'test-user', clock: () => now);
      library.save(product(), id: 'a');
      final first = library.checkpoint();
      await own.saveLibrary(first);
      expect((await own.loadLibrary())!.saved.single.product.id, 'product');
      library.edit('a', expectedRevision: 1, note: 'Private');
      await own.saveLibrary(library.checkpoint());
      await expectLater(own.saveLibrary(first), throwsStateError);
      final key = storage.values.keys.single;
      storage.values[key] = storage.values[key]!.replaceFirst(
        'Museum tour',
        'Changed',
      );
      await expectLater(own.loadLibrary(), throwsFormatException);
      await library.close();
      await own.close();
      await store.close();
    },
  );
  test('history and audit retention require independent purpose consent', () {
    final controls = privacy(),
        history = ActivityAccountHistory(scope: 'test-user', clock: () => now);
    expect(
      history.record(
        id: 's',
        kind: 'search',
        resourceId: 'destination',
        text: 'Museum',
        privacy: controls,
      ),
      isNull,
    );
    controls.decide(
      id: 'history',
      purpose: 'history',
      granted: true,
      expectedRevision: 1,
    );
    expect(
      history.record(
        id: 's',
        kind: 'search',
        resourceId: 'destination',
        text: 'Museum',
        privacy: controls,
      ),
      isNotNull,
    );
    expect(
      history.audit(
        ActivityAuditEvent(
          id: 'a',
          scope: 'test-user',
          resourceId: 'product',
          kind: 'saved',
          occurredAt: now,
        ),
        privacy: controls,
      ),
      isFalse,
    );
  });
  test('reminders remain opt-in and are acknowledged only while due', () {
    var clock = now;
    final center = ActivityReminderCenter(
      scope: 'test-user',
      clock: () => clock,
    );
    center.schedule(
      id: 'r',
      resourceId: 'booking',
      dueAt: now.add(const Duration(minutes: 30)),
      enabled: false,
    );
    expect(center.due(), isEmpty);
    final enabled = center.reminders.single.copyWith(enabled: true);
    center.restore([enabled], []);
    clock = now.add(const Duration(minutes: 5));
    expect(center.due().single.id, 'r');
    center.delivered('r', expectedRevision: 1);
    expect(center.due(), isEmpty);
  });
  test('saved synchronization refuses booking and cancellation operations', () {
    final sync = ActivitySavedSync(
      scope: 'test-user',
      clock: () => now,
      transport: SavedTransport(
        (b) async =>
            ActivitySyncAck(batchId: b.id, scope: b.scope, receivedAt: now),
      ),
    );
    expect(
      () => sync.enqueue(
        id: 'm',
        resourceId: 'booking:live',
        kind: 'upsert',
        payload: {'state': 'confirmed'},
        expectedRevision: 1,
      ),
      throwsStateError,
    );
    sync.close();
  });
  test(
    'saved sync deduplicates payloads and validates acknowledgements',
    () async {
      final transport = SavedTransport(
        (b) async => ActivitySyncAck(
          batchId: b.id,
          scope: b.scope,
          receivedAt: now,
          acknowledgedIds: b.mutations.map((m) => m.id).toList(),
        ),
      );
      final sync = ActivitySavedSync(
        scope: 'test-user',
        clock: () => now,
        transport: transport,
      );
      final first = sync.enqueue(
        id: 'm',
        resourceId: 'saved:p',
        kind: 'upsert',
        payload: {'id': 'p'},
        expectedRevision: 1,
      );
      expect(
        sync.enqueue(
          id: 'm',
          resourceId: 'saved:p',
          kind: 'upsert',
          payload: {'id': 'p'},
          expectedRevision: 1,
        ),
        first,
      );
      expect(
        () => sync.enqueue(
          id: 'm',
          resourceId: 'saved:p',
          kind: 'upsert',
          payload: {'id': 'other'},
          expectedRevision: 1,
        ),
        throwsStateError,
      );
      await sync.flush(batchId: 'batch');
      expect(sync.mutations.single.state, 'acknowledged');
      sync.close();
    },
  );
  test(
    'restored interrupted saved sync sends only local saved content',
    () async {
      final sync = ActivitySavedSync(
        scope: 'test-user',
        clock: () => now,
        transport: SavedTransport((b) async => throw StateError('offline')),
      );
      sync.enqueue(
        id: 'm',
        resourceId: 'saved:p',
        kind: 'upsert',
        payload: {'id': 'p'},
        expectedRevision: 1,
      );
      await expectLater(
        sync.flush(batchId: 'b'),
        throwsA(isA<ActivityOperationException>()),
      );
      expect(sync.mutations.single.state, 'pending');
      final json = sync.snapshot();
      final copy = ActivitySavedSync(
        scope: 'test-user',
        clock: () => now,
        transport: SavedTransport(
          (b) async =>
              ActivitySyncAck(batchId: b.id, scope: b.scope, receivedAt: now),
        ),
      );
      copy.restore(json, expectedGeneration: 1);
      expect(copy.generation, greaterThan(sync.generation));
      sync.close();
      copy.close();
    },
  );
}
