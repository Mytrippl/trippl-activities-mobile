import 'dart:async';
import '../trippl_activities_mobile.dart';

class ActivityWorkspace {
  ActivityWorkspace({
    required this.controller,
    required this.clock,
    ActivitySearchQuery? query,
    ActivitySearchFilter? filter,
    ActivitySearchSort? sort,
    this.cache,
  }) : _query = query ?? ActivitySearchQuery(),
       _filter = filter ?? ActivitySearchFilter(),
       _sort = sort ?? ActivitySearchSort() {
    if (cache != null && cache!.scope != controller.scope)
      throw ArgumentError('Activity cache and controller scope differ');
    _result = _compute(const []);
  }
  final ActivityDiscoveryController controller;
  final DateTime Function() clock;
  final ActivityDiscoveryCache? cache;
  ActivitySearchQuery _query;
  ActivitySearchFilter _filter;
  ActivitySearchSort _sort;
  late ActivitySearchResult _result;
  ActivityProviderPage? _page;
  ActivityProviderRequest? _request;
  ActivitySelection? _selection;
  ActivityAvailability? _availability;
  ActivityPriceQuote? _quote;
  ActivityAvailabilityRequest? _availabilityContext;
  bool _loading = false, _offline = false, _closed = false;
  String? _failure, _cacheWarning;
  int _epoch = 0, _revision = 1;
  final _changes = StreamController<ActivityWorkspaceSnapshot>.broadcast();
  Stream<ActivityWorkspaceSnapshot> get changes => _changes.stream;
  int get revision => _revision;
  void _open() {
    if (_closed) throw StateError('Activity workspace closed');
  }

  ActivitySearchResult _compute(
    Iterable<ActivityProduct> products, {
    ActivitySearchQuery? query,
    ActivitySearchFilter? filter,
    ActivitySearchSort? sort,
    bool incomplete = true,
  }) => ActivitySearch.run(
    products,
    query: query ?? _query,
    filter: filter ?? _filter,
    sort: sort ?? _sort,
    now: clock(),
    incomplete: incomplete,
  );
  ActivityWorkspaceSnapshot snapshot() {
    _open();
    return ActivityWorkspaceSnapshot(
      revision: _revision,
      result: _result,
      cards: ActivityPresentation.cards(
        _result,
        now: clock(),
        currency: _query.currency,
        locale: _query.language,
        origin: _filter.center,
      ),
      selection: _selection,
      availability: _availability,
      quote: _quote,
      loading: _loading,
      offline: _offline,
      failure: _failure,
      cacheWarning: _cacheWarning,
      attributions: ActivityDetails.credits(
        provider: _page?.attributions ?? const [],
        photos: _result.products.expand((p) => p.photos),
        reviews: _result.products.expand((p) => p.reviews),
      ),
    );
  }

  void _emit() {
    if (_closed) return;
    _revision++;
    _changes.add(snapshot());
  }

  void _accept(ActivityProviderPage page, {required bool offline}) {
    final result = _compute(page.products, incomplete: !page.complete);
    ActivityPresentation.cards(
      result,
      now: clock(),
      currency: _query.currency,
      locale: _query.language,
      origin: _filter.center,
    );
    ActivityDetails.credits(
      provider: page.attributions,
      photos: result.products.expand((p) => p.photos),
      reviews: result.products.expand((p) => p.reviews),
    );
    _result = result;
    _page = page;
    _offline = offline;
    _loading = false;
    _failure = null;
    _quote = null;
    _availability = null;
    final id = _selection?.productId;
    if (id == null || !result.products.any((p) => p.id == id))
      _selection = null;
    else
      _selection = ActivitySelection(
        productId: id,
        updatedAt: clock(),
        revision: (_selection?.revision ?? 0) + 1,
      );
    _emit();
  }

  Future<bool> refresh(ActivityProviderRequest request) async {
    _open();
    ActivityRequests.validate(request);
    if (request.mode != 'search' || request.scope != controller.scope)
      throw StateError('Workspace requires an account-scoped search');
    final epoch = ++_epoch;
    _loading = true;
    _failure = null;
    _cacheWarning = null;
    _quote = null;
    _availability = null;
    _availabilityContext = null;
    _emit();
    final state = await controller.load(request, wait: Future<void>.delayed);
    if (_closed || epoch != _epoch) return false;
    _loading = false;
    if (state?.page == null) {
      _failure = state?.failure?.code ?? 'cancelled';
      _emit();
      return false;
    }
    final nextQuery = request.query!;
    final before = _query;
    _query = nextQuery;
    try {
      _accept(state!.page!, offline: false);
      _request = request;
    } catch (_) {
      _query = before;
      _failure = 'invalidPresentation';
      _emit();
      return false;
    }
    if (cache != null && request.cursor == null) {
      try {
        await cache!.save(request, state.page!, now: clock());
      } catch (_) {
        if (!_closed && epoch == _epoch) {
          _cacheWarning = 'cacheWriteFailed';
          _emit();
        }
      }
    }
    return !_closed && epoch == _epoch;
  }

