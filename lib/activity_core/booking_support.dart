import '../trippl_activities_mobile.dart';

class ActivitySupportDrafts {
  ActivitySupportDrafts({
    required this.scope,
    required this.clock,
    this.maximumCases = 30,
  }) {
    ActivityGuard.identity(scope);
    if (maximumCases < 1 || maximumCases > 100)
      throw ArgumentError('Invalid support draft capacity');
  }
  final String scope;
  final DateTime Function() clock;
  final int maximumCases;
  final _cases = <String, ActivitySupportCase>{};
  List<ActivitySupportCase> get cases => List.unmodifiable(_cases.values);
  ActivitySupportCase create(
    ActivityBookingRecord booking, {
    required String id,
    required String category,
    required String summary,
  }) {
    ActivityBookingGuard.scope(scope, booking.scope);
    ActivityGuard.record(booking.validate());
    if (_cases.containsKey(id) || _cases.length >= maximumCases)
      throw StateError('Support draft identity or capacity conflict');
    final value = ActivitySupportCase(
      id: id,
      scope: scope,
      bookingId: booking.id,
      createdAt: clock(),
      updatedAt: clock(),
      category: category,
      summary: _text(summary),
    );
    ActivityGuard.record(value.validate());
    _cases[id] = value;
    return value;
  }

  static String _text(String text) {
    final clean = text.trim();
    if (clean.isEmpty ||
        clean.length > 1000 ||
        RegExp(r'[\x00-\x1f]').hasMatch(clean))
      throw const FormatException('Support summary must be bounded plain text');
    return clean;
  }

  ActivitySupportCase edit(
    String id,
    String text, {
    required int expectedRevision,
  }) {
    final old = _cases[id] ?? (throw StateError('Support draft missing'));
    ActivityGuard.revision(old.revision, expectedRevision);
    if (old.state != 'draft')
      throw StateError('Only local drafts may be edited');
    final next = old.copyWith(
      summary: _text(text),
      updatedAt: clock(),
      revision: old.revision + 1,
    );
    ActivityGuard.record(next.validate());
    _cases[id] = next;
    return next;
  }

  Map<String, Object?> payload(String id, {required bool confirmedByUser}) {
    if (!confirmedByUser)
      throw StateError('Review support text before handing it to the host');
    final value = _cases[id] ?? (throw StateError('Support draft missing'));
    return Map.unmodifiable({
      'id': value.id,
      'bookingId': value.bookingId,
      'category': value.category,
      'summary': value.summary,
      'scope': scope,
      'sent': false,
    });
  }

  void remove(String id, {required int expectedRevision}) {
    final old = _cases[id] ?? (throw StateError('Support draft missing'));
    ActivityGuard.revision(old.revision, expectedRevision);
    _cases.remove(id);
  }

  void clear() => _cases.clear();
}
