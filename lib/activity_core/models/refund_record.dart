// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityRefundRecord {
  ActivityRefundRecord({
    required this.id,
    required this.scope,
    required this.bookingId,
    required this.amount,
    required this.observedAt,
    required this.state,
    this.providerReference,
    this.revision = 1,
    this.completedAt,
  });

  final String id;
  final String scope;
  final String bookingId;
  final ActivityMoney amount;
  final DateTime observedAt;
  final String state;
  final String? providerReference;
  final int revision;
  final DateTime? completedAt;

  factory ActivityRefundRecord.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "bookingId",
      "amount",
      "observedAt",
      "state",
      "providerReference",
      "revision",
      "completedAt",
    });
    final value = ActivityRefundRecord(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      bookingId: ActivityCodec.text(json, 'bookingId', required: true)!,
      amount: (json['amount'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['amount'])))!,
      observedAt: ActivityCodec.date(json, 'observedAt', required: true)!,
      state: ActivityCodec.text(json, 'state', required: true)!,
      providerReference: ActivityCodec.text(json, 'providerReference'),
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      completedAt: ActivityCodec.date(json, 'completedAt'),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityRefundRecord> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityRefundRecord.fromJson(ActivityCodec.object(input)),
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

  ActivityRefundRecord copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? bookingId,
    ActivityMoney? amount,
    DateTime? observedAt,
    String? state,
    String? providerReference,
    int? revision,
    DateTime? completedAt,
  }) {
    final clearableFields = <String>{"providerReference", "completedAt"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityRefundRecord(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      bookingId: (bookingId ?? this.bookingId),
      amount: (amount ?? this.amount),
      observedAt: (observedAt ?? this.observedAt),
      state: (state ?? this.state),
      providerReference: clear.contains('providerReference')
          ? null
          : (providerReference ?? this.providerReference),
      revision: (revision ?? this.revision),
      completedAt: clear.contains('completedAt')
          ? null
          : (completedAt ?? this.completedAt),
    );
  }

  List<ActivityIssue> validate() {
    final validationIssues = <ActivityIssue>[];
    {
      if (id.trim().isEmpty || id.length > 4000)
        validationIssues.add(
          const ActivityIssue('id', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (scope.trim().isEmpty || scope.length > 4000)
        validationIssues.add(
          const ActivityIssue('scope', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (bookingId.trim().isEmpty || bookingId.length > 4000)
        validationIssues.add(
          const ActivityIssue('bookingId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in amount.validate())
        validationIssues.add(
          ActivityIssue(
            'amount.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    {
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
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
    if (revision < 1 ||
        !{'pending', 'processed', 'failed', 'unknown'}.contains(state) ||
        state == 'processed' && completedAt == null)
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
    "id": id,
    "scope": scope,
    "bookingId": bookingId,
    "amount": amount.toJson(),
    "observedAt": observedAt.toUtc().toIso8601String(),
    "state": state,
    if (providerReference != null) "providerReference": providerReference,
    "revision": revision,
    if (completedAt != null)
      "completedAt": completedAt!.toUtc().toIso8601String(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityRefundRecord &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityRefundRecord(redacted)';
}