  Future<bool> restore(
    ActivityProviderRequest request, {
    bool allowStale = false,
  }) async {
    _open();
    ActivityRequests.validate(request);
    if (request.mode != 'search' || request.scope != controller.scope)
      throw StateError('Invalid offline activity query');
    if (cache == null) return false;
    final epoch = ++_epoch;
    controller.cancel();
    final entry = await cache!.load(
      request,
      now: clock(),
      allowStale: allowStale,
    );
    if (_closed || epoch != _epoch || entry == null) return false;
    final previous = _query;
    _query = request.query!;
    try {
      _accept(entry.page, offline: true);
      _request = request;
    } catch (_) {
      _query = previous;
      rethrow;
    }
    return true;
  }

  Future<bool> loadMore() async {
    _open();
    final root = _request, page = _page;
    if (root == null || page?.cursor == null || page!.complete) return false;
    final cursor = page.cursor!;
    final epoch = ++_epoch;
    _loading = true;
    _emit();
    final request = root.copyWith(
      id: '${root.id}-next-$_revision',
      createdAt: clock(),
      cursor: cursor,
    );
    final state = await controller.load(request, wait: Future<void>.delayed);
    if (_closed || epoch != _epoch) return false;
    _loading = false;
    if (state?.page == null) {
      _failure = state?.failure?.code ?? 'paginationFailed';
      _emit();
      return false;
    }
    if (state!.page!.cursor == cursor) {
      _failure = 'cursorRepeated';
      _emit();
      return false;
    }
    try {
      _accept(ActivityPagination.merge(page, state.page!), offline: false);
      return true;
    } catch (_) {
      _failure = 'invalidContinuation';
      _emit();
      return false;
    }
  }

  void refine({
    required int expectedRevision,
    ActivitySearchQuery? query,
    ActivitySearchFilter? filter,
    ActivitySearchSort? sort,
  }) {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    final nextQuery = query ?? _query,
        nextFilter = filter ?? _filter,
        nextSort = sort ?? _sort;
    final result = _compute(
      _page?.products ?? const [],
      query: nextQuery,
      filter: nextFilter,
      sort: nextSort,
      incomplete: !(_page?.complete ?? false),
    );
    ActivityPresentation.cards(
      result,
      now: clock(),
      currency: nextQuery.currency,
      locale: nextQuery.language,
      origin: nextFilter.center,
    );
    final contextChanged =
        nextQuery.currency != _query.currency ||
        nextQuery.language != _query.language ||
        nextQuery.startDate != _query.startDate ||
        nextQuery.endDate != _query.endDate ||
        nextQuery.travelerMix != _query.travelerMix;
    final selectionRemoved =
        _selection != null &&
        !result.products.any((p) => p.id == _selection!.productId);
    if (contextChanged || selectionRemoved) {
      _epoch++;
      controller.cancel();
      _loading = false;
      _availability = null;
      _availabilityContext = null;
      _quote = null;
      if (_selection != null)
        _selection = _selection!.copyWith(
          clear: {'slotId', 'requestFingerprint'},
          revision: _selection!.revision + 1,
          updatedAt: clock(),
        );
    }
    _query = nextQuery;
    _filter = nextFilter;
    _sort = nextSort;
    _result = result;
    if (_selection != null &&
        !result.products.any((p) => p.id == _selection!.productId)) {
      _selection = null;
      _availability = null;
      _quote = null;
    }
    _emit();
  }

  ActivityProduct _selectedProduct() {
    final id = _selection?.productId;
    return _result.products.where((p) => p.id == id).firstOrNull ??
        (throw StateError('Activity selection missing'));
  }

  void select(
    String productId, {
    required int expectedRevision,
    String? optionId,
    String? languageCode,
  }) {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    final product =
        _result.products.where((p) => p.id == productId).firstOrNull ??
        (throw StateError('Activity product not in current results'));
    final option = product.options
        .where((o) => o.id == optionId && o.active)
        .firstOrNull;
    if (optionId != null && option == null)
      throw StateError('Activity option unavailable');
    if (languageCode != null &&
        (option == null ||
            !option.languages.any(
              (l) => l.available && l.code == languageCode,
            )))
      throw StateError('Guide language unavailable');
    _epoch++;
    controller.cancel();
    _loading = false;
    _availability = null;
    _quote = null;
    _selection = ActivitySelection(
      productId: productId,
      optionId: optionId,
      languageCode: languageCode,
      updatedAt: clock(),
      revision: (_selection?.revision ?? 0) + 1,
    );
    _emit();
  }

