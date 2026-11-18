// Generated typed activity records. Edit tool/activity_models.json and regenerate.
import '../activity_codec.dart';
import '../activity_issue.dart';
import 'cancellation_policy.dart';
import 'money.dart';

class ActivityBookingRecord {
  ActivityBookingRecord({
    required this.id,
    required this.scope,
    required this.productId,
    required this.optionId,
    required this.slotId,
    required this.startsAt,
    required this.createdAt,
    required this.updatedAt,
    required this.total,
    required this.state,
    required this.intentId,
    this.revision = 1,
    this.providerReference,
    this.cancellation,
  });

  final String id;
  final String scope;
  final String productId;
  final String optionId;
  final String slotId;
  final DateTime startsAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final ActivityMoney total;
  final String state;
  final String intentId;
  final int revision;
  final String? providerReference;
  final ActivityCancellationPolicy? cancellation;

  factory ActivityBookingRecord.fromJson(Map<String, Object?> json) {
    ActivityCodec.keys(json, {
      "id",
      "scope",
      "productId",
      "optionId",
      "slotId",
      "startsAt",
      "createdAt",
      "updatedAt",
      "total",
      "state",
      "intentId",
      "revision",
      "providerReference",
      "cancellation",
    });
    final value = ActivityBookingRecord(
      id: ActivityCodec.text(json, 'id', required: true)!,
      scope: ActivityCodec.text(json, 'scope', required: true)!,
      productId: ActivityCodec.text(json, 'productId', required: true)!,
      optionId: ActivityCodec.text(json, 'optionId', required: true)!,
      slotId: ActivityCodec.text(json, 'slotId', required: true)!,
      startsAt: ActivityCodec.date(json, 'startsAt', required: true)!,
      createdAt: ActivityCodec.date(json, 'createdAt', required: true)!,
      updatedAt: ActivityCodec.date(json, 'updatedAt', required: true)!,
      total: (json['total'] == null
          ? null
          : ActivityMoney.fromJson(ActivityCodec.object(json['total'])))!,
      state: ActivityCodec.text(json, 'state', required: true)!,
      intentId: ActivityCodec.text(json, 'intentId', required: true)!,
      revision:
          ActivityCodec.integer(
            json,
            'revision',
            minimum: 0,
            maximum: 9000000000000,
          ) ??
          1,
      providerReference: ActivityCodec.text(json, 'providerReference'),
      cancellation: json['cancellation'] == null
          ? null
          : ActivityCancellationPolicy.fromJson(
              ActivityCodec.object(json['cancellation']),
            ),
    );
    final issues = value.validate();
    if (issues.any((i) => i.severity == ActivitySeverity.error))
      throw ActivityValidationException(issues);
    return value;
  }

  static ActivityResult<ActivityBookingRecord> tryDecode(Object? input) {
    try {
      return ActivityResult(
        value: ActivityBookingRecord.fromJson(ActivityCodec.object(input)),
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

  ActivityBookingRecord copyWith({
    Set<String> clear = const {},
    String? id,
    String? scope,
    String? productId,
    String? optionId,
    String? slotId,
    DateTime? startsAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    ActivityMoney? total,
    String? state,
    String? intentId,
    int? revision,
    String? providerReference,
    ActivityCancellationPolicy? cancellation,
  }) {
    final clearableFields = <String>{"providerReference", "cancellation"};
    if (clear.any((key) => !clearableFields.contains(key)))
      throw const FormatException('Only optional fields may be cleared');
    return ActivityBookingRecord(
      id: (id ?? this.id),
      scope: (scope ?? this.scope),
      productId: (productId ?? this.productId),
      optionId: (optionId ?? this.optionId),
      slotId: (slotId ?? this.slotId),
      startsAt: (startsAt ?? this.startsAt),
      createdAt: (createdAt ?? this.createdAt),
      updatedAt: (updatedAt ?? this.updatedAt),
      total: (total ?? this.total),
      state: (state ?? this.state),
      intentId: (intentId ?? this.intentId),
      revision: (revision ?? this.revision),
      providerReference: clear.contains('providerReference')
          ? null
          : (providerReference ?? this.providerReference),
      cancellation: clear.contains('cancellation')
          ? null
          : (cancellation ?? this.cancellation),
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
      if (productId.trim().isEmpty || productId.length > 4000)
        validationIssues.add(
          const ActivityIssue('productId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (optionId.trim().isEmpty || optionId.length > 4000)
        validationIssues.add(
          const ActivityIssue('optionId', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (slotId.trim().isEmpty || slotId.length > 4000)
        validationIssues.add(
          const ActivityIssue('slotId', 'text', 'Use nonempty bounded text'),
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
      if (state.trim().isEmpty || state.length > 4000)
        validationIssues.add(
          const ActivityIssue('state', 'text', 'Use nonempty bounded text'),
        );
    }
    {
      if (intentId.trim().isEmpty || intentId.length > 4000)
        validationIssues.add(
          const ActivityIssue('intentId', 'text', 'Use nonempty bounded text'),
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
    if (cancellation != null) {
      for (final issue in cancellation!.validate())
        validationIssues.add(
          ActivityIssue(
            'cancellation.${issue.field}',
            issue.code,
            issue.message,
            severity: issue.severity,
          ),
        );
    }
    if (revision < 1 ||
        updatedAt.isBefore(createdAt) ||
        !{
          'pending',
          'confirmed',
          'rejected',
          'cancelPending',
          'cancelled',
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
    "productId": productId,
    "optionId": optionId,
    "slotId": slotId,
    "startsAt": startsAt.toUtc().toIso8601String(),
    "createdAt": createdAt.toUtc().toIso8601String(),
    "updatedAt": updatedAt.toUtc().toIso8601String(),
    "total": total.toJson(),
    "state": state,
    "intentId": intentId,
    "revision": revision,
    if (providerReference != null) "providerReference": providerReference,
    if (cancellation != null) "cancellation": cancellation!.toJson(),
  };

  @override
  bool operator ==(Object other) =>
      other is ActivityBookingRecord &&
      ActivityCodec.same(toJson(), other.toJson());
  @override
  int get hashCode => ActivityCodec.digest(toJson()).hashCode;
  @override
  String toString() => 'ActivityBookingRecord(redacted)';
}
