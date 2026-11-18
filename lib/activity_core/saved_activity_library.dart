import 'dart:async';
import '../trippl_activities_mobile.dart';

class ActivitySavedLibrary {
  ActivitySavedLibrary({
    required this.scope,
    required this.clock,
    this.maximumSaved = 100,
    this.maximumCollections = 30,
  }) {
    ActivityGuard.identity(scope);
    if (maximumSaved < 1 ||
        maximumSaved > 100 ||
        maximumCollections < 1 ||
        maximumCollections > 100)
      throw ArgumentError('Invalid saved activity capacity');
  }
  final String scope;
  final DateTime Function() clock;
  final int maximumSaved, maximumCollections;
  final _saved = <String, ActivitySavedActivity>{},
      _collections = <String, ActivityCollection>{},
      _items = <String, ActivityCollectionItem>{};
  final _changes = StreamController<int>.broadcast();
  int _revision = 1;
  bool _closed = false;
  int get revision => _revision;
  Stream<int> get changes => _changes.stream;
  List<ActivitySavedActivity> get saved => List.unmodifiable(_saved.values);
  List<ActivityCollection> get collections =>
      List.unmodifiable(_collections.values);
  void _open() {
    if (_closed) throw StateError('Saved activity library closed');
  }

  void _emit() {
    _revision++;
    _changes.add(_revision);
  }

  ActivitySavedActivity save(
    ActivityProduct product, {
    required String id,
    int priority = 0,
    String? note,
  }) {
    _open();
    ActivityGuard.product(product, now: clock());
    final duplicate = _saved.values
        .where((s) => s.product.id == product.id)
        .firstOrNull;
    if (duplicate != null) return duplicate;
    if (_saved.containsKey(id) || _saved.length >= maximumSaved)
      throw StateError('Saved activity identity or capacity conflict');
    final value = ActivitySavedActivity(
      id: id,
      scope: scope,
      product: product,
      savedAt: clock(),
      updatedAt: clock(),
      priority: priority,
      note: note,
    );
    ActivityGuard.record(value.validate());
    _saved[id] = value;
    _emit();
    return value;
  }

  ActivitySavedActivity edit(
    String id, {
    required int expectedRevision,
    String? note,
    bool clearNote = false,
    int? priority,
  }) {
    _open();
    final old = _saved[id] ?? (throw StateError('Saved activity missing'));
    ActivityGuard.revision(old.revision, expectedRevision);
    final next = old.copyWith(
      note: note,
      priority: priority,
      clear: clearNote ? {'note'} : {},
      updatedAt: clock(),
      revision: old.revision + 1,
    );
    ActivityGuard.record(next.validate());
    _saved[id] = next;
    _emit();
    return next;
  }

  ActivityCollection createCollection({
    required String id,
    required String title,
  }) {
    _open();
    if (_collections.containsKey(id) ||
        _collections.length >= maximumCollections)
      throw StateError('Collection identity or capacity conflict');
    final value = ActivityCollection(
      id: id,
      scope: scope,
      title: title,
      createdAt: clock(),
      updatedAt: clock(),
    );
    ActivityGuard.record(value.validate());
    _collections[id] = value;
    _emit();
    return value;
  }

  ActivityCollection collection(String id) {
    _open();
    return _collections[id] ?? (throw StateError('Collection missing'));
  }

  List<ActivityCollectionItem> items(String id) {
    final c = collection(id);
    return List.unmodifiable(c.itemIds.map((id) => _items[id]!));
  }

  ActivityCollectionItem add(
    String collectionId,
    String savedId, {
    required String id,
    required int expectedRevision,
  }) {
    final c = collection(collectionId);
    ActivityGuard.revision(c.revision, expectedRevision);
    if (c.archived || !_saved.containsKey(savedId))
      throw StateError('Collection archived or saved activity missing');
    final duplicate = items(
      c.id,
    ).where((i) => i.savedActivityId == savedId).firstOrNull;
    if (duplicate != null) return duplicate;
    if (_items.containsKey(id) || _items.length >= 100)
      throw StateError('Collection item identity or capacity conflict');
    final item = ActivityCollectionItem(
      id: id,
      collectionId: c.id,
      savedActivityId: savedId,
      addedAt: clock(),
      position: c.itemIds.length,
    );
    final next = c.copyWith(
      itemIds: [...c.itemIds, id],
      updatedAt: clock(),
      revision: c.revision + 1,
    );
    ActivityGuard.record(item.validate());
    ActivityGuard.record(next.validate());
    _items[id] = item;
    _collections[c.id] = next;
    _emit();
    return item;
  }

