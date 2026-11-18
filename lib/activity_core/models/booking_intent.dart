// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'money.dart';

class ActivityBookingIntent {
  ActivityBookingIntent({
    required this.id,
    required this.scope,
    required this.draftId,
    required this.draftFingerprint,
    required this.quoteId,
    required this.total,
    required this.createdAt,
    required this.expiresAt,
    required this.idempotencyKey,
    this.state = "prepared",
    this.attempts = 0,
    this.revision = 1,
  });

  final String id;
  final String scope;
  final String draftId;
  final String draftFingerprint;
  final String quoteId;
  final ActivityMoney total;
  final DateTime createdAt;
  final DateTime expiresAt;
  final String idempotencyKey;
  final String state;
  final int attempts;
  final int revision;

  factory ActivityBookingIntent.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "draftId",
      "draftFingerprint",
      "quoteId",
      "total",
      "createdAt",
      "expiresAt",
      "idempotencyKey",
      "state",
      "attempts",
      "revision",
    });
    final value = ActivityBookingIntent(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      draftId: ActivityCodec.text(json, 'draftId', required: true)!,
      draftFingerprint: ActivityCodec.text(
        json,
        'draftFingerprint',
        required: true,
      )!,
      quoteId: ActivityCodec.text(json, 'quoteId', required: true)!,
      total: (json['total'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['total'])))!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      expiresAt: ActivityCodec.date(json, 'expiresAt', required: true)!,
      idempotencyKey: ActivityCodec.text(
        json,
        'idempotencyKey',
        required: true,
      )!,
      state: ActivityCodec.text(json, 'state') ?? "prepared",
      attempts:
          ActivityCodec.integer(
            json,
            'attempts',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          0,
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityBookingIntent> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityBookingIntent.fromJson(ActivityCodec.object(input)),
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

  ActivityBookingIntent copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? draftId,
    String? draftFingerprint,
    String? quoteId,
    ActivityMoney? total,
    DateTime? createdAt,
    DateTime? expiresAt,
    String? idempotencyKey,
    String? state,
    int? attempts,
    int? revision,
  }) {
    final clearableFields = <String>{};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityBookingIntent(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      draftId: (draftId ?? this.draftId),
      draftFingerprint: (draftFingerprint ?? this.draftFingerprint),
      quoteId: (quoteId ?? this.quoteId),
      total: (total ?? this.total),
      createdAt: (createdAt ?? this.createdAt),
      expiresAt: (expiresAt ?? this.expiresAt),
      idempotencyKey: (idempotencyKey ?? this.idempotencyKey),
      state: (state ?? this.state),
      attempts: (attempts ?? this.attempts),
      revision: (revision ?? this.revision),
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
      if (draftId.trim().isEmpty || draftId.length > 4000)
        validationIssues.add(
          const ActivityIssue('draftId', 'text', 'Use nonempty bounded text'),
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
      if (quoteId.trim().isEmpty || quoteId.length > 4000)
        validationIssues.add(
          const ActivityIssue('quoteId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      for (final issue in total.validate())
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
      if (idempotencyKey.trim().isEmpty || idempotencyKey.length > 4000)
        validationIssues.add(
          const ActivityIssue(
            'idempotencyKey',
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
    {
      if (attempts < 0 || attempts > 9000000000000)
        validationIssues.add(
          const ActivityIssue(
            'attempts',
            'range',
            'Number is outside the activity limits',
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
        attempts > 5 ||
        !expiresAt.isAfter(createdAt) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(draftFingerprint) ||
        !RegExp(r'^[a-f0-9]{64}$').hasMatch(idempotencyKey) ||
        !{
          'prepared',
          'sending',
          'pending',
          'confirmed',
          'rejected',
          'unknown',
        }.contains(state))
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
    "draftId": draftId,
    "draftFingerprint": draftFingerprint,
    "quoteId": quoteId,
    "total": total.toJson(),
    "createdAt": createdAt.toUtc().toIso8601String(),
    "expiresAt": expiresAt.toUtc().toIso8601String(),
    "idempotencyKey": idempotencyKey,
    "state": state,
    "attempts": attempts,
    "revision": revision,
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityBookingIntent &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityBookingIntent(redacted)';
}