  Future<bool> checkAvailability(
    ActivityProviderRequest request, {
    required int offsetMinutes,
    required int expectedRevision,
  }) async {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    ActivityRequests.validate(request);
    final product = _selectedProduct(), selection = _selection!;
    final option =
        product.options.where((o) => o.id == selection.optionId).firstOrNull ??
        (throw StateError('Select an activity option'));
    if (request.mode != 'availability' ||
        request.scope != controller.scope ||
        request.availability?.productId != selection.productId ||
        request.availability?.optionId != selection.optionId ||
        request.availability?.selectedLanguage != selection.languageCode ||
        request.availability?.currency != _query.currency)
      throw StateError('Availability request differs from selection');
    if (_offline)
      throw StateError('Offline activity availability cannot be confirmed');
    final epoch = ++_epoch;
    _loading = true;
    _availability = null;
    _availabilityContext = null;
    _quote = null;
    _emit();
    final state = await controller.load(request, wait: Future<void>.delayed);
    if (_closed || epoch != _epoch) return false;
    _loading = false;
    if (state?.page == null) {
      _failure = state?.failure?.code ?? 'availabilityFailed';
      _emit();
      return false;
    }
    try {
      _availability = ActivityInventory.assess(
        option,
        request.availability!,
        state!.page!.slots,
        now: clock(),
        offsetMinutes: offsetMinutes,
      );
      _availabilityContext = request.availability;
      _quote = null;
      _failure = null;
      _emit();
      return true;
    } catch (_) {
      _failure = 'invalidAvailability';
      _emit();
      return false;
    }
  }

  void selectSlot(String slotId, {required int expectedRevision}) {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    final selection = _selection, availability = _availability;
    final slot = availability?.slots.where((s) => s.id == slotId).firstOrNull;
    if (selection == null ||
        availability?.bookable != true ||
        slot == null ||
        !slot.startsAt.isAfter(clock()) ||
        !ActivityGuard.fresh(slot.observedAt, slot.expiresAt, clock()))
      throw StateError('Activity slot unavailable');
    _selection = selection.copyWith(
      slotId: slotId,
      updatedAt: clock(),
      revision: selection.revision + 1,
    );
    _quote = null;
    _epoch++;
    _emit();
  }

  Future<bool> checkQuote(
    ActivityProviderRequest request, {
    required int expectedRevision,
  }) async {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    ActivityRequests.validate(request);
    final selection = _selection, context = _availabilityContext;
    if (_offline ||
        selection == null ||
        selection.slotId == null ||
        context == null ||
        _availability?.bookable != true)
      throw StateError('Select a live available activity departure first');
    final requested = request.availability;
    if (request.mode != 'quote' ||
        request.scope != controller.scope ||
        request.slotId != selection.slotId ||
        requested == null ||
        requested.productId != selection.productId ||
        requested.optionId != selection.optionId ||
        requested.selectedSlotId != selection.slotId ||
        requested.selectedLanguage != selection.languageCode ||
        requested.travelers != context.travelers ||
        requested.currency != context.currency ||
        requested.travelDate != context.travelDate ||
        requested.units != context.units)
      throw StateError('Quote input differs from checked availability');
    final slot = _availability!.slots
        .where((s) => s.id == selection.slotId)
        .firstOrNull;
    if (slot == null ||
        !slot.startsAt.isAfter(clock()) ||
        !ActivityGuard.fresh(slot.observedAt, slot.expiresAt, clock()))
      throw StateError('Availability must be refreshed before quoting');
    final epoch = ++_epoch;
    _loading = true;
    _quote = null;
    _emit();
    final state = await controller.load(request, wait: Future<void>.delayed);
    if (_closed || epoch != _epoch) return false;
    _loading = false;
    if (state?.page == null || state!.page!.quotes.length != 1) {
      _failure = state?.failure?.code ?? 'quoteMissing';
      _emit();
      return false;
    }
    final quote = state.page!.quotes.single;
    try {
      ActivityPricing.validateQuote(
        quote,
        request: ActivityQuoteRequest(
          productId: selection.productId,
          optionId: selection.optionId!,
          slotId: selection.slotId!,
          travelers: context.travelers,
          currency: context.currency,
          createdAt: request.createdAt,
          languageCode: selection.languageCode,
          units: context.units,
        ),
        requestFingerprint: ActivityRequests.fingerprint(request),
        now: clock(),
      );
      _quote = quote;
      _selection = selection.copyWith(
        requestFingerprint: quote.requestFingerprint,
        updatedAt: clock(),
        revision: selection.revision + 1,
      );
      _failure = null;
      _emit();
      return true;
    } catch (_) {
      _failure = 'invalidQuote';
      _emit();
      return false;
    }
  }

