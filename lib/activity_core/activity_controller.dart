import 'dart:async';
import '../trippl_activities_mobile.dart';

abstract interface class ActivityProvider {
  Future<ActivityProviderPage> fetch(ActivityProviderRequest request);
}

class ActivityProviderException implements Exception {
  const ActivityProviderException(
    this.code, {
    this.retryable = false,
    this.retryAfterSeconds,
  });
  final String code;
  final bool retryable;
  final int? retryAfterSeconds;
  @override
  String toString() => 'Activity provider read failed';
}

class ActivityDiscoveryController {
  ActivityDiscoveryController(
    this.provider, {
    required this.scope,
    required this.clock,
    this.timeout = const Duration(seconds: 15),
    this.maximumAttempts = 2,
  }) {
    ActivityGuard.identity(scope);
    if (timeout <= Duration.zero ||
        timeout > const Duration(minutes: 2) ||
        maximumAttempts < 1 ||
        maximumAttempts > 3)
      throw ArgumentError('Invalid activity read policy');
  }
  final ActivityProvider provider;
  final String scope;
  final DateTime Function() clock;
  final Duration timeout;
  final int maximumAttempts;
  final _changes = StreamController<ActivityDiscoveryState>.broadcast();
  Stream<ActivityDiscoveryState> get changes => _changes.stream;
  ActivityDiscoveryState? _state;
  ActivityDiscoveryState? get state => _state;
  int _epoch = 0, _active = 0;
  bool _closed = false;
  static void validateResponse(
    ActivityProviderRequest request,
    ActivityProviderPage page, {
    required DateTime now,
  }) {
    ActivityRequests.validate(request);
    ActivityGuard.record(page.validate());
    if (page.requestFingerprint != ActivityRequests.fingerprint(request) ||
        !ActivityGuard.fresh(page.observedAt, page.expiresAt, now) ||
        page.products.length > request.limit ||
        page.slots.length > request.limit ||
        page.quotes.length > request.limit)
      throw const FormatException(
        'Activity response identity freshness or bounds mismatch',
      );
    if (request.mode == 'search' &&
        (page.slots.isNotEmpty || page.quotes.isNotEmpty))
      throw const FormatException(
        'Search response contains unrelated slot or quote data',
      );
    for (final product in page.products) {
      ActivityGuard.product(product, now: now);
      if (request.mode != 'search' && request.productId != product.id)
        throw const FormatException('Activity details identity mismatch');
    }
    for (final slot in page.slots) {
      if (slot.productId != request.availability?.productId ||
          slot.optionId != request.availability?.optionId ||
          slot.observedAt.isAfter(now))
        throw const FormatException('Availability response selection mismatch');
    }
    for (final quote in page.quotes) {
      if (request.mode != 'quote' ||
          quote.productId != request.availability?.productId ||
          quote.optionId != request.availability?.optionId ||
          quote.slotId != request.slotId ||
          quote.requestFingerprint != page.requestFingerprint ||
          quote.total.currency != request.availability?.currency ||
          !ActivityGuard.fresh(quote.observedAt, quote.expiresAt, now))
        throw const FormatException(
          'Quote response selection or freshness mismatch',
        );
    }
  }

  void _emit(ActivityDiscoveryState state) {
    if (_closed) return;
    ActivityGuard.record(state.validate());
    _state = state;
    _changes.add(state);
  }

