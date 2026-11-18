import '../trippl_activities_mobile.dart';

class ActivityPagination {
  ActivityPagination(
    this.provider, {
    this.maximumPages = 5,
    this.maximumProducts = 100,
    this.timeout = const Duration(seconds: 30),
  }) {
    if (maximumPages < 1 ||
        maximumPages > 20 ||
        maximumProducts < 1 ||
        maximumProducts > 100 ||
        timeout <= Duration.zero ||
        timeout > const Duration(minutes: 2))
      throw ArgumentError('Invalid activity pagination policy');
  }
  final ActivityProvider provider;
  final int maximumPages, maximumProducts;
  final Duration timeout;
  int _epoch = 0;
  bool _closed = false;
  static ActivityProviderPage merge(
    ActivityProviderPage first,
    ActivityProviderPage next, {
    int maximumProducts = 100,
  }) {
    ActivityGuard.record(first.validate());
    ActivityGuard.record(next.validate());
    if (maximumProducts < 1 ||
        maximumProducts > 100 ||
        first.requestFingerprint != next.requestFingerprint ||
        first.cursor == null ||
        first.complete ||
        next.observedAt.isBefore(first.observedAt) ||
        first.slots.isNotEmpty ||
        next.slots.isNotEmpty ||
        first.quotes.isNotEmpty ||
        next.quotes.isNotEmpty)
      throw const FormatException(
        'Activity pages are not an ordered search continuation',
      );
    final products = {for (final p in first.products) p.id: p};
    for (final product in next.products) {
      final old = products[product.id];
      if (old != null &&
          old != product &&
          (product.revision <= old.revision ||
              product.observedAt == null ||
              old.observedAt == null ||
              !product.observedAt!.isAfter(old.observedAt!)))
        throw StateError('Activity pages contain divergent product snapshots');
      products[product.id] = product;
    }
    if (products.length > maximumProducts)
      throw const FormatException('Merged activities exceed capacity');
    final attrs = ActivityDetails.credits(
      provider: [...first.attributions, ...next.attributions],
    );
    final result = first.copyWith(
      products: products.values.toList(),
      attributions: attrs,
      observedAt: next.observedAt,
      expiresAt: first.expiresAt.isBefore(next.expiresAt)
          ? first.expiresAt
          : next.expiresAt,
      cursor: next.cursor,
      clear: next.cursor == null ? {'cursor'} : {},
      complete: next.complete,
      warningCodes: {
        ...first.warningCodes,
        ...next.warningCodes,
        'pagesMayReflectDifferentObservations',
      }.toList(),
    );
    ActivityGuard.record(result.validate());
    return result;
  }

  Future<ActivityProviderPage?> load(
    ActivityProviderRequest request, {
    required DateTime Function() clock,
  }) async {
    if (_closed) throw StateError('Activity pagination closed');
    ActivityRequests.validate(request);
    if (request.mode != 'search')
      throw const FormatException('Only activity searches can paginate');
    final epoch = ++_epoch, deadline = clock().add(timeout), seen = <String>{};
    var next = request;
    ActivityProviderPage? combined;
    for (var i = 0; i < maximumPages; i++) {
      final remaining = deadline.difference(clock());
      if (remaining <= Duration.zero)
        throw const ActivityProviderException(
          'paginationTimeout',
          retryable: true,
        );
      final page = await provider.fetch(next).timeout(remaining);
      if (_closed || epoch != _epoch) return null;
      ActivityDiscoveryController.validateResponse(next, page, now: clock());
      combined = combined == null
          ? page
          : merge(combined, page, maximumProducts: maximumProducts);
      if (combined.products.length > maximumProducts)
        throw const FormatException('Activity pagination exceeds capacity');
      if (page.cursor == null) return combined;
      if (!seen.add(page.cursor!) || page.cursor == next.cursor)
        throw const FormatException('Activity continuation cursor repeated');
      next = request.copyWith(cursor: page.cursor);
    }
    throw const ActivityProviderException('paginationLimit');
  }

  void cancel() {
    _epoch++;
  }

  void close() {
    _closed = true;
    _epoch++;
  }
}
