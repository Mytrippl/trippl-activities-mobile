// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityBookingReceipt {
  ActivityBookingReceipt({
    required this.intentId,
    required this.scope,
    required this.draftFingerprint,
    required this.receivedAt,
    required this.state,
    this.bookingId,
    this.providerReference,
    this.total,
    this.revision = 1,
    List<String> warningCodes = const [],
  }) : warningCodes = List.unmodifiable(warningCodes);

  final String intentId;
  final String scope;
  final String draftFingerprint;
  final DateTime receivedAt;
  final String state;
  final String? bookingId;
  final String? providerReference;
  final ActivityMoney? total;
  final int revision;
  final List<String> warningCodes;

  factory ActivityBookingReceipt.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "intentId",
      "scope",
      "draftFingerprint",
      "receivedAt",
      "state",
      "bookingId",
      "providerReference",
      "total",
      "revision",
      "warningCodes",
    });
    final value = ActivityBookingReceipt(
      intentId: ActivityCodec.text(json, 'intentId', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      draftFingerprint: ActivityCodec.text(
        json,
        'draftFingerprint',
        required: true,
      )!,
      receivedAt: ActivityCodec.date(json, 'receivedAt', required: true)!,
      state: ActivityCodec.text(json, 'state', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId'),
      providerReference: ActivityCodec.text(json, 'providerReference'),
      total: json['total'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['total'])),
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      warningCodes:
          ActivityCodec.list(json, 'warningCodes', (v) {
            if (v is! String || v.trim().isEmpty || v.length > 200)
              throw const FormatException('Invalid list text');
            return v;
          }) ??
          [],
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityBookingReceipt> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityBookingReceipt.fromJson(ActivityCodec.object(input)),
      );
    } on ActivityValidationException catch (e) {
      return ActivityResult(issues: e.issues);
    } on FormatException {
      return ActivityResult(
        issues: const [
          ActivityIssue(
            'record',
            'format',
            'Activity record has invalid fields or values',
          ),
        ],
      );
    }
  }

  ActivityBookingReceipt copyWith({
    Set<String> clear = const {},
    String? intentId,
    String? scope,
    String? draftFingerprint,
    DateTime? receivedAt,
    String? state,
    String? bookingId,
    String? providerReference,
    ActivityMoney? total,
    int? revision,
    List<String>? warningCodes,
  }) {
    final clearableFields = <String>{"bookingId", "providerReference", "total"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityBookingReceipt(
      intentId: (intentId ?? this.intentId),
      scope: (scope ?? this.scope),
      draftFingerprint: (draftFingerprint ?? this.draftFingerprint),
      receivedAt: (receivedAt ?? this.receivedAt),
      state: (state ?? this.state),
      bookingId: clear.contains('bookingId')
          ? null
          : (bookingId ?? this.bookingId),
      providerReference: clear.contains('providerReference')
          ? null
          : (providerReference ?? this.providerReference),
      total: clear.contains('total') ? null : (total ?? this.total),
      revision: (revision ?? this.revision),
      warningCodes: (warningCodes ?? this.warningCodes),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const ActivityIssue('intentId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (draftFingerprint.trim().isEmpty || draftFingerprint.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'draftFingerprint',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    if (bookingId != null) {
      if (bookingId!.trim().isEmpty || bookingId!.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    if (providerReference != null) {
      if (providerReference!.trim().isEmpty || providerReference!.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'providerReference',
            'text',
            'Use nonempty bounded text',
          ),
        );
    }
    if (total != null) {
      for (final issue in total!.validate())
        validationIssues.add(
          ActivityIssue(
            'total.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (revision < 0 || revision > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'revision',
            'range',
            'Number is outside the activity limits',
          ),
        );
    }
    {
      if (warningCodes.length > 100)
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'count',
            'Activity list is empty or exceeds its limit',
          ),
        );
    }
    {
      if (warningCodes.any((item) => item.trim().isEmpty || item.length > 200))
        validationIssues.add(
          const ActivityIssue(
            'warningCodes',
            'text',
            'Use bounded nonempty list text',
          ),
        );
    }
    if (revision < 1 ||
        !{'pending', 'confirmed', 'rejected', 'unknown'}.contains(state) ||
        state == 'confirmed' && (bookingId == null || total == null) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(draftFingerprint))
      validationIssues.add(
        const ActivityIssue(
          'record',
          'contract',
          'Record violates its domain constraints',
        ),
      );
    return List.unmodifiable(validationIssues);
  }

  Map<String, Object?> toJson() => {
    "intentId": intentId,
    "scope": scope,
    "draftFingerprint": draftFingerprint,
    "receivedAt": receivedAt.toUtc().toIso8601String(),
    "state": state,
    if (bookingId != null) "bookingId": bookingId,
    if (providerReference != null) "providerReference": providerReference,
    if (total != null) "total": total!.toJson(),
    "revision": revision,
    "warningCodes": warningCodes,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityBookingReceipt &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityBookingReceipt(redacted)';
}