  Future<ActivityDiscoveryState?> load(
    ActivityProviderRequest request, {
    required Future<void> Function(Duration) wait,
  }) async {
    if (_closed) throw StateError('Activity controller closed');
    ActivityRequests.validate(request);
    if (request.scope != scope || request.createdAt.isAfter(clock()))
      throw StateError('Activity request account or clock mismatch');
    if (_active >= 4) throw StateError('Too many concurrent activity reads');
    final epoch = ++_epoch;
    _active++;
    try {
      for (var attempt = 1; attempt <= maximumAttempts; attempt++) {
        if (_closed || epoch != _epoch) return null;
        _emit(
          ActivityDiscoveryState(
            requestId: request.id,
            scopeFingerprint: ActivityCodec.digest(scope),
            updatedAt: clock(),
            state: 'loading',
            generation: epoch,
            attempt: attempt,
          ),
        );
        try {
          final page = await provider.fetch(request).timeout(timeout);
          if (_closed || epoch != _epoch) return null;
          validateResponse(request, page, now: clock());
          final state = ActivityDiscoveryState(
            requestId: request.id,
            scopeFingerprint: ActivityCodec.digest(scope),
            updatedAt: clock(),
            state: 'ready',
            page: page,
            generation: epoch,
            attempt: attempt,
          );
          _emit(state);
          return state;
        } catch (error) {
          if (_closed || epoch != _epoch) return null;
          final known = error is ActivityProviderException ? error : null;
          final retry = known?.retryable ?? error is TimeoutException;
          if (retry && attempt < maximumAttempts) {
            await wait(
              Duration(
                seconds: (known?.retryAfterSeconds ?? (1 << attempt)).clamp(
                  1,
                  30,
                ),
              ),
            );
            continue;
          }
          final raw =
              known?.code ??
              (error is TimeoutException ? 'timeout' : 'invalidResponse');
          final code = RegExp(r'^[A-Za-z0-9_-]{1,80}$').hasMatch(raw)
              ? raw
              : 'providerFailure';
          final state = ActivityDiscoveryState(
            requestId: request.id,
            scopeFingerprint: ActivityCodec.digest(scope),
            updatedAt: clock(),
            state: 'failed',
            generation: epoch,
            attempt: attempt,
            failure: ActivityProviderFailure(
              code: code,
              occurredAt: clock(),
              retryable: retry,
              retryAfterSeconds: known?.retryAfterSeconds?.clamp(0, 120),
            ),
          );
          _emit(state);
          return state;
        }
      }
      return null;
    } finally {
      _active--;
    }
  }

  void cancel() {
    if (_closed) return;
    _epoch++;
    final old = _state;
    if (old != null)
      _emit(
        ActivityDiscoveryState(
          requestId: old.requestId,
          scopeFingerprint: ActivityCodec.digest(scope),
          updatedAt: clock(),
          state: 'cancelled',
          generation: _epoch,
        ),
      );
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _epoch++;
    await _changes.close();
  }
}

/// One debouncer per search screen. Replaced text searches resolve as cancelled;
/// provider work already sent is fenced by the controller's generation guard.
class ActivitySearchDebouncer {
  ActivitySearchDebouncer(
    this.controller, {
    this.delay = const Duration(milliseconds: 300),
  }) {
    if (delay < Duration.zero || delay > const Duration(seconds: 5)) {
      throw ArgumentError('Invalid activity search delay');
    }
  }
  final ActivityDiscoveryController controller;
  final Duration delay;
  Timer? _timer;
  Completer<ActivityDiscoveryState?>? _pending;
  int _generation = 0;
  bool _closed = false;

  Future<ActivityDiscoveryState?> search(ActivityProviderRequest request) {
    if (_closed) throw StateError('Activity search debouncer closed');
    ActivityRequests.validate(request);
    if (request.mode != 'search' || request.scope != controller.scope) {
      throw const FormatException(
        'Debounced search requires matching account scope',
      );
    }
    cancel();
    final generation = _generation;
    final completion = Completer<ActivityDiscoveryState?>();
    _pending = completion;
    _timer = Timer(delay, () {
      _timer = null;
      _read(request, generation, completion);
    });
    return completion.future;
  }

  Future<void> _read(
    ActivityProviderRequest request,
    int generation,
    Completer<ActivityDiscoveryState?> completion,
  ) async {
    if (_closed || generation != _generation) {
      if (!completion.isCompleted) completion.complete(null);
      return;
    }
    try {
      final state = await controller.load(request, wait: Future<void>.delayed);
      if (!completion.isCompleted) {
        completion.complete(
          _closed || generation != _generation ? null : state,
        );
      }
    } catch (error, stack) {
      if (!completion.isCompleted) {
        if (_closed || generation != _generation) {
          completion.complete(null);
        } else {
          completion.completeError(
            const ActivityProviderException('searchReadFailed'),
            stack,
          );
        }
      }
    } finally {
      if (identical(_pending, completion)) _pending = null;
    }
  }

  void cancel() {
    _generation++;
    _timer?.cancel();
    _timer = null;
    final pending = _pending;
    _pending = null;
    if (pending != null && !pending.isCompleted) pending.complete(null);
    controller.cancel();
  }

  void close() {
    if (_closed) return;
    cancel();
    _closed = true;
  }
}
