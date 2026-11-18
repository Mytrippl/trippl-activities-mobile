import '../trippl_activities_mobile.dart';

class ActivityPreferences {
  ActivityPreferences({required this.scope, required this.clock}) {
    ActivityGuard.identity(scope);
    _value = ActivityPreference(scope: scope, updatedAt: clock());
  }
  final String scope;
  final DateTime Function() clock;
  late ActivityPreference _value;
  ActivityPreference get value => _value;
  ActivityPreference update({
    required int expectedRevision,
    String? currency,
    String? language,
    String? sortField,
    bool? hideSaved,
    bool? offlineEnabled,
  }) {
    ActivityGuard.revision(_value.revision, expectedRevision);
    final next = _value.copyWith(
      currency: currency,
      language: language,
      sortField: sortField,
      hideSaved: hideSaved,
      offlineEnabled: offlineEnabled,
      revision: _value.revision + 1,
      updatedAt: clock(),
    );
    ActivityGuard.record(next.validate());
    ActivityGuard.language(next.language);
    _value = next;
    return next;
  }

  void restore(ActivityPreference value, {required int expectedRevision}) {
    ActivityGuard.revision(_value.revision, expectedRevision);
    ActivityGuard.record(value.validate());
    ActivityBookingGuard.scope(scope, value.scope);
    ActivityBookingGuard.clock(value.updatedAt, clock());
    ActivityGuard.language(value.language);
    _value = value.copyWith(revision: _value.revision + 1);
  }

  ActivitySearchQuery query(ActivitySearchQuery query) =>
      query.copyWith(currency: _value.currency, language: _value.language);
  ActivitySearchSort get sort => ActivitySearchSort(field: _value.sortField);
  List<ActivityProduct> visible(
    List<ActivityProduct> products,
    ActivityDeviceCheckpoint checkpoint,
  ) {
    ActivitySavedLibrary.validateCheckpoint(
      checkpoint,
      scope: scope,
      now: clock(),
    );
    if (products.length > 1000)
      throw const FormatException('Preference projection exceeds capacity');
    final saved = checkpoint.saved.map((s) => s.product.id).toSet();
    return List.unmodifiable(
      products.where((p) => !_value.hideSaved || !saved.contains(p.id)),
    );
  }
}