  ActivityDeparture selectedDeparture({
    ActivityMeetingPoint? meeting,
    ActivityPickup? pickup,
  }) {
    _open();
    final product = _selectedProduct(), selection = _selection!;
    final option = product.options
        .where((o) => o.id == selection.optionId)
        .firstOrNull;
    if (option == null || _availability == null || _offline)
      throw StateError('Live activity departure required');
    return ActivityInventory.departure(
      option,
      _availability!,
      selection,
      now: clock(),
      meeting: meeting,
      pickup: pickup,
    );
  }

  ActivityReadiness review() {
    _open();
    final reasons = <String>[];
    final selection = _selection;
    if (_offline) reasons.add('offline');
    if (_loading) reasons.add('readInProgress');
    if (selection == null)
      reasons.add('productNotSelected');
    else {
      final product = _result.products
          .where((p) => p.id == selection.productId)
          .firstOrNull;
      if (product == null ||
          !ActivityGuard.fresh(product.observedAt, product.expiresAt, clock()))
        reasons.add('productNeedsRefresh');
      if (selection.optionId == null) reasons.add('optionNotSelected');
      if (selection.slotId == null) reasons.add('slotNotSelected');
      final slot = _availability?.slots
          .where((s) => s.id == selection.slotId)
          .firstOrNull;
      if (_availability?.bookable != true ||
          slot == null ||
          !slot.startsAt.isAfter(clock()) ||
          !ActivityGuard.fresh(slot.observedAt, slot.expiresAt, clock()))
        reasons.add('availabilityNeedsRefresh');
    }
    final quote = _quote;
    if (quote == null ||
        !ActivityGuard.fresh(quote.observedAt, quote.expiresAt, clock()))
      reasons.add('quoteNeedsRefresh');
    else if (quote.indicative)
      reasons.add('quoteIndicative');
    return ActivityReadiness(
      evaluatedAt: clock(),
      readyForHostReview: reasons.isEmpty,
      reasonCodes: reasons,
      selection: selection,
      quote: quote,
    );
  }

  ActivityDetailSheet? details() {
    _open();
    if (_selection == null) return null;
    return ActivityPresentation.details(
      _selectedProduct(),
      now: clock(),
      currency: _query.currency,
      locale: _query.language,
      origin: _filter.center,
      availability: _availability,
    );
  }

  void cancel() {
    _open();
    _epoch++;
    controller.cancel();
    _loading = false;
    _emit();
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    _epoch++;
    await controller.close();
    await _changes.close();
  }
}

class ActivityWorkspaceSnapshot {
  ActivityWorkspaceSnapshot({
    required this.revision,
    required this.result,
    required List<ActivityResultCard> cards,
    required this.loading,
    required this.offline,
    required List<ActivityAttribution> attributions,
    this.selection,
    this.availability,
    this.quote,
    this.failure,
    this.cacheWarning,
  }) : cards = List.unmodifiable(cards),
       attributions = List.unmodifiable(attributions);
  final int revision;
  final ActivitySearchResult result;
  final List<ActivityResultCard> cards;
  final ActivitySelection? selection;
  final ActivityAvailability? availability;
  final ActivityPriceQuote? quote;
  final bool loading, offline;
  final String? failure, cacheWarning;
  final List<ActivityAttribution> attributions;
}

class ActivityReadiness {
  ActivityReadiness({
    required this.evaluatedAt,
    required this.readyForHostReview,
    required List<String> reasonCodes,
    this.selection,
    this.quote,
  }) : reasonCodes = List.unmodifiable(reasonCodes);
  final DateTime evaluatedAt;
  final bool readyForHostReview;
  final List<String> reasonCodes;
  final ActivitySelection? selection;
  final ActivityPriceQuote? quote;
  Map<String, Object?> toJson() => {
    'evaluatedAt': evaluatedAt.toUtc().toIso8601String(),
    'readyForHostReview': readyForHostReview,
    'reasonCodes': reasonCodes,
    if (selection != null) 'selection': selection!.toJson(),
    if (quote != null) 'quote': quote!.toJson(),
    'bookingConfirmed': false,
  };
}