  void reorder(
    String collectionId,
    List<String> ids, {
    required int expectedRevision,
  }) {
    final c = collection(collectionId);
    ActivityGuard.revision(c.revision, expectedRevision);
    if (c.archived ||
        ids.length != c.itemIds.length ||
        ids.toSet().length != ids.length ||
        ids.any((id) => !c.itemIds.contains(id)))
      throw StateError('Invalid collection reorder');
    for (var i = 0; i < ids.length; i++) {
      final item = _items[ids[i]]!;
      _items[item.id] = item.copyWith(position: i, revision: item.revision + 1);
    }
    _collections[c.id] = c.copyWith(
      itemIds: ids,
      updatedAt: clock(),
      revision: c.revision + 1,
    );
    _emit();
  }

  void removeSaved(String id, {required int expectedRevision}) {
    _open();
    final value = _saved[id] ?? (throw StateError('Saved activity missing'));
    ActivityGuard.revision(value.revision, expectedRevision);
    final removed = _items.values
        .where((i) => i.savedActivityId == id)
        .map((i) => i.id)
        .toSet();
    for (final c in collections) {
      if (!c.itemIds.any(removed.contains)) continue;
      final ids = c.itemIds.where((id) => !removed.contains(id)).toList();
      _collections[c.id] = c.copyWith(
        itemIds: ids,
        updatedAt: clock(),
        revision: c.revision + 1,
      );
      for (var i = 0; i < ids.length; i++) {
        final old = _items[ids[i]]!;
        _items[old.id] = old.copyWith(position: i, revision: old.revision + 1);
      }
    }
    _items.removeWhere((id, _) => removed.contains(id));
    _saved.remove(id);
    _emit();
  }

  ActivityDeviceCheckpoint checkpoint() {
    _open();
    return ActivityDeviceCheckpoint(
      scope: scope,
      savedAt: clock(),
      revision: _revision,
      saved: saved,
      collections: collections,
      items: _items.values.toList(),
    );
  }

  static void validateCheckpoint(
    ActivityDeviceCheckpoint value, {
    required String scope,
    required DateTime now,
  }) {
    ActivityGuard.record(value.validate());
    ActivityBookingGuard.scope(scope, value.scope);
    ActivityBookingGuard.clock(value.savedAt, now);
    ActivityGuard.distinct(value.saved.map((s) => s.id));
    ActivityGuard.distinct(value.saved.map((s) => s.product.id));
    ActivityGuard.distinct(value.collections.map((c) => c.id));
    ActivityGuard.distinct(value.items.map((i) => i.id));
    for (final saved in value.saved)
      if (saved.scope != scope || saved.updatedAt.isAfter(value.savedAt))
        throw StateError('Saved activity scope or timestamp mismatch');
    for (final c in value.collections) {
      if (c.scope != scope ||
          c.updatedAt.isAfter(value.savedAt) ||
          c.itemIds.any(
            (id) =>
                !value.items.any((i) => i.id == id && i.collectionId == c.id),
          ))
        throw StateError('Collection scope or item reference mismatch');
      final rows = value.items.where((i) => i.collectionId == c.id).toList();
      if (rows.length != c.itemIds.length)
        throw StateError('Collection membership differs from item references');
      ActivityGuard.distinct(rows.map((i) => i.savedActivityId));
      for (var index = 0; index < c.itemIds.length; index++)
        if (rows.firstWhere((i) => i.id == c.itemIds[index]).position != index)
          throw StateError('Collection ordering differs from item positions');
    }
    for (final item in value.items)
      if (!value.saved.any((s) => s.id == item.savedActivityId) ||
          !value.collections.any((c) => c.id == item.collectionId) ||
          item.addedAt.isAfter(value.savedAt))
        throw StateError('Orphan collection membership');
  }

  void restore(
    ActivityDeviceCheckpoint value, {
    required int expectedRevision,
  }) {
    _open();
    ActivityGuard.revision(_revision, expectedRevision);
    validateCheckpoint(value, scope: scope, now: clock());
    if (value.saved.length > maximumSaved ||
        value.collections.length > maximumCollections)
      throw StateError('Restored library exceeds capacity');
    _saved
      ..clear()
      ..addEntries(value.saved.map((s) => MapEntry(s.id, s)));
    _collections
      ..clear()
      ..addEntries(value.collections.map((c) => MapEntry(c.id, c)));
    _items
      ..clear()
      ..addEntries(value.items.map((i) => MapEntry(i.id, i)));
    _revision = (_revision > value.revision ? _revision : value.revision) + 1;
    _changes.add(_revision);
  }

  void clear() {
    _open();
    _saved.clear();
    _collections.clear();
    _items.clear();
    _emit();
  }

  Future<void> close() async {
    if (_closed) return;
    _closed = true;
    await _changes.close();
  }
}
