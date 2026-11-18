import 'dart:async';
import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';
import 'support.dart';
import 'booking_support.dart';

Future<ActivityLifecycleWorkspace> app() async {
  final provider = FakeProvider((r) async => page(r));
  final discovery = ActivityWorkspace(
    controller: ActivityDiscoveryController(
      provider,
      scope: 'test-user',
      clock: () => now,
    ),
    clock: () => now,
  );
  await discovery.refresh(request('r'));
  return ActivityLifecycleWorkspace(
    discovery: discovery,
    saved: ActivitySavedLibrary(scope: 'test-user', clock: () => now),
    preferences: ActivityPreferences(scope: 'test-user', clock: () => now),
    privacy: ActivityAccountPrivacy(
      scope: 'test-user',
      clock: () => now,
      policyVersion: 'v1',
    ),
    history: ActivityAccountHistory(scope: 'test-user', clock: () => now),
    reminders: ActivityReminderCenter(scope: 'test-user', clock: () => now),
    clock: () => now,
  );
}

Future<void> dispose(ActivityLifecycleWorkspace app) async {
  await app.close();
  await app.discovery.close();
  await app.saved.close();
}

void main() {
  test(
    'local command bridge saves discovery without exposing financial commands',
    () async {
      final workspace = await app(),
          commands = ActivityLifecycleCommands(await app());
      final local = ActivityLifecycleCommands(workspace);
      final result = local.execute({
        'type': 'save',
        'id': 'saved',
        'productId': 'product',
        'expectedRevision': workspace.revision,
      });
      expect(workspace.saved.saved.single.product.id, 'product');
      expect(result['dashboard'], isNotNull);
      expect(
        () => local.execute({
          'type': 'book',
          'expectedRevision': workspace.revision,
        }),
        throwsFormatException,
      );
      await dispose(workspace);
      await dispose(commands.workspace);
    },
  );
  test(
    'composed booking publishes confirmed backend state and masked contact',
    () async {
      final workspace = await app(),
          draft = readyDraft(),
          controller = ActivityBookingController(
            BookingTransport(),
            scope: 'test-user',
            clock: () => now,
          );
      workspace.attachBooking(
        draft,
        controller,
        expectedRevision: workspace.revision,
      );
      final outcome = await workspace.submit(
        intentId: 'intent',
        policy: policy,
        confirmedByUser: true,
        expectedRevision: workspace.revision,
      );
      expect(outcome.confirmed, isTrue);
      expect(draft.value.state, 'confirmed');
      expect(workspace.dashboard().confirmedBookingCount, 1);
      expect(
        workspace.screenState().toString(),
        isNot(contains('guest@example.com')),
      );
      await controller.close();
      await dispose(workspace);
    },
  );
  test(
    'notification capacity cannot turn a confirmed booking into a failed submission',
    () async {
      final workspace = await app(),
          draft = readyDraft(),
          controller = ActivityBookingController(
            BookingTransport(),
            scope: 'test-user',
            clock: () => now,
          );
      for (var i = 0; i < 100; i++)
        workspace.reminders.notify(
          id: 'n$i',
          resourceId: 'resource',
          kind: 'booking',
        );
      workspace.attachBooking(
        draft,
        controller,
        expectedRevision: workspace.revision,
      );
      final outcome = await workspace.submit(
        intentId: 'intent',
        policy: policy,
        confirmedByUser: true,
        expectedRevision: workspace.revision,
      );
      expect(outcome.confirmed, isTrue);
      expect(
        workspace.screenState()['warningCodes'],
        contains('bookingNotificationUnavailable'),
      );
      await controller.close();
      await dispose(workspace);
    },
  );
  test(
    'uncertain booking blocks switching drafts and resolves without a second write',
    () async {
      final workspace = await app(),
          draft = readyDraft(),
          transport = BookingTransport(
            onSubmit: (i, d) async => throw TimeoutException('lost reply'),
          );
      final controller = ActivityBookingController(
        transport,
        scope: 'test-user',
        clock: () => now,
      );
      workspace.attachBooking(
        draft,
        controller,
        expectedRevision: workspace.revision,
      );
      final outcome = await workspace.submit(
        intentId: 'intent',
        policy: policy,
        confirmedByUser: true,
        expectedRevision: workspace.revision,
      );
      expect(outcome.requiresReconciliation, isTrue);
      expect(
        () => workspace.attachBooking(
          readyDraft(id: 'other'),
          controller,
          expectedRevision: workspace.revision,
        ),
        throwsStateError,
      );
      expect((await workspace.reconcile()).confirmed, isTrue);
      expect(transport.submits, 1);
      await controller.close();
      await dispose(workspace);
    },
  );
  test(
    'closing the composer preserves externally owned dependencies',
    () async {
      final workspace = await app();
      await workspace.close();
      expect(workspace.dashboard, throwsStateError);
      expect(workspace.discovery.snapshot().result.products.length, 1);
      await workspace.discovery.close();
      await workspace.saved.close();
    },
  );
}
