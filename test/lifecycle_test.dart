import 'dart:async';
import 'package:test/test.dart';
import 'package:trippl_activities_mobile/trippl_activities_mobile.dart';
import 'support.dart';

void main() {
  test(
    'filtering out selection cancels its in-flight availability update',
    () async {
      final completion = Completer<ActivityProviderPage>();
      ActivityProviderRequest? pending;
      final provider = FakeProvider((r) {
        if (r.mode == 'search') return Future.value(page(r));
        pending = r;
        return completion.future;
      });
      final workspace = ActivityWorkspace(
        controller: ActivityDiscoveryController(
          provider,
          scope: 'test-user',
          clock: () => now,
        ),
        clock: () => now,
      );
      await workspace.refresh(request('r'));
      workspace.select(
        'product',
        optionId: 'option',
        expectedRevision: workspace.revision,
      );
      final future = workspace.checkAvailability(
        ActivityRequests(
          scope: 'test-user',
          clock: () => now,
        ).availability(availability()),
        offsetMinutes: 0,
        expectedRevision: workspace.revision,
      );
      workspace.refine(
        expectedRevision: workspace.revision,
        query: ActivitySearchQuery(text: 'not found'),
      );
      completion.complete(
        ActivityProviderPage(
          id: 'p',
          requestFingerprint: ActivityRequests.fingerprint(pending!),
          observedAt: now,
          expiresAt: now.add(const Duration(minutes: 5)),
          slots: [slot()],
        ),
      );
      expect(await future, isFalse);
      expect(workspace.snapshot().selection, isNull);
      expect(workspace.snapshot().availability, isNull);
      await workspace.close();
    },
  );

  test('newer search wins when an older response arrives late', () async {
    final first = Completer<ActivityProviderPage>();
    final provider = FakeProvider(
      (r) => r.id == 'first' ? first.future : Future.value(page(r)),
    );
    final controller = ActivityDiscoveryController(
      provider,
      scope: 'test-user',
      clock: () => now,
    );
    final pending = controller.load(request('first'), wait: noWait);
    await controller.load(request('second'), wait: noWait);
    first.complete(page(request('first')));
    expect(await pending, isNull);
    expect(controller.state!.requestId, 'second');
    await controller.close();
  });
  test(
    'retryable errors use bounded backoff while unknown errors are redacted',
    () async {
      var count = 0;
      final provider = FakeProvider((r) async {
        if (++count == 1)
          throw const ActivityProviderException(
            'busy',
            retryable: true,
            retryAfterSeconds: 999,
          );
        return page(r);
      });
      final controller = ActivityDiscoveryController(
        provider,
        scope: 'test-user',
        clock: () => now,
      );
      final waits = <Duration>[];
      expect(
        (await controller.load(
          request('r'),
          wait: (d) async {
            waits.add(d);
          },
        ))!.state,
        'ready',
      );
      expect(waits.single, const Duration(seconds: 30));
      await controller.close();
      final failed = ActivityDiscoveryController(
        FakeProvider((_) async => throw StateError('secret')),
        scope: 'test-user',
        clock: () => now,
      );
      expect(
        (await failed.load(request('r'), wait: noWait))!.failure!.code,
        'invalidResponse',
      );
      await failed.close();
    },
  );
  test(
    'wrong response fingerprint fails without accepting its products',
    () async {
      final provider = FakeProvider(
        (r) async => page(r).copyWith(requestFingerprint: 'a' * 64),
      );
      final controller = ActivityDiscoveryController(
        provider,
        scope: 'test-user',
        clock: () => now,
      );
      expect(
        (await controller.load(request('r'), wait: noWait))!.state,
        'failed',
      );
      expect(provider.calls, 1);
      await controller.close();
    },
  );
  test(
    'cancelled debounce resolves prior caller and performs only the latest search',
    () async {
      final provider = FakeProvider((r) async => page(r));
      final controller = ActivityDiscoveryController(
        provider,
        scope: 'test-user',
        clock: () => now,
      );
      final debounce = ActivitySearchDebouncer(
        controller,
        delay: Duration.zero,
      );
      final first = debounce.search(request('first')),
          second = debounce.search(request('second'));
      expect(await first, isNull);
      expect((await second)!.requestId, 'second');
      expect(provider.calls, 1);
      debounce.close();
      await controller.close();
    },
  );
  test('cache is account-scoped and stale restoration is explicit', () async {
    final storage = MemoryStorage(),
        cache = ActivityDiscoveryCache(MemoryStorage(), scope: 'other');
    final own = ActivityDiscoveryCache(storage, scope: 'test-user');
    final r = request('r');
    await own.save(r, page(r), now: now);
    expect((await own.load(r, now: now))!.offline, isTrue);
    final later = now.add(const Duration(minutes: 20));
    expect(await own.load(r, now: later), isNull);
    expect(await own.load(r, now: later, allowStale: true), isNotNull);
    expect(await cache.load(r.copyWith(scope: 'other'), now: now), isNull);
    await own.close();
    await cache.close();
  });
  test(
    'cache corruption fails rather than returning modified product data',
    () async {
      final storage = MemoryStorage(),
          cache = ActivityDiscoveryCache(MemoryStorage(), scope: 'test-user');
      final own = ActivityDiscoveryCache(storage, scope: 'test-user');
      final r = request('r');
      await own.save(r, page(r), now: now);
      storage.values[own.key] = storage.values[own.key]!.replaceFirst(
        'Museum tour',
        'Changed',
      );
      await expectLater(own.load(r, now: now), throwsFormatException);
      await own.close();
      await cache.close();
    },
  );
  test(
    'availability and quotes are never saved as discovery cache entries',
    () {
      final cache = ActivityDiscoveryCache(MemoryStorage(), scope: 'test-user');
      final r = ActivityRequests(
        scope: 'test-user',
        clock: () => now,
      ).availability(availability());
      final value = ActivityProviderPage(
        id: 'p',
        requestFingerprint: ActivityRequests.fingerprint(r),
        observedAt: now,
        expiresAt: now.add(const Duration(minutes: 1)),
        slots: [slot()],
      );
      expect(() => cache.save(r, value, now: now), throwsFormatException);
    },
  );
  test(
    'pagination detects repeated cursors and merges ordered unique products',
    () async {
      final invalid = ActivityPagination(
        FakeProvider((r) async => page(r, cursor: 'same')),
      );
      await expectLater(
        invalid.load(request('r'), clock: () => now),
        throwsFormatException,
      );
      invalid.close();
      final valid = ActivityPagination(
        FakeProvider(
          (r) async => r.cursor == null
              ? page(
                  r,
                  products: [product(id: 'a')],
                  cursor: 'next',
                )
              : page(r, products: [product(id: 'b')]),
        ),
      );
      final merged = await valid.load(request('r'), clock: () => now);
      expect(merged!.products.map((p) => p.id), ['a', 'b']);
      expect(merged.complete, isTrue);
      valid.close();
    },
  );
  test(
    'workspace option availability slot and quote form a bound read-only flow',
    () async {
      final factory = ActivityRequests(scope: 'test-user', clock: () => now);
      final provider = FakeProvider((r) async {
        if (r.mode == 'search') return page(r);
        return ActivityProviderPage(
          id: 'page-${r.id}',
          requestFingerprint: ActivityRequests.fingerprint(r),
          observedAt: now,
          expiresAt: now.add(const Duration(minutes: 5)),
          slots: r.mode == 'availability' ? [slot()] : [],
          quotes: r.mode == 'quote'
              ? [
                  ActivityPriceQuote(
                    id: 'quote',
                    productId: 'product',
                    optionId: 'option',
                    slotId: 'slot',
                    requestFingerprint: ActivityRequests.fingerprint(r),
                    observedAt: now,
                    expiresAt: now.add(const Duration(minutes: 5)),
                    total: money(1000),
                    indicative: false,
                  ),
                ]
              : [],
          complete: true,
        );
      });
      final controller = ActivityDiscoveryController(
            provider,
            scope: 'test-user',
            clock: () => now,
          ),
          workspace = ActivityWorkspace(
            controller: ActivityDiscoveryController(
              provider,
              scope: 'test-user',
              clock: () => now,
            ),
            clock: () => now,
          );
      expect(
        await workspace.refresh(factory.search(ActivitySearchQuery())),
        isTrue,
      );
      workspace.select(
        'product',
        optionId: 'option',
        expectedRevision: workspace.revision,
      );
      expect(
        await workspace.checkAvailability(
          factory.availability(availability()),
          offsetMinutes: 0,
          expectedRevision: workspace.revision,
        ),
        isTrue,
      );
      workspace.selectSlot('slot', expectedRevision: workspace.revision);
      expect(
        await workspace.checkQuote(
          factory.availability(availability(slotId: 'slot'), quote: true),
          expectedRevision: workspace.revision,
        ),
        isTrue,
      );
      expect(workspace.review().readyForHostReview, isTrue);
      expect(workspace.review().toJson()['bookingConfirmed'], isFalse);
      workspace.select(
        'product',
        optionId: 'option',
        expectedRevision: workspace.revision,
      );
      expect(workspace.snapshot().quote, isNull);
      expect(workspace.review().readyForHostReview, isFalse);
      await workspace.close();
      await controller.close();
    },
  );
  test('offline results cannot be used to confirm availability', () async {
    final provider = FakeProvider((r) async => page(r)),
        cache = ActivityDiscoveryCache(MemoryStorage(), scope: 'test-user');
    final workspace = ActivityWorkspace(
      controller: ActivityDiscoveryController(
        provider,
        scope: 'test-user',
        clock: () => now,
      ),
      clock: () => now,
      cache: cache,
    );
    final r = request('r');
    await cache.save(r, page(r), now: now);
    expect(await workspace.restore(r), isTrue);
    workspace.select(
      'product',
      optionId: 'option',
      expectedRevision: workspace.revision,
    );
    await expectLater(
      workspace.checkAvailability(
        ActivityRequests(
          scope: 'test-user',
          clock: () => now,
        ).availability(availability()),
        offsetMinutes: 0,
        expectedRevision: workspace.revision,
      ),
      throwsStateError,
    );
    await workspace.close();
    await cache.close();
  });
  test(
    'changing selected product discards an in-flight availability response',
    () async {
      final completion = Completer<ActivityProviderPage>();
      ActivityProviderRequest? pending;
      final provider = FakeProvider((r) {
        if (r.mode == 'search') return Future.value(page(r));
        pending = r;
        return completion.future;
      });
      final workspace = ActivityWorkspace(
        controller: ActivityDiscoveryController(
          provider,
          scope: 'test-user',
          clock: () => now,
        ),
        clock: () => now,
      );
      await workspace.refresh(request('r'));
      workspace.select(
        'product',
        optionId: 'option',
        expectedRevision: workspace.revision,
      );
      final future = workspace.checkAvailability(
        ActivityRequests(
          scope: 'test-user',
          clock: () => now,
        ).availability(availability()),
        offsetMinutes: 0,
        expectedRevision: workspace.revision,
      );
      workspace.select(
        'product',
        optionId: 'option',
        expectedRevision: workspace.revision,
      );
      completion.complete(
        ActivityProviderPage(
          id: 'p',
          requestFingerprint: ActivityRequests.fingerprint(pending!),
          observedAt: now,
          expiresAt: now.add(const Duration(minutes: 5)),
          slots: [slot()],
        ),
      );
      expect(await future, isFalse);
      expect(workspace.snapshot().availability, isNull);
      await workspace.close();
    },
  );
}
