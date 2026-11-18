import '../trippl_activities_mobile.dart';

class ActivityAccountPrivacy {
  ActivityAccountPrivacy({
    required this.scope,
    required this.clock,
    required this.policyVersion,
  }) {
    ActivityGuard.identity(scope);
    ActivityGuard.identity(policyVersion);
    _value = ActivityPrivacy(scope: scope, updatedAt: clock());
  }
  final String scope, policyVersion;
  final DateTime Function() clock;
  late ActivityPrivacy _value;
  final _consents = <String, ActivityConsent>{};
  ActivityPrivacy get value => _value;
  List<ActivityConsent> get consents => List.unmodifiable(_consents.values);
  bool permitted(String purpose) {
    if (!{
      'history',
      'draftDetails',
      'analytics',
      'reminders',
    }.contains(purpose))
      throw const FormatException('Unknown activity consent purpose');
    final c = _consents[purpose];
    if (c == null ||
        !c.granted ||
        c.policyVersion != policyVersion ||
        c.recordedAt.isAfter(clock()) ||
        c.expiresAt != null && !c.expiresAt!.isAfter(clock()))
      return false;
    return switch (purpose) {
      'history' => _value.retainHistory,
      'draftDetails' => _value.persistDraftDetails,
      'analytics' => _value.allowAnalytics,
      'reminders' => true,
      _ => false,
    };
  }

  ActivityConsent decide({
    required String id,
    required String purpose,
    required bool granted,
    required int expectedRevision,
    DateTime? expiresAt,
  }) {
    ActivityGuard.revision(_value.revision, expectedRevision);
    if (!{
          'history',
          'draftDetails',
          'analytics',
          'reminders',
        }.contains(purpose) ||
        _consents.values.any((c) => c.id == id && c.purpose != purpose))
      throw StateError('Consent purpose or identity conflict');
    final consent = ActivityConsent(
      id: id,
      scope: scope,
      purpose: purpose,
      policyVersion: policyVersion,
      recordedAt: clock(),
      granted: granted,
      expiresAt: expiresAt,
      revision: (_consents[purpose]?.revision ?? 0) + 1,
    );
    ActivityGuard.record(consent.validate());
    final next = _value.copyWith(
      retainHistory: purpose == 'history' ? granted : null,
      persistDraftDetails: purpose == 'draftDetails' ? granted : null,
      allowAnalytics: purpose == 'analytics' ? granted : null,
      updatedAt: clock(),
      revision: _value.revision + 1,
    );
    ActivityGuard.record(next.validate());
    _value = next;
    _consents[purpose] = consent;
    return consent;
  }

  void retention(int days, {required int expectedRevision}) {
    ActivityGuard.revision(_value.revision, expectedRevision);
    final next = _value.copyWith(
      retentionDays: days,
      updatedAt: clock(),
      revision: _value.revision + 1,
    );
    ActivityGuard.record(next.validate());
    _value = next;
  }

  void restore(
    ActivityPrivacy value,
    List<ActivityConsent> consents, {
    required int expectedRevision,
  }) {
    ActivityGuard.revision(_value.revision, expectedRevision);
    ActivityGuard.record(value.validate());
    ActivityBookingGuard.scope(scope, value.scope);
    if (consents.length > 4 || value.updatedAt.isAfter(clock()))
      throw StateError('Privacy snapshot capacity or clock mismatch');
    ActivityGuard.distinct(consents.map((c) => c.id));
    ActivityGuard.distinct(consents.map((c) => c.purpose));
    for (final c in consents) {
      ActivityGuard.record(c.validate());
      if (c.scope != scope || c.recordedAt.isAfter(clock()))
        throw StateError('Consent scope or clock mismatch');
    }
    _value = value.copyWith(revision: _value.revision + 1);
    _consents
      ..clear()
      ..addEntries(consents.map((c) => MapEntry(c.purpose, c)));
  }

  void reset() {
    _value = ActivityPrivacy(
      scope: scope,
      updatedAt: clock(),
      revision: _value.revision + 1,
    );
    _consents.clear();
  }
}
